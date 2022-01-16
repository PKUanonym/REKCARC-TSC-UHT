public abstract class Com
{
	public abstract int getNumber();
	public abstract void star(int number, int userId);

	public static Com getInstance()
	{
		return Main.C.com;
	}
}
