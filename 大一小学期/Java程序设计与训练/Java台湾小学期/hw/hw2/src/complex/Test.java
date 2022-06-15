package complex;

public class Test 
{
    public static void main(String[] args)
    {
        Complex a = new Complex(1.1, 2.2);
        Complex b = new Complex(2.3, 5.7);
        Complex c = a.add(b);
        Complex d = a.sub(b);
        c.print();
        d.print();
    }
}