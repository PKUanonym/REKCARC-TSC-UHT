package decaf.frontend;

import java.util.List;

import decaf.Location;
import decaf.tree.Tree;
import decaf.tree.Tree.ClassDef;
import decaf.tree.Tree.Expr;
import decaf.tree.Tree.MethodDef;
import decaf.tree.Tree.LValue;
import decaf.tree.Tree.TopLevel;
import decaf.tree.Tree.VarDef;
import decaf.tree.Tree.TypeLiteral;
import decaf.utils.MiscUtils;

public class SemValue {

	public int code;

	public Location loc;

	public int typeTag;
	
	public Object literal;
	
	public String ident;

	public List<ClassDef> clist;

	/**
	 * field list
	 */
	public List<Tree> flist;

	public List<VarDef> vlist;


	/**
	 * statement list
	 */
	public List<Tree> slist;

	public List<Expr> elist;

	public TopLevel prog;

	public ClassDef cdef;

	public VarDef vdef;

	public MethodDef fdef;

	public TypeLiteral type;

	public Tree stmt;

	public Expr expr;

	public LValue lvalue;

	/**
	 * 创建一个关键字的语义值
	 * 
	 * @param code
	 *            关键字的代表码
	 * @return 对应关键字的语义值
	 */
	public static SemValue createKeyword(int code) {
		SemValue v = new SemValue();
		v.code = code;
		return v;
	}

	/**
	 * 创建一个操作符的语义值
	 * 
	 * @param code
	 *            操作符的代表码
	 * @return 对应操作符的语义值
	 */
	public static SemValue createOperator(int code) {
		SemValue v = new SemValue();
		v.code = code;
		return v;
	}

	/**
	 * 创建一个常量的语义值
	 * 
	 * @param value
	 *            常量的值
	 * @return 对应的语义值
	 */
	public static SemValue createLiteral(int tag, Object value) {
		SemValue v = new SemValue();
		v.code = Parser.LITERAL;
		v.typeTag = tag;
		v.literal = value;
		return v;
	}

	/**
	 * 创建一个标识符的语义值
	 * 
	 * @param name
	 *            标识符的名字
	 * @return 对应的语义值（标识符名字存放在sval域）
	 */
	public static SemValue createIdentifier(String name) {
		SemValue v = new SemValue();
		v.code = Parser.IDENTIFIER;
		v.ident = name;
		return v;
	}

	/**
	 * 获取这个语义值的字符串表示<br>
	 * 
	 * 我们建议你在构造词法分析器之前先阅读一下这个函数。
	 */
	public String toString() {
		String msg;
		switch (code) {
		// 关键字
		case Parser.BOOL:
			msg = "keyword  : bool";
			break;
		case Parser.BREAK:
			msg = "keyword  : break";
			break;
		case Parser.CLASS:
			msg = "keyword  : class";
			break;
		case Parser.ELSE:
			msg = "keyword  : else";
			break;
		case Parser.EXTENDS:
			msg = "keyword  : extends";
			break;
		case Parser.FOR:
			msg = "keyword  : for";
			break;
		case Parser.IF:
			msg = "keyword  : if";
			break;
		case Parser.INT:
			msg = "keyword  : int";
			break;
		case Parser.INSTANCEOF:
			msg = "keyword  : instanceof";
			break;
		case Parser.NEW:
			msg = "keyword  : new";
			break;
		case Parser.NULL:
			msg = "keyword  : null";
			break;
		case Parser.PRINT:
			msg = "keyword  : Print";
			break;
		case Parser.READ_INTEGER:
			msg = "keyword  : ReadInteger";
			break;
		case Parser.READ_LINE:
			msg = "keyword  : ReadLine";
			break;
		case Parser.RETURN:
			msg = "keyword  : return";
			break;
		case Parser.STRING:
			msg = "keyword  : string";
			break;
		case Parser.THIS:
			msg = "keyword  : this";
			break;
		case Parser.VOID:
			msg = "keyword  : void";
			break;
		case Parser.WHILE:
			msg = "keyword  : while";
			break;
		case Parser.STATIC:
			msg = "keyword : static";
			break;

		// 常量
		case Parser.LITERAL:
			switch (typeTag) {
			case Tree.INT:
			case Tree.BOOL:
				msg = "constant : " + literal;
				break;
			default:
				msg = "constant : " + MiscUtils.quote((String)literal);
			}
			break;
			
		// 标识符
		case Parser.IDENTIFIER:
			msg = "identifier: " + ident;
			break;

		// 操作符
		case Parser.AND:
			msg = "operator : &&";
			break;
		case Parser.EQUAL:
			msg = "operator : ==";
			break;
		case Parser.GREATER_EQUAL:
			msg = "operator : >=";
			break;
		case Parser.LESS_EQUAL:
			msg = "operator : <=";
			break;
		case Parser.NOT_EQUAL:
			msg = "operator : !=";
			break;
		case Parser.OR:
			msg = "operator : ||";
			break;
		default:
			msg = "operator : " + (char) code;
			break;
		}
		return (String.format("%-15s%s", loc, msg));
	}
}
