package vehicles;

public class Test
{
    public static void main(String[] args)
    {
        Car car = new Car("BMA", "white", 5);
        car.showCar();
        Truck truck = new Truck("HHH", "black", 1000.98f);
        truck.showTruck();
    }
}