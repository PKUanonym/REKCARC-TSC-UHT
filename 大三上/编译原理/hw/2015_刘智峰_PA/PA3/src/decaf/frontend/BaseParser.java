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
		case Tree.AND:
			return "&&";
		case Tree.EQ:
			return "==";
		case Tree.GE:
			return ">=";
		case Tree.LE:
			return "<=";
		case Tree.NE:
			return "!=";
		case Tree.OR:
			return "||";
		case Tree.PLUS:
			return "+";
		case Tree.MINUS:
		case Tree.NEG:
			return "-";
		case Tree.MUL:
			return "*";
		case Tree.DIV:
			return "/";
		case Tree.MOD:
			return "%";
		case Tree.GT:
			return ">";
		case Tree.LT:
			return "<";
		default:
			return "unknow";
		}
	}
}
