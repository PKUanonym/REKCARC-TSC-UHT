import java.util.*;
import java.io.*;

public class Exchange
{
    public static void main(String[] args) throws IOException
    {
        
        Scanner console = new Scanner(System.in);
        int n = console.nextInt();
        for (int i = 0;i < n;i++)
        {
            String num = console.next();
            //System.out.println(num);
            String ans = change(num);
            
            char[] a = ans.toCharArray();
            String ans2 = "";
            boolean flag = false;
            for (int j = 0;j < ans.length();j++)
            {
                if (!flag && a[j] != '0')
                    flag = true;
                if (flag)
                    ans2 += a[j];
                    
                
            }

            System.out.println(ans2);
        }
    }

    public static String change(String x)
    {
        char[] num = x.toCharArray();
        String sum = "";
        int length = x.length();
        for (int i = 0;i < length; i++)
        {
            if (num[i] == 'A' || num[i] == 'B' || num[i] == 'C' || num[i] == 'D' || num[i] == 'E')
                sum += sixteenTo2(num[i] - 'A' + 10);
            else 
                sum += sixteenTo2(num[i] - '0');
            //System.out.println(num[i] + " "+ sum);
        }

        //System.out.println(sum);

        length = sum.length();
        if (length % 3 == 1)
            sum = "00" + sum;
        else if (length % 3 == 2)
            sum = "0" + sum;
        
        length = sum.length();
        char[] xx = sum.toCharArray();
        String ans = "";
        for (int i = 0;i < length;i = i+3)
        {
            String part = "";
            part = part + xx[i] + xx[i+1] + xx[i+2];
            ans = ans + twoTo16(part);
        }


        return ans;
    }

    public static String sixteenTo2(int x)
    {
        String ans = "";
        int x1 = x / 4;
        if (x1 == 3)
            ans += "11";
        else if (x1 == 2)
            ans += "10";
        else if (x1 == 1)
            ans += "01";
        else ans += "00";
        int x2 = x % 4;
        if (x2 == 3)
            ans += "11";
        else if (x2 == 2)
            ans += "10";
        else if (x2 == 1)
            ans += "01";
        else ans += "00";

        return ans;
    }

    public static int twoTo16(String x)
    {
        char[] num = x.toCharArray();
        int sum = 0;
        for (int i = 0;i < x.length();i++)
            sum = sum * 2 + num[i]-'0';
        return sum;
    }
}