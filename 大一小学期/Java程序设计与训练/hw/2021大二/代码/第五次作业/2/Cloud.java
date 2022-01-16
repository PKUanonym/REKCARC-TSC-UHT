import java.util.Random;

abstract class Cloud
{
	static Random r = new Random(System.currentTimeMillis());
	private static final int key = r.nextInt();
	static volatile int data;

	public static int getKey()
	{
		return key;
	}
	public synchronized static int getData()
	{
		return data;
	}
	public synchronized static void setData(final int data)
	{
		Cloud.data = data;
		Cloud.class.notify();
	}
	static boolean test(final int v)
	{
		return (v ^ key) == data;
	}
}
