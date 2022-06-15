package hugeinteger;

import java.util.*;
import java.io.*;

public class Test
{
    /*
    //   这是通过txt文件读入测试   java hugeinteger/Test < xxx.txt   txt文件每一行有三个数，第三个为正确答案
    public static void main(String[] args) throws IOException
    {
        //使用test.txt来输入进行测试
        Scanner console = new Scanner(System.in);
        for (int i = 0;i < 100;i++)
        {
            String x1 = console.next();
            String x2 = console.next();
            String x3 = console.next();
            //System.out.println(x1  +"  "+x2);
            HugeInteger a = new HugeInteger(x1);
            //a.output();
            HugeInteger b = new HugeInteger(x2);
            //b.output();
            HugeInteger c = a.sub(b);
            HugeInteger ans = new HugeInteger(x3);
            //c.output();
            System.out.println(c.isEqualTo(ans));
        }
    
        
    }*/
    
    public static void main(String[] args)
    {
        HugeInteger a = new HugeInteger("123443321");
        a.output();
        HugeInteger b = new HugeInteger("-909839289238");
        b.output();
        HugeInteger c = a.sub(b);
        c.output();
        HugeInteger d = a.add(b);
        d.output();
        System.out.println(a.isEqualTo(b));


    }
}