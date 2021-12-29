package role;

class Role 
{
    private String name;
    private String sex;
    private int age;
    Role(String n, String s, int a)
    {
        name = n;
        sex = s;
        age = a;
    }

    public String Getname()
    {
        return name;
    }
    public String Getsex()
    {
        return sex;
    }
    public int Getage()
    {
        return age;
    }

    public void Setname(String n)
    {
        name = n;
    }
    public void Setage(int n)
    {
        age = n;
    }
    public void Setsex(String n)
    {
        sex = n;
    }

    public void showInfo()
    {
        System.out.println("Name: "+name+"\nSex: "+sex+"\nAge: "+age);
    }



}

class Employee extends Role
{
    private double salary;
    Employee(String n, String s, int a, double sa)
    {
        super(n,s,a);
        salary = sa;
    }

    public double Getsalary()
    {
        return salary;
    }
    public void Setsalary(double n)
    {
        salary = n;
    }

    public void showEmployeeInfo()
    {
        showInfo();
        System.out.println("Salary: "+salary);
    }

}

class Manager extends Employee
{
    private String position;
    private int teamSize;
    Manager(String n, String s, int a, double sa, String p, int t)
    {
        super(n,s,a,sa);
        position = p;
        teamSize = t;
    }

    public String Getposition()
    {
        return position;
    }
    public int GetteamSize()
    {
        return teamSize;
    }
    public void Setposition(String p)
    {
        position = p;
    }
    public void SetteamSize(int t)
    {
        teamSize = t;
    }

    public void showManagerInfo()
    {
        showEmployeeInfo();
        System.out.println("Position: "+position + "\nTeam Size: "+teamSize);
    }
}