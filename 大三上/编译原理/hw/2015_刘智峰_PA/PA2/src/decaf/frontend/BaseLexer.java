package decaf.frontend;

import java.io.IOException;

import decaf.Driver;
import decaf.Location;
import decaf.error.DecafError;
import decaf.error.IntTooLargeError;
import decaf.tree.Tree;

public abstract class BaseLexer {

	private Parser parser;

	public void setParser(Parser parser) {
		this.parser = parser;
	}

	abstract int yylex() throws IOException;

	abstract Location getLocation();

	protected void issueError(DecafError error) {
		Driver.getDriver().issueError(error);
	}

	protected void setSemantic(Location where, SemValue v) {
		v.loc = where;
		parser.yylval = v;
	}

	protected int keyword(int code) {
		setSemantic(getLocation(), SemValue.createKeyword(code));
		return code;
	}

	protected int operator(int code) {
		setSemantic(getLocation(), SemValue.createOperator(code));
		return code;
	}

	protected int boolConst(boolean bval) {
		setSemantic(getLocation(), SemValue.createLiteral(Tree.BOOL, bval));
		return Parser.LITERAL;
	}

	protected int StringConst(String sval, Location loc) {
		setSemantic(loc, SemValue.createLiteral(Tree.STRING, sval));
		return Parser.LITERAL;
	}

	protected int intConst(String ival) {
		try {
			setSemantic(getLocation(), SemValue.createLiteral(
					Tree.INT, Integer.decode(ival)));
		} catch (NumberFormatException e) {
			Driver.getDriver().issueError(
					new IntTooLargeError(getLocation(), ival));
		}
		return Parser.LITERAL;
	}

	protected int identifier(String name) {
		setSemantic(getLocation(), SemValue.createIdentifier(name));
		return Parser.IDENTIFIER;
	}

	public void diagnose() throws IOException {
		while (yylex() != 0) {
			System.out.println(parser.yylval);
		}
	}
}
