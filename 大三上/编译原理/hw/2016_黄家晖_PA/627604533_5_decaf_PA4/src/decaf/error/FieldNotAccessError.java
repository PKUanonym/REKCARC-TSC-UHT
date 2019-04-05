package decaf.error;

import decaf.Location;

/**
 * example：field 'homework' of 'Others' not accessible here<br>
 * PA2
 */
public class FieldNotAccessError extends DecafError {

	private String name;

	private String owner;

	public FieldNotAccessError(Location location, String name, String owner) {
		super(location);
		this.name = name;
		this.owner = owner;
	}

	@Override
	protected String getErrMsg() {
		return "field '" + name + "' of '" + owner + "' not accessible here";
	}

}
