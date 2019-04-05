package decaf.symbol;

import java.util.Iterator;

import decaf.Driver;
import decaf.Location;
import decaf.backend.OffsetCounter;
import decaf.scope.ClassScope;
import decaf.scope.GlobalScope;
import decaf.tac.Label;
import decaf.tac.VTable;
import decaf.type.ClassType;

public class Class extends Symbol {

	private String parentName;

	private ClassScope associatedScope;

	private int order;

	private boolean check;

	private int numNonStaticFunc;

	private int numVar;

	private int size;

	private VTable vtable;

	private Label newFuncLabel;

	public Label getNewFuncLabel() {
		return newFuncLabel;
	}

	public void setNewFuncLabel(Label newFuncLabel) {
		this.newFuncLabel = newFuncLabel;
	}

	public VTable getVtable() {
		return vtable;
	}

	public void setVtable(VTable vtable) {
		this.vtable = vtable;
	}

	public int getSize() {
		return size;
	}

	public void setSize(int size) {
		this.size = size;
	}

	public int getNumNonStaticFunc() {
		return numNonStaticFunc;
	}

	public void setNumNonStaticFunc(int numNonStaticFunc) {
		this.numNonStaticFunc = numNonStaticFunc;
	}

	public int getNumVar() {
		return numVar;
	}

	public void setNumVar(int numVar) {
		this.numVar = numVar;
	}

	public Class(String name, String parentName, Location location) {
		this.name = name;
		this.parentName = parentName;
		this.location = location;
		this.order = -1;
		this.check = false;
		this.numNonStaticFunc = -1;
		this.numVar = -1;
		this.associatedScope = new ClassScope(this);
	}

	public void createType() {
		Class p = getParent();
		if (p == null) {
			type = new ClassType(this, null);
		} else {
			if (p.getType() == null) {
				p.createType();
			}
			type = new ClassType(this, (ClassType) p.getType());
		}
	}

	@Override
	public ClassType getType() {
		if (type == null) {
			createType();
		}
		return (ClassType) type;
	}

	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder(location + " -> class " + name);
		if (parentName != null) {
			sb.append(" : " + parentName);
		}
		return sb.toString();
	}

	public ClassScope getAssociatedScope() {
		return associatedScope;
	}

	public Class getParent() {
		return Driver.getDriver().getTable().lookupClass(parentName);
	}

	@Override
	public boolean isClass() {
		return true;
	}

	@Override
	public GlobalScope getScope() {
		return (GlobalScope) definedIn;
	}

	public int getOrder() {
		return order;
	}

	public void setOrder(int order) {
		this.order = order;
	}

	public void dettachParent() {
		parentName = null;
	}

	public boolean isCheck() {
		return check;
	}

	public void setCheck(boolean check) {
		this.check = check;
	}

	public void resolveFieldOrder() {
		if (numNonStaticFunc >= 0 && numVar >= 0) {
			return;
		}
		if (parentName != null) {
			Class parent = getParent();
			parent.resolveFieldOrder();
			numNonStaticFunc = parent.numNonStaticFunc;
			numVar = parent.numVar;
			size = parent.size;
		} else {
			numNonStaticFunc = 0;
			numVar = 0;
			size = OffsetCounter.POINTER_SIZE;
		}

		ClassScope ps = associatedScope.getParentScope();
		Iterator<Symbol> iter = associatedScope.iterator();
		while (iter.hasNext()) {
			Symbol sym = iter.next();
			if (sym.isVariable()) {
				sym.setOrder(numVar++);
				size += OffsetCounter.WORD_SIZE;
			} else if (!((Function) sym).isStatik()) {
				if (ps == null) {
					sym.setOrder(numNonStaticFunc++);
				} else {
					Symbol s = ps.lookupVisible(sym.name);
					if (s == null) {
						sym.setOrder(numNonStaticFunc++);
					} else {
						sym.setOrder(s.getOrder());
					}
				}
			}
		}
	}

	@Override
	public boolean isFunction() {
		return false;
	}

	@Override
	public boolean isVariable() {
		return false;
	}
}
