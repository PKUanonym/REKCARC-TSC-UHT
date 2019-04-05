package decaf.error;

import decaf.Location;

/**
 * Case Label is not const int
 */
public class CaseLabelNotConstError extends DecafError {

    public CaseLabelNotConstError(Location location) {
        super(location);
    }

    @Override
    protected String getErrMsg() {
        return "case label must be a constant int";
    }
}
