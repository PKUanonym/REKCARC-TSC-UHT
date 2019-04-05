#include "BaseRouter.h"

int main()
{
	int row = 10;
	int col = 10;
	Point source(1, 1);
	Point target(4, 4);

	PointVector obsVec;
	obsVec.push_back(Point(1, 4));
	obsVec.push_back(Point(4, 1));
	obsVec.push_back(Point(1, 3));
	obsVec.push_back(Point(3, 4));

//	obsVec.push_back(Point(4, 3));
//	obsVec.push_back(Point(5, 3));

	BaseRouter router(row, col, source, target, obsVec);
	router.route();

	return 0;
}
