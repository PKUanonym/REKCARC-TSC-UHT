package decaf.tac;

public class Label {
	public int id;

	public String name;

	public boolean target;

	public Tac where;

	private static int labelCount = 0;

	public Label() {
	}

	public Label(int id, String name, boolean target) {
		this.id = id;
		this.name = name;
		this.target = target;
	}

	public static Label createLabel() {
		return createLabel(false);
	}

	public static Label createLabel(boolean target) {
		int id = labelCount++;
		return new Label(id, "_L" + id, target);
	}

	public static Label createLabel(String name, boolean target) {
		int id = labelCount++;
		return new Label(id, name, target);
	}

	@Override
	public String toString() {
		return name;
	}

}
