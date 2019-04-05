package decaf.symbol;

import java.util.Comparator;

import decaf.Location;
import decaf.scope.Scope;
import decaf.type.Type;

public abstract class Symbol {
	protected String name;

	protected Scope definedIn;

	protected Type type;

	protected int order;

	protected Location location;

	public static final Comparator<Symbol> LOCATION_COMPARATOR = new Comparator<Symbol>() {

		@Override
		public int compare(Symbol o1, Symbol o2) {
			return o1.location.compareTo(o2.location);
		}

	};

	public static final Comparator<Symbol> ORDER_COMPARATOR = new Comparator<Symbol>() {

		@Override
		public int compare(Symbol o1, Symbol o2) {
			return o1.order > o2.order ? 1 : o1.order == o2.order ? 0 : -1;
		}

	};

	public Scope getScope() {
		return definedIn;
	}

	public void setScope(Scope definedIn) {
		this.definedIn = definedIn;
	}

	public int getOrder() {
		return order;
	}

	public void setOrder(int order) {
		this.order = order;
	}

	public Location getLocation() {
		return location;
	}

	public void setLocation(Location location) {
		this.location = location;
	}

	public Type getType() {
		return type;
	}

	public String getName() {
		return name;
	}

	public abstract boolean isVariable();

	public abstract boolean isClass();

	public abstract boolean isFunction();

	public abstract String toString();
}
