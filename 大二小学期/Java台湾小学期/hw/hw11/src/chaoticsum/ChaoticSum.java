package chaoticsum;

import java.util.*;
import java.io.*;
class ChaoticSum extends Thread  
{
    static int sum = 0;
    public static void main(String[] args)
    {
        //int sum = 0;
        
        Thread a = new Thread()
        {
			@Override
            public void run()
            {
                int t = 0;
                for (int j = 0;j < 20;j++)
                {
                    System.out.println("子线程");
                    t = sum;
                    t += 1;
                    try{
                        Thread.sleep(1);
                    }catch(InterruptedException e)
                    {

                    }
                    
                    sum = t;
                }
            }
        };
        a.start();
			

        for (int i = 0;i < 20;i++)
        {
            System.out.println("主线程");
            sum += 1;
            try    
            {
                Thread.sleep(1);
            }catch(InterruptedException e)
            {

            }
        }
        System.out.println("Sum= "+ sum);

    }

    
}