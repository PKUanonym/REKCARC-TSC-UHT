package decaf.tacvm.exec;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;

import decaf.tacvm.parser.Tac;

public final class Executor {

	private static final String[] intrinsics = new String[] { "_Alloc",
			"_Halt", "_PrintBool", "_PrintInt", "_PrintString", "_ReadInteger",
			"_ReadLine", "_StringEqual", };

	public static int getIntrinsicIndex(String name) {
		return Arrays.binarySearch(intrinsics, name);
	}

	public class Intrinsic {

		public int callIntrinsic(int index) {
			switch (index) {
			case 0:
				return _Alloc();
			case 1:
				_Halt();
				break;
			case 2:
				_PrintBool();
				break;
			case 3:
				_PrintInt();
				break;
			case 4:
				_PrintString();
				break;
			case 5:
				return _ReadInteger();
			case 6:
				return _ReadLine();
			case 7:
				return _StringEqual();
			default:
				throw new ExecuteException("unknown intrinsic call");
			}
			return 0;
		}

		private int _Alloc() {
			return memory.alloc(stack[sp + 1]);
		}

		private void _Halt() {
//			printStackTrace();
			System.exit(0);
		}

		private void _PrintBool() {
			System.out.print(stack[sp + 1] == 0 ? "false" : "true");
		}

		private void _PrintInt() {
			System.out.print(stack[sp + 1]);
		}

		private void _PrintString() {
			System.out.print(stringTable.get(stack[sp + 1]));
		}

		private int _ReadInteger() {
			Scanner scanner = new Scanner(System.in);
			return scanner.nextInt();
		}

		private int _ReadLine() {
			BufferedReader br = new BufferedReader(new InputStreamReader(
					System.in));
			try {
				String s = br.readLine();
				stringTable.add(s);
				return stringTable.size() - 1;
			} catch (IOException e) {
				throw new ExecuteException(e);
			}
		}

		private int _StringEqual() {
			String str1 = stringTable.get(stack[sp + 1]);
			String str2 = stringTable.get(stack[sp + 2]);
			return str1.equals(str2) ? 1 : 0;
		}
	}

	private Inst[] insts;

	private int enterPoint;

	private Memory memory;

	private Intrinsic intrinsic;

	private List<String> stringTable;

	private static final int DEFAULT_STACK_SIZE = 1024 * 1024;

	private int fp = DEFAULT_STACK_SIZE - 1;

	private int sp = DEFAULT_STACK_SIZE - 1;

	private int ra = -1;

	private int pc;

	private int rv = -1;

	private int[] stack = new int[DEFAULT_STACK_SIZE];

	private int maxRunInsts = 100000;

	public void setMaxRunInsts(int maxRunInsts) {
		this.maxRunInsts = maxRunInsts;
	}

	private void checkStackAccess(int index) {
		if (index >= stack.length) {
			throw new ExecuteException("stack access index = " + index
					+ " out of bounds");
		}
		if (index < 0) {
			int[] newStack = new int[stack.length * 2];
			System.arraycopy(stack, 0, newStack, stack.length, stack.length);
			fp += stack.length;
			sp += stack.length;
			stack = newStack;
		}
	}

	public void init(List<String> stringTable, List<Tac> tacs, int[] vtable,
			int enterPoint) {
		memory = new Memory();
		memory.setVTable(vtable);
		this.stringTable = stringTable;
		insts = new Inst[tacs.size()];
		Iterator<Tac> iter = tacs.iterator();
		for (int i = 0; iter.hasNext(); i++) {
			Tac tac = iter.next();
			insts[i] = new Inst();
			insts[i].opc = tac.opc;
			if (tac.opr0 != null) {
				insts[i].opr0 = tac.opr0.iVal;
			}
			if (tac.opr1 != null) {
				insts[i].opr1 = tac.opr1.iVal;
			}
			if (tac.opr2 != null) {
				insts[i].opr2 = tac.opr2.iVal;
			}
			insts[i].tac = tac.text;
			insts[i].loc = tac.loc;
		}
		this.enterPoint = enterPoint;
		this.intrinsic = new Intrinsic();
	}

	public void exec() {
		pc = enterPoint;
		rv = -1;

		int instCount = 0;
		while (pc != -1) {
			Inst inst = insts[pc++];
//			if (inst.loc.getLine() == 113) {
//				System.out.println("haha");
//			}
			int resultIndex;
			try {
				switch (inst.opc) {
				case ENTER_FUNC:
					checkStackAccess(sp - 1);
					stack[sp] = fp;
					stack[sp - 1] = ra;
					fp = sp;
					sp -= inst.opr0;
					break;
				case LEAVE_FUNC:
					sp = fp;
					ra = stack[fp - 1];
					fp = stack[fp];
					pc = ra;
					break;
				case INDIRECT_CALL:
					ra = pc;
					pc = stack[fp + inst.opr0 / 4];
					break;
				case DIRECT_CALL:
					ra = pc;
					pc = inst.opr0;
					break;
				case LIB_CALL:
					rv = intrinsic.callIntrinsic(inst.opr0);
					break;
				case MOVE_FROM_RV:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = rv;
					break;
				case RETURN:
					rv = stack[fp + inst.opr0 / 4];
					break;
				case ASSIGN:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = stack[fp + inst.opr1 / 4];
					break;
				case ADD:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = stack[fp + inst.opr1 / 4]
							+ stack[fp + inst.opr2 / 4];
					break;
				case SUB:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = stack[fp + inst.opr1 / 4]
							- stack[fp + inst.opr2 / 4];
					break;
				case MUL:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = stack[fp + inst.opr1 / 4]
							* stack[fp + inst.opr2 / 4];
					break;
				case DIV:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = stack[fp + inst.opr1 / 4]
							/ stack[fp + inst.opr2 / 4];
					break;
				case MOD:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = stack[fp + inst.opr1 / 4]
							% stack[fp + inst.opr2 / 4];
					break;
				case NEG:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = -stack[fp + inst.opr1 / 4];
					break;
				case GTR:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = stack[fp + inst.opr1 / 4] > stack[fp
							+ inst.opr2 / 4] ? 1 : 0;
					break;
				case GEQ:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = stack[fp + inst.opr1 / 4] >= stack[fp
							+ inst.opr2 / 4] ? 1 : 0;
					break;
				case EQU:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = stack[fp + inst.opr1 / 4] == stack[fp
							+ inst.opr2 / 4] ? 1 : 0;
					break;
				case NEQ:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = stack[fp + inst.opr1 / 4] != stack[fp
							+ inst.opr2 / 4] ? 1 : 0;
					break;
				case LEQ:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = stack[fp + inst.opr1 / 4] <= stack[fp
							+ inst.opr2 / 4] ? 1 : 0;
					break;
				case LES:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = stack[fp + inst.opr1 / 4] < stack[fp
							+ inst.opr2 / 4] ? 1 : 0;
					break;
				case LAND:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = stack[fp + inst.opr1 / 4]
							& stack[fp + inst.opr2 / 4];
					break;
				case LOR:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = stack[fp + inst.opr1 / 4]
							| stack[fp + inst.opr2 / 4];
					break;
				case LNOT:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = 1 - stack[fp + inst.opr1 / 4];
					break;
				case PARM:
					checkStackAccess(sp);
					stack[sp + inst.opr1 / 4] = stack[fp + inst.opr0 / 4];
					break;
				case LOAD_VTBL:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = inst.opr1;
					break;
				case LOAD_IMM4:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = inst.opr1;
					break;
				case LOAD_STR:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = inst.opr1;
					break;
				case BRANCH:
					pc = inst.opr0;
					break;
				case BEQZ:
					if (stack[fp + inst.opr0 / 4] == 0) {
						pc = inst.opr1;
					}
					break;
				case BNEZ:
					if (stack[fp + inst.opr0 / 4] != 0) {
						pc = inst.opr1;
					}
					break;
				case LOAD:
					resultIndex = fp + inst.opr0 / 4;
					checkStackAccess(resultIndex);
					stack[resultIndex] = memory.load(stack[fp + inst.opr1 / 4],
							inst.opr2);
					break;
				case STORE:
					memory.store(stack[fp + inst.opr0 / 4], stack[fp
							+ inst.opr1 / 4], inst.opr2);
					break;
				default:
					if (inst.loc != null) {
						System.err.println("***Error at " + inst.loc
								+ ", tac = " + inst.tac + ": unknown tac");
					} else {
						System.err.println("***Error, tac = " + inst.tac
								+ ": unknown tac");
					}
//					printStackTrace();
					System.exit(0);
				}
			} catch (ExecuteException e) {
				e.printStackTrace();
				if (inst.loc != null) {
					System.err.println("***Error at " + inst.loc + ", tac = "
							+ inst.tac + ": " + e.getMessage());
				} else {
					System.err.println("***Error, tac = " + inst.tac + ": "
							+ e.getMessage());
				}
//				printStackTrace();
				System.exit(0);
			} catch (Exception e) {
				if (inst.loc != null) {
					System.err.println("vm crash at " + inst.loc + ", tac = "
							+ inst.tac);
					System.err.println("Caused by:");
					e.printStackTrace(System.err);
				} else {
					System.err.println("vm crash, tac = " + inst.tac);
					System.err.println("Caused by:");
					e.printStackTrace(System.err);
				}
//				printStackTrace();
				System.exit(0);
			}
			instCount++;
			if (instCount > maxRunInsts) {
				System.err
						.println("***Error: program has been run for a long time(more than 10W instructions)");
				System.err.println("please check if there is a dead loop");
//				printStackTrace();
				System.exit(0);
			}
		}
	}

	/*private void printStackTrace() {
		int fp = this.fp;
		System.err.println("stack trace:");
		Inst inst = insts[pc];
		if (inst.loc != null) {
			System.err.println("\t" + inst.loc + ", tac = " + inst.tac);
		} else {
			System.err.println("\ttac = " + inst.tac);
		}
		while (fp != stack.length - 1) {
			inst = insts[stack[fp - 1] - 1];
			if (inst.loc != null) {
				System.err.println("\t" + inst.loc + ", tac = " + inst.tac);
			} else {
				System.err.println("\ttac = " + inst.tac);
			}
			fp = stack[fp];
		}
	}*/
	
	public void dumpInsts() {
		for (Inst inst : insts) {
			System.out.println(inst);
		}
	}
}
