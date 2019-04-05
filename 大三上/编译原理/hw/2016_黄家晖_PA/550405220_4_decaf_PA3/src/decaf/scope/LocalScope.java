package decaf.scope;

import decaf.tree.Tree;
import decaf.tree.Tree.Block;
import decaf.symbol.Symbol;
import decaf.utils.IndentPrintWriter;

public class LocalScope extends Scope {

	private Block node;
	
	private boolean misCombinedtoFormal;

	public LocalScope(Block node) {
		this.node = node;
		misCombinedtoFormal = false;
	}
	
	public void setCombinedtoFormal(boolean combined){
		misCombinedtoFormal = combined;
	}
	
	public boolean isCombinedtoFormal(){
		return misCombinedtoFormal;
	}

	@Override
	public Kind getKind() {
		return Kind.LOCAL;
	}

	@Override
	public void printTo(IndentPrintWriter pw) {
		pw.println("LOCAL SCOPE:");
		pw.incIndent();
		for (Symbol symbol : symbols.values()) {
			pw.println(symbol);
		}

		for (Tree s : node.block) {
			if (s instanceof Block) {
				((Block) s).associatedScope.printTo(pw);
			}
		}
		pw.decIndent();
	}

	@Override
	public boolean isLocalScope() {
		return true;
	}
}
