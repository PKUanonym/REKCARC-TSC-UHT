package decaf.backend;

import java.util.Set;

import decaf.tac.Temp;

public class MipsFrameManager {

	private int maxSize;

	private int currentSize;

	private int maxActualSize;

	private int currentActualSize;

	public int getStackFrameSize() {
		return maxSize + maxActualSize;
	}

	public void reset() {
		maxSize = currentSize = 0;
		maxActualSize = currentActualSize = 4;
		OffsetCounter.LOCAL_OFFSET_COUNTER.reset();
	}

	public void findSlot(Set<Temp> saves) {
		for (Temp temp : saves) {
			findSlot(temp);
		}
	}

	public void findSlot(Temp temp) {
		if (temp.isOffsetFixed()) {
			return;
		}
		temp.offset = OffsetCounter.LOCAL_OFFSET_COUNTER.next(temp.size);
		currentSize += temp.size;
		if (currentSize > maxSize) {
			maxSize = currentSize;
		}
	}

	public int addActual(Temp temp) {
		int offset = currentActualSize;
		currentActualSize += temp.size;
		return offset;
	}

	public void finishActual() {
		if (currentActualSize > maxActualSize) {
			maxActualSize = currentActualSize;
		}
		currentActualSize = 4;
	}

}
