package decaf.tacvm.exec;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Memory {

	private int[] vtable;

	private int currentSize = 0;

	private static class Block implements Comparable<Block> {

		public int start;

		public int[] mem;

		@Override
		public int compareTo(Block o) {
			return start > o.start ? 1 : start == o.start ? 0 : -1;
		}
	}

	private List<Block> heap = new ArrayList<Block>();

	public void setVTable(int[] vtable) {
		this.vtable = vtable;
	}

	public int alloc(int size) {
		if (size < 0 || size % 4 != 0) {
			throw new ExecuteException("bad alloc size = " + size);
		}
		size /= 4;
		Block block = new Block();
		block.start = currentSize;
		currentSize += size;
		block.mem = new int[size];
		heap.add(block);
		return block.start * 4;
	}

	private int accessVTable(int base, int offset) {
		if (base % 4 != 0 || offset < 0 || offset % 4 != 0) {
			throw new ExecuteException("bad vtable access base = " + base
					+ " offset = " + offset);
		}
		base /= 4;
		offset /= 4;
		if (offset >= vtable[base]) {
			throw new ExecuteException("vtable access base = " + base * 4
					+ " offset = " + offset * 4 + " out of bounds");
		}
		return vtable[base + offset + 1];
	}

	private Block checkHeapAccess(int base, int offset) {
		if (base < 0 || base % 4 != 0 || offset % 4 != 0) {
			throw new ExecuteException("bad memory access base = " + base
					+ " offset = " + offset);
		}
		base /= 4;
		offset /= 4;
		if (base >= currentSize) {
			throw new ExecuteException("memory access base = " + base * 4
					+ " out of bounds");
		}
		Block temp = new Block();
		temp.start = base;
		int index = Collections.binarySearch(heap, temp);
		Block block = index >= 0 ? heap.get(index) : heap.get(-index - 2);
		int accessIndex = base - block.start + offset;
		if (accessIndex < 0 || accessIndex >= block.mem.length) {
			throw new ExecuteException("memory access base = " + base * 4
					+ " offset = " + offset * 4 + " out of bounds");
		}
		return block;
	}

	public int load(int base, int offset) {
		if (base < 0) {
			return accessVTable(-base - 1, offset);
		} else {
			Block block = checkHeapAccess(base, offset);
			return block.mem[base / 4 - block.start + offset / 4];
		}
	}

	public void store(int val, int base, int offset) {
		Block block = checkHeapAccess(base, offset);
		block.mem[base / 4 - block.start + offset / 4] = val;
	}
}
