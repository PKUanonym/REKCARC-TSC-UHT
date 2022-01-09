package person;

class Person 
{
    void introduceSelf()
    {
        System.out.println("I am a person.");
    }
}

class Student extends Person 
{
    void introduceSelf()
    {
        System.out.println("I am a student.");
    }
}

class Employee extends Person 
{
    void introduceSelf()
    {
        System.out.println("I am an employee.");
    }
}

class Retired extends Person
{
    void introduceSelf()
    {
        System.out.println("I am a retired.");
    }
}
