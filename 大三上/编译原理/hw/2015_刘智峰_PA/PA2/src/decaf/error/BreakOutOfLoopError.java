package decaf.error;

import decaf.Location;

/**
 * example：'break' is only allowed inside a loop<br>
 * PA2
 */
public class BreakOutOfLoopError extends DecafError {

	public BreakOutOfLoopError(Location location) {
		super(location);
	}

	@Override
	protected String getErrMsg() {
		return "'break' is only allowed inside a loop";
	}

}
