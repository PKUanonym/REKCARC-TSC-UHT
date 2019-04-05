package decaf.error;

import decaf.Location;

/**
 * example：unterminated string constant: "this is str"<br>
 * PA1
 */
public class UntermStrError extends DecafError {

	private String str;

	public UntermStrError(Location location, String str) {
		super(location);
		this.str = str;
	}

	@Override
	protected String getErrMsg() {
		return "unterminated string constant " + str;
	}

}
