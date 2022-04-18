import java.io.*;

public class Lab7 {
 
    
    public static BufferedReader getKeyboard()  {
        
        return new BufferedReader(new InputStreamReader(System.in));
    }
    
    
    
 

    public static String readKeyboardLine() throws IOException {
        BufferedReader kyboard= getKeyboard();
        String line= kyboard.readLine();
        return line;
    }
    
 

    public static int readKeyboardInt() throws IOException {
        BufferedReader kyboard= getKeyboard();
        return 0;
    }
    
 

    public static double exp(double b, int c) {
        if (c == 0)
            return 1;
        
        if (c%2 == 0)
            return exp(b*b, c / 2);
        
        return b * exp(b, c-1);
    }
    
 

    public static int approach(double x) {
        int i= 1; 
        return i;
        
    }
}
