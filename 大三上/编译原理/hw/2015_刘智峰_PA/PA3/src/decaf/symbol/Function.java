package decaf.symbol;

import decaf.Driver;
import decaf.Location;
import decaf.tree.Tree.Block;
import decaf.scope.ClassScope;
import decaf.scope.FormalScope;
import decaf.scope.Scope;
import decaf.tac.Functy;
import decaf.type.FuncType;
import decaf.type.Type;

public class Function extends Symbol {

	private FormalScope associatedScope;

	private Functy functy;

	private boolean statik;

	private boolean isMain;

	public boolean isMain() {
		return isMain;
	}

	public void setMain(boolean isMain) {
		this.isMain = isMain;
	}

	public boolean isStatik() {
		return statik;
	}

	public void setStatik(boolean statik) {
		this.statik = statik;
	}

	private int offset;

	public int getOffset() {
		return offset;
	}

	public void setOffset(int offset) {
		this.offset = offset;
	}

	public Functy getFuncty() {
		return functy;
	}

	public void setFuncty(Functy functy) {
		this.functy = functy;
	}

	public Function(boolean statik, String name, Type returnType,
			Block node, Location location) {
		this.name = name;
		this.location = location;

		type = new FuncType(returnType);
		associatedScope = new FormalScope(this, node);
		ClassScope cs = (ClassScope) Driver.getDriver().getTable()
				.lookForScope(Scope.Kind.CLASS);
		this.statik = statik;
		if (!statik) {
			Variable _this = new Variable("this", cs.getOwner().getType(),
					location);
			associatedScope.declare(_this);
			appendParam(_this);
		}

	}

	public FormalScope getAssociatedScope() {
		return associatedScope;
	}

	public Type getReturnType() {
		return getType().getReturnType();
	}

	public void appendParam(Variable arg) {
		arg.setOrder(getType().numOfParams());
		getType().appendParam(arg.getType());
	}

	@Override
	public ClassScope getScope() {
		return (ClassScope) definedIn;
	}

	@Override
	public FuncType getType() {
		return (FuncType) type;
	}

	@Override
	public boolean isFunction() {
		return true;
	}

	@Override
	public String toString() {
		return location + " -> " + (statik ? "static " : "") + "function "
				+ name + " : " + type;
	}

	@Override
	public boolean isClass() {
		return false;
	}

	@Override
	public boolean isVariable() {
		return false;
	}

}
