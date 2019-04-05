package decaf.error;

import decaf.Location;

/**
 * example：no legal Main class named 'Main' was found<br>
 * PA2
 */
public class NoMainClassError extends DecafError {

	private String name;

	public NoMainClassError(String name) {
		super(Location.NO_LOCATION);
		this.name = name;
	}

	@Override
	protected String getErrMsg() {
		return "no legal Main class named '" + name + "' was found";
	}

}
