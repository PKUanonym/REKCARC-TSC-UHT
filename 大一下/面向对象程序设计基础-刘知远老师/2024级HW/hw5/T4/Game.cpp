#include "Game.h"

Casern* Game::createGame(AbstractFactory& factory) {
    Casern* casern = factory.createCasern();
    Footman* f1 = factory.createFootman("shou");
    Footman* f2 = factory.createFootman("shox");
    Commander* c1 = factory.createCommander("qmcc");
    Belong* b1 = factory.createBelong(f1, c1);        

    casern->addFootman(f1);
    casern->addFootman(f2);
    casern->addCommander(c1);
    casern->addBelong(b1);

    return casern;       
}