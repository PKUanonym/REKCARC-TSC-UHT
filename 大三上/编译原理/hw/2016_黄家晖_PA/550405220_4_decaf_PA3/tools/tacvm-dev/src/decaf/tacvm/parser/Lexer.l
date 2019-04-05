package decaf.tacvm.parser;

import decaf.tacvm.Location;
import decaf.tacvm.utils.MiscUtils;
 
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
		return new Location(yyline + 1, yycolumn + 1);
	}
%}

NEWLINE				= (\r|\n|\r\n)
DIGIT 				= ([0-9])
INTEGER				= ({DIGIT}+)
TEMP				= ("_T"{DIGIT}+)
LABEL				= ("_L"{DIGIT}+)
IDENT				= ([_0-9A-Za-z]+)
ENTRY				= ([_0-9A-Za-z]+"."[a-zA-Z][_0-9A-Za-z]+)
UNARY_OPERATOR		= ("+"|"-"|"*"|"/"|">"|"<"|"!"|";"|"("|")"|"%"|"["|"]"|"{"|"}"|"'"|":"|"=")
WHITESPACE			= ([ \t]+)

%x S

%%

{WHITESPACE}		{ /* Just ignore */    }
{NEWLINE}			{ /* Just ignore */    }


"if"				{ return keyword(Parser.IF);			}
"<empty>"			{ return keyword(Parser.EMPTY);			}
"parm"				{ return keyword(Parser.PARM);			}
"call"				{ return keyword(Parser.CALL);			}
"memo"				{ return keyword(Parser.MEMO);			}
"return"			{ return keyword(Parser.RETURN);		}
"branch"			{ return keyword(Parser.BRANCH);			}
"VTBL"				{ return keyword(Parser.VTBL);			}
"VTABLE"			{ return keyword(Parser.VTABLE);		}
"FUNCTION"			{ return keyword(Parser.FUNC);			}

"<="				{ return operator(Parser.LEQ);			}
">="				{ return operator(Parser.GEQ);			}
"=="				{ return operator(Parser.EQU);			}
"!="				{ return operator(Parser.NEQ);			}
"&&"				{ return operator(Parser.LAND);			}
"||"				{ return operator(Parser.LOR);			}
{UNARY_OPERATOR}	{ return operator((int)yycharat(0));	}

{INTEGER}			{ return intConst(yytext());			}
{TEMP}				{ return temp(yytext());				}
{LABEL}				{ return label(yytext());				}
{ENTRY}				{ return entry(yytext());				}
{IDENT}				{ return ident(yytext());				}


<YYINITIAL>\"		{ sloc = getLocation();		  
					  yybegin(S);
					  buffer = new StringBuilder();								    }
<S>{NEWLINE}		{ Errs.issue(sloc, Errs.NEWLINE_IN_STR1, MiscUtils.quote(buffer.toString()));}
<S><<EOF>>			{ Errs.issue(sloc, Errs.UNTERM_STR1, MiscUtils.quote(buffer.toString()));
					  yybegin(YYINITIAL);											}
<S>\"				{ yybegin(YYINITIAL);
					  return stringConst(buffer.toString(), sloc);					}
<S>"\\n"			{ buffer.append('\n');											}
<S>"\\r"			{ buffer.append('\r');											}
<S>"\\t"			{ buffer.append('\t'); 											}
<S>"\\\""			{ buffer.append('"');											}
<S>"\\\\"			{ buffer.append('\\'); 											}
<S>.				{ buffer.append(yytext()); 										}
	
.					{ Errs.issue(getLocation(), Errs.UNRECOG_CHAR1, yycharat(0));	}