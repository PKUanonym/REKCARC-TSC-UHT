package date;

import java.util.*;
import java.io.*;
class Date
{
    private String year;
    private String month;
    private String day;
    private int type;   //输出类型
    static String[] mmm = {" ", "January", "Febarary", "March", "April", "May", "June", "July", "August", "September"
                            , "October", "November", "December"};
    static int[] ddd = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    Date(int x, int y, int z)
    {
        year = ""+x;
        month = ""+y;
        day = ""+z;
        type = 3;
        if (!judge())
            System.out.println("Not Accepted! Illegal date!");
    }
    Date(String x1, String x2, String x3)
    {
        month = x1;
        day = x2;
        year = x3;
        type = 1;
        if (!judge())
            System.out.println("Not Accepted! Illegal date!");
    }

    Date(String x, int y, int z)
    {
        //year = x;
        day = ""+y;
        year = ""+z;
        type = 2;
        for (int i = 0;i <= 12;i++ )
            if (x == mmm[i])
            {
                month = ""+i;
                break;
            }
        if (!judge())
            System.out.println("Not Accepted! Illegal date!");
    }

    boolean judge()
    {
        char[] x = year.toCharArray();
        char[] y = month.toCharArray();
        char[] z = day.toCharArray();
        int yy = 0;
        int dd = 0;
        int mm = 0;
        for (int i = 0;i < year.length();i++)
            yy = yy*10 + x[i]-'0';
        for (int i = 0;i < month.length();i++)
            mm = mm*10 + y[i]-'0';
        for (int i = 0;i < day.length();i++)
            dd = dd*10 + z[i]-'0';
        if (!(dd >= 0 && dd <= 31 && mm >= 0 && mm <= 12))
            return false;
        else 
        {
            int bias = 0;
            if (yy % 400 == 0 ||(yy % 4 == 0 && yy % 100 != 0))
                bias = 1;
            ddd[2] = 28 + bias;
            if (dd > ddd[mm]) return false;
            return true;
        }
        
    }

    public void print()
    {
        char[] y = month.toCharArray();
        int num = 0;
        for (int i = 0;i < month.length();i++)
            num = num*10 + y[i]-'0';
        
        if (type == 1)
        {
            System.out.println(month+"/"+day+"/"+year);
        }
        else if (type == 2)
        {
            System.out.println(mmm[num]+" "+day+", "+year);
        }
        else if (type == 3)
        {
            System.out.println(year +"年"+month+"月"+day+"日");
        }
    }

    public int cal()
    {
        char[] x = year.toCharArray();
        char[] y = month.toCharArray();
        char[] z = day.toCharArray();
        int yy = 0;
        int dd = 0;
        int mm = 0;
        for (int i = 0;i < year.length();i++)
            yy = yy*10 + x[i]-'0';
        for (int i = 0;i < month.length();i++)
            mm = mm*10 + y[i]-'0';
        for (int i = 0;i < day.length();i++)
            dd = dd*10 + z[i]-'0';
        
        //System.out.println(yy+"  "+mm+"  "+dd);
        int sum = 0;
        for (int i = 1;i < yy;i++)
        {
            if (i % 400 == 0 ||(i % 4 == 0 && i % 100 != 0))
                sum += 366;
            else 
                sum += 365;
        }
        int bias = 0;
        if (yy % 400 == 0 ||(yy % 4 == 0 && yy % 100 != 0))
            bias = 1;
        ddd[2] = 28 + bias;
        for (int i = 1;i < mm;i++)
            sum += ddd[i];
        sum += dd;
        return sum;

    }

    public int dateDistance(Date n)
    {
        //System.out.println(this.cal());
        return this.cal() - n.cal();
    }
}