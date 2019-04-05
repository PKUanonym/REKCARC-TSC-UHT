//### This file created by BYACC 1.8(/Java extension  1.13)
//### Java capabilities added 7 Jan 97, Bob Jamison
//### Updated : 27 Nov 97  -- Bob Jamison, Joe Nieten
//###           01 Jan 98  -- Bob Jamison -- fixed generic semantic constructor
//###           01 Jun 99  -- Bob Jamison -- added Runnable support
//###           06 Aug 00  -- Bob Jamison -- made state variables class-global
//###           03 Jan 01  -- Bob Jamison -- improved flags, tracing
//###           16 May 01  -- Bob Jamison -- added custom stack sizing
//###           04 Mar 02  -- Yuval Oren  -- improved java performance, added options
//###           14 Mar 02  -- Tomas Hurka -- -d support, static initializer workaround
//###           14 Sep 06  -- Keltin Leung-- ReduceListener support, eliminate underflow report in error recovery
//### Please send bug reports to tom@hukatronic.cz
//### static char yysccsid[] = "@(#)yaccpar	1.8 (Berkeley) 01/20/90";






//#line 2 "Parser.y"
package decaf.tacvm.parser;

import java.util.*;
//#line 22 "Parser.java"
interface ReduceListener {
  public boolean onReduce(String rule);
}




public class Parser
             extends BaseParser
             implements ReduceListener
{

boolean yydebug;        //do I want debug output?
int yynerrs;            //number of errors so far
int yyerrflag;          //was there an error?
int yychar;             //the current working character

ReduceListener reduceListener = null;
void yyclearin ()       {yychar = (-1);}
void yyerrok ()         {yyerrflag=0;}
void addReduceListener(ReduceListener l) {
  reduceListener = l;}


//########## MESSAGES ##########
//###############################################################
// method: debug
//###############################################################
void debug(String msg)
{
  if (yydebug)
    System.out.println(msg);
}

//########## STATE STACK ##########
final static int YYSTACKSIZE = 500;  //maximum stack size
int statestk[] = new int[YYSTACKSIZE]; //state stack
int stateptr;
int stateptrmax;                     //highest index of stackptr
int statemax;                        //state when highest index reached
//###############################################################
// methods: state stack push,pop,drop,peek
//###############################################################
final void state_push(int state)
{
  try {
		stateptr++;
		statestk[stateptr]=state;
	 }
	 catch (ArrayIndexOutOfBoundsException e) {
     int oldsize = statestk.length;
     int newsize = oldsize * 2;
     int[] newstack = new int[newsize];
     System.arraycopy(statestk,0,newstack,0,oldsize);
     statestk = newstack;
     statestk[stateptr]=state;
  }
}
final int state_pop()
{
  return statestk[stateptr--];
}
final void state_drop(int cnt)
{
  stateptr -= cnt; 
}
final int state_peek(int relative)
{
  return statestk[stateptr-relative];
}
//###############################################################
// method: init_stacks : allocate and prepare stacks
//###############################################################
final boolean init_stacks()
{
  stateptr = -1;
  val_init();
  return true;
}
//###############################################################
// method: dump_stacks : show n levels of the stacks
//###############################################################
void dump_stacks(int count)
{
int i;
  System.out.println("=index==state====value=     s:"+stateptr+"  v:"+valptr);
  for (i=0;i<count;i++)
    System.out.println(" "+i+"    "+statestk[i]+"      "+valstk[i]);
  System.out.println("======================");
}


//########## SEMANTIC VALUES ##########
//## **user defined:SemValue
String   yytext;//user variable to return contextual strings
SemValue yyval; //used to return semantic vals from action routines
SemValue yylval;//the 'lval' (result) I got from yylex()
SemValue valstk[] = new SemValue[YYSTACKSIZE];
int valptr;
//###############################################################
// methods: value stack push,pop,drop,peek.
//###############################################################
final void val_init()
{
  yyval=new SemValue();
  yylval=new SemValue();
  valptr=-1;
}
final void val_push(SemValue val)
{
  try {
    valptr++;
    valstk[valptr]=val;
  }
  catch (ArrayIndexOutOfBoundsException e) {
    int oldsize = valstk.length;
    int newsize = oldsize*2;
    SemValue[] newstack = new SemValue[newsize];
    System.arraycopy(valstk,0,newstack,0,oldsize);
    valstk = newstack;
    valstk[valptr]=val;
  }
}
final SemValue val_pop()
{
  return valstk[valptr--];
}
final void val_drop(int cnt)
{
  valptr -= cnt;
}
final SemValue val_peek(int relative)
{
  return valstk[valptr-relative];
}
//#### end semantic value section ####
public final static short EQU=257;
public final static short NEQ=258;
public final static short GEQ=259;
public final static short LEQ=260;
public final static short LAND=261;
public final static short LOR=262;
public final static short BRANCH=263;
public final static short PARM=264;
public final static short CALL=265;
public final static short RETURN=266;
public final static short IF=267;
public final static short LABEL=268;
public final static short EMPTY=269;
public final static short VTABLE=270;
public final static short FUNC=271;
public final static short TEMP=272;
public final static short ENTRY=273;
public final static short INT_CONST=274;
public final static short STRING_CONST=275;
public final static short VTBL=276;
public final static short IDENT=277;
public final static short MEMO=278;
public final static short YYERRCODE=256;
final static short yylhs[] = {                           -1,
    0,    1,    1,    3,    3,    4,    4,    2,    2,    5,
    8,    6,   10,    6,    9,    9,    7,    7,   11,   11,
   11,   11,   11,   11,   11,   11,   11,   11,   11,   11,
   11,   11,   11,   11,   11,   11,   11,   11,   11,   11,
   11,   11,   11,   11,   11,   11,   11,   11,   11,   11,
   11,   11,   11,   11,
};
final static short yylen[] = {                            2,
    2,    2,    1,    9,    9,    3,    0,    2,    1,    3,
    0,   12,    0,   11,    4,    0,    2,    0,    7,    7,
    7,    7,    7,    7,    7,    7,    7,    7,    7,    7,
    7,    4,    4,    3,    3,    3,    8,    8,    8,    8,
    4,    2,    4,    4,    2,    2,    6,    2,    8,    8,
    2,    2,    2,    2,
};
final static short yydefred[] = {                         0,
    0,    0,    0,    3,    0,    0,    0,    2,    9,   18,
    0,    0,    8,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   10,    0,   17,    0,   11,   13,
   48,   51,   42,   46,   45,   53,   52,    0,   54,    0,
    0,    0,    0,    0,    0,    0,    0,   34,   35,   36,
    0,    0,    0,    0,    0,    0,    7,    7,    0,    0,
    0,    0,   41,   44,   43,    0,    0,   33,    0,   32,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    5,    4,   16,    0,
    0,    0,   47,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    6,    0,    0,    0,    0,   28,   29,   27,   30,   24,
   25,   19,   20,   21,   22,   23,   26,   31,    0,    0,
    0,    0,    0,    0,    0,   49,   50,   37,   38,   39,
   40,    0,    0,   14,   15,   12,
};
final static short yydgoto[] = {                          2,
    3,    7,    4,   73,    9,   10,   14,   44,  122,   45,
   27,
};
final static short yysindex[] = {                      -242,
   -9,    0, -244,    0, -257,   -7, -234,    0,    0,    0,
   -3, -259,    0,  -39,  -84,   -1,    1, -227, -229, -262,
 -250,    4,  -12,  -16,    0,    8,    0, -264,    0,    0,
    0,    0,    0,    0,    0,    0,    0, -221,    0,  -33,
 -220, -224, -223,  -73,  -68, -222, -256,    0,    0,    0,
   -4, -215, -214,   19, -212,  -37,    0,    0, -217, -216,
 -211, -210,    0,    0,    0, -209,  -13,    0, -207,    0,
 -208, -205, -123, -121,   28,   31,   30,   32,   10, -198,
 -197, -196, -195, -194, -193, -192, -191, -190, -189, -188,
 -187, -185,  -20,   47,   48,   33,    0,    0,    0,   51,
 -172, -170,    0,   53,   54,   55,   56,   57,   58,   59,
   60,   61,   62,   63,   64,   65, -167, -166,   49,   50,
    0,  -38, -168, -156, -155,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   73,   74,
 -154, -153,   66, -157,   67,    0,    0,    0,    0,    0,
    0, -152,   68,    0,    0,    0,
};
final static short yyrindex[] = {                         0,
    0,    0,    0,    0,    0,    0,  117,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,
};
final static short yygindex[] = {                         0,
    0,    0,  118,   69,  113,    0,    0,    0,    0,    0,
    0,
};
final static int YYTABLESIZE=249;
static short yytable[];
static { yytable();}
static void yytable(){
yytable = new short[]{                         55,
  144,   97,   26,   98,   42,   71,   52,   72,   54,   33,
   34,   53,   43,   16,   35,   63,   64,   17,   36,   11,
   65,   37,  117,   90,  118,    1,    6,    1,   88,   86,
    5,   87,   12,   89,   61,   62,    6,   15,   28,   29,
   31,   30,   32,   38,   40,   39,   92,   41,   91,   59,
   46,   56,   57,   58,   60,   66,   67,   68,   69,   70,
   75,   76,   77,   78,   93,   94,   99,   79,   95,  100,
  101,  103,  102,  104,  105,  106,  107,  108,  109,  110,
  111,  112,  113,  114,  115,   25,  116,  119,  120,  123,
  124,  121,  125,  126,  127,  128,  129,  130,  131,  132,
  133,  134,  135,  136,  137,  138,  139,  140,  145,  141,
  142,  146,  147,  148,  149,  153,    1,  150,  151,   13,
    8,  155,    0,  152,  154,  156,   74,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   96,
    0,   96,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   18,   19,   20,   21,   22,   23,    0,
    0,   47,   24,  143,    0,    0,    0,    0,   48,    0,
   49,   50,   51,   80,   81,   82,   83,   84,   85,
};
}
static short yycheck[];
static { yycheck(); }
static void yycheck() {
yycheck = new short[] {                         33,
   39,  125,   42,  125,  269,   43,   40,   45,   42,  272,
  273,   45,  277,  273,  277,  272,  273,  277,  269,  277,
  277,  272,   43,   37,   45,  270,  271,  270,   42,   43,
   40,   45,   40,   47,  257,  258,  271,   41,  123,   41,
  268,   41,  272,   40,   61,   58,   60,   40,   62,  123,
  272,  272,  277,  277,  123,   60,  272,  272,   40,  272,
  278,  278,  274,  274,  272,  274,   39,  277,  274,   39,
   41,   62,   41,  272,  272,  272,  272,  272,  272,  272,
  272,  272,  272,  272,  272,  125,  272,   41,   41,   39,
  263,   59,  263,   41,   41,   41,   41,   41,   41,   41,
   41,   41,   41,   41,   41,   41,  274,  274,  277,   61,
   61,  268,  268,   41,   41,  273,    0,  272,  272,    7,
    3,  274,   -1,   58,   58,   58,   58,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  273,
   -1,  273,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  263,  264,  265,  266,  267,  268,   -1,
   -1,  265,  272,  272,   -1,   -1,   -1,   -1,  272,   -1,
  274,  275,  276,  257,  258,  259,  260,  261,  262,
};
}
final static short YYFINAL=2;
final static short YYMAXTOKEN=278;
final static String yyname[] = {
"end-of-file",null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,"'!'",null,null,null,"'%'",null,"'\\''","'('","')'","'*'","'+'",
null,"'-'",null,"'/'",null,null,null,null,null,null,null,null,null,null,"':'",
"';'","'<'","'='","'>'",null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,"'{'",null,"'}'",null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,"EQU","NEQ","GEQ","LEQ","LAND","LOR",
"BRANCH","PARM","CALL","RETURN","IF","LABEL","EMPTY","VTABLE","FUNC","TEMP",
"ENTRY","INT_CONST","STRING_CONST","VTBL","IDENT","MEMO",
};
final static String yyrule[] = {
"$accept : Program",
"Program : VTables Funcs",
"VTables : VTables VTable",
"VTables : VTable",
"VTable : VTABLE '(' IDENT ')' '{' IDENT IDENT Entrys '}'",
"VTable : VTABLE '(' IDENT ')' '{' EMPTY IDENT Entrys '}'",
"Entrys : Entrys ENTRY ';'",
"Entrys :",
"Funcs : Funcs Func",
"Funcs : Func",
"Func : FuncHeader Tacs '}'",
"$$1 :",
"FuncHeader : FUNC '(' ENTRY ')' $$1 '{' MEMO '\\'' Params '\\'' ENTRY ':'",
"$$2 :",
"FuncHeader : FUNC '(' IDENT ')' $$2 '{' MEMO '\\'' '\\'' IDENT ':'",
"Params : Params TEMP ':' INT_CONST",
"Params :",
"Tacs : Tacs Tac",
"Tacs :",
"Tac : TEMP '=' '(' TEMP '+' TEMP ')'",
"Tac : TEMP '=' '(' TEMP '-' TEMP ')'",
"Tac : TEMP '=' '(' TEMP '*' TEMP ')'",
"Tac : TEMP '=' '(' TEMP '/' TEMP ')'",
"Tac : TEMP '=' '(' TEMP '%' TEMP ')'",
"Tac : TEMP '=' '(' TEMP LAND TEMP ')'",
"Tac : TEMP '=' '(' TEMP LOR TEMP ')'",
"Tac : TEMP '=' '(' TEMP '>' TEMP ')'",
"Tac : TEMP '=' '(' TEMP GEQ TEMP ')'",
"Tac : TEMP '=' '(' TEMP EQU TEMP ')'",
"Tac : TEMP '=' '(' TEMP NEQ TEMP ')'",
"Tac : TEMP '=' '(' TEMP LEQ TEMP ')'",
"Tac : TEMP '=' '(' TEMP '<' TEMP ')'",
"Tac : TEMP '=' '!' TEMP",
"Tac : TEMP '=' '-' TEMP",
"Tac : TEMP '=' TEMP",
"Tac : TEMP '=' INT_CONST",
"Tac : TEMP '=' STRING_CONST",
"Tac : TEMP '=' '*' '(' TEMP '+' INT_CONST ')'",
"Tac : TEMP '=' '*' '(' TEMP '-' INT_CONST ')'",
"Tac : '*' '(' TEMP '+' INT_CONST ')' '=' TEMP",
"Tac : '*' '(' TEMP '-' INT_CONST ')' '=' TEMP",
"Tac : TEMP '=' CALL TEMP",
"Tac : CALL TEMP",
"Tac : TEMP '=' CALL IDENT",
"Tac : TEMP '=' CALL ENTRY",
"Tac : CALL IDENT",
"Tac : CALL ENTRY",
"Tac : TEMP '=' VTBL '<' IDENT '>'",
"Tac : BRANCH LABEL",
"Tac : IF '(' TEMP EQU INT_CONST ')' BRANCH LABEL",
"Tac : IF '(' TEMP NEQ INT_CONST ')' BRANCH LABEL",
"Tac : PARM TEMP",
"Tac : RETURN TEMP",
"Tac : RETURN EMPTY",
"Tac : LABEL ':'",
};

//#line 232 "Parser.y"
    
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
//#line 365 "Parser.java"
//###############################################################
// method: yylexdebug : check lexer state
//###############################################################
void yylexdebug(int state,int ch)
{
String s=null;
  if (ch < 0) ch=0;
  if (ch <= YYMAXTOKEN) //check index bounds
     s = yyname[ch];    //now get it
  if (s==null)
    s = "illegal-symbol";
  debug("state "+state+", reading "+ch+" ("+s+")");
}





//The following are now global, to aid in error reporting
int yyn;       //next next thing to do
int yym;       //
int yystate;   //current parsing state from state table
String yys;    //current token string


//###############################################################
// method: yyparse : parse input and execute indicated items
//###############################################################
int yyparse()
{
boolean doaction;
  init_stacks();
  yynerrs = 0;
  yyerrflag = 0;
  yychar = -1;          //impossible char forces a read
  yystate=0;            //initial state
  state_push(yystate);  //save it
  while (true) //until parsing is done, either correctly, or w/error
    {
    doaction=true;
    //if (yydebug) debug("loop"); 
    //#### NEXT ACTION (from reduction table)
    for (yyn=yydefred[yystate];yyn==0;yyn=yydefred[yystate])
      {
      //if (yydebug) debug("yyn:"+yyn+"  state:"+yystate+"  yychar:"+yychar);
      if (yychar < 0)      //we want a char?
        {
        yychar = yylex();  //get next token
        //if (yydebug) debug(" next yychar:"+yychar);
        //#### ERROR CHECK ####
        //if (yychar < 0)    //it it didn't work/error
        //  {
        //  yychar = 0;      //change it to default string (no -1!)
          //if (yydebug)
          //  yylexdebug(yystate,yychar);
        //  }
        }//yychar<0
      yyn = yysindex[yystate];  //get amount to shift by (shift index)
      if ((yyn != 0) && (yyn += yychar) >= 0 &&
          yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
        {
        //if (yydebug)
          //debug("state "+yystate+", shifting to state "+yytable[yyn]);
        //#### NEXT STATE ####
        yystate = yytable[yyn];//we are in a new state
        state_push(yystate);   //save it
        val_push(yylval);      //push our lval as the input for next rule
        yychar = -1;           //since we have 'eaten' a token, say we need another
        if (yyerrflag > 0)     //have we recovered an error?
           --yyerrflag;        //give ourselves credit
        doaction=false;        //but don't process yet
        break;   //quit the yyn=0 loop
        }

    yyn = yyrindex[yystate];  //reduce
    if ((yyn !=0 ) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
      {   //we reduced!
      //if (yydebug) debug("reduce");
      yyn = yytable[yyn];
      doaction=true; //get ready to execute
      break;         //drop down to actions
      }
    else //ERROR RECOVERY
      {
      if (yyerrflag==0)
        {
        yyerror("syntax error");
        yynerrs++;
        }
      if (yyerrflag < 3) //low error count?
        {
        yyerrflag = 3;
        while (true)   //do until break
          {
          if (stateptr<0 || valptr<0)   //check for under & overflow here
            {
            return 1;
            }
          yyn = yysindex[state_peek(0)];
          if ((yyn != 0) && (yyn += YYERRCODE) >= 0 &&
                    yyn <= YYTABLESIZE && yycheck[yyn] == YYERRCODE)
            {
            //if (yydebug)
              //debug("state "+state_peek(0)+", error recovery shifting to state "+yytable[yyn]+" ");
            yystate = yytable[yyn];
            state_push(yystate);
            val_push(yylval);
            doaction=false;
            break;
            }
          else
            {
            //if (yydebug)
              //debug("error recovery discarding state "+state_peek(0)+" ");
            if (stateptr<0 || valptr<0)   //check for under & overflow here
              {
              return 1;
              }
            state_pop();
            val_pop();
            }
          }
        }
      else            //discard this token
        {
        if (yychar == 0)
          return 1; //yyabort
        //if (yydebug)
          //{
          //yys = null;
          //if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
          //if (yys == null) yys = "illegal-symbol";
          //debug("state "+yystate+", error recovery discards token "+yychar+" ("+yys+")");
          //}
        yychar = -1;  //read another
        }
      }//end error recovery
    }//yyn=0 loop
    if (!doaction)   //any reason not to proceed?
      continue;      //skip action
    yym = yylen[yyn];          //get count of terminals on rhs
    //if (yydebug)
      //debug("state "+yystate+", reducing "+yym+" by rule "+yyn+" ("+yyrule[yyn]+")");
    if (yym>0)                 //if count of rhs not 'nil'
      yyval = val_peek(yym-1); //get current semantic value
    if (reduceListener == null || reduceListener.onReduce(yyrule[yyn])) // if intercepted!
      switch(yyn)
      {
//########## USER-SUPPLIED ACTIONS ##########
case 4:
//#line 30 "Parser.y"
{
					createVTable(val_peek(6).sVal, val_peek(3).sVal, val_peek(2).sVal, val_peek(1).entrys);
				}
break;
case 5:
//#line 34 "Parser.y"
{
					createVTable(val_peek(6).sVal, null, val_peek(2).sVal, val_peek(1).entrys);
				}
break;
case 6:
//#line 40 "Parser.y"
{
					Entry e = new Entry();
					e.name = val_peek(1).sVal;
					e.offset = -1;
					val_peek(2).entrys.add(e);
				}
break;
case 7:
//#line 47 "Parser.y"
{
					yyval.entrys = new ArrayList<Entry>();
				}
break;
case 10:
//#line 57 "Parser.y"
{
					endFunc();
				}
break;
case 11:
//#line 63 "Parser.y"
{
					enterFunc(val_peek(3).loc, val_peek(1).sVal);
				}
break;
case 13:
//#line 68 "Parser.y"
{
					enterFunc(val_peek(3).loc, val_peek(1).sVal);
				}
break;
case 15:
//#line 75 "Parser.y"
{
					addParam(val_peek(2).sVal, val_peek(0).iVal);
				}
break;
case 19:
//#line 86 "Parser.y"
{
					genAdd(val_peek(2).loc, val_peek(6).sVal, val_peek(3).sVal, val_peek(1).sVal);
				}
break;
case 20:
//#line 90 "Parser.y"
{
					genSub(val_peek(2).loc, val_peek(6).sVal, val_peek(3).sVal, val_peek(1).sVal);
				}
break;
case 21:
//#line 94 "Parser.y"
{
					genMul(val_peek(2).loc, val_peek(6).sVal, val_peek(3).sVal, val_peek(1).sVal);
				}
break;
case 22:
//#line 98 "Parser.y"
{
					genDiv(val_peek(2).loc, val_peek(6).sVal, val_peek(3).sVal, val_peek(1).sVal);
				}
break;
case 23:
//#line 102 "Parser.y"
{
					genMod(val_peek(2).loc, val_peek(6).sVal, val_peek(3).sVal, val_peek(1).sVal);
				}
break;
case 24:
//#line 106 "Parser.y"
{
					genLAnd(val_peek(2).loc, val_peek(6).sVal, val_peek(3).sVal, val_peek(1).sVal);
				}
break;
case 25:
//#line 110 "Parser.y"
{
					genLOr(val_peek(2).loc, val_peek(6).sVal, val_peek(3).sVal, val_peek(1).sVal);
				}
break;
case 26:
//#line 114 "Parser.y"
{
					genGtr(val_peek(2).loc, val_peek(6).sVal, val_peek(3).sVal, val_peek(1).sVal);
				}
break;
case 27:
//#line 118 "Parser.y"
{
					genGeq(val_peek(2).loc, val_peek(6).sVal, val_peek(3).sVal, val_peek(1).sVal);
				}
break;
case 28:
//#line 122 "Parser.y"
{
					genEqu(val_peek(2).loc, val_peek(6).sVal, val_peek(3).sVal, val_peek(1).sVal);
				}
break;
case 29:
//#line 126 "Parser.y"
{
					genNeq(val_peek(2).loc, val_peek(6).sVal, val_peek(3).sVal, val_peek(1).sVal);
				}
break;
case 30:
//#line 130 "Parser.y"
{
					genLeq(val_peek(2).loc, val_peek(6).sVal, val_peek(3).sVal, val_peek(1).sVal);
				}
break;
case 31:
//#line 134 "Parser.y"
{
					genLes(val_peek(2).loc, val_peek(6).sVal, val_peek(3).sVal, val_peek(1).sVal);
				}
break;
case 32:
//#line 138 "Parser.y"
{
					genLNot(val_peek(1).loc, val_peek(3).sVal, val_peek(0).sVal);
				}
break;
case 33:
//#line 142 "Parser.y"
{
					genNeg(val_peek(1).loc, val_peek(3).sVal, val_peek(0).sVal);
				}
break;
case 34:
//#line 146 "Parser.y"
{
					genAssign(val_peek(1).loc, val_peek(2).sVal, val_peek(0).sVal);
				}
break;
case 35:
//#line 150 "Parser.y"
{
					genLoadImm4(val_peek(1).loc, val_peek(2).sVal, val_peek(0).iVal);
				}
break;
case 36:
//#line 154 "Parser.y"
{
					genLoadStr(val_peek(1).loc, val_peek(2).sVal, val_peek(0).sVal);
				}
break;
case 37:
//#line 158 "Parser.y"
{
					genLoad(val_peek(6).loc, val_peek(7).sVal, val_peek(3).sVal, val_peek(1).iVal);
				}
break;
case 38:
//#line 162 "Parser.y"
{
					genLoad(val_peek(6).loc, val_peek(7).sVal, val_peek(3).sVal, -val_peek(1).iVal);
				}
break;
case 39:
//#line 166 "Parser.y"
{
					genStore(val_peek(1).loc, val_peek(0).sVal, val_peek(5).sVal, val_peek(3).iVal);
				}
break;
case 40:
//#line 170 "Parser.y"
{
					genStore(val_peek(1).loc, val_peek(0).sVal, val_peek(5).sVal, -val_peek(3).iVal);
				}
break;
case 41:
//#line 174 "Parser.y"
{
					genIndirectCall(val_peek(1).loc, val_peek(3).sVal, val_peek(0).sVal);
				}
break;
case 42:
//#line 178 "Parser.y"
{
					genIndirectCall(val_peek(1).loc, null, val_peek(0).sVal);
				}
break;
case 43:
//#line 182 "Parser.y"
{
					genDirectCall(val_peek(1).loc, val_peek(3).sVal, val_peek(0).sVal);
				}
break;
case 44:
//#line 186 "Parser.y"
{
					genDirectCall(val_peek(1).loc, val_peek(3).sVal, val_peek(0).sVal);
				}
break;
case 45:
//#line 190 "Parser.y"
{
					genDirectCall(val_peek(1).loc, null, val_peek(0).sVal);
				}
break;
case 46:
//#line 194 "Parser.y"
{
					genDirectCall(val_peek(1).loc, null, val_peek(0).sVal);
				}
break;
case 47:
//#line 198 "Parser.y"
{
					genLoadVtbl(val_peek(4).loc, val_peek(5).sVal, val_peek(1).sVal);
				}
break;
case 48:
//#line 202 "Parser.y"
{
					genBranch(val_peek(1).loc, val_peek(0).sVal);
				}
break;
case 49:
//#line 206 "Parser.y"
{
					genBeqz(val_peek(7).loc, val_peek(5).sVal, val_peek(0).sVal);
				}
break;
case 50:
//#line 210 "Parser.y"
{
					genBnez(val_peek(7).loc, val_peek(5).sVal, val_peek(0).sVal);
				}
break;
case 51:
//#line 214 "Parser.y"
{
					genParm(val_peek(1).loc, val_peek(0).sVal);
				}
break;
case 52:
//#line 218 "Parser.y"
{
					genReturn(val_peek(1).loc, val_peek(0).sVal);
				}
break;
case 53:
//#line 222 "Parser.y"
{
					genReturn(val_peek(1).loc, null);
				}
break;
case 54:
//#line 226 "Parser.y"
{
					markLabel(val_peek(1).sVal);
				}
break;
//#line 778 "Parser.java"
//########## END OF USER-SUPPLIED ACTIONS ##########
    }//switch
    //#### Now let's reduce... ####
    //if (yydebug) debug("reduce");
    state_drop(yym);             //we just reduced yylen states
    yystate = state_peek(0);     //get new state
    val_drop(yym);               //corresponding value drop
    yym = yylhs[yyn];            //select next TERMINAL(on lhs)
    if (yystate == 0 && yym == 0)//done? 'rest' state and at first TERMINAL
      {
      //if (yydebug) debug("After reduction, shifting from state 0 to state "+YYFINAL+"");
      yystate = YYFINAL;         //explicitly say we're done
      state_push(YYFINAL);       //and save it
      val_push(yyval);           //also save the semantic value of parsing
      if (yychar < 0)            //we want another character?
        {
        yychar = yylex();        //get next character
        //if (yychar<0) yychar=0;  //clean, if necessary
        //if (yydebug)
          //yylexdebug(yystate,yychar);
        }
      if (yychar == 0)          //Good exit (if lex returns 0 ;-)
         break;                 //quit the loop--all DONE
      }//if yystate
    else                        //else not done yet
      {                         //get next state and push, for next yydefred[]
      yyn = yygindex[yym];      //find out where to go
      if ((yyn != 0) && (yyn += yystate) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yystate)
        yystate = yytable[yyn]; //get new state
      else
        yystate = yydgoto[yym]; //else go to new defred
      //if (yydebug) debug("after reduction, shifting from state "+state_peek(0)+" to state "+yystate+"");
      state_push(yystate);     //going again, so push state & val...
      val_push(yyval);         //for next action
      }
    }//main loop
  return 0;//yyaccept!!
}
//## end of method parse() ######################################



//## run() --- for Thread #######################################
//## The -Jnorun option was used ##
//## end of method run() ########################################



//## Constructors ###############################################
//## The -Jnoconstruct option was used ##
//###############################################################



}
//################### END OF CLASS ##############################
