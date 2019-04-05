package decaf.error;

import decaf.Location;

/**
 * example：overriding variable is not allowed for var 'kittyboy'<br>
 * PA2
 */
public class OverridingVarError extends DecafError {

	private String name;

	public OverridingVarError(Location location, String name) {
		super(location);
		this.name = name;
	}

	@Override
	protected String getErrMsg() {
		return "overriding variable is not allowed for var '" + name + "'";
	}

}
