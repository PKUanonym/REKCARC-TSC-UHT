#include "YourCasern.h"
#include "YourFactory.h"
#include "Game.h"

#include <cstdlib>
#include <cstdio>

void assert(bool flag){
	if(!flag){
		printf("error!\n");
		exit(0);
	}
}

void test1(Casern* casern) {
    assert(casern->getKind()=="HumanCasern");

    HumanFootman* f1 = dynamic_cast<HumanFootman*>(casern->getFootmanbyIndex(0));
    HumanFootman* f2 = dynamic_cast<HumanFootman*>(casern->getFootmanbyIndex(1));
    HumanCommander* c1 = dynamic_cast<HumanCommander*>(casern->getCommanderbyIndex(0));
    HumanBelong* b1 = dynamic_cast<HumanBelong*>(casern->getBelongbyIndex(0));

    assert(f1!=NULL);
    assert(f1->getFootmanId()=="shou");
    assert(f2!=NULL);
    assert(f2->getFootmanId()=="shox");
    assert(c1!=NULL);
    assert(c1->getCommanderId()=="qmcc");
    assert(b1!=NULL);
    assert(b1->getFootman()==f1);
    assert(b1->getCommander()==c1);
    printf("test1 ok!\n");

}

void test2(Casern* casern) {
    assert(casern->getKind()=="OrcCasern");

    OrcFootman* f1 = dynamic_cast<OrcFootman*>(casern->getFootmanbyIndex(0));
    OrcFootman* f2 = dynamic_cast<OrcFootman*>(casern->getFootmanbyIndex(1));
    OrcCommander* c1 = dynamic_cast<OrcCommander*>(casern->getCommanderbyIndex(0));
    OrcBelong* b1 = dynamic_cast<OrcBelong*>(casern->getBelongbyIndex(0));
    assert(f1!=NULL);
    assert(f1->getFootmanId()=="shou");
    assert(f2!=NULL);
    assert(f2->getFootmanId()=="shox");
    assert(c1!=NULL);
    assert(c1->getCommanderId()=="qmcc");
    assert(b1!=NULL);
    assert(b1->getFootman()==f1);
    assert(b1->getCommander()==c1);
    printf("test2 ok!\n");

}

int main() {
    Game* game = new Game();
    HumanFactory hum;
    OrcFactory orc;

    Casern* casern1 = game->createGame(hum);
    Casern* casern2 = game->createGame(orc);

    // for Test
    test1(casern1);
    test2(casern2);

    delete casern1;
    delete casern2;
    delete game;

    return 0;
}