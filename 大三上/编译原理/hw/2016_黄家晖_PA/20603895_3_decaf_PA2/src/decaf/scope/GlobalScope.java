package decaf.scope;

import decaf.symbol.Class;
import decaf.symbol.Symbol;
import decaf.utils.IndentPrintWriter;

public class GlobalScope extends Scope {

	@Override
	public boolean isGlobalScope() {
		return true;
	}

	@Override
	public Kind getKind() {
		return Kind.GLOBAL;
	}

	@Override
	public void printTo(IndentPrintWriter pw) {
		pw.println("GLOBAL SCOPE:");
		pw.incIndent();
		for (Symbol symbol : symbols.values()) {
			pw.println(symbol);
		}
		for (Symbol symbol : symbols.values()) {
			((Class) symbol).getAssociatedScope().printTo(pw);
		}
		pw.decIndent();
	}

}
