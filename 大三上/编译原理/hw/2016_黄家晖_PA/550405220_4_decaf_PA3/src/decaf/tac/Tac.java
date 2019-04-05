package decaf.tac;

import java.util.Set;

import decaf.utils.MiscUtils;

public class Tac {
	public enum Kind {
		ADD, SUB, MUL, DIV, MOD, NEG, LAND, LOR, LNOT, GTR, GEQ, EQU, NEQ, LEQ,
		LES, ASSIGN, LOAD_VTBL, INDIRECT_CALL, DIRECT_CALL, RETURN, BRANCH,
		BEQZ, BNEZ, LOAD, STORE, LOAD_IMM4, LOAD_STR_CONST, MEMO, MARK, PARM
	}

	public Kind opc;

	public boolean mark;

	public Tac prev;

	public Tac next;

	public Temp op0;

	public Temp op1;

	public Temp op2;

	public Label label;

	public VTable vt;

	public String str;

	public int bbNum;

	public Set<Temp> liveOut;
	
	public Set<Temp> saves;

	private Tac(Kind opc, Temp op0) {
		this(opc, op0, null, null);
	}

	private Tac(Kind opc, Temp op0, Temp op1) {
		this(opc, op0, op1, null);
	}

	private Tac(Kind opc, Temp op0, Temp op1, Temp op2) {
		this.opc = opc;
		this.op0 = op0;
		this.op1 = op1;
		this.op2 = op2;
	}

	private Tac(Kind opc, String str) {
		this.opc = opc;
		this.str = str;
	}

	private Tac(Kind opc, Temp op0, String str) {
		this.opc = opc;
		this.op0 = op0;
		this.str = str;
	}

	private Tac(Kind opc, Temp op0, VTable vt) {
		this.opc = opc;
		this.op0 = op0;
		this.vt = vt;
	}

	private Tac(Kind opc, Label label) {
		this.opc = opc;
		this.label = label;
	}

	private Tac(Kind opc, Temp op0, Label label) {
		this.opc = opc;
		this.op0 = op0;
		this.label = label;
	}

	public static Tac genAdd(Temp dst, Temp src1, Temp src2) {
		return new Tac(Kind.ADD, dst, src1, src2);
	}

	public static Tac genSub(Temp dst, Temp src1, Temp src2) {
		return new Tac(Kind.SUB, dst, src1, src2);
	}

	public static Tac genMul(Temp dst, Temp src1, Temp src2) {
		return new Tac(Kind.MUL, dst, src1, src2);
	}

	public static Tac genDiv(Temp dst, Temp src1, Temp src2) {
		return new Tac(Kind.DIV, dst, src1, src2);
	}

	public static Tac genMod(Temp dst, Temp src1, Temp src2) {
		return new Tac(Kind.MOD, dst, src1, src2);
	}

	public static Tac genNeg(Temp dst, Temp src) {
		return new Tac(Kind.NEG, dst, src);
	}

	public static Tac genLAnd(Temp dst, Temp src1, Temp src2) {
		return new Tac(Kind.LAND, dst, src1, src2);
	}

	public static Tac genLOr(Temp dst, Temp src1, Temp src2) {
		return new Tac(Kind.LOR, dst, src1, src2);
	}

	public static Tac genLNot(Temp dst, Temp src) {
		return new Tac(Kind.LNOT, dst, src);
	}

	public static Tac genGtr(Temp dst, Temp src1, Temp src2) {
		return new Tac(Kind.GTR, dst, src1, src2);
	}

	public static Tac genGeq(Temp dst, Temp src1, Temp src2) {
		return new Tac(Kind.GEQ, dst, src1, src2);
	}

	public static Tac genEqu(Temp dst, Temp src1, Temp src2) {
		return new Tac(Kind.EQU, dst, src1, src2);
	}

	public static Tac genNeq(Temp dst, Temp src1, Temp src2) {
		return new Tac(Kind.NEQ, dst, src1, src2);
	}

	public static Tac genLeq(Temp dst, Temp src1, Temp src2) {
		return new Tac(Kind.LEQ, dst, src1, src2);
	}

	public static Tac genLes(Temp dst, Temp src1, Temp src2) {
		return new Tac(Kind.LES, dst, src1, src2);
	}

	public static Tac genAssign(Temp dst, Temp src) {
		return new Tac(Kind.ASSIGN, dst, src);
	}

	public static Tac genLoadVtbl(Temp dst, VTable vt) {
		return new Tac(Kind.LOAD_VTBL, dst, vt);
	}

	public static Tac genIndirectCall(Temp dst, Temp func) {
		return new Tac(Kind.INDIRECT_CALL, dst, func);
	}

	public static Tac genDirectCall(Temp dst, Label func) {
		return new Tac(Kind.DIRECT_CALL, dst, func);
	}

	public static Tac genReturn(Temp src) {
		return new Tac(Kind.RETURN, src);
	}

	public static Tac genBranch(Label label) {
		label.target = true;
		return new Tac(Kind.BRANCH, label);
	}

	public static Tac genBeqz(Temp cond, Label label) {
		label.target = true;
		return new Tac(Kind.BEQZ, cond, label);
	}
	
	public static Tac genBnez(Temp cond, Label label) {
		label.target = true;
		return new Tac(Kind.BNEZ, cond, label);
	}

	public static Tac genLoad(Temp dst, Temp base, Temp offset) {
		if (!offset.isConst) {
			throw new IllegalArgumentException("offset must be const temp");
		}
		return new Tac(Kind.LOAD, dst, base, offset);
	}

	public static Tac genStore(Temp src, Temp base, Temp offset) {
		if (!offset.isConst) {
			throw new IllegalArgumentException("offset must be const temp");
		}
		return new Tac(Kind.STORE, src, base, offset);
	}

	public static Tac genLoadImm4(Temp dst, Temp val) {
		if (!val.isConst) {
			throw new IllegalArgumentException("val must be const temp");
		}
		return new Tac(Kind.LOAD_IMM4, dst, val);
	}

	public static Tac genLoadStrConst(Temp dst, String str) {
		return new Tac(Kind.LOAD_STR_CONST, dst, str);
	}

	public static Tac genMemo(String memo) {
		return new Tac(Kind.MEMO, memo);
	}

	public static Tac genMark(Label label) {
		Tac mark = new Tac(Kind.MARK, label);
		label.where = mark;
		return mark;
	}

	public static Tac genParm(Temp src) {
		return new Tac(Kind.PARM, src);
	}

	private String binanyOpToString(String op) {
		return op0.name + " = (" + op1.name + " " + op + " " + op2.name + ")";
	}

	private String unaryOpToString(String op) {
		return op0.name + " = " + op + " " + op1.name;
	}

	public String toString() {
		switch (opc) {
		case ADD:
			return binanyOpToString("+");
		case SUB:
			return binanyOpToString("-");
		case MUL:
			return binanyOpToString("*");
		case DIV:
			return binanyOpToString("/");
		case MOD:
			return binanyOpToString("%");
		case NEG:
			return unaryOpToString("-");
		case LAND:
			return binanyOpToString("&&");
		case LOR:
			return binanyOpToString("||");
		case LNOT:
			return unaryOpToString("!");
		case GTR:
			return binanyOpToString(">");
		case GEQ:
			return binanyOpToString(">=");
		case EQU:
			return binanyOpToString("==");
		case NEQ:
			return binanyOpToString("!=");
		case LEQ:
			return binanyOpToString("<=");
		case LES:
			return binanyOpToString("<");
		case ASSIGN:
			return op0.name + " = " + op1.name;
		case LOAD_VTBL:
			return op0.name + " = VTBL <" + vt.name + ">";
		case INDIRECT_CALL:
			if (op0 != null) {
				return op0.name + " = " + " call " + op1.name;
			} else {
				return "call " + op1.name;
			}
		case DIRECT_CALL:
			if (op0 != null) {
				return op0.name + " = " + " call " + label.name;
			} else {
				return "call " + label.name;
			}
		case RETURN:
			if (op0 != null) {
				return "return " + op0.name;
			} else {
				return "return <empty>";
			}
		case BRANCH:
			return "branch " + label.name;
		case BEQZ:
			return "if (" + op0.name + " == 0) branch " + label.name;
		case BNEZ:
			return "if (" + op0.name + " != 0) branch " + label.name;
		case LOAD:
			if (op2.value >= 0) {
				return op0.name + " = *(" + op1.name + " + " + op2.value + ")";
			} else {
				return op0.name + " = *(" + op1.name + " - " + (-op2.value)
						+ ")";
			}
		case STORE:
			if (op2.value >= 0) {
				return "*(" + op1.name + " + " + op2.value + ") = " + op0.name;
			} else {
				return "*(" + op1.name + " - " + (-op2.value) + ") = "
						+ op0.name;
			}
		case LOAD_IMM4:
			return op0.name + " = " + op1.value;
		case LOAD_STR_CONST:
			return op0.name + " = " + MiscUtils.quote(str);
		case MEMO:
			return "memo '" + str + "'";
		case MARK:
			return label.name + ":";
		case PARM:
			return "parm " + op0.name;
		default:
			throw new RuntimeException("unknown opc");
		}
	}
}
