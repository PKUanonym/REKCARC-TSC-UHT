package decaf.error;

import decaf.Location;

/**
 * Condition expressions are not equal.
 */

public class IncompatCondExprError extends DecafError {

    private String left;

    private String right;

    public IncompatCondExprError(Location location, String left, String right) {
        super(location);
        this.left = left;
        this.right = right;
    }

    @Override
    protected String getErrMsg() {
        return "incompatible condition expr type: " + left + " and " + right;
    }
}
