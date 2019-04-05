package decaf.tacvm.parser;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import decaf.tacvm.Location;

public final class Errs {
	private static List<String> errs = new ArrayList<String>();

	public static final String UNRECOG_CHAR1 = "unrecognized char: '%c'";

	public static final String FUNC_NOT_DEFINE1 = "undefined function %s";

	public static final String VTABLE_NOT_EXIST1 = "no vtable named %s";

	public static final String FUNC_NOT_DECL1 = "no function named %s";

	public static final String LABEL_NOT_EXIST1 = "no label named %s";

	public static final String NEWLINE_IN_STR1 = "illegal newline in string constant %s";

	public static final String UNTERM_STR1 = "unterminated string constant: %s";

	public static void issue(Location loc, String msg, Object... args) {
		if (loc == null) {
			errs.add(String.format("*** Error: " + msg, args));
		} else {
			errs.add(String.format("*** Error at " + loc + ": " + msg, args));
		}
	}

	public static void checkPoint(PrintWriter pw) {
		if (errs.isEmpty()) {
			return;
		}
		for (String s : errs) {
			pw.println(s);
		}
		pw.close();
		System.exit(0);
	}
}
