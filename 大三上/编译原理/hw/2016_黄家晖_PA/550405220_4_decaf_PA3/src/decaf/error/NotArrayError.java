package decaf.error;

import decaf.Location;

/**
 * example：[] can only be applied to arrays<br>
 * PA2
 */
public class NotArrayError extends DecafError {

	public NotArrayError(Location location) {
		super(location);
	}

	@Override
	protected String getErrMsg() {
		return "[] can only be applied to arrays";
	}

}
