package decaf.machdesc;

import java.io.PrintWriter;
import java.util.List;

import decaf.dataflow.FlowGraph;
import decaf.tac.VTable;

public interface MachineDescription {
	
	public void setOutputStream(PrintWriter pw);
	
	public void emitVTable(List<VTable> vtables);

	public void emitAsm(List<FlowGraph> gs);
}
