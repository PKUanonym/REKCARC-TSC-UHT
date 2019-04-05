package decaf.tacvm;

public class Location implements Comparable<Location> {

	private int line;

	private int column;

	public Location(int lin, int col) {
		line = lin;
		column = col;
	}

	public int getLine() {
		return line;
	}

	public int getColumn() {
		return column;
	}

	public String toString() {
		return "(" + line + "," + column + ")";
	}

	@Override
	public int compareTo(Location o) {
		if (line > o.line) {
			return 1;
		}
		if (line < o.line) {
			return -1;
		}
		if (column > o.column) {
			return 1;
		}
		if (column < o.column) {
			return -1;
		}
		return 0;
	}
}
