package decaf.machdesc;

import decaf.tac.Label;
import decaf.type.BaseType;

public final class Intrinsic {
	/**
	 * 分配内存，如果失败则自动退出程序<br>
	 * 参数: 为要分配的内存块大小（单位为字节）<br>
	 * 返回: 该内存块的首地址<br>
	 * 返回类型: 指针，需要用VarDecl的changeTypeTo()函数更改类型
	 */
	public static final Intrinsic ALLOCATE = new Intrinsic("_Alloc", 1,
			BaseType.INT);
	/**
	 * 读取一行字符串（最大63个字符）<br>
	 * 返回: 读到的字符串首地址<br>
	 * 返回类型: string
	 */
	public static final Intrinsic READ_LINE = new Intrinsic("_ReadLine", 0,
			BaseType.STRING);
	/**
	 * 读取一个整数<br>
	 * 返回: 读到的整数<br>
	 * 返回类型: int
	 */
	public static final Intrinsic READ_INT = new Intrinsic("_ReadInteger", 0,
			BaseType.INT);
	/**
	 * 比较两个字符串<br>
	 * 参数: 要比较的两个字符串的首地址<br>
	 * 返回: 若相等则返回true，否则返回false<br>
	 * 返回类型: bool
	 */
	public static final Intrinsic STRING_EQUAL = new Intrinsic("_StringEqual",
			2, BaseType.BOOL);
	/**
	 * 打印一个整数<br>
	 * 参数: 要打印的数字
	 */
	public static final Intrinsic PRINT_INT = new Intrinsic("_PrintInt", 1,
			BaseType.VOID);
	/**
	 * 打印一个字符串<br>
	 * 参数: 要打印的字符串
	 */
	public static final Intrinsic PRINT_STRING = new Intrinsic("_PrintString",
			1, BaseType.VOID);
	/**
	 * 打印一个布尔值<br>
	 * 参数: 要打印的布尔变量
	 */
	public static final Intrinsic PRINT_BOOL = new Intrinsic("_PrintBool", 1,
			BaseType.VOID);
	/**
	 * 结束程序<br>
	 * 可以作为子程序调用，也可以直接Goto
	 */
	public static final Intrinsic HALT = new Intrinsic("_Halt", 0,
			BaseType.VOID);
	/**
	 * 函数名字
	 */
	public final Label label;
	/**
	 * 函数的参数个数
	 */
	public final int numArgs;
	/**
	 * 函数返回值类型
	 */
	public final BaseType type;

	/**
	 * 构造一个预定义函数的信息
	 * 
	 * @param name
	 *            函数名字
	 * @param argc
	 *            参数个数
	 * @param type
	 *            返回类型
	 */
	private Intrinsic(String name, int numArgs, BaseType type) {
		this.label = Label.createLabel(name, false);
		this.numArgs = numArgs;
		this.type = type;
	}

}
