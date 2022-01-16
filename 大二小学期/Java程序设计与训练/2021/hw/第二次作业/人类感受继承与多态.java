class Man extends BasePerson implements Person {
    private final String name, description;
    protected Integer count;

    Man(String name, String description) {
        this.name = name;
        this.description = description;
        this.count = 0;
    }

    protected void move() {
        System.out.println("I'm moving...");
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public int changeSomething() {
        count -= 1;
        return count;
    }
}

class SuperMan extends Man {
    SuperMan(String name, String description) {
        super(name, description);
    }

    SuperMan() {
        this("superMan", "I can fly.");
    }

    void fly() {
        System.out.println("Fly! SuperMan!");
    }

    @Override
    protected void move() {
        System.out.println("I am flying...");
    }

    @Override
    public int changeSomething() {
        count += 1;
        return count;
    }

}
