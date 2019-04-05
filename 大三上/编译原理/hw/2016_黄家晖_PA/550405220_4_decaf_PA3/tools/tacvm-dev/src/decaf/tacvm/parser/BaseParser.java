package decaf.tacvm.parser;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import decaf.tacvm.Location;
import decaf.tacvm.Opcode;
import decaf.tacvm.exec.ExecuteException;
import decaf.tacvm.exec.Executor;

public abstract class BaseParser {
	private Lexer lexer;

	protected Map<String, Temp> localTemps = new HashMap<String, Temp>();

	protected Map<String, Temp> paramTemps = new HashMap<String, Temp>();

	protected Map<String, Temp> labels = new HashMap<String, Temp>();

	protected Map<String, Temp> funcLabels = new HashMap<String, Temp>();

	protected Map<Integer, Temp> constTempI4 = new HashMap<Integer, Temp>();

	protected Map<String, Temp> constTempString = new HashMap<String, Temp>();

	protected List<String> stringTable = new ArrayList<String>();

	protected int enterPoint;

	protected List<Tac> tacs = new ArrayList<Tac>();

	protected Temp leaveFuncLabel;

	protected Temp stackFrameSize;

	protected int vtableOffset = 4;

	protected int[] runtimeVTable;

	protected int parmOffset = 4;

	protected int maxParmOffset = 4;

	protected Map<String, VTable> vtables = new HashMap<String, VTable>();

	public void setLexer(Lexer lexer) {
		this.lexer = lexer;
	}

	protected void yyerror(String msg) {
		Errs.issue(lexer.getLocation(), msg);
	}

	protected int yylex() {
		int token = -1;
		try {
			token = lexer.yylex();
		} catch (Exception e) {
			yyerror("lexer error: " + e.getMessage());
		}

		return token;
	}

	abstract int yyparse();

	public void parse() {
		yyparse();
		for (Temp t : funcLabels.values()) {
			if (t.iVal == -1) {
				Errs.issue(null, Errs.FUNC_NOT_DECL1, t.name);
			}
		}
		runtimeVTable = new int[vtableOffset / 4];
		for (VTable vt : vtables.values()) {
			runtimeVTable[vt.offset / 4] = vt.entrys.size() + 8;
			if (vt.parentName != null) {
				runtimeVTable[vt.offset / 4 + 1] = - vtables.get(vt.parentName).offset - 1;
			} else {
				runtimeVTable[vt.offset / 4 + 1] = 0;
			}
			runtimeVTable[vt.offset / 4 + 2] = getConstTempString(vt.className).iVal;
			for (int i = 0; i < vt.entrys.size(); i++) {
				Entry e = vt.entrys.get(i);
				if (e.offset == -1) {
					Errs.issue(null, Errs.FUNC_NOT_DEFINE1, e.name);
				} else {
					runtimeVTable[vt.offset / 4 + i + 3] = e.offset;
				}
			}
		}
	}

	protected void createVTable(String name, String parentName,
			String className, List<Entry> entrys) {
		VTable vtable = new VTable();
		vtable.name = name;
		vtable.className = className;
		vtable.parentName = parentName;
		vtable.entrys = entrys;
		vtable.offset = vtableOffset;
		vtableOffset += 4 * entrys.size() + 12;
		vtables.put(name, vtable);
	}

	protected void enterFunc(Location loc, String name) {
		localTemps.clear();
		paramTemps.clear();
		labels.clear();
		stackFrameSize = new Temp();
		stackFrameSize.isConst = true;
		leaveFuncLabel = new Temp();
		leaveFuncLabel.isConst = true;

		if (name.equals("main")) {
			enterPoint = tacs.size();
		} else {
			boolean isExist = false;
			for (VTable vt : vtables.values()) {
				for (Entry e : vt.entrys) {
					if (e.name.equals(name)) {
						e.offset = tacs.size();
						isExist = true;
					}
				}
			}
			if (!isExist) {
				getFuncLabel(name).iVal = tacs.size();
			}
		}
		tacs.add(Tac.genTac(loc, "enterFunc " + name, Opcode.ENTER_FUNC,
				stackFrameSize));
	}

	protected void endFunc() {
		int offset = -8;
		for (Temp t : localTemps.values()) {
			t.iVal = offset;
			offset -= 4;
		}
		stackFrameSize.iVal = -offset + maxParmOffset;
		leaveFuncLabel.iVal = tacs.size();
		tacs.add(Tac.genTac(tacs.get(tacs.size() - 1).loc, "leaveFunc",
				Opcode.LEAVE_FUNC, stackFrameSize));
		for (Temp t : labels.values()) {
			if (t.iVal == -1) {
				Errs.issue(null, Errs.LABEL_NOT_EXIST1, t.name);
			}
		}
	}

	protected void addParam(String name, int offset) {
		Temp t = new Temp();
		t.name = name;
		t.iVal = offset;
		paramTemps.put(name, t);
	}

	protected Temp getTemp(String name) {
		if (name == null) {
			return null;
		}
		Temp t = paramTemps.get(name);
		if (t != null) {
			return t;
		}
		t = localTemps.get(name);
		if (t != null) {
			return t;
		}
		t = new Temp();
		t.name = name;
		localTemps.put(name, t);
		return t;
	}

	protected Temp getConstTempI4(int val) {
		Temp t = constTempI4.get(val);
		if (t == null) {
			t = new Temp();
			t.isConst = true;
			t.iVal = val;
			constTempI4.put(val, t);
		}
		return t;
	}

	protected Temp getConstTempString(String val) {
		Temp t = constTempString.get(val);
		if (t == null) {
			t = new Temp();
			t.isConst = true;
			t.iVal = stringTable.size();
			constTempString.put(val, t);
			stringTable.add(val);
		}
		return t;
	}

	protected Temp getLabel(String name) {
		Temp t = labels.get(name);
		if (t == null) {
			t = new Temp();
			t.name = name;
			t.isConst = true;
			t.iVal = -1;
			labels.put(name, t);
		}
		return t;
	}

	protected Temp getFuncLabel(String name) {
		Temp t = funcLabels.get(name);
		if (t == null) {
			t = new Temp();
			t.name = name;
			t.isConst = true;
			t.iVal = -1;
			funcLabels.put(name, t);
		}
		return t;
	}

	public int[] getVTables() {
		return runtimeVTable;
	}

	public List<Tac> getTacs() {
		return tacs;
	}

	public int getEnterPoint() {
		return enterPoint;
	}

	public List<String> getStringTable() {
		return stringTable;
	}

	protected void genBinOp(Location loc, String op, Opcode opc, String dest,
			String src1, String src2) {
		String text = dest + " = (" + src1 + " " + op + " " + src2 + ")";
		tacs.add(Tac.genTac(loc, text, opc, getTemp(dest), getTemp(src1),
				getTemp(src2)));
	}

	protected void genAdd(Location loc, String dest, String src1, String src2) {
		genBinOp(loc, "+", Opcode.ADD, dest, src1, src2);
	}

	protected void genSub(Location loc, String dest, String src1, String src2) {
		genBinOp(loc, "-", Opcode.SUB, dest, src1, src2);
	}

	protected void genMul(Location loc, String dest, String src1, String src2) {
		genBinOp(loc, "*", Opcode.MUL, dest, src1, src2);
	}

	protected void genDiv(Location loc, String dest, String src1, String src2) {
		genBinOp(loc, "/", Opcode.DIV, dest, src1, src2);
	}

	protected void genMod(Location loc, String dest, String src1, String src2) {
		genBinOp(loc, "%", Opcode.MOD, dest, src1, src2);
	}

	protected void genLAnd(Location loc, String dest, String src1, String src2) {
		genBinOp(loc, "&&", Opcode.LAND, dest, src1, src2);
	}

	protected void genLOr(Location loc, String dest, String src1, String src2) {
		genBinOp(loc, "||", Opcode.LOR, dest, src1, src2);
	}

	protected void genGtr(Location loc, String dest, String src1, String src2) {
		genBinOp(loc, ">", Opcode.GTR, dest, src1, src2);
	}

	protected void genGeq(Location loc, String dest, String src1, String src2) {
		genBinOp(loc, ">=", Opcode.GEQ, dest, src1, src2);
	}

	protected void genEqu(Location loc, String dest, String src1, String src2) {
		genBinOp(loc, "==", Opcode.EQU, dest, src1, src2);
	}

	protected void genNeq(Location loc, String dest, String src1, String src2) {
		genBinOp(loc, "!=", Opcode.NEQ, dest, src1, src2);
	}

	protected void genLeq(Location loc, String dest, String src1, String src2) {
		genBinOp(loc, "<=", Opcode.LEQ, dest, src1, src2);
	}

	protected void genLes(Location loc, String dest, String src1, String src2) {
		genBinOp(loc, "<", Opcode.LES, dest, src1, src2);
	}

	protected void genUnaryOp(Location loc, String op, Opcode opc, String dest,
			String src) {
		String text = dest + " = " + op + " " + src;
		tacs.add(Tac.genTac(loc, text, opc, getTemp(dest), getTemp(src)));
	}

	protected void genLNot(Location loc, String dest, String src) {
		genUnaryOp(loc, "!", Opcode.LNOT, dest, src);
	}

	protected void genNeg(Location loc, String dest, String src) {
		genUnaryOp(loc, "-", Opcode.NEG, dest, src);
	}

	protected void genAssign(Location loc, String dest, String src) {
		String text = dest + " = " + src;
		tacs.add(Tac.genTac(loc, text, Opcode.ASSIGN, getTemp(dest),
				getTemp(src)));
	}

	protected void genLoadImm4(Location loc, String dest, int val) {
		String text = dest + " = " + val;
		tacs.add(Tac.genTac(loc, text, Opcode.LOAD_IMM4, getTemp(dest),
				getConstTempI4(val)));
	}

	protected void genLoadStr(Location loc, String dest, String val) {
		String text = dest + " = \"" + val + "\"";
		tacs.add(Tac.genTac(loc, text, Opcode.LOAD_STR, getTemp(dest),
				getConstTempString(val)));
	}

	protected void genLoad(Location loc, String dest, String base, int offset) {
		String text;
		if (offset >= 0) {
			text = dest + " = *(" + base + " + " + offset + ")";
		} else {
			text = dest + " = *(" + base + " - " + (-offset) + ")";
		}
		tacs.add(Tac.genTac(loc, text, Opcode.LOAD, getTemp(dest),
				getTemp(base), getConstTempI4(offset)));
	}

	protected void genStore(Location loc, String src, String base, int offset) {
		String text;
		if (offset >= 0) {
			text = "*(" + base + " + " + offset + ") = " + src;
		} else {
			text = "*(" + base + " - " + (-offset) + ") = " + src;
		}
		tacs.add(Tac.genTac(loc, text, Opcode.STORE, getTemp(src),
				getTemp(base), getConstTempI4(offset)));
	}

	private void checkParm() {
		if (parmOffset > maxParmOffset) {
			maxParmOffset = parmOffset;
		}
		parmOffset = 4;
	}

	protected void genIndirectCall(Location loc, String dest, String func) {
		checkParm();
		String text;
		if (dest == null) {
			text = "call " + func;
		} else {
			text = dest + " = call " + func;
		}
		tacs.add(Tac.genTac(loc, text, Opcode.INDIRECT_CALL, getTemp(func)));
		if (dest != null) {
			tacs.add(Tac.genTac(loc, text, Opcode.MOVE_FROM_RV, getTemp(dest)));
		}
	}

	protected void genDirectCall(Location loc, String dest, String func) {
		checkParm();
		String text;
		if (dest == null) {
			text = "call " + func;
		} else {
			text = dest + " = call " + func;
		}
		int index = Executor.getIntrinsicIndex(func);
		if (index < 0) {
			tacs.add(Tac.genTac(loc, text, Opcode.DIRECT_CALL,
					getFuncLabel(func)));
		} else {
			tacs.add(Tac.genTac(loc, text, Opcode.LIB_CALL,
					getConstTempI4(index)));
		}
		if (dest != null) {
			tacs.add(Tac.genTac(loc, text, Opcode.MOVE_FROM_RV, getTemp(dest)));
		}
	}

	protected void genLoadVtbl(Location loc, String dest, String name) {
		String text = dest + " = VTBL <" + name + ">";
		tacs.add(Tac.genTac(loc, text, Opcode.LOAD_VTBL, getTemp(dest),
				getConstTempI4(-vtables.get(name).offset - 1)));
	}

	protected void genBranch(Location loc, String target) {
		String text = "branch " + target;
		tacs.add(Tac.genTac(loc, text, Opcode.BRANCH, getLabel(target)));
	}

	protected void genBeqz(Location loc, String cond, String target) {
		String text = "if " + cond + " == 0 branch " + target;
		tacs.add(Tac.genTac(loc, text, Opcode.BEQZ, getTemp(cond),
				getLabel(target)));
	}

	protected void genBnez(Location loc, String cond, String target) {
		String text = "if " + cond + " != 0 branch " + target;
		tacs.add(Tac.genTac(loc, text, Opcode.BNEZ, getTemp(cond),
				getLabel(target)));
	}

	protected void genParm(Location loc, String val) {
		String text = "parm " + val;
		tacs.add(Tac.genTac(loc, text, Opcode.PARM, getTemp(val),
				getConstTempI4(parmOffset)));
		parmOffset += 4;
	}

	protected void genReturn(Location loc, String val) {
		if (val != null) {
			tacs.add(Tac.genTac(loc, "return " + val, Opcode.RETURN,
					getTemp(val)));
		}
		tacs.add(Tac
				.genTac(loc, "branch to end", Opcode.BRANCH, leaveFuncLabel));
	}

	protected void markLabel(String name) {
		Temp t = labels.get(name);
		if (t == null) {
			t = new Temp();
			t.isConst = true;
			labels.put(name, t);
		}
		t.iVal = tacs.size();
	}
}
