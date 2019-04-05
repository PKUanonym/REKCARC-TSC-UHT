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






//#line 11 "Parser.y"
package decaf.frontend;

import decaf.tree.Tree;
import decaf.tree.Tree.*;
import decaf.error.*;
import java.util.*;
//#line 25 "Parser.java"
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
public final static short VOID=257;
public final static short BOOL=258;
public final static short INT=259;
public final static short STRING=260;
public final static short CLASS=261;
public final static short NULL=262;
public final static short EXTENDS=263;
public final static short THIS=264;
public final static short WHILE=265;
public final static short FOR=266;
public final static short IF=267;
public final static short ELSE=268;
public final static short RETURN=269;
public final static short BREAK=270;
public final static short NEW=271;
public final static short PRINT=272;
public final static short READ_INTEGER=273;
public final static short READ_LINE=274;
public final static short LITERAL=275;
public final static short IDENTIFIER=276;
public final static short AND=277;
public final static short OR=278;
public final static short STATIC=279;
public final static short INSTANCEOF=280;
public final static short NUMINSTANCES=281;
public final static short LESS_EQUAL=282;
public final static short GREATER_EQUAL=283;
public final static short EQUAL=284;
public final static short NOT_EQUAL=285;
public final static short DOUBLE_PLUS=286;
public final static short DOUBLE_MINUS=287;
public final static short FI=288;
public final static short TRIBLE_OR=289;
public final static short DO=290;
public final static short OD=291;
public final static short UMINUS=292;
public final static short EMPTY=293;
public final static short YYERRCODE=256;
final static short yylhs[] = {                           -1,
    0,    1,    1,    3,    4,    5,    5,    5,    5,    5,
    5,    2,    6,    6,    7,    7,    7,    9,    9,   10,
   10,    8,    8,   11,   12,   12,   13,   13,   13,   13,
   13,   13,   13,   13,   13,   13,   13,   23,   25,   25,
   21,   22,   14,   14,   14,   28,   28,   26,   26,   27,
   24,   24,   24,   24,   24,   24,   24,   24,   24,   24,
   24,   24,   24,   24,   24,   24,   24,   24,   24,   24,
   24,   24,   24,   24,   24,   24,   24,   24,   24,   24,
   24,   24,   30,   30,   29,   29,   31,   31,   16,   17,
   20,   15,   32,   32,   18,   18,   19,
};
final static short yylen[] = {                            2,
    1,    2,    1,    2,    2,    1,    1,    1,    1,    2,
    3,    6,    2,    0,    2,    2,    0,    1,    0,    3,
    1,    7,    6,    3,    2,    0,    1,    2,    1,    1,
    1,    2,    2,    2,    1,    1,    1,    3,    1,    3,
    3,    3,    3,    1,    0,    2,    0,    2,    4,    5,
    1,    1,    1,    3,    3,    3,    3,    3,    3,    3,
    3,    3,    3,    3,    3,    3,    3,    2,    2,    3,
    3,    1,    4,    5,    6,    5,    2,    2,    2,    2,
    5,    4,    1,    1,    1,    0,    3,    1,    5,    9,
    1,    6,    2,    0,    2,    1,    4,
};
final static short yydefred[] = {                         0,
    0,    0,    0,    3,    0,    2,    0,    0,   13,   17,
    0,    7,    8,    6,    9,    0,    0,   12,   15,    0,
    0,   16,   10,    0,    4,    0,    0,    0,    0,   11,
    0,   21,    0,    0,    0,    0,    5,    0,    0,    0,
   26,   23,   20,   22,    0,   84,   72,    0,    0,    0,
    0,   91,    0,    0,    0,    0,   83,    0,    0,    0,
    0,    0,    0,    0,    0,   24,   27,   35,   25,    0,
   29,   30,   31,    0,    0,    0,   36,   37,    0,    0,
    0,    0,   53,    0,    0,    0,   39,    0,    0,   51,
   52,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   28,   32,   33,   34,
    0,    0,    0,    0,    0,    0,   77,   79,    0,    0,
    0,    0,    0,    0,    0,   46,    0,    0,    0,    0,
    0,    0,    0,    0,   41,    0,    0,    0,    0,    0,
   70,   71,    0,    0,   42,    0,   67,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   38,   40,   73,
    0,    0,   97,    0,   82,    0,   49,    0,    0,    0,
   89,    0,    0,   74,    0,    0,   76,    0,   50,    0,
    0,   92,   75,    0,   93,    0,   90,
};
final static short yydgoto[] = {                          2,
    3,    4,   67,   20,   33,    8,   11,   22,   34,   35,
   68,   45,   69,   70,   71,   72,   73,   74,   75,   76,
   77,   78,   87,   79,   89,   90,   91,   82,  179,   83,
  140,  192,
};
final static short yysindex[] = {                      -253,
 -252,    0, -253,    0, -229,    0, -233,  -77,    0,    0,
  -92,    0,    0,    0,    0, -218,  -44,    0,    0,    3,
  -86,    0,    0,  -82,    0,   23,  -16,   40,  -44,    0,
  -44,    0,  -78,   41,   42,   43,    0,  -35,  -44,  -35,
    0,    0,    0,    0,    2,    0,    0,   47,   49,  131,
  151,    0,  189,   51,   53,   54,    0,   58,   64,  151,
  151,  151,  151,  151,   91,    0,    0,    0,    0,   50,
    0,    0,    0,   52,   57,   60,    0,    0,  754,   34,
    0, -170,    0,  151,  151,   91,    0,  466, -270,    0,
    0,  754,   68,   21,  151,   81,   85,  151, -159,  -31,
  -31, -266,  -42,  -42, -148,  490,    0,    0,    0,    0,
  151,  151,  151,  151,  151,  151,    0,    0,  151,  151,
  151,  151,  151,  151,  151,    0,  151,  151,  151,   89,
  502,   71,  526,   36,    0,  151,   92,  111,  754,  -12,
    0,    0,  553,   93,    0,   94,    0,  901,  889,   -6,
   -6,  913,  913,  -36,  -36,  -42,  -42,  -42,   -6,   -6,
  564,  588,  754,  151,   36,  151,   70,    0,    0,    0,
  626,  151,    0, -144,    0,  151,    0,  151,   98,   96,
    0,  839, -127,    0,  754,  102,    0,  754,    0,  151,
   36,    0,    0,  104,    0,   36,    0,
};
final static short yyrindex[] = {                         0,
    0,    0,  147,    0,   26,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,   95,    0,    0,  112,    0,
  112,    0,    0,    0,  114,    0,    0,    0,    0,    0,
    0,    0,    0,    0,  -57,    0,    0,    0,    0, -124,
  -56,    0,    0,    0,    0,    0,    0,    0,    0, -124,
 -124, -124, -124, -124, -124,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,  877,
  455,    0,    0, -124,  -57, -124,    0,    0,    0,    0,
    0,   99,    0,    0, -124,    0,    0, -124,    0,  940,
  964,    0, 1005, 1034,    0,    0,    0,    0,    0,    0,
 -124, -124, -124, -124, -124, -124,    0,    0, -124, -124,
 -124, -124, -124, -124, -124,    0, -124, -124, -124,  398,
    0,    0,    0,  -57,    0, -124,    0, -124,   15,    0,
    0,    0,    0,    0,    0,    0,    0,    7,   55, 1240,
 1251,    9,   79, 1087, 1215, 1043, 1168, 1192, 1288, 1290,
    0,    0,  -21,  -27,  -57, -124,  425,    0,    0,    0,
    0, -124,    0,    0,    0, -124,    0, -124,    0,  116,
    0,    0,  -33,    0,   30,    0,    0,  -14,    0,  -24,
  -57,    0,    0,    0,    0,  -57,    0,
};
final static short yygindex[] = {                         0,
    0,  157,  150,   76,   11,    0,    0,    0,  132,    0,
   35,    0, -113,  -69,    0,    0,    0,    0,    0,    0,
    0,    0,   37, 1492,  100,   12,   16,    0,    0,    0,
    6,    0,
};
final static int YYTABLESIZE=1670;
static short yytable[];
static { yytable();}
static void yytable(){
yytable = new short[]{                         94,
  123,   45,   96,  126,   27,  121,   94,    1,   27,  126,
  122,   94,   27,   86,  126,  132,   45,  135,  136,   43,
  168,   21,  136,    5,  145,   94,   81,   24,  173,   81,
  123,  172,   18,    7,   64,  121,  119,   43,  120,  126,
  122,   65,    9,   81,   81,   10,   63,   65,  127,   59,
   65,  181,   59,  183,  127,   88,   80,   23,   88,  127,
   81,   25,   29,   94,   65,   65,   59,   59,   64,   65,
   87,   59,   42,   87,   44,   65,   30,  195,   81,   31,
   63,   38,  197,   40,  127,   39,   84,   41,   85,   94,
   95,   94,   96,   97,  129,   66,   80,   98,   66,   65,
   81,   59,   64,   99,   32,  130,   32,  137,  107,   65,
  108,  138,   66,   66,   43,  109,  144,   66,  110,   60,
  194,  141,   60,   64,   41,  142,   66,  146,  164,  166,
   65,  186,  170,  175,  176,   63,   60,   60,  189,  172,
  191,   60,  193,   64,  196,   80,    1,   66,   14,   81,
   65,   47,   19,    5,   18,   63,   85,   95,   41,    6,
   19,  102,   36,   64,   12,   13,   14,   15,   16,  180,
   86,   60,  169,    0,    0,   63,   80,    0,   80,    0,
   81,    0,   81,   64,    0,    0,   17,    0,    0,   26,
   65,    0,   41,   28,    0,   63,    0,   37,    0,    0,
    0,   80,   80,   30,    0,   81,   81,   80,    0,    0,
    0,   81,   12,   13,   14,   15,   16,    0,   47,   47,
    0,    0,    0,   94,   94,   94,   94,   94,   94,    0,
   94,   94,   94,   94,    0,   94,   94,   94,   94,   94,
   94,   94,   94,  117,  118,    0,   94,   94,   47,  117,
  118,   47,   94,   94,   94,   94,   94,   94,   12,   13,
   14,   15,   16,   46,    0,   47,   48,   49,   50,    0,
   51,   52,   53,   54,   55,   56,   57,    0,    0,  117,
  118,   58,   59,   65,   65,   59,   59,   60,   61,    0,
    0,   62,   12,   13,   14,   15,   16,   46,    0,   47,
   48,   49,   50,    0,   51,   52,   53,   54,   55,   56,
   57,    0,    0,    0,    0,   58,   59,    0,    0,    0,
    0,   60,   61,    0,    0,   62,   12,   13,   14,   15,
   16,   46,   66,   47,   48,   49,   50,    0,   51,   52,
   53,   54,   55,   56,   57,    0,    0,    0,    0,   58,
   59,  105,   46,    0,   47,   60,   60,    0,    0,   62,
    0,   53,    0,   55,   56,   57,    0,    0,    0,    0,
   58,   59,   46,    0,   47,    0,   60,   61,    0,    0,
    0,   53,    0,   55,   56,   57,    0,    0,    0,    0,
   58,   59,   46,    0,   47,    0,   60,   61,    0,    0,
    0,   53,    0,   55,   56,   57,    0,    0,    0,    0,
   58,   59,   46,    0,   47,    0,   60,   61,    0,    0,
    0,   53,    0,   55,   56,   57,    0,    0,    0,    0,
   58,   59,    0,    0,   48,    0,   60,   61,   48,   48,
   48,   48,   48,   48,   48,   12,   13,   14,   15,   16,
    0,    0,    0,    0,    0,   48,   48,   48,   48,   48,
   48,   67,    0,    0,   93,    0,   67,   67,    0,   67,
   67,   67,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   67,   45,   67,    0,   67,   67,   48,    0,
   48,   52,    0,    0,    0,   44,   52,   52,    0,   52,
   52,   52,  123,    0,    0,    0,    0,  121,  119,    0,
  120,  126,  122,   44,   52,   67,   52,   52,    0,    0,
    0,    0,    0,  134,    0,  125,  123,  124,  128,    0,
  147,  121,  119,    0,  120,  126,  122,    0,  123,    0,
    0,    0,  165,  121,  119,   52,  120,  126,  122,  125,
    0,  124,  128,    0,    0,    0,  127,    0,    0,    0,
    0,  125,  123,  124,  128,    0,  167,  121,  119,    0,
  120,  126,  122,    0,    0,    0,    0,    0,    0,    0,
  127,    0,    0,    0,    0,  125,    0,  124,  128,  123,
    0,    0,  127,    0,  121,  119,  174,  120,  126,  122,
  123,    0,    0,    0,    0,  121,  119,    0,  120,  126,
  122,    0,  125,    0,  124,  128,  127,    0,    0,    0,
    0,    0,    0,  125,  123,  124,  128,    0,    0,  121,
  119,    0,  120,  126,  122,    0,    0,    0,    0,    0,
    0,    0,    0,  127,    0,  178,    0,  125,    0,  124,
  128,    0,    0,    0,  127,    0,  177,    0,    0,    0,
    0,    0,  123,    0,    0,    0,    0,  121,  119,    0,
  120,  126,  122,    0,   48,   48,    0,    0,  127,   48,
   48,   48,   48,   48,   48,  125,    0,  124,  128,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   47,   67,   67,    0,    0,    0,   67,   67,   67,   67,
   67,   67,    0,    0,    0,    0,  127,    0,  184,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   52,   52,    0,    0,    0,   52,   52,   52,   52,
   52,   52,  111,  112,    0,    0,    0,  113,  114,  115,
  116,  117,  118,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,  111,  112,    0,    0,
    0,  113,  114,  115,  116,  117,  118,    0,  111,  112,
    0,    0,    0,  113,  114,  115,  116,  117,  118,    0,
  123,    0,    0,    0,    0,  121,  119,    0,  120,  126,
  122,    0,  111,  112,    0,    0,    0,  113,  114,  115,
  116,  117,  118,  125,    0,  124,  128,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,  111,
  112,    0,    0,    0,  113,  114,  115,  116,  117,  118,
  111,  112,    0,    0,  127,  113,  114,  115,  116,  117,
  118,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,  111,  112,    0,    0,    0,  113,
  114,  115,  116,  117,  118,  123,    0,    0,    0,    0,
  121,  119,    0,  120,  126,  122,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,  190,  125,    0,
  124,  128,  111,  112,    0,    0,    0,  113,  114,  115,
  116,  117,  118,   51,    0,    0,    0,    0,   51,   51,
    0,   51,   51,   51,    0,  123,    0,    0,    0,  127,
  121,  119,    0,  120,  126,  122,   51,  123,   51,   51,
    0,    0,  121,  119,    0,  120,  126,  122,  125,  123,
  124,    0,    0,    0,  121,  119,    0,  120,  126,  122,
  125,    0,  124,    0,    0,    0,    0,   51,    0,    0,
    0,    0,  125,    0,  124,    0,   78,    0,    0,  127,
   78,   78,   78,   78,   78,    0,   78,    0,    0,    0,
    0,  127,    0,    0,    0,    0,    0,   78,   78,   78,
   80,   78,   78,  127,   80,   80,   80,   80,   80,    0,
   80,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   80,   80,   80,    0,   80,   80,    0,    0,    0,
  111,  112,   78,    0,    0,  113,  114,  115,  116,  117,
  118,   68,    0,    0,    0,   68,   68,   68,   68,   68,
    0,   68,    0,    0,    0,    0,   80,    0,    0,    0,
    0,    0,   68,   68,   68,    0,   68,   68,    0,    0,
   69,    0,    0,    0,   69,   69,   69,   69,   69,   56,
   69,    0,    0,   56,   56,   56,   56,   56,    0,   56,
    0,   69,   69,   69,    0,   69,   69,   68,    0,    0,
   56,   56,   56,    0,   56,   56,    0,    0,    0,    0,
    0,    0,    0,    0,    0,  111,  112,    0,    0,    0,
  113,  114,  115,  116,  117,  118,   69,   54,    0,   54,
   54,   54,    0,    0,    0,   56,    0,    0,    0,    0,
    0,    0,    0,    0,   54,   54,   54,    0,   54,   54,
    0,    0,    0,   51,   51,    0,    0,    0,   51,   51,
   51,   51,   51,   51,    0,  111,    0,    0,    0,    0,
  113,  114,  115,  116,  117,  118,    0,    0,    0,   54,
    0,    0,  113,  114,  115,  116,  117,  118,    0,    0,
    0,    0,    0,    0,  113,  114,    0,    0,  117,  118,
    0,    0,    0,    0,   57,    0,    0,    0,   57,   57,
   57,   57,   57,    0,   57,    0,   78,   78,    0,    0,
    0,   78,   78,   78,   78,   57,   57,   57,   58,   57,
   57,    0,   58,   58,   58,   58,   58,    0,   58,    0,
   80,   80,    0,    0,    0,   80,   80,   80,   80,   58,
   58,   58,    0,   58,   58,   55,    0,   55,   55,   55,
   57,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   55,   55,   55,    0,   55,   55,    0,    0,
   63,   68,   68,   63,   58,    0,   68,   68,   68,   68,
    0,   64,    0,    0,   64,    0,    0,   63,   63,    0,
    0,    0,   63,    0,    0,    0,    0,   55,   64,   64,
   69,   69,    0,   64,    0,   69,   69,   69,   69,   56,
   56,    0,    0,    0,   56,   56,   56,   56,   62,    0,
   61,   62,   63,   61,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   64,    0,   62,   62,   61,   61,    0,
   62,    0,   61,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   54,   54,    0,    0,    0,   54,   54,
   54,   54,    0,    0,    0,    0,    0,    0,    0,    0,
   62,    0,   61,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   57,   57,    0,    0,    0,   57,
   57,   57,   57,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   58,   58,
    0,    0,    0,   58,   58,   58,   58,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   55,   55,    0,    0,    0,   55,   55,   55,   55,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   63,   63,    0,    0,
    0,    0,    0,   63,   63,    0,    0,   64,   64,    0,
    0,    0,    0,    0,   64,   64,    0,    0,    0,    0,
    0,   88,   92,    0,    0,    0,    0,    0,    0,    0,
    0,  100,  101,   88,  103,  104,  106,    0,    0,    0,
    0,    0,    0,    0,   62,   62,   61,   61,    0,    0,
    0,   62,   62,   61,   61,  131,    0,  133,    0,    0,
    0,    0,    0,    0,    0,    0,  139,    0,    0,  143,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,  148,  149,  150,  151,  152,  153,    0,    0,
  154,  155,  156,  157,  158,  159,  160,    0,  161,  162,
  163,    0,    0,    0,    0,    0,    0,   88,    0,  171,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,  139,    0,  182,    0,    0,
    0,    0,    0,  185,    0,    0,    0,  187,    0,  188,
};
}
static short yycheck[];
static { yycheck(); }
static void yycheck() {
yycheck = new short[] {                         33,
   37,   59,   59,   46,   91,   42,   40,  261,   91,   46,
   47,   45,   91,   41,   46,   85,   41,  288,  289,   41,
  134,   11,  289,  276,  291,   59,   41,   17,   41,   44,
   37,   44,  125,  263,   33,   42,   43,   59,   45,   46,
   47,   40,  276,   58,   59,  123,   45,   41,   91,   41,
   44,  165,   44,  167,   91,   41,   45,  276,   44,   91,
   45,   59,   40,   53,   58,   59,   58,   59,   33,   63,
   41,   63,   38,   44,   40,   40,   93,  191,   93,   40,
   45,   41,  196,   41,   91,   44,   40,  123,   40,  123,
   40,  125,   40,   40,   61,   41,   85,   40,   44,   93,
   85,   93,   33,   40,   29,  276,   31,   40,   59,   40,
   59,   91,   58,   59,   39,   59,  276,   63,   59,   41,
  190,   41,   44,   33,  123,   41,  125,  276,   40,   59,
   40,  276,   41,   41,   41,   45,   58,   59,   41,   44,
  268,   63,   41,   33,   41,  134,    0,   93,  123,  134,
   40,  276,   41,   59,   41,   45,   41,   59,  123,    3,
   11,   62,   31,   33,  257,  258,  259,  260,  261,  164,
   40,   93,  136,   -1,   -1,   45,  165,   -1,  167,   -1,
  165,   -1,  167,   33,   -1,   -1,  279,   -1,   -1,  276,
   40,   -1,  123,  276,   -1,   45,   -1,  276,   -1,   -1,
   -1,  190,  191,   93,   -1,  190,  191,  196,   -1,   -1,
   -1,  196,  257,  258,  259,  260,  261,   -1,  276,  276,
   -1,   -1,   -1,  257,  258,  259,  260,  261,  262,   -1,
  264,  265,  266,  267,   -1,  269,  270,  271,  272,  273,
  274,  275,  276,  286,  287,   -1,  280,  281,  276,  286,
  287,  276,  286,  287,  288,  289,  290,  291,  257,  258,
  259,  260,  261,  262,   -1,  264,  265,  266,  267,   -1,
  269,  270,  271,  272,  273,  274,  275,   -1,   -1,  286,
  287,  280,  281,  277,  278,  277,  278,  286,  287,   -1,
   -1,  290,  257,  258,  259,  260,  261,  262,   -1,  264,
  265,  266,  267,   -1,  269,  270,  271,  272,  273,  274,
  275,   -1,   -1,   -1,   -1,  280,  281,   -1,   -1,   -1,
   -1,  286,  287,   -1,   -1,  290,  257,  258,  259,  260,
  261,  262,  278,  264,  265,  266,  267,   -1,  269,  270,
  271,  272,  273,  274,  275,   -1,   -1,   -1,   -1,  280,
  281,  261,  262,   -1,  264,  277,  278,   -1,   -1,  290,
   -1,  271,   -1,  273,  274,  275,   -1,   -1,   -1,   -1,
  280,  281,  262,   -1,  264,   -1,  286,  287,   -1,   -1,
   -1,  271,   -1,  273,  274,  275,   -1,   -1,   -1,   -1,
  280,  281,  262,   -1,  264,   -1,  286,  287,   -1,   -1,
   -1,  271,   -1,  273,  274,  275,   -1,   -1,   -1,   -1,
  280,  281,  262,   -1,  264,   -1,  286,  287,   -1,   -1,
   -1,  271,   -1,  273,  274,  275,   -1,   -1,   -1,   -1,
  280,  281,   -1,   -1,   37,   -1,  286,  287,   41,   42,
   43,   44,   45,   46,   47,  257,  258,  259,  260,  261,
   -1,   -1,   -1,   -1,   -1,   58,   59,   60,   61,   62,
   63,   37,   -1,   -1,  276,   -1,   42,   43,   -1,   45,
   46,   47,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   58,   59,   60,   -1,   62,   63,   91,   -1,
   93,   37,   -1,   -1,   -1,   41,   42,   43,   -1,   45,
   46,   47,   37,   -1,   -1,   -1,   -1,   42,   43,   -1,
   45,   46,   47,   59,   60,   91,   62,   63,   -1,   -1,
   -1,   -1,   -1,   58,   -1,   60,   37,   62,   63,   -1,
   41,   42,   43,   -1,   45,   46,   47,   -1,   37,   -1,
   -1,   -1,   41,   42,   43,   91,   45,   46,   47,   60,
   -1,   62,   63,   -1,   -1,   -1,   91,   -1,   -1,   -1,
   -1,   60,   37,   62,   63,   -1,   41,   42,   43,   -1,
   45,   46,   47,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   91,   -1,   -1,   -1,   -1,   60,   -1,   62,   63,   37,
   -1,   -1,   91,   -1,   42,   43,   44,   45,   46,   47,
   37,   -1,   -1,   -1,   -1,   42,   43,   -1,   45,   46,
   47,   -1,   60,   -1,   62,   63,   91,   -1,   -1,   -1,
   -1,   -1,   -1,   60,   37,   62,   63,   -1,   -1,   42,
   43,   -1,   45,   46,   47,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   91,   -1,   58,   -1,   60,   -1,   62,
   63,   -1,   -1,   -1,   91,   -1,   93,   -1,   -1,   -1,
   -1,   -1,   37,   -1,   -1,   -1,   -1,   42,   43,   -1,
   45,   46,   47,   -1,  277,  278,   -1,   -1,   91,  282,
  283,  284,  285,  286,  287,   60,   -1,   62,   63,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  276,  277,  278,   -1,   -1,   -1,  282,  283,  284,  285,
  286,  287,   -1,   -1,   -1,   -1,   91,   -1,   93,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  277,  278,   -1,   -1,   -1,  282,  283,  284,  285,
  286,  287,  277,  278,   -1,   -1,   -1,  282,  283,  284,
  285,  286,  287,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  277,  278,   -1,   -1,
   -1,  282,  283,  284,  285,  286,  287,   -1,  277,  278,
   -1,   -1,   -1,  282,  283,  284,  285,  286,  287,   -1,
   37,   -1,   -1,   -1,   -1,   42,   43,   -1,   45,   46,
   47,   -1,  277,  278,   -1,   -1,   -1,  282,  283,  284,
  285,  286,  287,   60,   -1,   62,   63,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  277,
  278,   -1,   -1,   -1,  282,  283,  284,  285,  286,  287,
  277,  278,   -1,   -1,   91,  282,  283,  284,  285,  286,
  287,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  277,  278,   -1,   -1,   -1,  282,
  283,  284,  285,  286,  287,   37,   -1,   -1,   -1,   -1,
   42,   43,   -1,   45,   46,   47,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   59,   60,   -1,
   62,   63,  277,  278,   -1,   -1,   -1,  282,  283,  284,
  285,  286,  287,   37,   -1,   -1,   -1,   -1,   42,   43,
   -1,   45,   46,   47,   -1,   37,   -1,   -1,   -1,   91,
   42,   43,   -1,   45,   46,   47,   60,   37,   62,   63,
   -1,   -1,   42,   43,   -1,   45,   46,   47,   60,   37,
   62,   -1,   -1,   -1,   42,   43,   -1,   45,   46,   47,
   60,   -1,   62,   -1,   -1,   -1,   -1,   91,   -1,   -1,
   -1,   -1,   60,   -1,   62,   -1,   37,   -1,   -1,   91,
   41,   42,   43,   44,   45,   -1,   47,   -1,   -1,   -1,
   -1,   91,   -1,   -1,   -1,   -1,   -1,   58,   59,   60,
   37,   62,   63,   91,   41,   42,   43,   44,   45,   -1,
   47,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   58,   59,   60,   -1,   62,   63,   -1,   -1,   -1,
  277,  278,   93,   -1,   -1,  282,  283,  284,  285,  286,
  287,   37,   -1,   -1,   -1,   41,   42,   43,   44,   45,
   -1,   47,   -1,   -1,   -1,   -1,   93,   -1,   -1,   -1,
   -1,   -1,   58,   59,   60,   -1,   62,   63,   -1,   -1,
   37,   -1,   -1,   -1,   41,   42,   43,   44,   45,   37,
   47,   -1,   -1,   41,   42,   43,   44,   45,   -1,   47,
   -1,   58,   59,   60,   -1,   62,   63,   93,   -1,   -1,
   58,   59,   60,   -1,   62,   63,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  277,  278,   -1,   -1,   -1,
  282,  283,  284,  285,  286,  287,   93,   41,   -1,   43,
   44,   45,   -1,   -1,   -1,   93,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   58,   59,   60,   -1,   62,   63,
   -1,   -1,   -1,  277,  278,   -1,   -1,   -1,  282,  283,
  284,  285,  286,  287,   -1,  277,   -1,   -1,   -1,   -1,
  282,  283,  284,  285,  286,  287,   -1,   -1,   -1,   93,
   -1,   -1,  282,  283,  284,  285,  286,  287,   -1,   -1,
   -1,   -1,   -1,   -1,  282,  283,   -1,   -1,  286,  287,
   -1,   -1,   -1,   -1,   37,   -1,   -1,   -1,   41,   42,
   43,   44,   45,   -1,   47,   -1,  277,  278,   -1,   -1,
   -1,  282,  283,  284,  285,   58,   59,   60,   37,   62,
   63,   -1,   41,   42,   43,   44,   45,   -1,   47,   -1,
  277,  278,   -1,   -1,   -1,  282,  283,  284,  285,   58,
   59,   60,   -1,   62,   63,   41,   -1,   43,   44,   45,
   93,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   58,   59,   60,   -1,   62,   63,   -1,   -1,
   41,  277,  278,   44,   93,   -1,  282,  283,  284,  285,
   -1,   41,   -1,   -1,   44,   -1,   -1,   58,   59,   -1,
   -1,   -1,   63,   -1,   -1,   -1,   -1,   93,   58,   59,
  277,  278,   -1,   63,   -1,  282,  283,  284,  285,  277,
  278,   -1,   -1,   -1,  282,  283,  284,  285,   41,   -1,
   41,   44,   93,   44,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   93,   -1,   58,   59,   58,   59,   -1,
   63,   -1,   63,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  277,  278,   -1,   -1,   -1,  282,  283,
  284,  285,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   93,   -1,   93,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  277,  278,   -1,   -1,   -1,  282,
  283,  284,  285,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  277,  278,
   -1,   -1,   -1,  282,  283,  284,  285,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  277,  278,   -1,   -1,   -1,  282,  283,  284,  285,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  277,  278,   -1,   -1,
   -1,   -1,   -1,  284,  285,   -1,   -1,  277,  278,   -1,
   -1,   -1,   -1,   -1,  284,  285,   -1,   -1,   -1,   -1,
   -1,   50,   51,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   60,   61,   62,   63,   64,   65,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  277,  278,  277,  278,   -1,   -1,
   -1,  284,  285,  284,  285,   84,   -1,   86,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   95,   -1,   -1,   98,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  111,  112,  113,  114,  115,  116,   -1,   -1,
  119,  120,  121,  122,  123,  124,  125,   -1,  127,  128,
  129,   -1,   -1,   -1,   -1,   -1,   -1,  136,   -1,  138,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  164,   -1,  166,   -1,   -1,
   -1,   -1,   -1,  172,   -1,   -1,   -1,  176,   -1,  178,
};
}
final static short YYFINAL=2;
final static short YYMAXTOKEN=293;
final static String yyname[] = {
"end-of-file",null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,"'!'",null,null,null,"'%'",null,null,"'('","')'","'*'","'+'",
"','","'-'","'.'","'/'",null,null,null,null,null,null,null,null,null,null,"':'",
"';'","'<'","'='","'>'","'?'",null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,"'['",null,"']'",null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,"'{'",null,"'}'",null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,"VOID","BOOL","INT","STRING",
"CLASS","NULL","EXTENDS","THIS","WHILE","FOR","IF","ELSE","RETURN","BREAK",
"NEW","PRINT","READ_INTEGER","READ_LINE","LITERAL","IDENTIFIER","AND","OR",
"STATIC","INSTANCEOF","NUMINSTANCES","LESS_EQUAL","GREATER_EQUAL","EQUAL",
"NOT_EQUAL","DOUBLE_PLUS","DOUBLE_MINUS","FI","TRIBLE_OR","DO","OD","UMINUS",
"EMPTY",
};
final static String yyrule[] = {
"$accept : Program",
"Program : ClassList",
"ClassList : ClassList ClassDef",
"ClassList : ClassDef",
"VariableDef : Variable ';'",
"Variable : Type IDENTIFIER",
"Type : INT",
"Type : VOID",
"Type : BOOL",
"Type : STRING",
"Type : CLASS IDENTIFIER",
"Type : Type '[' ']'",
"ClassDef : CLASS IDENTIFIER ExtendsClause '{' FieldList '}'",
"ExtendsClause : EXTENDS IDENTIFIER",
"ExtendsClause :",
"FieldList : FieldList VariableDef",
"FieldList : FieldList FunctionDef",
"FieldList :",
"Formals : VariableList",
"Formals :",
"VariableList : VariableList ',' Variable",
"VariableList : Variable",
"FunctionDef : STATIC Type IDENTIFIER '(' Formals ')' StmtBlock",
"FunctionDef : Type IDENTIFIER '(' Formals ')' StmtBlock",
"StmtBlock : '{' StmtList '}'",
"StmtList : StmtList Stmt",
"StmtList :",
"Stmt : VariableDef",
"Stmt : SimpleStmt ';'",
"Stmt : IfStmt",
"Stmt : WhileStmt",
"Stmt : ForStmt",
"Stmt : ReturnStmt ';'",
"Stmt : PrintStmt ';'",
"Stmt : BreakStmt ';'",
"Stmt : StmtBlock",
"Stmt : GuardedIFStmt",
"Stmt : GuaededDOStmt",
"GuardedES : Expr ':' Stmt",
"GuardedStmts : GuardedES",
"GuardedStmts : GuardedStmts TRIBLE_OR GuardedES",
"GuardedIFStmt : IF GuardedStmts FI",
"GuaededDOStmt : DO GuardedStmts OD",
"SimpleStmt : LValue '=' Expr",
"SimpleStmt : Call",
"SimpleStmt :",
"Receiver : Expr '.'",
"Receiver :",
"LValue : Receiver IDENTIFIER",
"LValue : Expr '[' Expr ']'",
"Call : Receiver IDENTIFIER '(' Actuals ')'",
"Expr : LValue",
"Expr : Call",
"Expr : Constant",
"Expr : Expr '+' Expr",
"Expr : Expr '-' Expr",
"Expr : Expr '*' Expr",
"Expr : Expr '/' Expr",
"Expr : Expr '%' Expr",
"Expr : Expr EQUAL Expr",
"Expr : Expr NOT_EQUAL Expr",
"Expr : Expr '<' Expr",
"Expr : Expr '>' Expr",
"Expr : Expr LESS_EQUAL Expr",
"Expr : Expr GREATER_EQUAL Expr",
"Expr : Expr AND Expr",
"Expr : Expr OR Expr",
"Expr : '(' Expr ')'",
"Expr : '-' Expr",
"Expr : '!' Expr",
"Expr : READ_INTEGER '(' ')'",
"Expr : READ_LINE '(' ')'",
"Expr : THIS",
"Expr : NEW IDENTIFIER '(' ')'",
"Expr : NEW Type '[' Expr ']'",
"Expr : INSTANCEOF '(' Expr ',' IDENTIFIER ')'",
"Expr : '(' CLASS IDENTIFIER ')' Expr",
"Expr : Expr DOUBLE_PLUS",
"Expr : DOUBLE_PLUS Expr",
"Expr : Expr DOUBLE_MINUS",
"Expr : DOUBLE_MINUS Expr",
"Expr : Expr '?' Expr ':' Expr",
"Expr : NUMINSTANCES '(' IDENTIFIER ')'",
"Constant : LITERAL",
"Constant : NULL",
"Actuals : ExprList",
"Actuals :",
"ExprList : ExprList ',' Expr",
"ExprList : Expr",
"WhileStmt : WHILE '(' Expr ')' Stmt",
"ForStmt : FOR '(' SimpleStmt ';' Expr ';' SimpleStmt ')' Stmt",
"BreakStmt : BREAK",
"IfStmt : IF '(' Expr ')' Stmt ElseClause",
"ElseClause : ELSE Stmt",
"ElseClause :",
"ReturnStmt : RETURN Expr",
"ReturnStmt : RETURN",
"PrintStmt : PRINT '(' ExprList ')'",
};

//#line 487 "Parser.y"
    
	/**
	 * 打印当前归约所用的语法规则<br>
	 * 请勿修改。
	 */
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
//#line 741 "Parser.java"
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
case 1:
//#line 58 "Parser.y"
{
						tree = new Tree.TopLevel(val_peek(0).clist, val_peek(0).loc);
					}
break;
case 2:
//#line 64 "Parser.y"
{
						yyval.clist.add(val_peek(0).cdef);
					}
break;
case 3:
//#line 68 "Parser.y"
{
                		yyval.clist = new ArrayList<Tree.ClassDef>();
                		yyval.clist.add(val_peek(0).cdef);
                	}
break;
case 5:
//#line 78 "Parser.y"
{
						yyval.vdef = new Tree.VarDef(val_peek(0).ident, val_peek(1).type, val_peek(0).loc);
					}
break;
case 6:
//#line 84 "Parser.y"
{
						yyval.type = new Tree.TypeIdent(Tree.INT, val_peek(0).loc);
					}
break;
case 7:
//#line 88 "Parser.y"
{
                		yyval.type = new Tree.TypeIdent(Tree.VOID, val_peek(0).loc);
                	}
break;
case 8:
//#line 92 "Parser.y"
{
                		yyval.type = new Tree.TypeIdent(Tree.BOOL, val_peek(0).loc);
                	}
break;
case 9:
//#line 96 "Parser.y"
{
                		yyval.type = new Tree.TypeIdent(Tree.STRING, val_peek(0).loc);
                	}
break;
case 10:
//#line 100 "Parser.y"
{
                		yyval.type = new Tree.TypeClass(val_peek(0).ident, val_peek(1).loc);
                	}
break;
case 11:
//#line 104 "Parser.y"
{
                		yyval.type = new Tree.TypeArray(val_peek(2).type, val_peek(2).loc);
                	}
break;
case 12:
//#line 110 "Parser.y"
{
						yyval.cdef = new Tree.ClassDef(val_peek(4).ident, val_peek(3).ident, val_peek(1).flist, val_peek(5).loc);
					}
break;
case 13:
//#line 116 "Parser.y"
{
						yyval.ident = val_peek(0).ident;
					}
break;
case 14:
//#line 120 "Parser.y"
{
                		yyval = new SemValue();
                	}
break;
case 15:
//#line 126 "Parser.y"
{
						yyval.flist.add(val_peek(0).vdef);
					}
break;
case 16:
//#line 130 "Parser.y"
{
						yyval.flist.add(val_peek(0).fdef);
					}
break;
case 17:
//#line 134 "Parser.y"
{
                		yyval = new SemValue();
                		yyval.flist = new ArrayList<Tree>();
                	}
break;
case 19:
//#line 142 "Parser.y"
{
                		yyval = new SemValue();
                		yyval.vlist = new ArrayList<Tree.VarDef>(); 
                	}
break;
case 20:
//#line 149 "Parser.y"
{
						yyval.vlist.add(val_peek(0).vdef);
					}
break;
case 21:
//#line 153 "Parser.y"
{
                		yyval.vlist = new ArrayList<Tree.VarDef>();
						yyval.vlist.add(val_peek(0).vdef);
                	}
break;
case 22:
//#line 160 "Parser.y"
{
						yyval.fdef = new MethodDef(true, val_peek(4).ident, val_peek(5).type, val_peek(2).vlist, (Block) val_peek(0).stmt, val_peek(4).loc);
					}
break;
case 23:
//#line 164 "Parser.y"
{
						yyval.fdef = new MethodDef(false, val_peek(4).ident, val_peek(5).type, val_peek(2).vlist, (Block) val_peek(0).stmt, val_peek(4).loc);
					}
break;
case 24:
//#line 170 "Parser.y"
{
						yyval.stmt = new Block(val_peek(1).slist, val_peek(2).loc);
					}
break;
case 25:
//#line 176 "Parser.y"
{
						yyval.slist.add(val_peek(0).stmt);
					}
break;
case 26:
//#line 180 "Parser.y"
{
                		yyval = new SemValue();
                		yyval.slist = new ArrayList<Tree>();
                	}
break;
case 27:
//#line 187 "Parser.y"
{
						yyval.stmt = val_peek(0).vdef;
					}
break;
case 28:
//#line 192 "Parser.y"
{
                		if (yyval.stmt == null) {
                			yyval.stmt = new Tree.Skip(val_peek(0).loc);
                		}
                	}
break;
case 38:
//#line 209 "Parser.y"
{
						yyval.guardedES = new Tree.GuardedES(val_peek(2).expr , val_peek(0).stmt , val_peek(1).loc);
					}
break;
case 39:
//#line 215 "Parser.y"
{
						
						yyval.myList = new ArrayList<Tree.GuardedES>();
						yyval.myList.add(val_peek(0).guardedES);
					}
break;
case 40:
//#line 222 "Parser.y"
{
						
                		yyval.myList.add(val_peek(0).guardedES);
					}
break;
case 41:
//#line 229 "Parser.y"
{
						yyval.stmt = new Tree.GuardedIFStmt(val_peek(1).myList , val_peek(2).loc);
					}
break;
case 42:
//#line 235 "Parser.y"
{
						yyval.stmt = new Tree.GuardedDOStmt(val_peek(1).myList , val_peek(2).loc);
					}
break;
case 43:
//#line 241 "Parser.y"
{
						yyval.stmt = new Tree.Assign(val_peek(2).lvalue, val_peek(0).expr, val_peek(1).loc);
					}
break;
case 44:
//#line 245 "Parser.y"
{
                		yyval.stmt = new Tree.Exec(val_peek(0).expr, val_peek(0).loc);
                	}
break;
case 45:
//#line 249 "Parser.y"
{
                		yyval = new SemValue();
                	}
break;
case 47:
//#line 256 "Parser.y"
{
                		yyval = new SemValue();
                	}
break;
case 48:
//#line 262 "Parser.y"
{
						yyval.lvalue = new Tree.Ident(val_peek(1).expr, val_peek(0).ident, val_peek(0).loc);
						if (val_peek(1).loc == null) {
							yyval.loc = val_peek(0).loc;
						}
					}
break;
case 49:
//#line 269 "Parser.y"
{
                		yyval.lvalue = new Tree.Indexed(val_peek(3).expr, val_peek(1).expr, val_peek(3).loc);
                	}
break;
case 50:
//#line 275 "Parser.y"
{
						yyval.expr = new Tree.CallExpr(val_peek(4).expr, val_peek(3).ident, val_peek(1).elist, val_peek(3).loc);
						if (val_peek(4).loc == null) {
							yyval.loc = val_peek(3).loc;
						}
					}
break;
case 51:
//#line 284 "Parser.y"
{
						yyval.expr = val_peek(0).lvalue;
					}
break;
case 54:
//#line 290 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.PLUS, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 55:
//#line 294 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.MINUS, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 56:
//#line 298 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.MUL, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 57:
//#line 302 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.DIV, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 58:
//#line 306 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.MOD, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 59:
//#line 310 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.EQ, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 60:
//#line 314 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.NE, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 61:
//#line 318 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.LT, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 62:
//#line 322 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.GT, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 63:
//#line 326 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.LE, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 64:
//#line 330 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.GE, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 65:
//#line 334 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.AND, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 66:
//#line 338 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.OR, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 67:
//#line 342 "Parser.y"
{
                		yyval = val_peek(1);
                	}
break;
case 68:
//#line 346 "Parser.y"
{
                		yyval.expr = new Tree.Unary(Tree.NEG, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 69:
//#line 350 "Parser.y"
{
                		yyval.expr = new Tree.Unary(Tree.NOT, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 70:
//#line 354 "Parser.y"
{
                		yyval.expr = new Tree.ReadIntExpr(val_peek(2).loc);
                	}
break;
case 71:
//#line 358 "Parser.y"
{
                		yyval.expr = new Tree.ReadLineExpr(val_peek(2).loc);
                	}
break;
case 72:
//#line 362 "Parser.y"
{
                		yyval.expr = new Tree.ThisExpr(val_peek(0).loc);
                	}
break;
case 73:
//#line 366 "Parser.y"
{
                		yyval.expr = new Tree.NewClass(val_peek(2).ident, val_peek(3).loc);
                	}
break;
case 74:
//#line 370 "Parser.y"
{
                		yyval.expr = new Tree.NewArray(val_peek(3).type, val_peek(1).expr, val_peek(4).loc);
                	}
break;
case 75:
//#line 374 "Parser.y"
{
                		yyval.expr = new Tree.TypeTest(val_peek(3).expr, val_peek(1).ident, val_peek(5).loc);
                	}
break;
case 76:
//#line 378 "Parser.y"
{
                		yyval.expr = new Tree.TypeCast(val_peek(2).ident, val_peek(0).expr, val_peek(0).loc);
                	}
break;
case 77:
//#line 382 "Parser.y"
{
                		yyval.expr = new Tree.Unary(Tree.POSTINC, val_peek(1).expr, val_peek(1).loc);
                	}
break;
case 78:
//#line 386 "Parser.y"
{
                		yyval.expr = new Tree.Unary(Tree.PREINC, val_peek(0).expr, val_peek(0).loc);
                	}
break;
case 79:
//#line 390 "Parser.y"
{
                		yyval.expr = new Tree.Unary(Tree.POSTDEC, val_peek(1).expr, val_peek(1).loc);
                	}
break;
case 80:
//#line 394 "Parser.y"
{
                		yyval.expr = new Tree.Unary(Tree.PREDEC, val_peek(0).expr, val_peek(0).loc);
                	}
break;
case 81:
//#line 398 "Parser.y"
{
                		yyval.expr = new Tree.QuestionAndColon(Tree.QUESTION_COLON, val_peek(4).expr, val_peek(2).expr, val_peek(0).expr, val_peek(4).loc);
                	}
break;
case 82:
//#line 402 "Parser.y"
{
                		yyval.expr = new Tree.NumTest(val_peek(1).ident, val_peek(3).loc);
                	}
break;
case 83:
//#line 408 "Parser.y"
{
						yyval.expr = new Tree.Literal(val_peek(0).typeTag, val_peek(0).literal, val_peek(0).loc);
					}
break;
case 84:
//#line 412 "Parser.y"
{
						yyval.expr = new Null(val_peek(0).loc);
					}
break;
case 86:
//#line 419 "Parser.y"
{
                		yyval = new SemValue();
                		yyval.elist = new ArrayList<Tree.Expr>();
                	}
break;
case 87:
//#line 426 "Parser.y"
{
						yyval.elist.add(val_peek(0).expr);
					}
break;
case 88:
//#line 430 "Parser.y"
{
                		yyval.elist = new ArrayList<Tree.Expr>();
						yyval.elist.add(val_peek(0).expr);
                	}
break;
case 89:
//#line 437 "Parser.y"
{
						yyval.stmt = new Tree.WhileLoop(val_peek(2).expr, val_peek(0).stmt, val_peek(4).loc);
					}
break;
case 90:
//#line 443 "Parser.y"
{
						yyval.stmt = new Tree.ForLoop(val_peek(6).stmt, val_peek(4).expr, val_peek(2).stmt, val_peek(0).stmt, val_peek(8).loc);
					}
break;
case 91:
//#line 449 "Parser.y"
{
						yyval.stmt = new Tree.Break(val_peek(0).loc);
					}
break;
case 92:
//#line 455 "Parser.y"
{
						yyval.stmt = new Tree.If(val_peek(3).expr, val_peek(1).stmt, val_peek(0).stmt, val_peek(5).loc);
					}
break;
case 93:
//#line 461 "Parser.y"
{
						yyval.stmt = val_peek(0).stmt;
					}
break;
case 94:
//#line 465 "Parser.y"
{
						yyval = new SemValue();
					}
break;
case 95:
//#line 471 "Parser.y"
{
						yyval.stmt = new Tree.Return(val_peek(0).expr, val_peek(1).loc);
					}
break;
case 96:
//#line 475 "Parser.y"
{
                		yyval.stmt = new Tree.Return(null, val_peek(0).loc);
                	}
break;
case 97:
//#line 481 "Parser.y"
{
						yyval.stmt = new Print(val_peek(1).elist, val_peek(3).loc);
					}
break;
//#line 1397 "Parser.java"
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
