package bank;

abstract class Bank 
{
    private double oneyearRate;
    private double oneyearNationaldebt;
    private double interestRate;
    public double money;

    Bank(double m)
    {
        oneyearRate = 0.0178;
        oneyearNationaldebt = 0.0198;
        interestRate = 0.0078;
        money = m;
    }

    public double getoneyearRate()
    {
        return oneyearRate;
    }
    public double getoneyearNationalDebt()
    {
        return oneyearNationaldebt;
    }
    public double getinterestRate()
    {
        return interestRate;
    }

    public abstract double count();
    public abstract void show();
}

class oneyearRateAccount extends Bank
{
    oneyearRateAccount(double n)
    {
        super(n);
    }

    public double count()
    {
        return money * (1 + getoneyearRate());
    }
    public void show() 
    {
        System.out.println("show()的结果，定期存款总金额为： "+count());
    }
}

class oneyearNationaldebtAccount extends Bank
{
    oneyearNationaldebtAccount(double n)
    {
        super(n);
    }

    public double count()
    {
        return money * (1+getoneyearNationalDebt());
    }
    public void show() 
    {
        System.out.println("show()的结果，国债总金额为： "+count());
    }
}

class interestAccount extends Bank
{
    interestAccount(double n)
    {
        super(n);
    }

    public double count()
    {
        return money * (1+getinterestRate());
    }
    public void show() 
    {
        System.out.println("show()的结果，活期存款总金额为： "+count());
    }
}



