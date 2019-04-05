package decaf.error;

import decaf.Location;

/**
 * example：test expression must have bool type<br>
 * PA2
 */
public class BadTestExpr extends DecafError {

	public BadTestExpr(Location location) {
		super(location);
	}

	@Override
	protected String getErrMsg() {
		return "test expression must have bool type";
	}

}
