package decaf.error;

import decaf.Location;

/**
 * example：array base type must be non-void type<br>
 * PA2
 */
public class BadArrElementError extends DecafError {

	public BadArrElementError(Location location) {
		super(location);
	}

	@Override
	protected String getErrMsg() {
		return "array element type must be non-void type";
	}

}
