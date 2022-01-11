package person;

class Test 
{
    public static void func(Person h)
    {
        h.introduceSelf();
    }
    public static void main(String[] args)
    {
        System.out.println("单个对象的测试：");
        Person p = new Person();
        Student s = new Student();
        Employee e = new Employee();
        Retired r = new Retired();
        p.introduceSelf();
        s.introduceSelf();
        e.introduceSelf();
        r.introduceSelf();

        System.out.println("父类引用子类对象的测试：");
        Person p1 = new Student();
        p1.introduceSelf();
        Person p2 = new Employee();
        p2.introduceSelf();

        System.out.println("数组化的测试：");
        Person[] arr = new Person[3];
        arr[0] = new Student();
        arr[1] = new Employee();
        arr[2] = new Retired();
        for (int i = 0;i < 3;i++)
        {
            arr[i].introduceSelf();
        }

        System.out.println("函数参数化的测试：");
        Person per = new Student();
        func(per);
        Student student = new Student();
        func(student);


    }
}