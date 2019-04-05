package decaf.frontend;

import decaf.Driver;
import decaf.tree.Tree;
import decaf.error.DecafError;
import decaf.error.MsgError;

public abstract class BaseParser {
	private Lexer lexer;

	protected Tree.TopLevel tree;

	public void setLexer(Lexer lexer) {
		this.lexer = lexer;
	}

	public Tree.TopLevel getTree() {
		return tree;
	}

	protected void issueError(DecafError error) {
		Driver.getDriver().issueError(error);
	}

	void yyerror(String msg) {
		Driver.getDriver().issueError(
				new MsgError(lexer.getLocation(), msg));
	}

	int yylex() {
		int token = -1;
		try {
			token = lexer.yylex();
		} catch (Exception e) {
			yyerror("lexer error: " + e.getMessage());
		}

		return token;
	}

	abstract int yyparse();

	public Tree.TopLevel parseFile() {
		yyparse();
		return tree;
	}

	/**
	 * 获得操作符的字符串表示
	 * 
	 * @param opCode
	 *            操作符的符号码
	 * @return 该操作符的字符串形式
	 */
	public static String opStr(int opCode) {
		switch (opCode) {
		case Parser.AND:
			return "&&";
		case Parser.EQUAL:
			return "==";
		case Parser.GREATER_EQUAL:
			return ">=";
		case Parser.LESS_EQUAL:
			return "<=";
		case Parser.NOT_EQUAL:
			return "!=";
		case Parser.OR:
			return "||";
		default:
			return "" + (char) opCode;
		}
	}
}
