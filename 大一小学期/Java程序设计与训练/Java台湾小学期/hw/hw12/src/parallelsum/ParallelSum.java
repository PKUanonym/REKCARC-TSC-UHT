package parallelsum;

import java.util.Random;

class Counter
{
    private int times = 0;
    Counter()
    {
        times = 0;
    }

    public void addTimes()
    {
        this.times += 1;
    }
    public int getTimes()
    {
        return this.times;
    }
}
class Data
{
    public int[] num;
    private Counter counter;
    private int[] ans;

    Data()
    {
        counter = new Counter();
        num = new int[300];
        ans = new int[3];
        Random r = new Random();
        for (int i = 0;i < 300;i++)
        {
            
            num[i] = r.nextInt(100)+1;
            //System.out.println(num[i]);
        }
        for (int i = 0;i < 3;i++)
            ans[i] = 0;
        
    }

    synchronized private void SynAns(int sign)
    {
        if (sign == 0)    //单个线程的100次加法完成
        {
            counter.addTimes();
            notify();
        }
        else
        {
            while(true)
            {
                synchronized(counter)
                {
                    try{
                        if (counter.getTimes() == 3)
                            break;
                        wait();
                        
                    }catch (Exception e)
                    {

                    }
                    
                }
                
            }
        }
    }

    public void add(int index)
    {
        int sum = 0;
        for (int i = index*100;i < index*100+100;i++)
        {
            sum += this.num[i];
        }
        this.ans[index] = sum;
        this.SynAns(0);    //完成一次唤醒一次查看计数
    }

    public int solve()
    {
        this.SynAns(1);
        int answer = 0;
        for (int i = 0;i < 3;i++)
            answer += ans[i];
        return answer;

    }
}


public class ParallelSum extends Thread 
{
    private int index;
    private Data data;

    ParallelSum(int index, Data data) 
    {
        this.index = index;
        this.data = data;
    }

    @Override
    public void run() 
    {
        data.add(index);
    }
}