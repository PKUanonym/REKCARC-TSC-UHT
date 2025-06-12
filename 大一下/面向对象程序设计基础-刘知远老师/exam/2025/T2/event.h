#pragma once

class EventInterface {
    int mood;
public:
    EventInterface() : mood(0) {}
    virtual ~EventInterface() {};

    int get_mood() {
        return mood;
    }
    void increase_mood(int value) {
        mood += value;
    }

    virtual void zoo(EventInterface*) = 0;
    virtual void shop(EventInterface*) = 0;
    virtual void birthday() = 0;
};