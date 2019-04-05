package decaf.backend;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import decaf.dataflow.BasicBlock;
import decaf.dataflow.FlowGraph;
import decaf.dataflow.BasicBlock.EndKind;
import decaf.machdesc.Asm;
import decaf.machdesc.MachineDescription;
import decaf.tac.Label;
import decaf.tac.Tac;
import decaf.tac.Temp;
import decaf.tac.VTable;
import decaf.utils.MiscUtils;

public class Mips implements MachineDescription {

	public static final MipsRegister[] REGS = new MipsRegister[] {
			new MipsRegister(MipsRegister.RegId.ZERO, "$zero"),// zero
			new MipsRegister(MipsRegister.RegId.AT, "$at"), // assembler
			// temporary
			new MipsRegister(MipsRegister.RegId.V0, "$v0"), // return value 0
			new MipsRegister(MipsRegister.RegId.V1, "$v1"), // return value 1
			new MipsRegister(MipsRegister.RegId.A0, "$a0"), // argument 0
			new MipsRegister(MipsRegister.RegId.A1, "$a1"), // argument 1
			new MipsRegister(MipsRegister.RegId.A2, "$a2"), // argument 2
			new MipsRegister(MipsRegister.RegId.A3, "$a3"), // argument 3
			new MipsRegister(MipsRegister.RegId.K0, "$k0"), // kernal 0
			new MipsRegister(MipsRegister.RegId.K1, "$k1"), // kernal 1
			new MipsRegister(MipsRegister.RegId.GP, "$gp"), // global pointer
			new MipsRegister(MipsRegister.RegId.SP, "$sp"), // stack pointer
			new MipsRegister(MipsRegister.RegId.FP, "$fp"), // frame pointer
			new MipsRegister(MipsRegister.RegId.RA, "$ra"), // return address
			new MipsRegister(MipsRegister.RegId.T0, "$t0"),
			new MipsRegister(MipsRegister.RegId.T1, "$t1"),
			new MipsRegister(MipsRegister.RegId.T2, "$t2"),
			new MipsRegister(MipsRegister.RegId.T3, "$t3"),
			new MipsRegister(MipsRegister.RegId.T4, "$t4"),
			new MipsRegister(MipsRegister.RegId.T5, "$t5"),
			new MipsRegister(MipsRegister.RegId.T6, "$t6"),
			new MipsRegister(MipsRegister.RegId.T7, "$t7"),
			new MipsRegister(MipsRegister.RegId.T8, "$t8"),
			new MipsRegister(MipsRegister.RegId.T9, "$t9"),
			new MipsRegister(MipsRegister.RegId.S0, "$s0"),
			new MipsRegister(MipsRegister.RegId.S1, "$s1"),
			new MipsRegister(MipsRegister.RegId.S2, "$s2"),
			new MipsRegister(MipsRegister.RegId.S3, "$s3"),
			new MipsRegister(MipsRegister.RegId.S4, "$s4"),
			new MipsRegister(MipsRegister.RegId.S5, "$s5"),
			new MipsRegister(MipsRegister.RegId.S6, "$s6"),
			new MipsRegister(MipsRegister.RegId.S7, "$s7") };

	public static final MipsRegister[] GENERAL_REGS;
	static {
		GENERAL_REGS = new MipsRegister[MipsRegister.RegId.S7.ordinal()
				- MipsRegister.RegId.T0.ordinal()];
		System.arraycopy(REGS, MipsRegister.RegId.T0.ordinal(), GENERAL_REGS,
				0, GENERAL_REGS.length);
	}

	private RegisterAllocator regAllocator;

	private MipsFrameManager frameManager;

	private Map<String, String> stringConst;

	private String getStringConstLabel(String s) {
		String label = stringConst.get(s);
		if (label == null) {
			label = "_STRING" + stringConst.size();
			stringConst.put(s, label);
		}
		return label;
	}

	private PrintWriter output;

	public Mips() {
		frameManager = new MipsFrameManager();
		Temp fpTemp = Temp.createTempI4();
		fpTemp.reg = REGS[MipsRegister.RegId.FP.ordinal()];
		regAllocator = new RegisterAllocator(fpTemp, frameManager, GENERAL_REGS);
		stringConst = new HashMap<String, String>();
	}

	@Override
	public void emitAsm(List<FlowGraph> gs) {
		emit(null, ".text", null);
		for (FlowGraph g : gs) {
			regAllocator.reset();
			for (BasicBlock bb : g) {
				bb.label = Label.createLabel();
			}
			for (BasicBlock bb : g) {
				if (bb.cancelled) {
					continue;
				}
				regAllocator.alloc(bb);
				genAsmForBB(bb);
				for (Temp t : bb.saves) {
					bb.appendAsm(new MipsAsm(MipsAsm.FORMAT4, "sw", t.reg,
							t.offset, "$fp"));
				}
			}
			emitProlog(g.getFuncty().label, frameManager.getStackFrameSize());
			emitTrace(g.getBlock(0), g);
			output.println();
		}
		for (int i = 0; i < 3; i++) {
			output.println();
		}
		emitStringConst();
	}

	private void emitStringConst() {
		emit(null, ".data", null);
		for (Entry<String, String> e : stringConst.entrySet()) {
			emit(e.getValue(), ".asciiz " + MiscUtils.quote(e.getKey()), null);
		}
	}

	private void genAsmForBB(BasicBlock bb) {
		for (Tac tac = bb.tacList; tac != null; tac = tac.next) {
			switch (tac.opc) {
			case ADD:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT3, "add", tac.op0.reg,
						tac.op1.reg, tac.op2.reg));
				break;
			case SUB:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT3, "sub", tac.op0.reg,
						tac.op1.reg, tac.op2.reg));
				break;
			case MUL:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT3, "mul", tac.op0.reg,
						tac.op1.reg, tac.op2.reg));
				break;
			case DIV:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT3, "div", tac.op0.reg,
						tac.op1.reg, tac.op2.reg));
				break;
			case MOD:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT3, "rem", tac.op0.reg,
						tac.op1.reg, tac.op2.reg));
				break;
			case LAND:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT3, "and", tac.op0.reg,
						tac.op1.reg, tac.op2.reg));
				break;
			case LOR:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT3, "or", tac.op0.reg,
						tac.op1.reg, tac.op2.reg));
				break;
			case GTR:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT3, "sgt", tac.op0.reg,
						tac.op1.reg, tac.op2.reg));
				break;
			case GEQ:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT3, "sge", tac.op0.reg,
						tac.op1.reg, tac.op2.reg));
				break;
			case EQU:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT3, "seq", tac.op0.reg,
						tac.op1.reg, tac.op2.reg));
				break;
			case NEQ:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT3, "sne", tac.op0.reg,
						tac.op1.reg, tac.op2.reg));
				break;
			case LEQ:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT3, "sle", tac.op0.reg,
						tac.op1.reg, tac.op2.reg));
				break;
			case LES:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT3, "slt", tac.op0.reg,
						tac.op1.reg, tac.op2.reg));
				break;
			case NEG:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT2, "neg", tac.op0.reg,
						tac.op1.reg));
				break;
			case LNOT:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT2, "not", tac.op0.reg,
						tac.op1.reg));
				break;
			case ASSIGN:
				if (tac.op0.reg != tac.op1.reg) {
					bb.appendAsm(new MipsAsm(MipsAsm.FORMAT2, "move",
							tac.op0.reg, tac.op1.reg));
				}
				break;
			case LOAD_VTBL:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT2, "la", tac.op0.reg,
						tac.vt.name));
				break;
			case LOAD_IMM4:
				if (!tac.op1.isConst) {
					throw new IllegalArgumentException();
				}
				int high = tac.op1.value >> 16;
				int low = tac.op1.value & 0x0000FFFF;
				if (high == 0) {
					bb.appendAsm(new MipsAsm(MipsAsm.FORMAT2, "li",
							tac.op0.reg, low));
				} else {
					bb.appendAsm(new MipsAsm(MipsAsm.FORMAT2, "lui",
							tac.op0.reg, high));
					if (low != 0) {
						bb.appendAsm(new MipsAsm(MipsAsm.FORMAT2, "addiu",
								tac.op0.reg, tac.op0.reg, low));
					}
				}
				break;
			case LOAD_STR_CONST:
				String label = getStringConstLabel(tac.str);
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT2, "la", tac.op0.reg,
						label));
				break;
			case INDIRECT_CALL:
			case DIRECT_CALL:
				genAsmForCall(bb, tac);
				break;
			case PARM:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT4, "sw", tac.op0.reg,
						tac.op1.value, "$sp"));
				break;
			case LOAD:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT4, "lw", tac.op0.reg,
						tac.op2.value, tac.op1.reg));
				break;
			case STORE:
				bb.appendAsm(new MipsAsm(MipsAsm.FORMAT4, "sw", tac.op0.reg,
						tac.op2.value, tac.op1.reg));
				break;
			case BRANCH:
			case BEQZ:
			case BNEZ:
			case RETURN:
				throw new IllegalArgumentException();
			}
		}
	}

	private void genAsmForCall(BasicBlock bb, Tac call) {
		for (Temp t : call.saves) {
			bb.appendAsm(new MipsAsm(MipsAsm.FORMAT4, "sw", t.reg, t.offset,
					"$fp"));
		}
		if (call.opc == Tac.Kind.DIRECT_CALL) {
			bb.appendAsm(new MipsAsm(MipsAsm.FORMAT1, "jal", call.label));
		} else {
			bb.appendAsm(new MipsAsm(MipsAsm.FORMAT1, "jalr", call.op1.reg));
		}
		if (call.op0 != null) {
			bb.appendAsm(new MipsAsm(MipsAsm.FORMAT2, "move", call.op0.reg,
					"$v0"));
		}
		for (Temp t : call.saves) {
			bb.appendAsm(new MipsAsm(MipsAsm.FORMAT4, "lw", t.reg, t.offset,
					"$fp"));
		}
	}

	private void emitTrace(BasicBlock bb, FlowGraph graph) {
		if (bb.mark) {
			return;
		}
		bb.mark = true;
		emit(bb.label.name, null, null);
		for (Asm asm : bb.getAsms()) {
			emit(null, asm.toString(), null);
		}
		BasicBlock directNext;
		switch (bb.endKind) {
		case BY_BRANCH:
			directNext = graph.getBlock(bb.next[0]);
			if (directNext.mark) {
				emit(null, String.format(MipsAsm.FORMAT1, "b",
						directNext.label.name), null);
			} else {
				emitTrace(directNext, graph);
			}
			break;
		case BY_BEQZ:
		case BY_BNEZ:
			if (bb.endKind == EndKind.BY_BEQZ) {
				emit(null, String.format(MipsAsm.FORMAT2, "beqz", bb.varReg,
						graph.getBlock(bb.next[0]).label.name), null);
			} else {
				emit(null, String.format(MipsAsm.FORMAT3, "bne", bb.varReg,
						"$zero", graph.getBlock(bb.next[0]).label.name), null);
			}

			directNext = graph.getBlock(bb.next[1]);
			if (directNext.mark) {
				emit(null, String.format(MipsAsm.FORMAT1, "b",
						directNext.label.name), null);
			} else {
				emitTrace(directNext, graph);
			}
			emitTrace(graph.getBlock(bb.next[0]), graph);
			break;
		case BY_RETURN:
			if (bb.var != null) {
				emit(null, String.format(MipsAsm.FORMAT2, "move", "$v0",
						bb.varReg), null);
			}
			emit(null, String.format(MipsAsm.FORMAT2, "move", "$sp", "$fp"),
					null);
			emit(null, String.format(MipsAsm.FORMAT2, "lw", "$ra", "-4($fp)"),
					null);
			emit(null, String.format(MipsAsm.FORMAT2, "lw", "$fp", "0($fp)"),
					null);
			emit(null, String.format(MipsAsm.FORMAT1, "jr", "$ra"), null);
			break;
		}
	}

	private void emitProlog(Label entryLabel, int frameSize) {
		emit(entryLabel.name, null, "function entry");
		emit(null, "sw $fp, 0($sp)", null);
		emit(null, "sw $ra, -4($sp)", null);

		emit(null, "move $fp, $sp", null);
		emit(null, "addiu $sp, $sp, "
				+ (-frameSize - 2 * OffsetCounter.POINTER_SIZE), null);
	}

	@Override
	public void setOutputStream(PrintWriter pw) {
		this.output = pw;
	}

	@Override
	public void emitVTable(List<VTable> vtables) {
		emit(null, ".text", null);
		emit(null, ".globl main", null);

		for (VTable vt : vtables) {
			emit(null, null, null);
			emit(null, ".data", null);
			emit(null, ".align 2", null);
			emit(vt.name, null, "virtual table");
			emit(null, ".word " + (vt.parent == null ? "0" : vt.parent.name),
					"parent");
			emit(null, ".word " + getStringConstLabel(vt.className),
					"class name");
			for (Label l : vt.entries) {
				emit(null, ".word " + l.name, null);
			}
		}
	}

	private String emitToString(String label, String body, String comment) {
		if (comment != null && label == null && body == null) {
			return "                                        # " + comment;
		} else {
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			if (label != null) {
				if (body == null) {
					pw.format("%-40s", label + ":");
				} else {
					pw.println(label + ":");
				}
			}
			if (body != null) {
				pw.format("          %-30s", body);
			}
			if (comment != null) {
				pw.print("# " + comment);
			}
			pw.close();
			return sw.toString();
		}
	}

	private void emit(String label, String body, String comment) {
		output.println(emitToString(label, body, comment));
	}

}
