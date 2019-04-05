package decaf.error;

import decaf.Location;

/**
 * example：array subscript must be an integer<br>
 * PA2
 */
public class SubNotIntError extends DecafError {

	public SubNotIntError(Location location) {
		super(location);
	}

	@Override
	protected String getErrMsg() {
		return "array subscript must be an integer";
	}

}
