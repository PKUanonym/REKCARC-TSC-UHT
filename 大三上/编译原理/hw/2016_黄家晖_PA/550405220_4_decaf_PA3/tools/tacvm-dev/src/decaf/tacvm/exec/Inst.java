package decaf.tacvm.exec;

import decaf.tacvm.Location;
import decaf.tacvm.Opcode;

public class Inst {
	public Opcode opc;

	public int opr0;

	public int opr1;

	public int opr2;

	public String tac;

	public Location loc;

	@Override
	public String toString() {
		return tac != null ? tac : super.toString();
	}

}
