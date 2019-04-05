package matrixcalculator;

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
class Matrix 
{
    public double[][] matrix1;
    public double[][] matrix2;
    public double[][] answer;
    public double[][][] ans;
    private Counter counter;

    Matrix()
    {
        counter = new Counter();
        Random r = new Random();
        matrix1 = new double[1000][1000];
        matrix2 = new double[1000][1000];
        ans = new double[4][250][1000];
        answer = new double[1000][1000];
        for (int i =0;i < 1000;i++)
            for (int j = 0;j < 1000;j++)
            {
                double temp = r.nextDouble()*100 + 1;
                matrix1[i][j] = temp;
                temp = r.nextDouble()*100 + 1;
                matrix2[i][j] = temp;
            }
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
                        if (counter.getTimes() == 4)
                            break;
                        wait();
                        
                    }catch (Exception e)
                    {

                    }
                    
                }
                
            }
        }
    }

    public void multiply(int index)
    {
        for (int i = index*250;i < index*250+250;i++)
            for (int j = 0;j < 1000;j++)
            {
                double temp = 0.0;
                for (int k = 0;k < 1000;k++)
                {
                    temp += matrix1[i][k] * matrix2[k][j];
                }
                ans[index][i-index*250][j] = temp;
            }
        
        SynAns(0);
    } 

    public void multiplyAll()
    {
        this.SynAns(1);
        for (int i = 0;i < 1000;i++)
        {
            answer[i] = ans[i/250][i%250];
        }
    }
}


public class MatrixCalculator extends Thread 
{
    private int index;
    private Matrix data;

    MatrixCalculator(int index, Matrix data) 
    {
        this.index = index;
        this.data = data;
    }

    @Override
    public void run() 
    {
        data.multiply(index);
    }
}