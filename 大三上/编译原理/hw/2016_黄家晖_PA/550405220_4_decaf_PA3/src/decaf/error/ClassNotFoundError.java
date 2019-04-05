package decaf.error;

import decaf.Location;

/**
 * example：class 'zig' not found<br>
 * PA2
 */
public class ClassNotFoundError extends DecafError {

	private String name;

	public ClassNotFoundError(Location location, String name) {
		super(location);
		this.name = name;
	}

	@Override
	protected String getErrMsg() {
		return "class '" + name + "' not found";
	}

}
