package decaf.error;

import decaf.Location;

/**
 * string is not a class type.
 */
public class NotClassError extends DecafError {

	private String type;

	public NotClassError(String type, Location location) {
		super(location);
		this.type = type;
	}

	@Override
	protected String getErrMsg() {
		return type + " is not a class type";
	}

}
