package fslister;
import java.io.*;
import java.util.*;

class FSLister 
{
    public String directory;
    public File f;
    PrintStream out;

    FSLister(String dir)
    {
        directory = dir;
    }

    public void showFileList(String filePath)
    {
        f = new File(filePath);
        
        try 
        {
            out = new PrintStream(f);
            solve(directory, 0);
        }
        catch(FileNotFoundException e)
        {
            System.out.println("打开文件错误");
        }
    }

    private void solve(String filePath, int num)
    {
        System.out.println(filePath);
        try 
        {
            File temp = new File(filePath);
            
            File[] subfiles = temp.listFiles();
        
            if (subfiles == null || subfiles.length == 0)
            {
                print(filePath, num,false);
                return;
            }
            else    
            {
                print(filePath, num, true);
                for (File file : subfiles)
                {
                    solve(file.getAbsolutePath(), num+4);
                }
            }

        }
        catch(NullPointerException e)
        {
            System.out.println("Error");
        }
        
        

    }

    private void print(String filename, int num, boolean judge)
    {
       
        for (int i = 0;i < num;i++)
            out.print(" ");
        String[] l = filename.split("/");
        out.print(l[l.length -1]);
        if (judge == true)
        {
            out.print(":\n");
        }
        else    
        {
            out.print("\n");
        }
                
       

    }
}