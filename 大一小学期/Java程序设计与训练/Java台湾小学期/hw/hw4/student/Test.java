package student;

import java.util.*;
import java.io.*;
public class Test 
{
    public static void main(String[] args)
    {
        Undergraduate liu = new Undergraduate("liu", 22, "Master", "Computer Science");
        Graduate shuo = new Graduate("shuo", 22, "Doctor", "Computer Science");

        liu.show();
        shuo.show();
    }
}

