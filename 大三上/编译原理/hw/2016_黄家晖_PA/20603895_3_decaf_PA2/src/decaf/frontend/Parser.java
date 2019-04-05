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
public final static short LESS_EQUAL=281;
public final static short GREATER_EQUAL=282;
public final static short EQUAL=283;
public final static short NOT_EQUAL=284;
public final static short MIN_CP=285;
public final static short SWITCH=286;
public final static short CASE=287;
public final static short DEFAULT=288;
public final static short REPEAT=289;
public final static short UNTIL=290;
public final static short CONTINUE=291;
public final static short PCLONE=292;
public final static short UMINUS=293;
public final static short EMPTY=294;
public final static short YYERRCODE=256;
final static short yylhs[] = {                           -1,
    0,    1,    1,    3,    4,    5,    5,    5,    5,    5,
    5,    2,    6,    6,    7,    7,    7,    9,    9,   10,
   10,    8,    8,   11,   12,   12,   13,   13,   13,   13,
   13,   13,   13,   13,   13,   13,   13,   13,   14,   14,
   14,   27,   27,   24,   24,   26,   25,   25,   25,   25,
   25,   25,   25,   25,   25,   25,   25,   25,   25,   25,
   25,   25,   25,   25,   25,   25,   25,   25,   25,   25,
   25,   25,   25,   25,   29,   29,   28,   28,   30,   30,
   16,   17,   22,   23,   15,   18,   32,   32,   34,   33,
   33,   19,   31,   31,   20,   20,   21,
};
final static short yylen[] = {                            2,
    1,    2,    1,    2,    2,    1,    1,    1,    1,    2,
    3,    6,    2,    0,    2,    2,    0,    1,    0,    3,
    1,    7,    6,    3,    2,    0,    1,    2,    1,    1,
    1,    1,    2,    2,    2,    2,    2,    1,    3,    1,
    0,    2,    0,    2,    4,    5,    1,    1,    1,    3,
    3,    3,    3,    3,    3,    3,    3,    3,    3,    3,
    3,    3,    3,    2,    2,    3,    3,    1,    4,    5,
    6,    5,    5,    3,    1,    1,    1,    0,    3,    1,
    5,    9,    1,    1,    6,    8,    2,    0,    4,    3,
    0,    6,    2,    0,    2,    1,    4,
};
final static short yydefred[] = {                         0,
    0,    0,    0,    3,    0,    2,    0,    0,   13,   17,
    0,    7,    8,    6,    9,    0,    0,   12,   15,    0,
    0,   16,   10,    0,    4,    0,    0,    0,    0,   11,
    0,   21,    0,    0,    0,    0,    5,    0,    0,    0,
   26,   23,   20,   22,    0,   76,   68,    0,    0,    0,
    0,   83,    0,    0,    0,    0,   75,    0,    0,   26,
   84,    0,    0,    0,   24,   27,   38,   25,    0,   29,
   30,   31,   32,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   49,    0,    0,    0,   47,    0,   48,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   28,   33,   34,   35,   36,   37,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   42,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   66,   67,    0,    0,    0,    0,   63,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   69,    0,    0,   97,    0,    0,    0,    0,   45,
    0,    0,    0,   81,    0,    0,   70,    0,    0,   88,
    0,   72,    0,   46,    0,    0,   85,   71,    0,   92,
    0,   93,    0,    0,    0,   87,    0,    0,   26,   86,
   82,   26,    0,    0,
};
final static short yydgoto[] = {                          2,
    3,    4,   66,   20,   33,    8,   11,   22,   34,   35,
   67,   45,   68,   69,   70,   71,   72,   73,   74,   75,
   76,   77,   78,   87,   80,   89,   82,  172,   83,  133,
  187,  189,  195,  196,
};
final static short yysindex[] = {                      -228,
 -224,    0, -228,    0, -219,    0, -214,  -66,    0,    0,
  -91,    0,    0,    0,    0, -209, -120,    0,    0,   12,
  -85,    0,    0,  -83,    0,   41,  -10,   46, -120,    0,
 -120,    0,  -80,   47,   45,   50,    0,  -28, -120,  -28,
    0,    0,    0,    0,    2,    0,    0,   53,   57,   58,
  871,    0,  -46,   59,   60,   63,    0,   64,   67,    0,
    0,  871,  871,  810,    0,    0,    0,    0,   52,    0,
    0,    0,    0,   55,   62,   76,   83,   84,   48,  740,
    0, -154,    0,  871,  871,  871,    0,  740,    0,   86,
   32,  871,  103,  111,  871,  871,   37,  -30,  -30, -123,
  477,    0,    0,    0,    0,    0,    0,  871,  871,  871,
  871,  871,  871,  871,  871,  871,  871,  871,  871,  871,
  871,    0,  871,  871,  871,  122,  489,   95,  513,  124,
 1022,  740,   -3,    0,    0,  540,  552,  123,  130,    0,
  740,  998,  948,   73,   73, 1049, 1049,  -22,  -22,  -30,
  -30,  -30,   73,   73,  564,  576,    3,  871,   72,  871,
   72,    0,  650,  871,    0,  -95,   69,  871,  871,    0,
  871,  134,  138,    0,  674,  -78,    0,  740,  157,    0,
  824,    0,  740,    0,  871,   72,    0,    0, -208,    0,
  158,    0, -232,  145,   81,    0,   72,  150,    0,    0,
    0,    0,   72,   72,
};
final static short yyrindex[] = {                         0,
    0,    0,  209,    0,   93,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,  151,    0,    0,  176,    0,
  176,    0,    0,    0,  177,    0,    0,    0,    0,    0,
    0,    0,    0,    0,  -56,    0,    0,    0,    0,    0,
  -54,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,  -55,  -55,  -55,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,  846,    0,
  447,    0,    0,  -55,  -56,  -55,    0,  164,    0,    0,
    0,  -55,    0,    0,  -55,  -55,  -56,  114,  142,    0,
    0,    0,    0,    0,    0,    0,    0,  -55,  -55,  -55,
  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
  -55,    0,  -55,  -55,  -55,   87,    0,    0,    0,    0,
  -55,   10,    0,    0,    0,    0,    0,    0,    0,    0,
  -20,  -27,  975,  705,  918,   43,  625,  881,  905,  370,
  394,  423,  943,  968,    0,    0,  -40,  -32,  -56,  -55,
  -56,    0,    0,  -55,    0,    0,    0,  -55,  -55,    0,
  -55,    0,  205,    0,    0,  -33,    0,   31,    0,    0,
    0,    0,   15,    0,  -31,  -56,    0,    0,  153,    0,
    0,    0,    0,    0,    0,    0,  -56,    0,    0,    0,
    0,    0,  -57,  224,
};
final static short yygindex[] = {                         0,
    0,  245,  238,   -2,   11,    0,    0,    0,  239,    0,
   38,   -5, -101,  -72,    0,    0,    0,    0,    0,    0,
    0,    0,    0, 1052, 1241, 1115,    0,    0,   96,  121,
    0,    0,    0,    0,
};
final static int YYTABLESIZE=1412;
static short yytable[];
static { yytable();}
static void yytable(){
yytable = new short[]{                         94,
   74,   41,   41,   74,   96,   27,   94,   27,   78,   41,
   27,   94,  128,   61,  119,  122,   61,   74,   74,  117,
   39,   21,   74,  122,  118,   94,   32,   24,   32,   46,
   61,   61,    1,   18,   63,   61,   43,  165,   39,  119,
  164,   64,   57,    7,  117,  115,   62,  116,  122,  118,
   80,    5,   74,   80,   97,   73,   10,  174,   73,  176,
  123,    9,  121,   91,  120,   61,   23,   90,  123,   63,
   25,   79,   73,   73,   79,   42,   64,   44,  193,  194,
   29,   62,   30,   55,  192,   31,   55,   38,   39,   94,
   40,   94,   84,  123,   41,  201,   85,   86,   92,   93,
   55,   55,   94,   95,   63,   55,   96,   73,  108,  119,
  102,   64,  191,  103,  117,  115,   62,  116,  122,  118,
  104,  126,  131,   44,   41,  130,   65,   44,   44,   44,
   44,   44,   44,   44,  105,   55,   12,   13,   14,   15,
   16,  106,  107,  134,   44,   44,   44,   44,   44,   44,
   64,  135,  139,  160,   64,   64,   64,   64,   64,   41,
   64,  158,  168,  123,  162,   12,   13,   14,   15,   16,
  169,   64,   64,   64,  184,   64,   64,   44,   65,   44,
  179,  164,   65,   65,   65,   65,   65,   17,   65,  186,
   26,  180,   28,  203,   41,   37,  204,  188,  197,   65,
   65,   65,  199,   65,   65,  200,   64,  202,    1,    5,
   12,   13,   14,   15,   16,   14,   19,   18,   43,   43,
   43,   43,   95,   94,   94,   94,   94,   94,   94,   90,
   94,   94,   94,   94,   65,   94,   94,   94,   94,   94,
   94,   94,   94,   43,   43,   77,   94,    6,   19,   61,
   61,   74,   94,   94,   94,   94,   94,   94,   12,   13,
   14,   15,   16,   46,   61,   47,   48,   49,   50,   36,
   51,   52,   53,   54,   55,   56,   57,   91,  173,  109,
  110,   58,   41,  111,  112,  113,  114,   59,  198,    0,
   60,    0,   61,   12,   13,   14,   15,   16,   46,    0,
   47,   48,   49,   50,    0,   51,   52,   53,   54,   55,
   56,   57,    0,    0,    0,    0,   58,    0,    0,   55,
   55,    0,   59,    0,    0,   60,  138,   61,   12,   13,
   14,   15,   16,   46,   55,   47,   48,   49,   50,    0,
   51,   52,   53,   54,   55,   56,   57,    0,   89,    0,
    0,   58,    0,    0,    0,    0,    0,   59,    0,    0,
   60,    0,   61,   44,   44,    0,    0,   44,   44,   44,
   44,    0,    0,    0,    0,    0,    0,    0,   44,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   64,   64,    0,    0,   64,   64,   64,   64,    0,    0,
    0,    0,    0,    0,    0,   64,   52,    0,    0,    0,
   52,   52,   52,   52,   52,    0,   52,    0,   65,   65,
    0,    0,   65,   65,   65,   65,    0,   52,   52,   52,
   53,   52,   52,   65,   53,   53,   53,   53,   53,    0,
   53,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   53,   53,   53,    0,   53,   53,    0,    0,   54,
    0,    0,   52,   54,   54,   54,   54,   54,    0,   54,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   54,   54,   54,   48,   54,   54,   53,   40,   48,   48,
    0,   48,   48,   48,    0,    0,    0,    0,    0,   43,
    0,    0,    0,    0,    0,   40,   48,    0,   48,   48,
   89,   89,    0,  119,    0,   54,    0,  140,  117,  115,
    0,  116,  122,  118,    0,  119,    0,    0,    0,  159,
  117,  115,    0,  116,  122,  118,  121,   48,  120,  124,
    0,    0,    0,    0,    0,    0,    0,    0,  121,  119,
  120,  124,    0,  161,  117,  115,    0,  116,  122,  118,
    0,    0,    0,    0,    0,    0,    0,  123,    0,    0,
    0,    0,  121,    0,  120,  124,  119,    0,    0,  123,
    0,  117,  115,  166,  116,  122,  118,    0,  119,    0,
    0,    0,  167,  117,  115,    0,  116,  122,  118,  121,
  119,  120,  124,  123,    0,  117,  115,    0,  116,  122,
  118,  121,  119,  120,  124,    0,    0,  117,  115,    0,
  116,  122,  118,  121,    0,  120,  124,    0,    0,    0,
  123,    0,    0,  171,    0,  121,    0,  120,  124,    0,
    0,    0,  123,    0,    0,    0,   52,   52,    0,    0,
   52,   52,   52,   52,  123,    0,  170,    0,    0,    0,
    0,   52,    0,    0,    0,   56,  123,    0,   56,    0,
   53,   53,    0,    0,   53,   53,   53,   53,    0,    0,
    0,    0,   56,   56,    0,   53,  119,   56,    0,    0,
    0,  117,  115,    0,  116,  122,  118,    0,    0,   54,
   54,    0,    0,   54,   54,   54,   54,    0,    0,  121,
  119,  120,  124,    0,   54,  117,  115,   56,  116,  122,
  118,    0,    0,   48,   48,    0,    0,   48,   48,   48,
   48,    0,  185,  121,    0,  120,  124,    0,   48,    0,
  123,    0,  177,    0,    0,   59,    0,    0,   59,    0,
    0,    0,    0,  109,  110,    0,    0,  111,  112,  113,
  114,    0,   59,   59,  123,  109,  110,   59,  125,  111,
  112,  113,  114,    0,    0,    0,  119,    0,    0,    0,
  125,  117,  115,    0,  116,  122,  118,    0,    0,  109,
  110,    0,    0,  111,  112,  113,  114,   59,    0,  121,
    0,  120,  124,    0,  125,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,  109,  110,    0,    0,
  111,  112,  113,  114,    0,    0,    0,    0,  109,  110,
  123,  125,  111,  112,  113,  114,    0,    0,    0,    0,
  109,  110,   63,  125,  111,  112,  113,  114,    0,   64,
    0,    0,  109,  110,   62,  125,  111,  112,  113,  114,
  119,    0,    0,    0,  190,  117,  115,  125,  116,  122,
  118,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   47,  121,    0,  120,  124,   47,   47,    0,
   47,   47,   47,    0,    0,    0,    0,    0,    0,    0,
    0,   56,   56,   63,    0,   47,    0,   47,   47,    0,
   64,    0,    0,    0,  123,   62,   56,    0,    0,    0,
    0,   50,    0,   50,   50,   50,  109,  110,    0,    0,
  111,  112,  113,  114,    0,    0,   47,    0,   50,   50,
   50,  125,   50,   50,    0,   51,    0,   51,   51,   51,
  109,  110,    0,    0,  111,  112,  113,  114,   60,    0,
    0,   60,   51,   51,   51,  125,   51,   51,    0,    0,
    0,    0,    0,   50,    0,   60,   60,    0,    0,    0,
   60,   59,   59,   58,  119,    0,   58,   59,   59,  117,
  115,    0,  116,  122,  118,    0,   59,   51,    0,    0,
   58,   58,    0,    0,    0,   58,    0,  121,   57,  120,
   60,   57,    0,    0,    0,   62,  109,  110,   62,    0,
  111,  112,  113,  114,    0,   57,   57,    0,    0,    0,
   57,  125,   62,   62,  119,   58,    0,   62,  123,  117,
  115,    0,  116,  122,  118,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   63,    0,    0,  121,    0,  120,
   57,   64,    0,    0,    0,    0,   62,   62,    0,    0,
  100,   46,    0,   47,    0,    0,    0,    0,    0,    0,
   53,    0,   55,   56,   57,  119,    0,    0,  123,   58,
  117,  115,    0,  116,  122,  118,   79,    0,    0,    0,
  109,  110,    0,    0,  111,  112,  113,  114,  121,    0,
  120,    0,    0,    0,   30,  125,    0,    0,    0,    0,
    0,    0,   47,   47,    0,    0,   47,   47,   47,   47,
    0,    0,   46,    0,   47,    0,   79,   47,    0,  123,
    0,   53,    0,   55,   56,   57,    0,    0,   79,    0,
   58,    0,    0,    0,    0,    0,    0,   50,   50,   81,
    0,   50,   50,   50,   50,    0,    0,    0,    0,    0,
    0,    0,   50,    0,    0,    0,    0,    0,    0,    0,
    0,   51,   51,    0,    0,   51,   51,   51,   51,    0,
    0,    0,    0,    0,   60,   60,   51,    0,    0,   81,
   60,   60,    0,    0,    0,    0,    0,    0,    0,   60,
   79,   81,   79,    0,    0,    0,    0,    0,    0,   58,
   58,    0,    0,    0,  109,   58,   58,    0,  111,  112,
  113,  114,    0,    0,   58,    0,   79,   79,    0,    0,
    0,    0,    0,    0,   57,   57,    0,    0,   79,    0,
   57,   57,   62,    0,   79,   79,    0,    0,    0,   57,
    0,    0,    0,    0,    0,    0,   62,    0,    0,    0,
    0,    0,    0,   81,    0,   81,    0,    0,  111,  112,
  113,  114,    0,   46,    0,   47,    0,    0,    0,    0,
    0,   88,   53,    0,   55,   56,   57,    0,    0,   81,
   81,   58,   98,   99,  101,    0,    0,    0,    0,    0,
    0,   81,    0,    0,    0,    0,    0,   81,   81,    0,
    0,    0,    0,    0,  127,    0,  129,    0,    0,  111,
  112,    0,  132,    0,    0,  136,  137,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,  141,  142,
  143,  144,  145,  146,  147,  148,  149,  150,  151,  152,
  153,  154,    0,  155,  156,  157,    0,    0,    0,    0,
    0,  163,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,  132,    0,
  175,    0,    0,    0,  178,    0,    0,    0,  181,  182,
    0,  183,
};
}
static short yycheck[];
static { yycheck(); }
static void yycheck() {
yycheck = new short[] {                         33,
   41,   59,   59,   44,   59,   91,   40,   91,   41,   41,
   91,   45,   85,   41,   37,   46,   44,   58,   59,   42,
   41,   11,   63,   46,   47,   59,   29,   17,   31,  262,
   58,   59,  261,  125,   33,   63,   39,   41,   59,   37,
   44,   40,  275,  263,   42,   43,   45,   45,   46,   47,
   41,  276,   93,   44,   60,   41,  123,  159,   44,  161,
   91,  276,   60,   53,   62,   93,  276,  125,   91,   33,
   59,   41,   58,   59,   44,   38,   40,   40,  287,  288,
   40,   45,   93,   41,  186,   40,   44,   41,   44,  123,
   41,  125,   40,   91,  123,  197,   40,   40,   40,   40,
   58,   59,   40,   40,   33,   63,   40,   93,   61,   37,
   59,   40,  185,   59,   42,   43,   45,   45,   46,   47,
   59,  276,   91,   37,  123,   40,  125,   41,   42,   43,
   44,   45,   46,   47,   59,   93,  257,  258,  259,  260,
  261,   59,   59,   41,   58,   59,   60,   61,   62,   63,
   37,   41,  276,   59,   41,   42,   43,   44,   45,  123,
   47,   40,   40,   91,   41,  257,  258,  259,  260,  261,
   41,   58,   59,   60,   41,   62,   63,   91,   37,   93,
  276,   44,   41,   42,   43,   44,   45,  279,   47,  268,
  276,  123,  276,  199,  123,  276,  202,   41,   41,   58,
   59,   60,   58,   62,   63,  125,   93,   58,    0,   59,
  257,  258,  259,  260,  261,  123,   41,   41,  276,  276,
  276,  276,   59,  257,  258,  259,  260,  261,  262,  276,
  264,  265,  266,  267,   93,  269,  270,  271,  272,  273,
  274,  275,  276,  276,  276,   41,  280,    3,   11,  277,
  278,  292,  286,  287,  288,  289,  290,  291,  257,  258,
  259,  260,  261,  262,  292,  264,  265,  266,  267,   31,
  269,  270,  271,  272,  273,  274,  275,  125,  158,  277,
  278,  280,   59,  281,  282,  283,  284,  286,  193,   -1,
  289,   -1,  291,  257,  258,  259,  260,  261,  262,   -1,
  264,  265,  266,  267,   -1,  269,  270,  271,  272,  273,
  274,  275,   -1,   -1,   -1,   -1,  280,   -1,   -1,  277,
  278,   -1,  286,   -1,   -1,  289,  290,  291,  257,  258,
  259,  260,  261,  262,  292,  264,  265,  266,  267,   -1,
  269,  270,  271,  272,  273,  274,  275,   -1,  125,   -1,
   -1,  280,   -1,   -1,   -1,   -1,   -1,  286,   -1,   -1,
  289,   -1,  291,  277,  278,   -1,   -1,  281,  282,  283,
  284,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  292,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  277,  278,   -1,   -1,  281,  282,  283,  284,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  292,   37,   -1,   -1,   -1,
   41,   42,   43,   44,   45,   -1,   47,   -1,  277,  278,
   -1,   -1,  281,  282,  283,  284,   -1,   58,   59,   60,
   37,   62,   63,  292,   41,   42,   43,   44,   45,   -1,
   47,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   58,   59,   60,   -1,   62,   63,   -1,   -1,   37,
   -1,   -1,   93,   41,   42,   43,   44,   45,   -1,   47,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   58,   59,   60,   37,   62,   63,   93,   41,   42,   43,
   -1,   45,   46,   47,   -1,   -1,   -1,   -1,   -1,  276,
   -1,   -1,   -1,   -1,   -1,   59,   60,   -1,   62,   63,
  287,  288,   -1,   37,   -1,   93,   -1,   41,   42,   43,
   -1,   45,   46,   47,   -1,   37,   -1,   -1,   -1,   41,
   42,   43,   -1,   45,   46,   47,   60,   91,   62,   63,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   60,   37,
   62,   63,   -1,   41,   42,   43,   -1,   45,   46,   47,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   91,   -1,   -1,
   -1,   -1,   60,   -1,   62,   63,   37,   -1,   -1,   91,
   -1,   42,   43,   44,   45,   46,   47,   -1,   37,   -1,
   -1,   -1,   41,   42,   43,   -1,   45,   46,   47,   60,
   37,   62,   63,   91,   -1,   42,   43,   -1,   45,   46,
   47,   60,   37,   62,   63,   -1,   -1,   42,   43,   -1,
   45,   46,   47,   60,   -1,   62,   63,   -1,   -1,   -1,
   91,   -1,   -1,   58,   -1,   60,   -1,   62,   63,   -1,
   -1,   -1,   91,   -1,   -1,   -1,  277,  278,   -1,   -1,
  281,  282,  283,  284,   91,   -1,   93,   -1,   -1,   -1,
   -1,  292,   -1,   -1,   -1,   41,   91,   -1,   44,   -1,
  277,  278,   -1,   -1,  281,  282,  283,  284,   -1,   -1,
   -1,   -1,   58,   59,   -1,  292,   37,   63,   -1,   -1,
   -1,   42,   43,   -1,   45,   46,   47,   -1,   -1,  277,
  278,   -1,   -1,  281,  282,  283,  284,   -1,   -1,   60,
   37,   62,   63,   -1,  292,   42,   43,   93,   45,   46,
   47,   -1,   -1,  277,  278,   -1,   -1,  281,  282,  283,
  284,   -1,   59,   60,   -1,   62,   63,   -1,  292,   -1,
   91,   -1,   93,   -1,   -1,   41,   -1,   -1,   44,   -1,
   -1,   -1,   -1,  277,  278,   -1,   -1,  281,  282,  283,
  284,   -1,   58,   59,   91,  277,  278,   63,  292,  281,
  282,  283,  284,   -1,   -1,   -1,   37,   -1,   -1,   -1,
  292,   42,   43,   -1,   45,   46,   47,   -1,   -1,  277,
  278,   -1,   -1,  281,  282,  283,  284,   93,   -1,   60,
   -1,   62,   63,   -1,  292,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  277,  278,   -1,   -1,
  281,  282,  283,  284,   -1,   -1,   -1,   -1,  277,  278,
   91,  292,  281,  282,  283,  284,   -1,   -1,   -1,   -1,
  277,  278,   33,  292,  281,  282,  283,  284,   -1,   40,
   -1,   -1,  277,  278,   45,  292,  281,  282,  283,  284,
   37,   -1,   -1,   -1,   41,   42,   43,  292,   45,   46,
   47,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   37,   60,   -1,   62,   63,   42,   43,   -1,
   45,   46,   47,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  277,  278,   33,   -1,   60,   -1,   62,   63,   -1,
   40,   -1,   -1,   -1,   91,   45,  292,   -1,   -1,   -1,
   -1,   41,   -1,   43,   44,   45,  277,  278,   -1,   -1,
  281,  282,  283,  284,   -1,   -1,   91,   -1,   58,   59,
   60,  292,   62,   63,   -1,   41,   -1,   43,   44,   45,
  277,  278,   -1,   -1,  281,  282,  283,  284,   41,   -1,
   -1,   44,   58,   59,   60,  292,   62,   63,   -1,   -1,
   -1,   -1,   -1,   93,   -1,   58,   59,   -1,   -1,   -1,
   63,  277,  278,   41,   37,   -1,   44,  283,  284,   42,
   43,   -1,   45,   46,   47,   -1,  292,   93,   -1,   -1,
   58,   59,   -1,   -1,   -1,   63,   -1,   60,   41,   62,
   93,   44,   -1,   -1,   -1,   41,  277,  278,   44,   -1,
  281,  282,  283,  284,   -1,   58,   59,   -1,   -1,   -1,
   63,  292,   58,   59,   37,   93,   -1,   63,   91,   42,
   43,   -1,   45,   46,   47,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   33,   -1,   -1,   60,   -1,   62,
   93,   40,   -1,   -1,   -1,   -1,   45,   93,   -1,   -1,
  261,  262,   -1,  264,   -1,   -1,   -1,   -1,   -1,   -1,
  271,   -1,  273,  274,  275,   37,   -1,   -1,   91,  280,
   42,   43,   -1,   45,   46,   47,   45,   -1,   -1,   -1,
  277,  278,   -1,   -1,  281,  282,  283,  284,   60,   -1,
   62,   -1,   -1,   -1,   93,  292,   -1,   -1,   -1,   -1,
   -1,   -1,  277,  278,   -1,   -1,  281,  282,  283,  284,
   -1,   -1,  262,   -1,  264,   -1,   85,  292,   -1,   91,
   -1,  271,   -1,  273,  274,  275,   -1,   -1,   97,   -1,
  280,   -1,   -1,   -1,   -1,   -1,   -1,  277,  278,   45,
   -1,  281,  282,  283,  284,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  292,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  277,  278,   -1,   -1,  281,  282,  283,  284,   -1,
   -1,   -1,   -1,   -1,  277,  278,  292,   -1,   -1,   85,
  283,  284,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  292,
  159,   97,  161,   -1,   -1,   -1,   -1,   -1,   -1,  277,
  278,   -1,   -1,   -1,  277,  283,  284,   -1,  281,  282,
  283,  284,   -1,   -1,  292,   -1,  185,  186,   -1,   -1,
   -1,   -1,   -1,   -1,  277,  278,   -1,   -1,  197,   -1,
  283,  284,  278,   -1,  203,  204,   -1,   -1,   -1,  292,
   -1,   -1,   -1,   -1,   -1,   -1,  292,   -1,   -1,   -1,
   -1,   -1,   -1,  159,   -1,  161,   -1,   -1,  281,  282,
  283,  284,   -1,  262,   -1,  264,   -1,   -1,   -1,   -1,
   -1,   51,  271,   -1,  273,  274,  275,   -1,   -1,  185,
  186,  280,   62,   63,   64,   -1,   -1,   -1,   -1,   -1,
   -1,  197,   -1,   -1,   -1,   -1,   -1,  203,  204,   -1,
   -1,   -1,   -1,   -1,   84,   -1,   86,   -1,   -1,  281,
  282,   -1,   92,   -1,   -1,   95,   96,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  108,  109,
  110,  111,  112,  113,  114,  115,  116,  117,  118,  119,
  120,  121,   -1,  123,  124,  125,   -1,   -1,   -1,   -1,
   -1,  131,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  158,   -1,
  160,   -1,   -1,   -1,  164,   -1,   -1,   -1,  168,  169,
   -1,  171,
};
}
final static short YYFINAL=2;
final static short YYMAXTOKEN=294;
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
"STATIC","INSTANCEOF","LESS_EQUAL","GREATER_EQUAL","EQUAL","NOT_EQUAL","MIN_CP",
"SWITCH","CASE","DEFAULT","REPEAT","UNTIL","CONTINUE","PCLONE","UMINUS","EMPTY",
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
"Stmt : SwitchStmt",
"Stmt : RepeatStmt ';'",
"Stmt : ReturnStmt ';'",
"Stmt : PrintStmt ';'",
"Stmt : BreakStmt ';'",
"Stmt : ContinueStmt ';'",
"Stmt : StmtBlock",
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
"Expr : Expr '?' Expr ':' Expr",
"Expr : Expr PCLONE Expr",
"Constant : LITERAL",
"Constant : NULL",
"Actuals : ExprList",
"Actuals :",
"ExprList : ExprList ',' Expr",
"ExprList : Expr",
"WhileStmt : WHILE '(' Expr ')' Stmt",
"ForStmt : FOR '(' SimpleStmt ';' Expr ';' SimpleStmt ')' Stmt",
"BreakStmt : BREAK",
"ContinueStmt : CONTINUE",
"IfStmt : IF '(' Expr ')' Stmt ElseClause",
"SwitchStmt : SWITCH '(' Expr ')' '{' CaseStmtList DefaultStmt '}'",
"CaseStmtList : CaseStmtList CaseStmt",
"CaseStmtList :",
"CaseStmt : CASE Constant ':' StmtList",
"DefaultStmt : DEFAULT ':' StmtList",
"DefaultStmt :",
"RepeatStmt : REPEAT StmtList UNTIL '(' Expr ')'",
"ElseClause : ELSE Stmt",
"ElseClause :",
"ReturnStmt : RETURN Expr",
"ReturnStmt : RETURN",
"PrintStmt : PRINT '(' ExprList ')'",
};

//#line 486 "Parser.y"
    
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
//#line 694 "Parser.java"
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
//#line 59 "Parser.y"
{
						tree = new Tree.TopLevel(val_peek(0).clist, val_peek(0).loc);
					}
break;
case 2:
//#line 65 "Parser.y"
{
						yyval.clist.add(val_peek(0).cdef);
					}
break;
case 3:
//#line 69 "Parser.y"
{
                		yyval.clist = new ArrayList<Tree.ClassDef>();
                		yyval.clist.add(val_peek(0).cdef);
                	}
break;
case 5:
//#line 79 "Parser.y"
{
						yyval.vdef = new Tree.VarDef(val_peek(0).ident, val_peek(1).type, val_peek(0).loc);
					}
break;
case 6:
//#line 85 "Parser.y"
{
						yyval.type = new Tree.TypeIdent(Tree.INT, val_peek(0).loc);
					}
break;
case 7:
//#line 89 "Parser.y"
{
                		yyval.type = new Tree.TypeIdent(Tree.VOID, val_peek(0).loc);
                	}
break;
case 8:
//#line 93 "Parser.y"
{
                		yyval.type = new Tree.TypeIdent(Tree.BOOL, val_peek(0).loc);
                	}
break;
case 9:
//#line 97 "Parser.y"
{
                		yyval.type = new Tree.TypeIdent(Tree.STRING, val_peek(0).loc);
                	}
break;
case 10:
//#line 101 "Parser.y"
{
                		yyval.type = new Tree.TypeClass(val_peek(0).ident, val_peek(1).loc);
                	}
break;
case 11:
//#line 105 "Parser.y"
{
                		yyval.type = new Tree.TypeArray(val_peek(2).type, val_peek(2).loc);
                	}
break;
case 12:
//#line 111 "Parser.y"
{
						yyval.cdef = new Tree.ClassDef(val_peek(4).ident, val_peek(3).ident, val_peek(1).flist, val_peek(5).loc);
					}
break;
case 13:
//#line 117 "Parser.y"
{
						yyval.ident = val_peek(0).ident;
					}
break;
case 14:
//#line 121 "Parser.y"
{
                		yyval = new SemValue();
                	}
break;
case 15:
//#line 127 "Parser.y"
{
						yyval.flist.add(val_peek(0).vdef);
					}
break;
case 16:
//#line 131 "Parser.y"
{
						yyval.flist.add(val_peek(0).fdef);
					}
break;
case 17:
//#line 135 "Parser.y"
{
                		yyval = new SemValue();
                		yyval.flist = new ArrayList<Tree>();
                	}
break;
case 19:
//#line 143 "Parser.y"
{
                		yyval = new SemValue();
                		yyval.vlist = new ArrayList<Tree.VarDef>(); 
                	}
break;
case 20:
//#line 150 "Parser.y"
{
						yyval.vlist.add(val_peek(0).vdef);
					}
break;
case 21:
//#line 154 "Parser.y"
{
                		yyval.vlist = new ArrayList<Tree.VarDef>();
						yyval.vlist.add(val_peek(0).vdef);
                	}
break;
case 22:
//#line 161 "Parser.y"
{
						yyval.fdef = new MethodDef(true, val_peek(4).ident, val_peek(5).type, val_peek(2).vlist, (Block) val_peek(0).stmt, val_peek(4).loc);
					}
break;
case 23:
//#line 165 "Parser.y"
{
						yyval.fdef = new MethodDef(false, val_peek(4).ident, val_peek(5).type, val_peek(2).vlist, (Block) val_peek(0).stmt, val_peek(4).loc);
					}
break;
case 24:
//#line 171 "Parser.y"
{
						yyval.stmt = new Block(val_peek(1).slist, val_peek(2).loc);
					}
break;
case 25:
//#line 177 "Parser.y"
{
						yyval.slist.add(val_peek(0).stmt);
					}
break;
case 26:
//#line 181 "Parser.y"
{
                		yyval = new SemValue();
                		yyval.slist = new ArrayList<Tree>();
                	}
break;
case 27:
//#line 188 "Parser.y"
{
						yyval.stmt = val_peek(0).vdef;
					}
break;
case 28:
//#line 193 "Parser.y"
{
                		if (yyval.stmt == null) {
                			yyval.stmt = new Tree.Skip(val_peek(0).loc);
                		}
                	}
break;
case 39:
//#line 211 "Parser.y"
{
						yyval.stmt = new Tree.Assign(val_peek(2).lvalue, val_peek(0).expr, val_peek(1).loc);
					}
break;
case 40:
//#line 215 "Parser.y"
{
                		yyval.stmt = new Tree.Exec(val_peek(0).expr, val_peek(0).loc);
                	}
break;
case 41:
//#line 219 "Parser.y"
{
                		yyval = new SemValue();
                	}
break;
case 43:
//#line 226 "Parser.y"
{
                		yyval = new SemValue();
                	}
break;
case 44:
//#line 232 "Parser.y"
{
						yyval.lvalue = new Tree.Ident(val_peek(1).expr, val_peek(0).ident, val_peek(0).loc);
						if (val_peek(1).loc == null) {
							yyval.loc = val_peek(0).loc;
						}
					}
break;
case 45:
//#line 239 "Parser.y"
{
                		yyval.lvalue = new Tree.Indexed(val_peek(3).expr, val_peek(1).expr, val_peek(3).loc);
                	}
break;
case 46:
//#line 245 "Parser.y"
{
						yyval.expr = new Tree.CallExpr(val_peek(4).expr, val_peek(3).ident, val_peek(1).elist, val_peek(3).loc);
						if (val_peek(4).loc == null) {
							yyval.loc = val_peek(3).loc;
						}
					}
break;
case 47:
//#line 254 "Parser.y"
{
						yyval.expr = val_peek(0).lvalue;
					}
break;
case 50:
//#line 260 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.PLUS, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 51:
//#line 264 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.MINUS, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 52:
//#line 268 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.MUL, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 53:
//#line 272 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.DIV, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 54:
//#line 276 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.MOD, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 55:
//#line 280 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.EQ, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 56:
//#line 284 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.NE, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 57:
//#line 288 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.LT, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 58:
//#line 292 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.GT, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 59:
//#line 296 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.LE, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 60:
//#line 300 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.GE, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 61:
//#line 304 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.AND, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 62:
//#line 308 "Parser.y"
{
                		yyval.expr = new Tree.Binary(Tree.OR, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 63:
//#line 312 "Parser.y"
{
                		yyval = val_peek(1);
                	}
break;
case 64:
//#line 316 "Parser.y"
{
                		yyval.expr = new Tree.Unary(Tree.NEG, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 65:
//#line 320 "Parser.y"
{
                		yyval.expr = new Tree.Unary(Tree.NOT, val_peek(0).expr, val_peek(1).loc);
                	}
break;
case 66:
//#line 324 "Parser.y"
{
                		yyval.expr = new Tree.ReadIntExpr(val_peek(2).loc);
                	}
break;
case 67:
//#line 328 "Parser.y"
{
                		yyval.expr = new Tree.ReadLineExpr(val_peek(2).loc);
                	}
break;
case 68:
//#line 332 "Parser.y"
{
                		yyval.expr = new Tree.ThisExpr(val_peek(0).loc);
                	}
break;
case 69:
//#line 336 "Parser.y"
{
                		yyval.expr = new Tree.NewClass(val_peek(2).ident, val_peek(3).loc);
                	}
break;
case 70:
//#line 340 "Parser.y"
{
                		yyval.expr = new Tree.NewArray(val_peek(3).type, val_peek(1).expr, val_peek(4).loc);
                	}
break;
case 71:
//#line 344 "Parser.y"
{
                		yyval.expr = new Tree.TypeTest(val_peek(3).expr, val_peek(1).ident, val_peek(5).loc);
                	}
break;
case 72:
//#line 348 "Parser.y"
{
                		yyval.expr = new Tree.TypeCast(val_peek(2).ident, val_peek(0).expr, val_peek(0).loc);
                	}
break;
case 73:
//#line 352 "Parser.y"
{
                    	yyval.expr = new Tree.Ternary(Tree.CONDEXPR, val_peek(4).expr, val_peek(2).expr, val_peek(0).expr, val_peek(3).loc);
                   	}
break;
case 74:
//#line 356 "Parser.y"
{
                        yyval.expr = new Tree.Binary(Tree.PCLONE, val_peek(2).expr, val_peek(0).expr, val_peek(1).loc);
                    }
break;
case 75:
//#line 362 "Parser.y"
{
						yyval.expr = new Tree.Literal(val_peek(0).typeTag, val_peek(0).literal, val_peek(0).loc);
					}
break;
case 76:
//#line 366 "Parser.y"
{
						yyval.expr = new Null(val_peek(0).loc);
					}
break;
case 78:
//#line 373 "Parser.y"
{
                		yyval = new SemValue();
                		yyval.elist = new ArrayList<Tree.Expr>();
                	}
break;
case 79:
//#line 380 "Parser.y"
{
						yyval.elist.add(val_peek(0).expr);
					}
break;
case 80:
//#line 384 "Parser.y"
{
                		yyval.elist = new ArrayList<Tree.Expr>();
						yyval.elist.add(val_peek(0).expr);
                	}
break;
case 81:
//#line 391 "Parser.y"
{
						yyval.stmt = new Tree.WhileLoop(val_peek(2).expr, val_peek(0).stmt, val_peek(4).loc);
					}
break;
case 82:
//#line 397 "Parser.y"
{
						yyval.stmt = new Tree.ForLoop(val_peek(6).stmt, val_peek(4).expr, val_peek(2).stmt, val_peek(0).stmt, val_peek(8).loc);
					}
break;
case 83:
//#line 403 "Parser.y"
{
						yyval.stmt = new Tree.Break(val_peek(0).loc);
					}
break;
case 84:
//#line 409 "Parser.y"
{
						yyval.stmt = new Tree.Continue(val_peek(0).loc);
					}
break;
case 85:
//#line 415 "Parser.y"
{
						yyval.stmt = new Tree.If(val_peek(3).expr, val_peek(1).stmt, val_peek(0).stmt, val_peek(5).loc);
					}
break;
case 86:
//#line 421 "Parser.y"
{
                        yyval.stmt = new Tree.Switch(val_peek(5).expr, val_peek(2).caselist, val_peek(1).slist, val_peek(7).loc);
                    }
break;
case 87:
//#line 427 "Parser.y"
{
                        yyval.caselist.add(val_peek(0).casedef);
                    }
break;
case 88:
//#line 431 "Parser.y"
{
                        yyval = new SemValue();
                        yyval.caselist = new ArrayList<Case>();
                    }
break;
case 89:
//#line 438 "Parser.y"
{
                        yyval.casedef = new Tree.Case(val_peek(2).expr, val_peek(0).slist, val_peek(3).loc);
                    }
break;
case 90:
//#line 444 "Parser.y"
{
						yyval.slist = val_peek(0).slist;
					}
break;
case 91:
//#line 448 "Parser.y"
{
                		yyval = new SemValue();
                	}
break;
case 92:
//#line 454 "Parser.y"
{
                        yyval.stmt = new Tree.Repeat(val_peek(1).expr, new Tree.Block(val_peek(4).slist, val_peek(5).loc), val_peek(5).loc);
                    }
break;
case 93:
//#line 460 "Parser.y"
{
						yyval.stmt = val_peek(0).stmt;
					}
break;
case 94:
//#line 464 "Parser.y"
{
						yyval = new SemValue();
					}
break;
case 95:
//#line 470 "Parser.y"
{
						yyval.stmt = new Tree.Return(val_peek(0).expr, val_peek(1).loc);
					}
break;
case 96:
//#line 474 "Parser.y"
{
                		yyval.stmt = new Tree.Return(null, val_peek(0).loc);
                	}
break;
case 97:
//#line 480 "Parser.y"
{
						yyval.stmt = new Print(val_peek(1).elist, val_peek(3).loc);
					}
break;
//#line 1342 "Parser.java"
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
