package decaf.scope;

import java.util.ListIterator;
import java.util.Stack;

import decaf.Location;
import decaf.scope.Scope.Kind;
import decaf.symbol.Class;
import decaf.symbol.Symbol;

public class ScopeStack {
	private Stack<Scope> scopeStack = new Stack<Scope>();
	
	private GlobalScope globalScope;

	public Symbol lookup(String name, boolean through) {
		if (through) {
			ListIterator<Scope> iter = scopeStack.listIterator(scopeStack
					.size());
			while (iter.hasPrevious()) {
				Symbol symbol = iter.previous().lookup(name);
				if (symbol != null) {
					return symbol;
				}
			}
			return null;
		} else {
			return scopeStack.peek().lookup(name);
		}
	}

	public Symbol lookupBeforeLocation(String name, Location loc) {
		ListIterator<Scope> iter = scopeStack.listIterator(scopeStack.size());
		while (iter.hasPrevious()) {
			Scope scope = iter.previous();
			Symbol symbol = scope.lookup(name);
			if (symbol != null) {
				if (scope.isLocalScope()
						&& symbol.getLocation().compareTo(loc) > 0) {
					continue;
				}
				return symbol;
			}
		}
		return null;
	}

	public void declare(Symbol symbol) {
		scopeStack.peek().declare(symbol);
	}

	public void open(Scope scope) {
		switch (scope.getKind()) {
		case GLOBAL:
			globalScope = (GlobalScope)scope;
			break;
		case CLASS:
			ClassScope cs = ((ClassScope) scope).getParentScope();
			if (cs != null) {
				open(cs);
			}
			break;
		}
		scopeStack.push(scope);
	}

	public void close() {
		Scope scope = scopeStack.pop();
		if (scope.isClassScope()) {
			for (int n = scopeStack.size() - 1; n > 0; n--) {
				scopeStack.pop();
			}
		}
	}

	public Scope lookForScope(Kind kind) {
		ListIterator<Scope> iter = scopeStack.listIterator(scopeStack.size());
		while (iter.hasPrevious()) {
			Scope scope = iter.previous();
			if (scope.getKind() == kind) {
				return scope;
			}
		}
		return null;
	}

	public Scope getCurrentScope() {
		return scopeStack.peek();
	}

	public Class lookupClass(String name) {
		return (Class) globalScope.lookup(name);
	}
}
