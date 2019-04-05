#ifndef __SP_PACKINGSTRATEGY_H__
#define __SP_PACKINGSTRATEGY_H__
#include "PackingCommand.h"

namespace RECTPACKING {
class Layout;
class PackingStrategy
{
public:
  PackingStrategy():m_pCommand(0) {}
  virtual ~PackingStrategy() {
    if (m_pCommand)
      delete m_pCommand;
  }
  virtual void initialPacking(Layout &layout) = 0;
  virtual void compPackingLayout(Layout &layout) = 0;
  virtual void nextPackingCommand() = 0;
  PackingCommand *getPackingCommand() { return m_pCommand; }
  void setPackingCommand(PackingCommand *c) { 
    if (m_pCommand)
      delete m_pCommand;
    m_pCommand = c;
  }

protected:
  PackingCommand *m_pCommand;  
};

}

#endif	//__SP_PACKINGSTRATEGY_H__
