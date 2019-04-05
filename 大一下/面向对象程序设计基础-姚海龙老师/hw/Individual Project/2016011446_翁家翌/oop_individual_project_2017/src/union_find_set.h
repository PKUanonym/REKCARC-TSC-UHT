#ifndef __UFS_H__
#define __UFS_H__

#include <vector>

class UFS
{
    std::vector<int>father;
    int Get_father(int x);
public:
    UFS();
    //return if x and y are in the same block
    bool Is_linked(int x, int y);
    //Link point_x and point_y to the same block.
    void Link(int x, int y);
};

#endif