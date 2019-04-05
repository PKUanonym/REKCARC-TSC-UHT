package decaf.error;

import decaf.Location;

/**
 * example：declaration of 'abcde' here conflicts with earlier declaration at (3,2)<br>
 * PA2
 */
public class DeclConflictError extends DecafError {

	private Location earlier;

	private String name;

	public DeclConflictError(Location location, String name, Location earlier) {
		super(location);
		this.name = name;
		this.earlier = earlier;
	}

	@Override
	protected String getErrMsg() {
		return "declaration of '" + name
				+ "' here conflicts with earlier declaration at " + earlier;
	}

}
