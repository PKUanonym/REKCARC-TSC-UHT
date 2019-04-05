package decaf.error;

import decaf.Location;

/**
 * example：'orz' is not a method in class 'Person'<br>
 * PA2
 */
public class NotClassMethodError extends DecafError {

	private String name;

	private String owner;

	public NotClassMethodError(Location location, String name, String owner) {
		super(location);
		this.name = name;
		this.owner = owner;
	}

	@Override
	protected String getErrMsg() {
		return "'" + name + "' is not a method in class '" + owner + "'";
	}

}
