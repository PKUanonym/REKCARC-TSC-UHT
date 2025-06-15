#pragma once

class Belong {
    Footman* footman;
    Commander* commander;
public:
    Belong(Footman* _footman, Commander* _commander) {
        footman = _footman;
        commander = _commander;
    }
    virtual Footman* getFootman() {
        return footman;
    }
    virtual Commander* getCommander() {
        return commander;
    }
};