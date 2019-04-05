package decaf.error;

import decaf.Location;

/**
 * example：incompatible return: int[] given, int expected<br>
 * PA2
 */
public class BadReturnTypeError extends DecafError {

	private String expect;

	private String given;

	public BadReturnTypeError(Location location, String expect, String given) {
		super(location);
		this.expect = expect;
		this.given = given;
	}

	@Override
	protected String getErrMsg() {
		return "incompatible return: " + given + " given, " + expect
				+ " expected";
	}
}
