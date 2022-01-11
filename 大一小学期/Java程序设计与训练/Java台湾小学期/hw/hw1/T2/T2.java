import java.io.*;  

public class Clock
{
    public static void main(String[] args) throws IOException
    {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String str = reader.readLine();
        int t = Integer.parseInt(str);
        //System.out.println(t);
        int hour = t / 3600;
        t = t % 3600;
        int min = t / 60;
        int sec = t % 60;
        System.out.println(hour + ":"+min + ":"+sec);
    }
}