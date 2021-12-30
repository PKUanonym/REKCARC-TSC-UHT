package vehicles;

class Vehicles 
{
    public String brand;
    public String color;

    Vehicles(String b, String c)
    {
        brand = b;
        color = c;
    }
    void run()
    {
        System.out.println("我已经开动了！");
    }
    void showInfo()
    {
        System.out.println("Brand: "+brand+"\nColor: "+color);
    }
}

class Car extends Vehicles
{
    public int seat;
    Car(String b, String c, int s)
    {
        super(b,c);
        seat = s;
    }
    void showCar()
    {
        System.out.println("Brand: "+brand+"\nColor: "+color+"\nSeats: "+seat);
    }
}

class Truck extends Vehicles
{
    public float load;
    Truck(String b, String c, float s)
    {
        super(b,c);
        load = s;
    }
    void showTruck()
    {
        System.out.println("Brand: "+brand+"\nColor: "+color+"\nLoad: "+load);
    }
}