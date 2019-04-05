package decaf.error;

import decaf.Location;

/**
 * example：new array length must be an integer<br>
 * PA2
 */
public class BadNewArrayLength extends DecafError {

	public BadNewArrayLength(Location location) {
		super(location);
	}

	@Override
	protected String getErrMsg() {
		return "new array length must be an integer";
	}

}
