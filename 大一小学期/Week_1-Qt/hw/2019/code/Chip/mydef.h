#ifndef MYDEF_H
#define MYDEF_H
struct MyPoint
{
    int x, y, ID;
    int sizeX = 1, sizeY = 1;
    MyPoint(int _x, int _y, int _ID, int _sX = 1, int _sY = 1) {
        x = _x; y = _y; ID = _ID; sizeX = _sX; sizeY = _sY;
    }
};

enum Act {
    Input, Move, Split1, Split2, Merge1, Merge2, OutPut
};//Mix = (n-1) * Move
struct Action
{
    Act a;
    int t, x, y, nx, ny, line;
    Action(int _t, int _x, int _y, int _line, Act _a = Input, int _nx = 0, int _ny = 0) :
        a(_a), t(_t), x(_x), y(_y), nx(_nx), ny(_ny), line(_line) {}
};

#endif // MYDEF_H
