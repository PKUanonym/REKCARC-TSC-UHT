package decaf.translate;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import decaf.tree.Tree;
import decaf.backend.OffsetCounter;
import decaf.symbol.Class;
import decaf.symbol.Function;
import decaf.symbol.Symbol;
import decaf.symbol.Variable;
import decaf.tac.Temp;

public class TransPass1 extends Tree.Visitor {
	private Translater tr;

	private int objectSize;

	private List<Variable> vars;

	public TransPass1(Translater tr) {
		this.tr = tr;
		vars = new ArrayList<Variable>();
	}

	@Override
	public void visitTopLevel(Tree.TopLevel program) {
		for (Tree.ClassDef cd : program.classes) {
			cd.accept(this);
		}
		for (Tree.ClassDef cd : program.classes) {
			tr.createVTable(cd.symbol);
			tr.genNewForClass(cd.symbol);
		}
		for (Tree.ClassDef cd : program.classes) {
			if (cd.parent != null) {
				cd.symbol.getVtable().parent = cd.symbol.getParent()
						.getVtable();
			}
		}
	}

	@Override
	public void visitClassDef(Tree.ClassDef classDef) {
		classDef.symbol.resolveFieldOrder();
		objectSize = 0;
		vars.clear();
		for (Tree f : classDef.fields) {
			f.accept(this);
		}
		Collections.sort(vars, Symbol.ORDER_COMPARATOR);
		OffsetCounter oc = OffsetCounter.VARFIELD_OFFSET_COUNTER;
		Class c = classDef.symbol.getParent();
		if (c != null) {
			oc.set(c.getSize());
		} else {
			oc.reset();
		}
		for (Variable v : vars) {
			v.setOffset(oc.next(OffsetCounter.WORD_SIZE));
		}
	}

	@Override
	public void visitMethodDef(Tree.MethodDef funcDef) {
		Function func = funcDef.symbol;
		if (!func.isStatik()) {
			func.setOffset(2 * OffsetCounter.POINTER_SIZE + func.getOrder()
					* OffsetCounter.POINTER_SIZE);
		}
		tr.createFuncty(func);
		OffsetCounter oc = OffsetCounter.PARAMETER_OFFSET_COUNTER;
		oc.reset();
		int order;
		if (!func.isStatik()) {
			Variable v = (Variable) func.getAssociatedScope().lookup("this");
			v.setOrder(0);
			Temp t = Temp.createTempI4();
			t.sym = v;
			t.isParam = true;
			v.setTemp(t);
			v.setOffset(oc.next(OffsetCounter.POINTER_SIZE));
			order = 1;
		} else {
			order = 0;
		}
		for (Tree.VarDef vd : funcDef.formals) {
			vd.symbol.setOrder(order++);
			Temp t = Temp.createTempI4();
			t.sym = vd.symbol;
			t.isParam = true;
			vd.symbol.setTemp(t);
			vd.symbol.setOffset(oc.next(vd.symbol.getTemp().size));
		}
	}

	@Override
	public void visitVarDef(Tree.VarDef varDef) {
		vars.add(varDef.symbol);
		objectSize += OffsetCounter.WORD_SIZE;
	}

}
