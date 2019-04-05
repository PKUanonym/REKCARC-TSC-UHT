package bank;

public class Test 
{
    public static void main(String[] args)
    {
        oneyearRateAccount a = new oneyearRateAccount(10000.0);
        oneyearNationaldebtAccount b = new oneyearNationaldebtAccount(10000.0);
        interestAccount c = new interestAccount(10000.0);
        System.out.println("一年的定期存款本金为10000.0， 一年后count()的结果为："+a.count());
        System.out.println("一年的国债本金为10000.0， 一年后count()的结果为："+b.count());
        System.out.println("一年的活期存款本金为10000.0， 一年后count()的结果为："+c.count());

        a.show();
        b.show();
        c.show();

    }
}