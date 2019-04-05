package decaf.error;

import decaf.Location;

/**
 * example：field 'money' not found in 'Student'<br>
 * PA2
 */
public class FieldNotFoundError extends DecafError {

	private String name;

	private String owner;

	public FieldNotFoundError(Location location, String name, String owner) {
		super(location);
		this.name = name;
		this.owner = owner;
	}

	@Override
	protected String getErrMsg() {
		return "field '" + name + "' not found in '" + owner + "'";
	}

}
