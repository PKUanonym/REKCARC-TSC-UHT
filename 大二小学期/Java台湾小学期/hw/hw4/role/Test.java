package role;

public class Test
{
    public static void main(String[] args)
    {
        Employee e = new Employee("Jack", "M", 23, 3500);
        e.showEmployeeInfo();
        Manager m = new Manager("Lee", "FM", 25, 5000, "Boss", 20);
        m.showManagerInfo();
    }
}