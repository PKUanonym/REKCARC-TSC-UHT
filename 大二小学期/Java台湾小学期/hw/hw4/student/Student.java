package student;

import java.util.*;
import java.io.*;
class Student 
{
    public String name;
    public int age;
    public String degree;

    Student(String n, int a, String d)
    {
        name = n;
        age = a;
        degree = d;
    }

    void show()
    {
        System.out.println("Name: "+name+"\n"+"Age: "+age+"\n"+"Degree: "+degree);
    }
}

class Undergraduate extends Student
{
    private String speciality;
    Undergraduate(String n, int a, String d, String s) 
    {
        super(n, a, d);
        speciality = s;
    }

    void show()
    {
        System.out.println("Name: "+name+"\n"+"Age: "+age+"\n"+"Degree: "+degree+"\nSpeciality: "+speciality);
    }
}

class Graduate extends Student
{
    private String direction;
    Graduate(String n, int a, String d, String dir)
    {
        super(n,a,d);
        direction = dir;
    }
    void show()
    {
        System.out.println("Name: "+name+"\n"+"Age: "+age+"\n"+"Degree: "+degree+"\nDirection: "+direction);
    }
}
