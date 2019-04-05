#include <iostream>
#include <algorithm>
#include "SPPackingStrategy.h"
#include "SPPackingCommand.h"
#include "Layout.h"

using namespace std;
namespace RECTPACKING {

void SPPackingStrategy::initialPacking(Layout &layout)
{
  int rectNum = layout.getRectNum();
  if (rectNum < 2)
      return;

  vector<int> s1, s2;
  for (int i = 0; i < rectNum; ++ i)
  {
    s1.push_back(i);
  }
  s2 = s1;
  random_shuffle(s1.begin(), s1.end());
  random_shuffle(s2.begin(), s2.end());
  SPPackingCommand *spcmd = new SPPackingCommand(s1, s2);
  cout << "Packing Command in SPPackingStrategy::initialPacking" << endl;
  cout << *spcmd;

  setPackingCommand(spcmd);
  spcmd->interpretToLayout(layout);
  cout << "Layout after SPPackingStrategy::initialPacking" << endl;
  cout << layout;
}

void SPPackingStrategy::nextPackingCommand()
{
  if (m_pCommand)
  {
    m_pCommand->next();
  }
}

void SPPackingStrategy::compPackingLayout(Layout &layout)
{
  if (m_pCommand)
    m_pCommand->interpretToLayout(layout);
}

}
