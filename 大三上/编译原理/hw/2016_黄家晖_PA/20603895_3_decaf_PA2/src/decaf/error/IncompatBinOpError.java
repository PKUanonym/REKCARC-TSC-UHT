package decaf.error;

import decaf.Location;

/**
 * example：incompatible operands: int + bool<br>
 * PA2
 */
public class IncompatBinOpError extends DecafError {

	private String left;

	private String right;

	private String op;

	public IncompatBinOpError(Location location, String left, String op,
			String right) {
		super(location);
		this.left = left;
		this.right = right;
		this.op = op;
	}

	@Override
	protected String getErrMsg() {
		return "incompatible operands: " + left + " " + op + " " + right;
	}

}
