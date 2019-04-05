package writer;

import java.io.*;

public class Test   
{
    public static void main(String[] args)
    {
        File output = new File("./writer.txt");
        try  
        {
            PrintStream ps = new PrintStream(new FileOutputStream(output));
            Writer a = new Writer(ps);
            Thread b = new Thread(new Writer2(ps));
            a.start();
            b.start();


        }catch(FileNotFoundException e)
        {

        }
        
    }
    
}