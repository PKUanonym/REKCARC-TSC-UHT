package shape;

interface Shape 
{
    public double PI = 3.14;
    public double getArea();
}

class Circle implements Shape
{
    double r;
    Circle(double n)
    {
        r = n;
    }
    public double getArea()
    {
        return PI*r*r;
    }
}

class Square 
{
    double a;
    Square(double n)
    {
        a = n;
    }
    public double getArea()
    {
        return a*a;
    }
}

