public class Minmax { 
    public double get_max(double a, double b, double c) {
		if (a > b) {
		    if (a > c)
		        return a;
		    return c;
		}
		else {
		    if (b > c)
		        return b;
		    return c;
		}
	}
}
