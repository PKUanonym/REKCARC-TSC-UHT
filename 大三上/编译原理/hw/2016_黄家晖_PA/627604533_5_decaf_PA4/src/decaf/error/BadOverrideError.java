package decaf.error;

import decaf.Location;

/**
 * example：overriding method 'tooold' doesn't match the type signature in class
 * 'duckyaya'<br>
 * PA2
 */
public class BadOverrideError extends DecafError {

	private String funcName;

	private String parentName;

	public BadOverrideError(Location location, String funcName,
			String parentName) {
		super(location);
		this.funcName = funcName;
		this.parentName = parentName;
	}

	@Override
	protected String getErrMsg() {
		return "overriding method '" + funcName
				+ "' doesn't match the type signature in class '" + parentName
				+ "'";
	}

}
