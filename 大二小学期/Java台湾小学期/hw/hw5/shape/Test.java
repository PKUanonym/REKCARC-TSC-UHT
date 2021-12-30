package shape;

public class Test 
{
    public static void main(String[] args)
    {
        Circle c = new Circle(5);
        System.out.println("Circle : "+ c.getArea());
        Square f = new Square(5);
        System.out.println("Square : "+ f.getArea());

    }
}