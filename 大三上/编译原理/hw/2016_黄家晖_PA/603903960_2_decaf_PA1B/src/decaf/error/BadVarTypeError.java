package decaf.error;

import decaf.Location;

/**
 * example：cannot declare identifier 'boost' as void type<br>
 * PA2
 */
public class BadVarTypeError extends DecafError {

	private String name;

	public BadVarTypeError(Location location, String name) {
		super(location);
		this.name = name;
	}

	@Override
	protected String getErrMsg() {
		return "cannot declare identifier '" + name + "' as void type";
	}

}
