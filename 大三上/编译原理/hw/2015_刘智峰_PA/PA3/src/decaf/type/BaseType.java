package decaf.type;

public class BaseType extends Type {

	private final String typeName;

	private BaseType(String typeName) {
		this.typeName = typeName;
	}

	public static final BaseType INT = new BaseType("int");
	
	public static final BaseType BOOL = new BaseType("bool");

	public static final BaseType NULL = new BaseType("null");

	public static final BaseType ERROR = new BaseType("Error");
	
	public static final BaseType STRING = new BaseType("string");
	
	public static final BaseType VOID = new BaseType("void");

	@Override
	public boolean isBaseType() {
		return true;
	}

	@Override
	public boolean compatible(Type type) {
		if (equal(ERROR) || type.equal(ERROR)) {
			return true;
		}
		if (equal(NULL) && type.isClassType()) {
			return true;
		}
		return equal(type);
	}

	@Override
	public boolean equal(Type type) {
		return this == type;
	}

	@Override
	public String toString() {
		return typeName;
	}

}
