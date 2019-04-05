package decaf.backend;

import decaf.machdesc.Register;

public class MipsRegister extends Register {

	public enum RegId {
		ZERO, AT, V0, V1, A0, A1, A2, A3, K0, K1, GP, SP, FP, RA, T0, T1, T2,
		T3, T4, T5, T6, T7, T8, T9, S0, S1, S2, S3, S4, S5, S6, S7
	}

	public final RegId id;

	public final String name;

	public MipsRegister(RegId id, String name) {
		this.id = id;
		this.name = name;
	}

	@Override
	public String toString() {
		return name;
	}

}
