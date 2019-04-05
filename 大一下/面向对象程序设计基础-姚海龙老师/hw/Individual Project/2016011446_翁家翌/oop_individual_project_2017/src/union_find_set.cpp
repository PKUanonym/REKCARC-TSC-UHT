#include "generator.h"
#include "union_find_set.h"

UFS::UFS()
{
    if (father.size() == 0)
        for (int i = 0; i < Generator::TOTAL_NUMBER_OF_POINTS; ++i)
            father.push_back(i);
}
/**
 * [UFS::Get_father description]
 * @Author   n+e
 * @DateTime 2017-04-24
 * @return              [the root of block which x is in it]
 */
int UFS::Get_father(int x)
{
    return father[x] == x ? x : father[x] = Get_father(father[x]);
}
/**
 * [UFS::Is_linked description]
 * @Author   n+e
 * @DateTime 2017-04-24
 * @return              [if x and y are in the same block]
 */
bool UFS::Is_linked(int x, int y)
{
    return Get_father(x) == Get_father(y);
}
/**
 * [UFS::Link description]
 * @Author   n+e
 * @DateTime 2017-04-24
 * Link point_x and point_y to the same block.
 */
void UFS::Link(int x, int y)
{
    father[Get_father(x)] = Get_father(y);
}