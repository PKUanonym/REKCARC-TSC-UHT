package decaf.error;

import decaf.Location;

/**
 * example：function 'length' expects 0 argument(s) but 2 given<br>
 * PA2
 */
public class BadLengthArgError extends DecafError {

	private int count;

	public BadLengthArgError(Location location, int count) {
		super(location);
		this.count = count;
	}

	@Override
	protected String getErrMsg() {
		return "function 'length' expects 0 argument(s) but " + count
				+ " given";
	}

}
