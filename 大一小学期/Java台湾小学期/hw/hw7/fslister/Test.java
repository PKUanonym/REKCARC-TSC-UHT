package fslister;

public class Test 
{
    public static void main(String[] args)
    {
        FSLister lister = new FSLister("/Users/liujiashuo/Desktop/java小学期");
        lister.showFileList("./result.txt");
    }
}