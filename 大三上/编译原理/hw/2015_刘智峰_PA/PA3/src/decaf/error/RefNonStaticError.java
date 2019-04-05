package decaf.error;

import decaf.Location;

/**
 * can not reference a non-static field 'kylin' from static method from 'dove'
 * PA2
 */
public class RefNonStaticError extends DecafError {

	private String from;

	private String ref;

	public RefNonStaticError(Location location, String from, String ref) {
		super(location);
		this.from = from;
		this.ref = ref;
	}

	@Override
	protected String getErrMsg() {
		return "can not reference a non-static field '" + ref
				+ "' from static method '" + from + "'";
	}

}
