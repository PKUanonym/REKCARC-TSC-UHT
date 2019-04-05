package decaf.typecheck;

import java.util.Iterator;

import decaf.Driver;
import decaf.tree.Tree;
import decaf.error.BadArrElementError;
import decaf.error.BadInheritanceError;
import decaf.error.BadOverrideError;
import decaf.error.BadVarTypeError;
import decaf.error.ClassNotFoundError;
import decaf.error.DecafError;
import decaf.error.DeclConflictError;
import decaf.error.NoMainClassError;
import decaf.error.OverridingVarError;
import decaf.scope.ClassScope;
import decaf.scope.GlobalScope;
import decaf.scope.LocalScope;
import decaf.scope.ScopeStack;
import decaf.symbol.Class;
import decaf.symbol.Function;
import decaf.symbol.Symbol;
import decaf.symbol.Variable;
import decaf.type.BaseType;
import decaf.type.FuncType;

public class BuildSym extends Tree.Visitor {

	private ScopeStack table;

	private void issueError(DecafError error) {
		Driver.getDriver().issueError(error);
	}

	public BuildSym(ScopeStack table) {
		this.table = table;
	}

	public static void buildSymbol(Tree.TopLevel tree) {
		new BuildSym(Driver.getDriver().getTable()).visitTopLevel(tree);
	}

	// root
	@Override
	public void visitTopLevel(Tree.TopLevel program) {
		program.globalScope = new GlobalScope();
		table.open(program.globalScope);
		for (Tree.ClassDef cd : program.classes) {
			Class c = new Class(cd.name, cd.parent, cd.getLocation());
			Class earlier = table.lookupClass(cd.name);
			if (earlier != null) {
				issueError(new DeclConflictError(cd.getLocation(), cd.name,
						earlier.getLocation()));
			} else {
				table.declare(c);
			}
			cd.symbol = c;
		}

		for (Tree.ClassDef cd : program.classes) {
			Class c = cd.symbol;
			if (cd.parent != null && c.getParent() == null) {
				issueError(new ClassNotFoundError(cd.getLocation(), cd.parent));
				c.dettachParent();
			}
			if (calcOrder(c) <= calcOrder(c.getParent())) {
				issueError(new BadInheritanceError(cd.getLocation()));
				c.dettachParent();
			}
		}

		for (Tree.ClassDef cd : program.classes) {
			cd.symbol.createType();
		}

		for (Tree.ClassDef cd : program.classes) {
			cd.accept(this);
			if (Driver.getDriver().getOption().getMainClassName().equals(
					cd.name)) {
				program.main = cd.symbol;
			}
		}

		for (Tree.ClassDef cd : program.classes) {
			checkOverride(cd.symbol);
		}

		if (!isMainClass(program.main)) {
			issueError(new NoMainClassError(Driver.getDriver().getOption()
					.getMainClassName()));
		}
		table.close();
	}

	// visiting declarations
	@Override
	public void visitClassDef(Tree.ClassDef classDef) {
		table.open(classDef.symbol.getAssociatedScope());
		for (Tree f : classDef.fields) {
			f.accept(this);
		}
		table.close();
	}

	@Override
	public void visitVarDef(Tree.VarDef varDef) {
		varDef.type.accept(this);
		if (varDef.type.type.equal(BaseType.VOID)) {
			issueError(new BadVarTypeError(varDef.getLocation(), varDef.name));
			// for argList
			varDef.symbol = new Variable(".error", BaseType.ERROR, varDef
					.getLocation());
			return;
		}
		Variable v = new Variable(varDef.name, varDef.type.type, 
				varDef.getLocation());
		Symbol sym = table.lookup(varDef.name, true);
		if (sym != null) {
			if (table.getCurrentScope().equals(sym.getScope())) {
				issueError(new DeclConflictError(v.getLocation(), v.getName(),
						sym.getLocation()));
			} else if ((sym.getScope().isFormalScope() || sym.getScope()
					.isLocalScope())) {
				issueError(new DeclConflictError(v.getLocation(), v.getName(),
						sym.getLocation()));
			} else {
				table.declare(v);
			}
		} else {
			table.declare(v);
		}
		varDef.symbol = v;
	}

	@Override
	public void visitMethodDef(Tree.MethodDef funcDef) {
		funcDef.returnType.accept(this);
		Function f = new Function(funcDef.statik, funcDef.name,
				funcDef.returnType.type, funcDef.body, funcDef.getLocation());
		funcDef.symbol = f;
		Symbol sym = table.lookup(funcDef.name, false);
		if (sym != null) {
			issueError(new DeclConflictError(funcDef.getLocation(),
					funcDef.name, sym.getLocation()));
		} else {
			table.declare(f);
		}
		table.open(f.getAssociatedScope());
		for (Tree.VarDef d : funcDef.formals) {
			d.accept(this);
			f.appendParam(d.symbol);
		}
		funcDef.body.accept(this);
		table.close();
	}

	// visiting types
	@Override
	public void visitTypeIdent(Tree.TypeIdent type) {
		switch (type.typeTag) {
		case Tree.VOID:
			type.type = BaseType.VOID;
			break;
		case Tree.INT:
			type.type = BaseType.INT;
			break;
		case Tree.BOOL:
			type.type = BaseType.BOOL;
			break;
		default:
			type.type = BaseType.STRING;
		}
	}

	@Override
	public void visitTypeClass(Tree.TypeClass typeClass) {
		Class c = table.lookupClass(typeClass.name);
		if (c == null) {
			issueError(new ClassNotFoundError(typeClass.getLocation(),
					typeClass.name));
			typeClass.type = BaseType.ERROR;
		} else {
			typeClass.type = c.getType();
		}
	}

	@Override
	public void visitTypeArray(Tree.TypeArray typeArray) {
		typeArray.elementType.accept(this);
		if (typeArray.elementType.type.equal(BaseType.ERROR)) {
			typeArray.type = BaseType.ERROR;
		} else if (typeArray.elementType.type.equal(BaseType.VOID)) {
			issueError(new BadArrElementError(typeArray.getLocation()));
			typeArray.type = BaseType.ERROR;
		} else {
			typeArray.type = new decaf.type.ArrayType(
					typeArray.elementType.type);
		}
	}

	// for VarDecl in LocalScope
	@Override
	public void visitBlock(Tree.Block block) {
		block.associatedScope = new LocalScope(block);
		table.open(block.associatedScope);
		for (Tree s : block.block) {
			s.accept(this);
		}
		table.close();
	}

	@Override
	public void visitForLoop(Tree.ForLoop forLoop) {
		if (forLoop.loopBody != null) {
			forLoop.loopBody.accept(this);
		}
	}

	@Override
	public void visitIf(Tree.If ifStmt) {
		if (ifStmt.trueBranch != null) {
			ifStmt.trueBranch.accept(this);
		}
		if (ifStmt.falseBranch != null) {
			ifStmt.falseBranch.accept(this);
		}
	}

	@Override
	public void visitWhileLoop(Tree.WhileLoop whileLoop) {
		if (whileLoop.loopBody != null) {
			whileLoop.loopBody.accept(this);
		}
	}

	private int calcOrder(Class c) {
		if (c == null) {
			return -1;
		}
		if (c.getOrder() < 0) {
			c.setOrder(0);
			c.setOrder(calcOrder(c.getParent()) + 1);
		}
		return c.getOrder();
	}

	private void checkOverride(Class c) {
		if (c.isCheck()) {
			return;
		}
		Class parent = c.getParent();
		if (parent == null) {
			return;
		}
		checkOverride(parent);

		ClassScope parentScope = parent.getAssociatedScope();
		ClassScope subScope = c.getAssociatedScope();
		table.open(parentScope);
		Iterator<Symbol> iter = subScope.iterator();
		while (iter.hasNext()) {
			Symbol suspect = iter.next();
			Symbol sym = table.lookup(suspect.getName(), true);
			if (sym != null && !sym.isClass()) {
				if ((suspect.isVariable() && sym.isFunction())
						|| (suspect.isFunction() && sym.isVariable())) {
					issueError(new DeclConflictError(suspect.getLocation(),
							suspect.getName(), sym.getLocation()));
					iter.remove();
				} else if (suspect.isFunction()) {
					if (((Function) suspect).isStatik()
							|| ((Function) sym).isStatik()) {
						issueError(new DeclConflictError(suspect.getLocation(),
								suspect.getName(), sym.getLocation()));
						iter.remove();
					} else if (!suspect.getType().compatible(sym.getType())) {
						issueError(new BadOverrideError(suspect.getLocation(),
								suspect.getName(),
								((ClassScope) sym.getScope()).getOwner()
										.getName()));
						iter.remove();
					}
				} else if (suspect.isVariable()) {
					issueError(new OverridingVarError(suspect.getLocation(),
							suspect.getName()));
					iter.remove();
				}
			}
		}
		table.close();
		c.setCheck(true);
	}

	private boolean isMainClass(Class c) {
		if (c == null) {
			return false;
		}
		table.open(c.getAssociatedScope());
		Symbol main = table.lookup(Driver.getDriver().getOption()
				.getMainFuncName(), false);
		if (main == null || !main.isFunction()) {
			return false;
		}
		((Function) main).setMain(true);
		FuncType type = (FuncType) main.getType();
		return type.getReturnType().equal(BaseType.VOID)
				&& type.numOfParams() == 0 && ((Function) main).isStatik();
	}
}
