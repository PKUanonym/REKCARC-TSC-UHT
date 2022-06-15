package datachooser;

import java.io.*;
import java.util.*;

class Data implements Comparable<Data>
{
    public String data;
    int num;
    Data(String input)
    {
        data = input;
        Scanner solver = new Scanner(input);
        String temp;
        for (int i = 0;i < 4;i++)
        {
            if (solver.hasNext())
                temp = solver.next();
        }
        if (solver.hasNextInt())
            num = solver.nextInt();
    }

    public void show()
    {
        System.out.println(data);
        System.out.println(num);
    }

    public int compareTo(Data o) 
    {              //利用编号实现对象间的比较  
        if (num > o.num) 
        {  
            return 1;  
        } 
        else if (num < o.num) 
        {  
            return -1;  
        }  
        return 0;  
    } 
    
}

class DataChooser 
{
    String file;
    DataChooser(String filepath)
    {
        file = filepath;
    }

    public void solve(String newfile)
    {
        List<Data> list = new ArrayList<Data>();  
        try 
        {
            Scanner input = new Scanner(new File(this.file));
            int sum =0;
            while(input.hasNextLine())
            {
                String temp = input.nextLine();
                list.add(new Data(temp));
                sum += 1;
            }
            Collections.sort(list);
            for (Data e:list)
            {
                System.out.println(e.num);
                break;
            }
            File f = new File(newfile);
            try 
            {
                PrintStream out = new PrintStream(f);
                for (Data e: list)
                {
                    out.println(e.data);
                }
            }
            catch(FileNotFoundException e)
            {
                System.out.println("输出文件不存在！");
            }

        }
        catch (FileNotFoundException e)
        {
            System.out.println("输入文件不存在！");
        }
        
    }
}