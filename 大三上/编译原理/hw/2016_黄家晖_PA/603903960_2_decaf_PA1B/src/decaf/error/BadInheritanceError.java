package decaf.error;

import decaf.Location;

/**
 * example：illegal class inheritance (should be a cyclic)<br>
 * PA2
 */
public class BadInheritanceError extends DecafError {

	public BadInheritanceError(Location location) {
		super(location);
	}

	@Override
	protected String getErrMsg() {
		return "illegal class inheritance (should be a cyclic)";
	}

}
