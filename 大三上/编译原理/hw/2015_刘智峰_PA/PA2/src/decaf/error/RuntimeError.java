package decaf.error;

/**
 * 运行期的错误
 */
public final class RuntimeError {

	private RuntimeError() {
	}

	public static final String ARRAY_INDEX_OUT_OF_BOUND = "Decaf runtime error: Array subscript out of bounds\n";

	public static final String NEGATIVE_ARR_SIZE = "Decaf runtime error: Cannot create negative-sized array\n";
	
	public static final String CLASS_CAST_ERROR1 = "Decaf runtime error: ";
	
	public static final String CLASS_CAST_ERROR2 = " cannot be cast to ";
	
	public static final String CLASS_CAST_ERROR3 = "\n";
}
