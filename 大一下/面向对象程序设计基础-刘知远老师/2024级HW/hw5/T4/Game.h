#pragma once
#include "Casern.h"
#include "AbstractFactory.h"

class Game
{
public:
	Casern* createGame(AbstractFactory& factory);
};
