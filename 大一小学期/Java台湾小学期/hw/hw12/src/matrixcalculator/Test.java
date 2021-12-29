package matrixcalculator;

public class Test
{
    public static void main(String[] args)
    {
        Matrix data = new Matrix();
        double [][] answer2 = new double[1000][1000];



        long starttime2 = System.currentTimeMillis();
        for (int i = 0;i < 1000;i++)
            for (int j = 0;j < 1000;j++)
                {
                    double temp = 0.0;
                    for (int k = 0;k < 1000;k++)
                        temp += data.matrix1[i][k]*data.matrix2[k][j];
                    answer2[i][j] = temp;
                }

        long endtime2 = System.currentTimeMillis();
        System.out.println("单线程花费时间： "+(endtime2-starttime2));

        long starttime=System.currentTimeMillis();
        MatrixCalculator sum1 = new MatrixCalculator(0, data);
        MatrixCalculator sum2 = new MatrixCalculator(1, data);
        MatrixCalculator sum3 = new MatrixCalculator(2, data);
        MatrixCalculator sum4 = new MatrixCalculator(3, data);
        sum1.start();
        sum2.start();
        sum3.start();
        sum4.start();
        
        data.multiplyAll();
        long endtime = System.currentTimeMillis();
        System.out.println("多线程花费时间： "+(endtime-starttime));

        

        boolean judge = true;
        for (int i = 0;i < 1000;i++)
            for (int j = 0;j < 1000;j++)
                if (answer2[i][j] != data.answer[i][j])
                {
                    judge = false;
                    break;
                }
        if (judge)
                System.out.println("一样");
        else System.out.println("不一样");
    }
}