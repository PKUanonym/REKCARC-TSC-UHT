#ifndef __SP_SPPACKINGCOMMAND_H__
#define __SP_SPPACKINGCOMMAND_H__
#include "PackingCommand.h"

namespace RECTPACKING {

class SPPackingCommand : public PackingCommand
{
public:
  SPPackingCommand(std::vector<int> &s1, std::vector<int> &s2):PackingCommand() {
    m_s1 = s1;
    m_s2 = s2;
  }
  ~SPPackingCommand() {}
  void interpretToLayout(Layout &layout);
  void dump(std::ostream &out);
  void next();
  void getS1(std::vector<int> &s1) { s1 = m_s1; }
  void getS2(std::vector<int> &s2) { s2 = m_s2; }

protected:
  void change(std::vector<int> &m_s);
  
  std::vector<int> m_s1;
  std::vector<int> m_s2;
};

}

#endif	//__SP_SPPACKINGCOMMAND_H__
