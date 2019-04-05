package decaf.frontend;


public class ParserHelper extends Parser {
	/**
	 * 辅助模版（切勿直接调用）
	 * 
	 * @param $$
	 *            对应 YACC 语义动作中的 $$
	 * @param $1
	 *            对应 YACC 语义动作中的 $1
	 * @param $2
	 *            对应 YACC 语义动作中的 $2
	 * @param $3
	 *            对应 YACC 语义动作中的 $3
	 * @param $4
	 *            对应 YACC 语义动作中的 $4
	 * @param $5
	 *            对应 YACC 语义动作中的 $5
	 * @param $6
	 *            对应 YACC 语义动作中的 $6
	 */
	void UserAction(SemValue $$, SemValue $1, SemValue $2, SemValue $3,
			SemValue $4, SemValue $5, SemValue $6) {
		/*
		 * 这个函数作用是提供一个模版给你编写你的 YACC 语义动作。 因为在一般编辑器中编写 YACC 脚本的时候没法充分调用 IDE
		 * 的各种编辑功能， 因此专门开辟一个函数。使用的时候你只需要把语义动作写在下面的花括号中， 然后连同花括号一起复制-粘贴到 YACC
		 * 脚本对应位置即可。
		 */
		{
			
		}
	}
}
