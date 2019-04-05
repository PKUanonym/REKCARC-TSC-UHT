#ifndef __PAGE_RANK_H__
#define __PAGE_RANK_H__

#include "../common/graph.h"

void pageRank(Graph g, double* solution, double damping, double convergence);

#endif /* __PAGE_RANK_H__ */
