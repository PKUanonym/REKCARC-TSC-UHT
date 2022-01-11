package lab6;
import java.io.*;

class MyException extends Exception
{
    MyException() {}
    MyException(String mess)
    {
        super(mess);
    }
}

public class Lab {
    /**   A buffered reader attached to the keyboard. If you store this value
      *   in a variable kbd (say), then
      * 
      *      kbd.readLine()
      * 
      *   will prompt the reader to type a line by putting in the Interactions pane
      *   a field into which to type and will then yield the string of characters
      *   the user typed in.
      */    
    public static BufferedReader getKeyboard()  {
        // Create a link to the keyboard
        return new BufferedReader(new InputStreamReader(System.in));
    }
    
    
    
    /** Prompt the reader to type a line into the interactions pane and
      * return the line that the user types. */
    public static String readKeyboardLine() throws IOException {
        BufferedReader kyboard= getKeyboard();
        String line= kyboard.readLine();
        return line;
    }
    
    /** Prompt the reader to type an integer (an int) into the interactions pane
      * and return the integer that they type. If the user types something that
      * is not an int, then issue a message (System.out.println(...) and prompts
      * again.
      */
    public static int readKeyboardInt() throws IOException {
        BufferedReader kyboard= getKeyboard();
        while (true)
        {
            String line = kyboard.readLine();
            try 
            {
                int ans = Integer.parseInt(line);
                return ans;
            }
            catch(NumberFormatException e)
            {
                System.out.println("您的输入不是整数，请重新输入");
            }
        }
        //return 0;
    }
    
    /** = b**c.
          Precondition: c ?0
        */
    public static double exp(double b, int c) 
        throws MyException
    {
        if (c < 0)
        {
            //System.out.println("c<0");
            throw new MyException("c<0");
        }
        if (c == 0)
            return 1;
        // c > 0
        
        if (c%2 == 0)
            return exp(b*b, c / 2);
            // c is odd and > 0
        return b * exp(b, c-1);
    }
    
    /**   The value i such that x**i <= .00000001 but x**(i-1) is not.
          Throw MyException if x <= 0 or 1 <= x. 
       */
    public static int approach(double x) 
    throws MyException
    {
        int i= 1; // stub; you have to complete this function
        if (x <= 0)
            throw new MyException("x <= 0");
        else if (x >= 1)
            throw new MyException("x >= 1");
        
        double ans = 1;  
        for (i = 1;;i++)
        {
            ans = ans * x;
            if (ans < 0.1)
                break;
        }
        return i;
        
    }
}
