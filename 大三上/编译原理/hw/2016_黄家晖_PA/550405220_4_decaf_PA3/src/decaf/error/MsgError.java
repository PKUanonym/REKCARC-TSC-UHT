package decaf.error;

import decaf.Location;

/**
 * 仅供Parser的yyerror函数使用
 */
public class MsgError extends DecafError {

	private String msg;

	public MsgError(Location location, String msg) {
		super(location);
		this.msg = msg;
	}

	@Override
	protected String getErrMsg() {
		return msg;
	}

}
