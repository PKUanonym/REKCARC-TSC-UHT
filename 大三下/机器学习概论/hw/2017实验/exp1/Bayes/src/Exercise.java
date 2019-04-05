import java.lang.Math;
import java.util.Arrays;
import java.util.Collections;
/**
 * Created by steven on 2017/3/22.
 */

public class Exercise {
    public static void main(String[] args) {
        String[] aa = "39,State-gov,77516,Bachelors,13,Never-married,Adm-clerical,Not-in-family,White,Male,2174,0,40,United-States,<=50K.".split(",");
        //String[] aa = "aaa|bbb|ccc".split("\\|"); 这样才能得到正确的结果
        for (int i = 0 ; i <aa.length ; i++ ) {
            //System.out.println(aa[i]);
        }
        for(int i=1;i<=10;i++) {
            int a = (int) (1 + Math.random() * (10 - 1 + 1));
            //System.out.println(a);
        }
        double bb = Math.log10(0.002);
        //System.out.println(bb);
        //System.out.println(0/13);
        int age=Integer.parseInt("10");
        //System.out.println(age);
        Integer[] a = {4,23,43,12,-8,94,52};

        Arrays.sort(a, Collections.reverseOrder()); //数组排序

        for(int i=0;i<a.length;i++)

        { //System.out.print(a[i]+ " ");

        }
        int[] ai = {1,2,3,4,5};
        Variance(ai);
        //System.out.println(Variance(ai)[0]+" "+Variance(ai)[1]);


        for(int i=0;i<10;i++)

        {
            int ap = (int) (1 + Math.random() * 100);System.out.println(ap);

        }

    }

    public static double[] Variance(int[] x) {
        int m=x.length;
        double sum=0;
        for(int i=0;i<m;i++){//求和
            sum+=x[i];
        }
        double dAve=1.0*sum/m;//求平均值
        double dVar=0;
        for(int i=0;i<m;i++){//求方差
            dVar+=(x[i]-dAve)*(x[i]-dAve);
        }
        double[] d ={dAve,dVar};
        return d;
    }
}
