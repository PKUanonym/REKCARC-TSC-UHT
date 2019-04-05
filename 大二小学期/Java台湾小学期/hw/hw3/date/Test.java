package date;
import java.util.*;
import java.io.*;

public class Test
{
    public static void main(String[] args)
    {
        Date one = new Date(1998, 3, 24);
        Date two = new Date("7", "4", "2018");
        Date three = new Date("April", 4, 1997);
        one.print();
        two.print();
        three.print();
        System.out.println(one.dateDistance(three));
    }
}