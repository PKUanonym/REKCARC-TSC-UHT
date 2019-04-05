#ifndef __SP_GRAPHPACKING_H__
#define __SP_GRAPHPACKING_H__
#include <vector>
#include <utility>

namespace RECTPACKING {

class SPPackingCommand;
class Layout;

void LongestGraphPacking(std::vector<std::pair<int, int> > &horCons, std::vector<std::pair<int, int> > &verCons, Layout &layout);

}

#endif	//__SP_GRAPHPACKING_H__
