package decaf.tacvm.parser;

import java.io.IOException;

import decaf.tacvm.Location;

public abstract class BaseLexer {
	private Parser parser;

	public void setParser(Parser parser) {
		this.parser = parser;
	}

	abstract int yylex() throws IOException;

	abstract Location getLocation();

	protected void setSemantic(Location loc, SemValue v) {
		v.loc = loc;
		parser.yylval = v;
	}

	protected int keyword(int code) {
		setSemantic(getLocation(), new SemValue(code));
		return code;
	}

	protected int operator(int code) {
		setSemantic(getLocation(), new SemValue(code));
		return code;
	}

	protected int intConst(String iVal) {
		SemValue v = new SemValue(Parser.INT_CONST);
		v.iVal = Integer.parseInt(iVal);
		setSemantic(getLocation(), v);
		return Parser.INT_CONST;
	}

	protected int stringConst(String sVal, Location loc) {
		SemValue v = new SemValue(Parser.STRING_CONST);
		v.sVal = sVal;
		setSemantic(loc, v);
		return Parser.STRING_CONST;
	}

	protected int temp(String name) {
		SemValue v = new SemValue(Parser.TEMP);
		v.sVal = name;
		setSemantic(getLocation(), v);
		return Parser.TEMP;
	}

	protected int entry(String name) {
		SemValue v = new SemValue(Parser.ENTRY);
		v.sVal = name;
		setSemantic(getLocation(), v);
		return Parser.ENTRY;
	}

	protected int ident(String name) {
		SemValue v = new SemValue(Parser.IDENT);
		v.sVal = name;
		setSemantic(getLocation(), v);
		return Parser.IDENT;
	}

	protected int label(String name) {
		SemValue v = new SemValue(Parser.LABEL);
		v.sVal = name;
		setSemantic(getLocation(), v);
		return Parser.LABEL;
	}
	
	public void diagnose() throws IOException {
		while (yylex() != 0) {
			System.out.println(parser.yylval);
		}
	}
}
