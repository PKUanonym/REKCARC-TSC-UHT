package decaf.type;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class FuncType extends Type {

	private Type returnType;

	private List<Type> argList;

	public FuncType(Type returnType) {
		this.returnType = returnType;
		argList = new ArrayList<Type>();
	}

	public int numOfParams() {
		return argList.size();
	}

	public void appendParam(Type type) {
		argList.add(type);
	}

	@Override
	public boolean compatible(Type type) {
		if (type.equal(BaseType.ERROR)) {
			return true;
		}
		if (!type.isFuncType()) {
			return false;
		}
		FuncType ft = (FuncType) type;
		if (!returnType.compatible(ft.returnType)
				|| argList.size() != ft.argList.size()) {
			return false;
		}
		Iterator<Type> iter1 = argList.iterator();
		iter1.next();
		Iterator<Type> iter2 = ft.argList.iterator();
		iter2.next();
		while (iter1.hasNext()) {
			if (!iter2.next().compatible(iter1.next())) {
				return false;
			}
		}
		return true;
	}

	@Override
	public boolean equal(Type type) {
		return equals(type);
	}

	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		for (Type type : argList) {
			sb.append(type + "->");
		}
		sb.append(returnType);
		return sb.toString();
	}

	public Type getReturnType() {
		return returnType;
	}

	@Override
	public boolean isFuncType() {
		return true;
	}

	public List<Type> getArgList() {
		return argList;
	}
}
