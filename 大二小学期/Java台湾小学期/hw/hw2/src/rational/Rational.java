package rational;

import java.util.*;
import java.io.*;

public class Rational
{
    int upper;
    int lower;
    
    Rational(int x, int y)
    {
        if (y == 0)
            System.out.println("Error");
        int ggg = 0;
        if (x == 0)
            ggg = y;
        else if (x >= y)
            ggg = gcd(x, y);
        else
            ggg = gcd(y, x);

        upper = x / ggg;
        lower = y / ggg;
    }

    public int gcd(int x, int y)
    {
        if (x < 0)
            x = -x;
        if (y < 0)
            y = -y;
        if (x % y == 0)
            return y;
        else return gcd(y, x % y);
    }

    public Rational add(Rational x)
    {
        Rational ans = new Rational(upper * x.lower + lower * x.upper, lower * x.lower);
        return ans;
    }
    public Rational sub(Rational x)
    {
        Rational ans = new Rational(upper * x.lower - lower * x.upper, lower * x.lower);
        return ans;
    }
    public Rational mul(Rational x)
    {
        Rational ans = new Rational(upper * x.upper, lower * x.lower);
        return ans;
    }

    public Rational div(Rational x)
    {
        Rational ans = new Rational(upper * x.lower, lower * x.upper);
        return ans;
    }

    public void printRational()
    {
        if (lower == 0)
        {
            System.out.println("Error");
            return;
        }
        if (lower != 1 && lower != -1)
            System.out.println(upper + "/" + lower);
        else if (lower == 1)
            System.out.println(upper);
        else if (lower == -1)
            System.out.println((-upper));

    }
   
    public void printReal()
    {
        double u = upper;
        double l = lower;
        if (l == 0)
        {
            System.out.println("Error");
            return;
        }
        double ans = u / l;
        System.out.println(ans);

    }
}
