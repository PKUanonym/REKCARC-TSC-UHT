import java.io.*;  

public class Number
{
    public static void main(String[] args) throws IOException
    {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String str = reader.readLine();
        int n = Integer.parseInt(str);
        //System.out.println(n);
        if (judge(n))
            System.out.println("yes");
        else 
            System.out.println("no");


    }

    static boolean judge(int num)
    {
        int sum = 1;
        double n = Math.sqrt(num);
        for (int i = 2;i <= n;i++)
        {
            if (num % i == 0)
            {
                sum += i;
                if (num != i*i)
                    sum += num / i;
            }
        }

       // System.out.println(sum);
        if (sum == num)
            return true;
        else return false;
    }
}