package treeset;

import java.util.Random;
import java.util.*;

class NumTreeSet
{
    Set<Integer> data = new TreeSet<Integer>();
    NumTreeSet()
    {
        Random r = new Random();
        for (int i = 0;i < 80;i++)
        {
            int temp = r.nextInt(100)+1;   //我理解“1到100”为【1，100】
            data.add(temp);
        }
    }
    public void solve()
    {
        int sum = 0;
        Iterator iter = data.iterator();
        while(iter.hasNext())
        {
            System.out.print(iter.next() + "\t");
            sum += 1;
        }

        System.out.println("元素个数："+sum);
			

    }
}