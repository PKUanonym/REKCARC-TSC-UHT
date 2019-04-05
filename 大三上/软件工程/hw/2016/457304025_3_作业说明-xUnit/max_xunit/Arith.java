import java.lang.Math;

public class Arith { 
    public double decrease(double n1, double n2) { 
        return n1 - n2; 
    } 

	public double pow(double n1, double n2) { 
		return Math.pow(n1, n2);
    } 
    public static void main(String[] args){
    	Arith a = new Arith();
        double result = a.pow(-2, 0.5);
        boolean b=Double.isNaN(result);
    	System.out.println(b);
    }
}
