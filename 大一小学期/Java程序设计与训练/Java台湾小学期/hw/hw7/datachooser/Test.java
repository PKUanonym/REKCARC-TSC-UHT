package datachooser;

public class Test 
{
    public static void main(String[] args)
    {
        //Data d = new Data("2011:08:03:00:00:26:375: C1  1023 60001  1372  3093  6622     4     4  1372  1388  1312  1182     0     0     0     0     0     0");
        //d.show();
        DataChooser solver = new DataChooser("./data.txt");
        solver.solve("./newFile.txt");
    }
}