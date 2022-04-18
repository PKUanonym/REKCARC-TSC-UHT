package savingsaccount;
import java.util.*;
import java.io.*;

class SavingsAccount 
{
    private double savingsBalance;
    static double annualInterestRate;
    SavingsAccount(double money)
    {
        savingsBalance = money;
    }

    public double calculateMonthlyInterest()
    {
        double i = savingsBalance * annualInterestRate / 12.0;
        savingsBalance += i;
        return i;
    }

    public double getBalance()
    {
        return savingsBalance;
    }

    public static void modifyInterestRate(double h)
    {
        annualInterestRate = h;
    }

}