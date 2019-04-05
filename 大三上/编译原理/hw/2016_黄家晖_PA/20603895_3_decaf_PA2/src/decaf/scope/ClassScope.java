package decaf.scope;

import java.util.TreeSet;

import decaf.symbol.Class;
import decaf.symbol.Function;
import decaf.symbol.Symbol;
import decaf.utils.IndentPrintWriter;

public class ClassScope extends Scope {

	private Class owner;

	public ClassScope(Class owner) {
		super();
		this.owner = owner;
	}

	@Override
	public boolean isClassScope() {
		return true;
	}

	public ClassScope getParentScope() {
		Class p = owner.getParent();
		return p == null ? null : p.getAssociatedScope();
	}

	@Override
	public Kind getKind() {
		return Kind.CLASS;
	}

	public Class getOwner() {
		return owner;
	}

	@Override
	public void printTo(IndentPrintWriter pw) {
		TreeSet<Symbol> ss = new TreeSet<Symbol>(Symbol.LOCATION_COMPARATOR);
		for (Symbol symbol : symbols.values()) {
			ss.add(symbol);
		}
		pw.println("CLASS SCOPE OF '" + owner.getName() + "':");
		pw.incIndent();
		for (Symbol symbol : ss) {
			pw.println(symbol);
		}
		for (Symbol symbol : ss) {
			if (symbol.isFunction()) {
				((Function) symbol).getAssociatedScope().printTo(pw);
			}
		}
		pw.decIndent();
	}

	public boolean isInherited(Symbol symbol) {
		Scope scope = symbol.getScope();
		if (scope == null || scope == this || !scope.isClassScope()) {
			return false;
		}
		for (ClassScope p = getParentScope(); p != null; p = p.getParentScope()) {
			if (scope == p) {
				return true;
			}
		}
		return false;
	}

	public Symbol lookupVisible(String name) {
		for (ClassScope cs = this; cs != null; cs = cs.getParentScope()) {
			Symbol symbol = cs.lookup(name);
			if (symbol != null) {
				return symbol;
			}
		}
		return null;
	}
}
