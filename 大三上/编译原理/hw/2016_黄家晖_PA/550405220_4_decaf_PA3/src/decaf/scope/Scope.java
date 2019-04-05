package decaf.scope;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

import decaf.symbol.Symbol;
import decaf.utils.IndentPrintWriter;

public abstract class Scope {
	public enum Kind {
		GLOBAL, CLASS, FORMAL, LOCAL
	}

	protected Map<String, Symbol> symbols = new LinkedHashMap<String, Symbol>();

	public abstract Kind getKind();

	public abstract void printTo(IndentPrintWriter pw);

	public boolean isGlobalScope() {
		return false;
	}

	public boolean isClassScope() {
		return false;
	}

	public boolean isLocalScope() {
		return false;
	}

	public boolean isFormalScope() {
		return false;
	}

	public Symbol lookup(String name) {
		return symbols.get(name);
	}

	public void declare(Symbol symbol) {
		symbols.put(symbol.getName(), symbol);
		symbol.setScope(this);
	}

	public void cancel(Symbol symbol) {
		symbols.remove(symbol.getName());
	}

	public Iterator<Symbol> iterator() {
		return symbols.values().iterator();
	}

}
