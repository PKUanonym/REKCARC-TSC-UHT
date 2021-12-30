package savingsaccount;

public class Test 
{
    public static void main(String[] args)
    {
        SavingsAccount saver1 = new SavingsAccount(2000.0);
        SavingsAccount saver2 = new SavingsAccount(3000.0);
        saver2.modifyInterestRate(0.04);
        System.out.println("Saver1 monthly interest is "+saver1.calculateMonthlyInterest());
        System.out.println("Saver1 saving balance is "+saver1.getBalance());
        System.out.println("Saver2 monthly interest is "+saver2.calculateMonthlyInterest());
        System.out.println("Saver2 saving balance is "+saver2.getBalance());

        saver2.modifyInterestRate(0.05);
        System.out.println("Saver1 monthly interest is "+saver1.calculateMonthlyInterest());
        System.out.println("Saver1 saving balance is "+saver1.getBalance());
        System.out.println("Saver2 monthly interest is "+saver2.calculateMonthlyInterest());
        System.out.println("Saver2 saving balance is "+saver2.getBalance());

    }
}