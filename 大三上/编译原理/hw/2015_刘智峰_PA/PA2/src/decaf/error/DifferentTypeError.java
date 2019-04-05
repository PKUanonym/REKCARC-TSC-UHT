package decaf.error;

import decaf.Location;

public class DifferentTypeError extends DecafError{ // decaf_pa2 A?B:C

	private String middleType;
	private String rightType;
	public DifferentTypeError(Location location,String middleType, String rightType) {
		super(location);
		this.middleType = middleType;
		this.rightType = rightType;
	}

	@Override
	protected String getErrMsg() {
		return "incompatible condition operates: " + middleType + " and " + rightType;
	}

}