package decaf.backend;

import decaf.machdesc.Asm;

public class MipsAsm extends Asm {

	public static final String FORMAT0 = "%-6s";

	public static final String FORMAT1 = "%-6s%s";

	public static final String FORMAT2 = "%-6s%s, %s";

	public static final String FORMAT3 = "%-6s%s, %s, %s";

	public static final String FORMAT4 = "%-6s%s, %s(%s)";

	private String asm;

	public MipsAsm(String format, String opc, Object... ops) {
		switch (ops.length) {
		case 0:
			asm = String.format(format, opc);
			break;
		case 1:
			asm = String.format(format, opc, ops[0]);
			break;
		case 2:
			asm = String.format(format, opc, ops[0], ops[1]);
			break;
		case 3:
			asm = String.format(format, opc, ops[0], ops[1], ops[2]);
			break;
		default:
			throw new IllegalArgumentException();
		}
	}

	@Override
	public String toString() {
		return asm;
	}

	public static void main(String[] args) {
		System.out.println(new MipsAsm(FORMAT3, "add", 1, 2, 3));
	}
}
