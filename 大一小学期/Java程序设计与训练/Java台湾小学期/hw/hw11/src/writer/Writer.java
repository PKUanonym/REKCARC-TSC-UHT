package writer;

import java.io.PrintStream;

class Writer extends Thread
{
    PrintStream out;
    Writer(PrintStream f)
    {
        out = f;
    }
    @Override
    public void run()
    {
        for (int i = 0;i < 1000;i++)
        {
            System.out.println("线程1   "+i);
            out.println("线程1   "+i);
            try   
            {
                Thread.sleep(10);;
                
            }
            catch (InterruptedException e)
            {

            }
            
        }
            
    }
}

class Writer2 implements Runnable
{
    PrintStream out;
    Writer2(PrintStream f)
    {
        out = f;
    }
    public void run()
    {
        for (int i = 0;i < 1000;i++)
        {
            System.out.println("线程2   "+i);
            out.println("线程2   "+i);
            try   
            {
                Thread.sleep(10);
                
            }
            catch (InterruptedException e)
            {
                
            }
        }
            
    }
}