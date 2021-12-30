package arraylist;

import java.util.Iterator;
import java.util.Random;
import java.util.*;


class NumArrayList 
{
    ArrayList<Integer> data = new ArrayList<Integer> ();
    NumArrayList()
    {
        Random r = new Random();
        for (int i = 0;i < 20;i++)
        {
            int temp = r.nextInt(1000)+1;   //我理解“1到1000”为【1，1000】
            data.add(temp);
            System.out.println(temp);
        }
        System.out.println("这是生成的数组");
    }

    public void solve()
    {
        Iterator<Integer> iter = data.iterator();
        while(iter.hasNext())
        {
            Integer temp = iter.next();
            if (temp > 500)
                iter.remove();
        }

        Iterator<Integer> iter2 = data.iterator();
        while(iter2.hasNext())
        {
            Integer temp = iter2.next();
            System.out.println(temp);
        }

        System.out.println("这是处理之后的数组");
    }
}