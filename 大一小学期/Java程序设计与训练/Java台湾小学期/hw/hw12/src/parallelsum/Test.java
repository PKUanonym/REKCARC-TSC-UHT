package parallelsum;

class Test
{
    public static void main(String[] args)
    {
        Data data = new Data();
        ParallelSum sum1 = new ParallelSum(0, data);
        ParallelSum sum2 = new ParallelSum(1, data);
        ParallelSum sum3 = new ParallelSum(2, data);
        sum1.start();
        sum2.start();
        sum3.start();

        System.out.println(data.solve());

        int ans = 0;
        for (int i = 0;i < 300;i++)
            ans += data.num[i];
        
        System.out.println("单线程的答案是： "+ans);

    }
}