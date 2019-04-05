package decaf.error;

import decaf.Location;

/**
 * example：'length' can only be applied to arrays<br>
 * PA2
 */
public class BadLengthError extends DecafError {

	public BadLengthError(Location location) {
		super(location);
	}

	@Override
	protected String getErrMsg() {
		return "'length' can only be applied to arrays";
	}

}
