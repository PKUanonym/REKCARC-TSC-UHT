#include <iostream>
#include "PackingCommand.h"

namespace RECTPACKING {
using namespace std;

ostream & operator << (ostream &out, PackingCommand &pcmd)
{
  pcmd.dump(out);
  return out;
}

}
