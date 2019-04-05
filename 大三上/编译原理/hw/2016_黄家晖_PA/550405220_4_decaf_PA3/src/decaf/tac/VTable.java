package decaf.tac;
import decaf.symbol.Class;

public class VTable {
	public String name;
	
	public VTable parent;
	
	public String className;

	public Class actualClass;

	public Label[] entries;
}
