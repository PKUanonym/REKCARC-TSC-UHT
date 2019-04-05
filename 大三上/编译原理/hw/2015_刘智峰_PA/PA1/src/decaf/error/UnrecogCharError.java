package decaf.error;

import decaf.Location;

/**
 * example：unrecognized char: '@'<br>
 * PA1
 */
public class UnrecogCharError extends DecafError {

	private char c;

	public UnrecogCharError(Location location, char c) {
		super(location);
		this.c = c;
	}

	@Override
	protected String getErrMsg() {
		return "unrecognized character '" + c + "'";
	}
}
