package decaf.error;

import decaf.Location;

/**
 * switch (condition != null)
 */
public class SwitchVarNotInt extends DecafError {

    public SwitchVarNotInt(Location location) {
        super(location);
    }

    @Override
    protected String getErrMsg() {
        return "switch varible must be a int";
    }
}
