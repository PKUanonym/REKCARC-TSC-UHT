package hashmap;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Scanner;
import java.util.*;

class Encryption
{
    HashMap<String, String> map = new HashMap<String, String>();
    Encryption()
    {
        map.put("a", "v");
        map.put("b", "e");
        map.put("c", "k");
        map.put("d", "n");
        map.put("e", "o");
        map.put("f", "h");
        map.put("g", "z");
        map.put("h", "f");
        map.put("i", " ");
        map.put("j", "i");
        map.put("k", "l");
        map.put("l", "j");
        map.put("m", "x");
        map.put("n", "d");
        map.put("o", "m");
        map.put("p", "y");
        map.put("q", "g");
        map.put("r", "b");
        map.put("s", "r");
        map.put("t", "c");
        map.put("u", "s");
        map.put("v", "w");
        map.put("w", "q");
        map.put("x", "u");
        map.put("y", "p");
        map.put("z", "t");
        map.put(" ", "a");



    }

    public void solve()   //注：我不太明确“从命令行输入数据”是什么意思，现在代码每输入一行便会输出该行对应的结果，最后会将所有输入的结果一起再输出来一次
    {
        ArrayList<String> result = new ArrayList<String>();
        Scanner sc = new Scanner(System.in);
        while(sc.hasNextLine())
        {
            String str = sc.nextLine().toLowerCase();
            String r = "";
            for(int i=0;i<str.length();i++)
            {
                String subStr = str.substring(i, i+1);
                r = r + map.get(subStr);

            }
            result.add(r);
            System.out.println(r);
            
        }

        Iterator<String> iter = result.iterator();
        while(iter.hasNext())
        {
            String temp = iter.next();
            System.out.print(temp);
        }
    }
}