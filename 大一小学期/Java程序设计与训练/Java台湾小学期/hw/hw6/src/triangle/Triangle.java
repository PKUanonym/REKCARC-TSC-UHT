package triangle;


class NotTriangleException extends Exception
{
    public NotTriangleException() {}
}

public class Triangle 
{
    float x, y, z;
    Triangle(float x1, float x2, float x3)
    {
        x = x1;
        y = x2;
        z = x3;
    }

    public boolean judge()
    {
        if (x > 0 && y > 0 && z > 0 && x+y>z && x-y>-z && x-y<z)
            return true;
        else 
            return false;
    }
    public double getArea()
        throws NotTriangleException
    {
        if (!judge())
            throw new NotTriangleException();

        double area = 0.25 * Math.sqrt((x+y-z)*(x+z-y)*(y+z-x)*(x+y+z));
        return area;
    
    }

    public void showInfo()
        throws  NotTriangleException
    {
        if (!judge())
            throw new NotTriangleException();
        System.out.println("Triangle Info: x="+x+", y="+y+", z="+z);
    }

}