package complex;

import java.util.*;

import java.io.*;

public class Complex
{
    public double realPart;
    public double imaginaryPart;
    Complex(double r, double i)
    {
        this.realPart = r;
        this.imaginaryPart = i;
    }

    public Complex add(Complex x)
    {
        Complex ans = new Complex(realPart + x.realPart, imaginaryPart + x.imaginaryPart);
        return ans;
    }

    public Complex sub(Complex x)
    {
        Complex ans = new Complex(realPart - x.realPart, imaginaryPart - x.imaginaryPart);
        return ans;
    }

    public void print()
    {
        if (this.imaginaryPart >= 0)
            System.out.println(realPart + "+" + imaginaryPart + "i");
        else 
            System.out.println(realPart + ""+imaginaryPart + "i");

    }
}
