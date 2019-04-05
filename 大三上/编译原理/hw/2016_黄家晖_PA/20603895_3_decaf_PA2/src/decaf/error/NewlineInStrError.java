package decaf.error;

import decaf.Location;

/**
 * example：illegal newline in string constant "this is stri"<br>
 * PA1
 */
public class NewlineInStrError extends DecafError {

	private String str;

	public NewlineInStrError(Location location, String str) {
		super(location);
		this.str = str;
	}

	@Override
	protected String getErrMsg() {
		return "illegal newline in string constant " + str;
	}

}
