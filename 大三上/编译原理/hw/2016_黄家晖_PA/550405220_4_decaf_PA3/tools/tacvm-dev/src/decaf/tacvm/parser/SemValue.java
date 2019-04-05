package decaf.tacvm.parser;

import java.util.List;

import decaf.tacvm.Location;
import decaf.tacvm.utils.MiscUtils;

public class SemValue {
	public int code;

	public Location loc;

	public int iVal;

	public String sVal;

	public List<Entry> entrys;

	public SemValue() {
	}

	public SemValue(int code) {
		this.code = code;
	}

	@Override
	public String toString() {
		String msg;
		switch (code) {
		case Parser.IF:
			msg = "keyword : if";
			break;
		case Parser.PARM:
			msg = "keyword : parm";
			break;
		case Parser.CALL:
			msg = "keyword : call";
			break;
		case Parser.MEMO:
			msg = "keyword : memo";
			break;
		case Parser.RETURN:
			msg = "keyword : return";
			break;
		case Parser.BRANCH:
			msg = "keyword : branch";
			break;
		case Parser.VTBL:
			msg = "keyword : VTBL";
			break;
		case Parser.VTABLE:
			msg = "keyword : VTABLE";
			break;
		case Parser.FUNC:
			msg = "keyword : FUNCTION";
			break;
		case Parser.LEQ:
			msg = "operator : <=";
			break;
		case Parser.GEQ:
			msg = "oprtator : >=";
			break;
		case Parser.EQU:
			msg = "operator : ==";
			break;
		case Parser.NEQ:
			msg = "operator : !=";
			break;
		case Parser.LAND:
			msg = "operator : &&";
			break;
		case Parser.LOR:
			msg = "operator : ||";
			break;
		case Parser.INT_CONST:
			msg = "constant : " + iVal;
			break;
		case Parser.STRING_CONST:
			msg = "constant : " + MiscUtils.quote(sVal);
			break;
		case Parser.TEMP:
			msg = "temp : " + sVal;
			break;
		case Parser.LABEL:
			msg = "label : " + sVal;
			break;
		case Parser.ENTRY:
			msg = "entry : " + sVal;
			break;
		case Parser.IDENT:
			msg = "ident : " + sVal;
			break;
		default:
			msg = "operator : " + (char) code;
		}
		return (String.format("%-15s%s", loc, msg));
	}
}
