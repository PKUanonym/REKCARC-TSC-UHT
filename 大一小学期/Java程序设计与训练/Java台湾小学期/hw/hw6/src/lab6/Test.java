package lab6;

import java.io.IOException;

public class Test 
{
    public static void main(String[] args)
    {
        Lab scanner = new Lab();
        try 
        {
            int input = scanner.readKeyboardInt();
            System.out.println("INput is "+input);
            double ans = scanner.exp(5,3);
            System.out.println("EXP answer is "+ ans);
            int ans2 = scanner.approach(0.7);
            System.out.println("Approach answer is "+ ans2);

        }
        catch(IOException e)
        {
            System.out.println("IO Exception");
        }
        catch(MyException e)
        {
            System.out.println(e.getMessage());
        }
        
    }
}