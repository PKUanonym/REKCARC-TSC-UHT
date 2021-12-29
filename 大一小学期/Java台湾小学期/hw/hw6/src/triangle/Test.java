package triangle;

public class Test 
{
    public static void main(String[] args)
    {
        Triangle t = new Triangle(3,4,5);
        try 
        {
            System.out.println("三角形面积为："+t.getArea());
            t.showInfo();
        }
        catch(NotTriangleException e)
        {
            System.out.println("不构成三角形！");
        }
    }
}