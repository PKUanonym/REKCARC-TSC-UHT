/*
 * 本文件是构造Decaf编译器所需要的JFlex输入脚本。
 * 在第一阶段，你需要完成这个脚本的内容，请参考"JFlex Manual"中关于如何编写JFlex脚本的说明。
 *
 * 注意：在UNIX系统下你需要保证这个文件使用UNIX文本格式，可使用dos2unix命令进行文本各式转换。
 */

package decaf.frontend;

import decaf.Location;
import decaf.error.*;
import decaf.utils.MiscUtils;
 
%%
%public
%class Lexer
%extends BaseLexer
%byaccj
%line
%column
%switch
%unicode
	
%{
	private Location sloc = null;
	private StringBuilder buffer = new StringBuilder();

	public Location getLocation() {
		return new decaf.Location(yyline + 1, yycolumn + 1);
	}
%}

NEWLINE				= (\r|\n|\r\n)
DIGIT 				= ([0-9])
HEX_DIGIT 			= ([0-9A-Fa-f])
HEX_INTEGER			= (0[Xx]{HEX_DIGIT}+)
DEC_INTEGER			= ({DIGIT}+)
INTEGER				= ({HEX_INTEGER}|{DEC_INTEGER})
IDENTIFIER			= ([A-Za-z][_0-9A-Za-z]*)
SIMPLE_OPERATOR		= ("+"|"-"|"*"|"/"|"%"|"="|"<"|">"|"."|","|";"|"!"|"("|")"|"["|"]"|"{"|"}")
S_COMMENT			= ("//"[^\r\n]*{NEWLINE})
WHITESPACE			= ([ \t]+)

	// 开始条件S表示字符串
%x S

%%
	// 识别注释和空白字符的规则
{WHITESPACE}		{ /* Just ignore */    }
{NEWLINE}			{ /* Just ignore */    }
{S_COMMENT}			{ /* Just ignore */    }


	// 识别关键字的规则 
"void"				{ return keyword(Parser.VOID);			}
"int"				{ return keyword(Parser.INT);			}
"bool"				{ return keyword(Parser.BOOL);			}
"string"			{ return keyword(Parser.STRING);		}
"new"				{ return keyword(Parser.NEW);			}
"null"				{ return keyword(Parser.NULL);			}
"class"				{ return keyword(Parser.CLASS);			}
"extends"			{ return keyword(Parser.EXTENDS);		}
"this"				{ return keyword(Parser.THIS);			}
"while"				{ return keyword(Parser.WHILE);			}
"for"				{ return keyword(Parser.FOR);			}
"if"				{ return keyword(Parser.IF);			}
"else"				{ return keyword(Parser.ELSE);			}
"return"			{ return keyword(Parser.RETURN);		}
"break"				{ return keyword(Parser.BREAK);			}
"Print"				{ return keyword(Parser.PRINT);			}
"ReadInteger"		{ return keyword(Parser.READ_INTEGER);	}
"ReadLine"			{ return keyword(Parser.READ_LINE);		}
"static"			{ return keyword(Parser.STATIC);		}
"instanceof"		{ return keyword(Parser.INSTANCEOF);	}

	// 识别操作符的规则
"<="				{ return operator(Parser.LESS_EQUAL);	}
">="				{ return operator(Parser.GREATER_EQUAL);}
"=="				{ return operator(Parser.EQUAL);		}
"!="				{ return operator(Parser.NOT_EQUAL);	}
"&&"				{ return operator(Parser.AND);			}
"||"				{ return operator(Parser.OR);			}
{SIMPLE_OPERATOR}	{ return operator((int)yycharat(0));	}

	// 识别常数的规则
"true"				{ return boolConst(true);										}
"false"				{ return boolConst(false);										}
{INTEGER}			{ return intConst(yytext());			}
<YYINITIAL>\"		{ sloc = getLocation();		  
					  yybegin(S);
					  buffer = new StringBuilder();								    }
<S>{NEWLINE}		{ issueError(new NewlineInStrError(sloc, MiscUtils.quote(buffer.toString())));}
<S><<EOF>>			{ issueError(new UntermStrError(sloc, MiscUtils.quote(buffer.toString())));
					  yybegin(YYINITIAL);											}
<S>\"				{ yybegin(YYINITIAL);
					  return StringConst(buffer.toString(), sloc);						}
<S>"\\n"			{ buffer.append('\n');											}
<S>"\\t"			{ buffer.append('\t'); 											}
<S>"\\\""			{ buffer.append('"');											}
<S>"\\\\"			{ buffer.append('\\'); 											}
<S>.				{ buffer.append(yytext()); 										}

	// 识别标识符的规则
{IDENTIFIER}		{ return identifier(yytext());			}
	
	// 上面规则不能识别的字符怎么处理
.					{ issueError(new UnrecogCharError(getLocation(), yycharat(0))); 		}
