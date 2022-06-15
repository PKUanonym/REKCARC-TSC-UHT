package writer;

import java.io.*;

public class Test   
{
    public static void main(String[] args)
    {
        File output = new File("./writer8.txt");
        try  
        {
            PrintStream ps = new PrintStream(new FileOutputStream(output));
            Writer a = new Writer(ps);
            Thread b = new Thread(new Writer2(ps));
            //a.setPriority(5);
            b.setPriority(8);
            a.start();
            b.start();

        }catch(FileNotFoundException e)
        {

        }
        
    }
    
}