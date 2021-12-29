package commentdeleter;

import java.io.*;
import java.util.*;

class CommentDeleter 
{
    String oldfile;
    CommentDeleter(String s)
    {
        oldfile = s;
    }

    public void solver(String newfile)
    {
        File old = new File(oldfile);
        try 
        {
            Scanner solve = new Scanner(old);
            try 
            {
                PrintStream out = new PrintStream(new File(newfile));
                boolean judge = false;
                while (solve.hasNextLine())
                {
                    String temp = solve.nextLine();

                    if (judge == false)   //find /* only
                    {
                        int index = temp.indexOf("/*");
                        if (index == -1)
                        {
                            out.println(temp.split("//")[0]);
                        }
                        else      
                        {
                            int index2 = temp.indexOf("//");
                            if (index2 == -1 || (index2 != -1 && index > index))
                            {
                                out.println(temp.split("/*")[0]);
                                judge = true;
                            }
                            else      
                            {
                                out.println(temp.split("//")[0]);
                            }
                            
                        }
                    }
                    else        
                    {
                        int index = temp.indexOf("*/");
                        if (index == -1)
                        {
                            continue;
                        }
                        else    
                        {
                            out.println(temp.substring(index+2).split("//")[0]);
                            judge = false;
                        }
                    }

                }
            }
            catch (FileNotFoundException e)
            {
                System.out.println("输出文件不存在！");
            }
        }
        catch (FileNotFoundException e)
        {
            System.out.println("要处理的文件不存在或者路径不对");
        }
    }
}