import java.io.*;
import java.util.*;

public class Cal 
{
    public static void main(String[] args) 
    {
        Scanner console = new Scanner(System.in);
        int x = console.nextInt();
        int y = console.nextInt();
        int z = console.nextInt();
        //System.out.println(x + " "+y+" "+z);
        int ans = 0;
        int ggg = 0;
        if (z == 1)
            ans = x + y;
        else if (z == 2)
            ans = x - y;
        else if (z == 3)
            ans = x * y;
        else if (z == 4)
            ans = x / y;
        else if (z == 5)
            ans = x % y;
        else if (z == 6)
        {
            if (x > y)
                ggg = gcd(x, y);
            else ggg = gcd(y, x);
            ans = ggg;
        }
        else if (z == 7)
        {
            if (x > y)
                ggg = gcd(x, y);
            else ggg = gcd(y, x);
            ans = (x * y) / ggg;
        }
           
        System.out.println(ans);

    }

    public static int gcd(int x ,int y)
    {
        if (x % y == 0)
            return y;
        else 
            return gcd(y, x % y);
    }
}