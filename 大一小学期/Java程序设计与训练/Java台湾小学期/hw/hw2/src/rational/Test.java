package rational;

import java.util.*;
import java.io.*;

public class Test
{
    public static void main(String[] args)
    {
        Rational x1 = new Rational(2, 1);
        System.out.println("x1 = ");
        x1.printRational();
        //System.out.println(x1.upper + " "+x1.lower);
        Rational x2 = new Rational(-3, 5);
        System.out.println("x2 = ");
        x2.printRational();

        Rational y1 = x1.add(x2);
        System.out.println("x1+x2 = ");
        y1.printRational();
        y1.printReal();

        y1 = x1.mul(x2);
        System.out.println("x1*x2 = ");
        y1.printRational();
        y1.printReal();

        y1 = x1.sub(x2);
        System.out.println("x1-x2 = ");
        y1.printRational();
        y1.printReal();

        y1 = x1.div(x2);
        System.out.println("x1/x2 = ");
        y1.printRational();
        y1.printReal();

    }
}