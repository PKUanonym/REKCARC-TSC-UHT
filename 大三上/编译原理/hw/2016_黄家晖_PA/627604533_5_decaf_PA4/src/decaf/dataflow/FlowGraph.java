package decaf.dataflow;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import decaf.tac.Functy;
import decaf.tac.Tac;
import decaf.tac.Tac.Kind;

public class FlowGraph implements Iterable<BasicBlock> {

	private Functy functy;

	private List<BasicBlock> bbs;

	public FlowGraph(Functy func) {
		this.functy = func;
		deleteMemo(func);
		bbs = new ArrayList<BasicBlock>();
		markBasicBlocks(func.head);
		gatherBasicBlocks(func.head);
		simplify();
		analyzeLiveness();
		for (BasicBlock bb : bbs) {
			bb.analyzeLiveness();
		}
	}

	private void deleteMemo(Functy func) {
		while (func.head != null && func.head.opc == Tac.Kind.MEMO) {
			func.head = func.head.next;
		}
		for (Tac t = func.head; t != null; t = t.next) {
			if (t.opc == Tac.Kind.MEMO) {
				if (t.prev != null) {
					t.prev.next = t.next;
				}
				if (t.next != null) {
					t.next.prev = t.prev;
				}
			}
		}

	}

	private void markBasicBlocks(Tac t) {
		int index = -1;
		boolean atStart = false;

		for (; t != null; t = t.next) {
			t.bbNum = index;
			switch (t.opc) {
			case RETURN:
			case BRANCH:
			case BEQZ:
			case BNEZ:
				index++;
				atStart = true;
				break;
			case MARK:
				if (!t.label.target) {
					if (t.prev != null) {
						t.prev.next = t.next;
					} else {
						functy.head = t.next;
					}
					if (t.next != null) {
						t.next.prev = t.prev;
					}
				} else {
					if (!atStart) {
						index++;
						t.bbNum = index;
						atStart = true;
					}
				}
				break;
			default:
				atStart = false;
				break;
			}
		}

	}

	private void gatherBasicBlocks(Tac start) {
		BasicBlock current = null;
		Tac nextStart = null;
		Tac end = null;

		while (start != null && start.bbNum < 0) {
			start = start.next;
		}

		for (; start != null; start = nextStart) {
			int bbNum = start.bbNum;
			while (start != null && start.opc == Tac.Kind.MARK) {
				start = start.next;
			}

			if (start == null) {
				current = new BasicBlock();
				current.bbNum = bbNum;
				current.tacList = null;
				current.endKind = BasicBlock.EndKind.BY_RETURN;
				nextStart = null;
			} else {
				start.prev = null;
				end = start;
				while (end.next != null && end.next.bbNum == start.bbNum) {
					end = end.next;
				}
				nextStart = end.next;
				current = new BasicBlock();
				current.bbNum = bbNum;
				current.tacList = start;
				switch (end.opc) {
				case RETURN:
					current.endKind = BasicBlock.EndKind.BY_RETURN;
					current.var = end.op0;
					end = end.prev;
					break;
				case BRANCH:
					current.endKind = BasicBlock.EndKind.BY_BRANCH;
					current.next[0] = current.next[1] = end.label.where.bbNum;
					end = end.prev;
					break;
				case BEQZ:
				case BNEZ:
					current.endKind = end.opc == Kind.BEQZ ? BasicBlock.EndKind.BY_BEQZ
							: BasicBlock.EndKind.BY_BNEZ;
					current.var = end.op0;
					current.next[0] = end.label.where.bbNum;
					current.next[1] = nextStart.bbNum;
					end = end.prev;
					break;
				default:
					if (nextStart == null) {
						current.endKind = BasicBlock.EndKind.BY_RETURN;
					} else {
						current.endKind = BasicBlock.EndKind.BY_BRANCH;
						current.next[0] = current.next[1] = nextStart.bbNum;
					}
				}
				if (end == null) {
					current.tacList = null;
				} else {
					end.next = null;
				}
			}
			bbs.add(current);
		}
	}

	@Override
	public Iterator<BasicBlock> iterator() {
		return bbs.iterator();
	}

	public BasicBlock getBlock(int i) {
		return bbs.get(i);
	}

	public int size() {
		return bbs.size();
	}

	public void analyzeLiveness() {
		for (BasicBlock bb : bbs) {
			bb.computeDefAndLiveUse();
		}
		boolean changed = true;
		do {
			changed = false;
			for (BasicBlock bb: bbs) {
				for (int i = 0; i < 2; i++) {
					bb.liveOut.addAll (bbs.get(bb.next[i]).liveIn);
				}
				bb.liveOut.removeAll(bb.def);
				if (bb.liveIn.addAll (bb.liveOut))
					changed = true;
				for (int i = 0; i < 2; i++) {
					bb.liveOut.addAll (bbs.get(bb.next[i]).liveIn);
				}
			}
		} while (changed);
	}

	public void simplify() {
		getBlock(0).inDegree = 1;
		for (BasicBlock bb : bbs) {
			switch (bb.endKind) {
			case BY_BEQZ:
			case BY_BNEZ:
				getBlock(bb.next[1]).inDegree++;
			case BY_BRANCH:
				getBlock(bb.next[0]).inDegree++;
				break;
			}
		}
		for (BasicBlock bb : bbs) {
			if (bb.inDegree <= 0
					|| (bb.endKind == BasicBlock.EndKind.BY_BRANCH && bb.tacList == null)) {
				bb.cancelled = true;
			}
		}
		for (BasicBlock bb : bbs) {
			if (bb.cancelled || bb.endKind == BasicBlock.EndKind.BY_RETURN) {
				continue;
			}
			BasicBlock trace = getBlock(bb.next[0]);
			while (trace.cancelled) {
				trace = getBlock(trace.next[0]);
			}
			bb.next[0] = trace.bbNum;

			if (bb.endKind == BasicBlock.EndKind.BY_BEQZ
					|| bb.endKind == BasicBlock.EndKind.BY_BNEZ) {
				trace = getBlock(bb.next[1]);
				while (trace.cancelled) {
					trace = getBlock(trace.next[0]);
				}
				bb.next[1] = trace.bbNum;

				if (bb.next[0] == bb.next[1]) {
					bb.endKind = BasicBlock.EndKind.BY_BRANCH;
				}
			} else {
				bb.next[1] = bb.next[0];
			}
		}

		Map<Integer, Integer> newBBNum = new HashMap<Integer, Integer>();
		int sz = 0;
		int i = 0;
		for (BasicBlock bb : bbs) {
			if (!bb.cancelled) {
				newBBNum.put(i, sz);
				if (i > sz) {
					bbs.set(sz, getBlock(i));
				}
				sz++;
			}
			i++;
		}
		bbs = bbs.subList(0, sz);
		for (BasicBlock bb : bbs) {
			bb.bbNum = newBBNum.get(bb.bbNum);
			if (bb.endKind != BasicBlock.EndKind.BY_RETURN) {
				bb.next[0] = newBBNum.get(bb.next[0]);
				bb.next[1] = newBBNum.get(bb.next[1]);
			}
		}
	}

	public void printTo(PrintWriter pw) {
		pw.println("FUNCTION " + functy.label.name + " : ");
		for (BasicBlock bb : bbs) {
			bb.printTo(pw);
		}
	}

	public void printLivenessTo(PrintWriter pw) {
		pw.println("FUNCTION " + functy.label.name + " : ");
		for (BasicBlock bb : bbs) {
			bb.printLivenessTo(pw);
		}
	}

	public Functy getFuncty() {
		return functy;
	}
}
