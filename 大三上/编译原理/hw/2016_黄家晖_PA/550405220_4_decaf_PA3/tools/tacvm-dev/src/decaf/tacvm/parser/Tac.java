package decaf.tacvm.parser;

import decaf.tacvm.Location;
import decaf.tacvm.Opcode;

public class Tac {
	public Opcode opc;

	public Temp opr0;

	public Temp opr1;

	public Temp opr2;

	public String text;

	public Location loc;

	public static Tac genTac(Location loc, String text, Opcode opc,
			Temp... oprs) {
		Tac t = new Tac();
		t.loc = loc;
		t.text = text;
		t.opc = opc;
		assert oprs.length <= 3;
		if (oprs.length > 0) {
			t.opr0 = oprs[0];
		}
		if (oprs.length > 1) {
			t.opr1 = oprs[1];
		}
		if (oprs.length > 2) {
			t.opr2 = oprs[2];
		}
		return t;
	}

	@Override
	public String toString() {
		return text != null ? text : super.toString();
	}
}
