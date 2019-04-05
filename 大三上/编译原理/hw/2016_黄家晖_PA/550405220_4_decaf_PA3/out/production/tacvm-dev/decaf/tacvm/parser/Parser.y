%{
package decaf.tacvm.parser;

import java.util.*;
%}

%Jclass Parser
%Jextends BaseParser
%Jsemantic SemValue
%Jimplements ReduceListener
%Jnorun
%Jnodebug
%Jnoconstruct

%token EQU NEQ GEQ LEQ LAND LOR BRANCH PARM CALL RETURN IF LABEL EMPTY
%token VTABLE FUNC TEMP ENTRY INT_CONST STRING_CONST VTBL IDENT MEMO

%start Program

%%

Program			:	VTables Funcs
				;

VTables			:	VTables VTable
				|	VTable
				;

VTable			:	VTABLE '(' IDENT ')' '{' IDENT IDENT Entrys '}'
				{
					createVTable($3.sVal, $6.sVal, $7.sVal, $8.entrys);
				}
				|	VTABLE '(' IDENT ')' '{' EMPTY IDENT Entrys '}'
				{
					createVTable($3.sVal, null, $7.sVal, $8.entrys);
				}
				;

Entrys			:	Entrys ENTRY ';'
				{
					Entry e = new Entry();
					e.name = $2.sVal;
					e.offset = -1;
					$1.entrys.add(e);
				}
				|	/* empty */
				{
					$$.entrys = new ArrayList<Entry>();
				}
				;

Funcs			:	Funcs Func
				|	Func
				;

Func			:	FuncHeader Tacs '}'
				{
					endFunc();
				}
				;

FuncHeader		:	FUNC '(' ENTRY ')' 
				{
					enterFunc($1.loc, $3.sVal);
				}
					'{' MEMO '\'' Params '\'' ENTRY ':'
				|	FUNC '(' IDENT ')' 
				{
					enterFunc($1.loc, $3.sVal);
				}
					'{' MEMO '\'' '\'' IDENT ':'
				;

Params			:	Params TEMP ':' INT_CONST
				{
					addParam($2.sVal, $4.iVal);
				}
				|	/* empty */
				;

Tacs			:	Tacs Tac
				|	/* empty */
				;

Tac				:	TEMP '=' '(' TEMP '+' TEMP ')'
				{
					genAdd($5.loc, $1.sVal, $4.sVal, $6.sVal);
				}
				|	TEMP '=' '(' TEMP '-' TEMP ')'
				{
					genSub($5.loc, $1.sVal, $4.sVal, $6.sVal);
				}
				|	TEMP '=' '(' TEMP '*' TEMP ')'
				{
					genMul($5.loc, $1.sVal, $4.sVal, $6.sVal);
				}
				|	TEMP '=' '(' TEMP '/' TEMP ')'
				{
					genDiv($5.loc, $1.sVal, $4.sVal, $6.sVal);
				}
				|	TEMP '=' '(' TEMP '%' TEMP ')'
				{
					genMod($5.loc, $1.sVal, $4.sVal, $6.sVal);
				}
				|	TEMP '=' '(' TEMP LAND TEMP ')'
				{
					genLAnd($5.loc, $1.sVal, $4.sVal, $6.sVal);
				}
				|	TEMP '=' '(' TEMP LOR TEMP ')'
				{
					genLOr($5.loc, $1.sVal, $4.sVal, $6.sVal);
				}
				|	TEMP '=' '(' TEMP '>' TEMP ')'
				{
					genGtr($5.loc, $1.sVal, $4.sVal, $6.sVal);
				}
				|	TEMP '=' '(' TEMP GEQ TEMP ')'
				{
					genGeq($5.loc, $1.sVal, $4.sVal, $6.sVal);
				}
				|	TEMP '=' '(' TEMP EQU TEMP ')'
				{
					genEqu($5.loc, $1.sVal, $4.sVal, $6.sVal);
				}
				|	TEMP '=' '(' TEMP NEQ TEMP ')'
				{
					genNeq($5.loc, $1.sVal, $4.sVal, $6.sVal);
				}
				|	TEMP '=' '(' TEMP LEQ TEMP ')'
				{
					genLeq($5.loc, $1.sVal, $4.sVal, $6.sVal);
				}
				|	TEMP '=' '(' TEMP '<' TEMP ')'
				{
					genLes($5.loc, $1.sVal, $4.sVal, $6.sVal);
				}
				|	TEMP '=' '!' TEMP
				{
					genLNot($3.loc, $1.sVal, $4.sVal);
				}
				|	TEMP '=' '-' TEMP
				{
					genNeg($3.loc, $1.sVal, $4.sVal);
				}
				|	TEMP '=' TEMP
				{
					genAssign($2.loc, $1.sVal, $3.sVal);
				}
				|	TEMP '=' INT_CONST
				{
					genLoadImm4($2.loc, $1.sVal, $3.iVal);
				}
				|	TEMP '=' STRING_CONST
				{
					genLoadStr($2.loc, $1.sVal, $3.sVal);
				}
				|	TEMP '=' '*' '(' TEMP '+' INT_CONST ')'
				{
					genLoad($2.loc, $1.sVal, $5.sVal, $7.iVal);
				}
				|	TEMP '=' '*' '(' TEMP '-' INT_CONST ')'
				{
					genLoad($2.loc, $1.sVal, $5.sVal, -$7.iVal);
				}
				|	'*' '(' TEMP '+' INT_CONST ')' '=' TEMP
				{
					genStore($7.loc, $8.sVal, $3.sVal, $5.iVal);
				}
				|	'*' '(' TEMP '-' INT_CONST ')' '=' TEMP
				{
					genStore($7.loc, $8.sVal, $3.sVal, -$5.iVal);
				}
				|	TEMP '=' CALL TEMP
				{
					genIndirectCall($3.loc, $1.sVal, $4.sVal);
				}
				|	CALL TEMP
				{
					genIndirectCall($1.loc, null, $2.sVal);
				}
				|	TEMP '=' CALL IDENT
				{
					genDirectCall($3.loc, $1.sVal, $4.sVal);
				}
				|	TEMP '=' CALL ENTRY
				{
					genDirectCall($3.loc, $1.sVal, $4.sVal);
				}
				|	CALL IDENT
				{
					genDirectCall($1.loc, null, $2.sVal);
				}
				|	CALL ENTRY
				{
					genDirectCall($1.loc, null, $2.sVal);
				}
				|	TEMP '=' VTBL '<' IDENT '>'
				{
					genLoadVtbl($2.loc, $1.sVal, $5.sVal);
				}
				|	BRANCH LABEL
				{
					genBranch($1.loc, $2.sVal);
				}
				|	IF '(' TEMP EQU INT_CONST ')' BRANCH LABEL
				{
					genBeqz($1.loc, $3.sVal, $8.sVal);
				}
				|	IF '(' TEMP NEQ INT_CONST ')' BRANCH LABEL
				{
					genBnez($1.loc, $3.sVal, $8.sVal);
				}
				|	PARM TEMP
				{
					genParm($1.loc, $2.sVal);
				}
				|	RETURN TEMP
				{
					genReturn($1.loc, $2.sVal);
				}
				|	RETURN EMPTY
				{
					genReturn($1.loc, null);
				}
				|	LABEL ':'
				{
					markLabel($1.sVal);
				}
				;

%%
    
    public boolean onReduce(String rule) {
		if (rule.startsWith("$$"))
			return false;
		else
			rule = rule.replaceAll(" \\$\\$\\d+", "");

   	    if (rule.endsWith(":"))
    	    System.out.println(rule + " <empty>");
   	    else
			System.out.println(rule);
		return false;
    }
    
    public void diagnose() {
		addReduceListener(this);
		yyparse();
	}
