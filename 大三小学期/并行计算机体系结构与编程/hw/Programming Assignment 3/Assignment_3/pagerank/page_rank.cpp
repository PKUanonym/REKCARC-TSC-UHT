#include "page_rank.h"

#include <stdlib.h>
#include <cmath>
#include <omp.h>
#include <utility>

#include "../common/CycleTimer.h"
#include "../common/graph.h"

double dabs(double a) {
    if (a > 0) return a;
    return -a;
}


// pageRank --
//
// g:           graph to process (see common/graph.h)
// solution:    array of per-vertex vertex scores (length of array is num_nodes(g))
// damping:     page-rank algorithm's damping parameter
// convergence: page-rank algorithm's convergence threshold
//
void pageRank(Graph g, double* solution, double damping, double convergence)
{

    // initialize vertex weights to uniform probability. Double
    // precision scores are used to avoid underflow for large graphs

    int numNodes = num_nodes(g);
    double equal_prob = 1.0 / numNodes;

    double sum_total = 0;
	#pragma omp parallel for reduction(+: sum_total)
    for (int i = 0; i < numNodes; ++i) {
        solution[i] = equal_prob;
        if (outgoing_size(g, i) == 0)
            sum_total += solution[i];
    }
    double* solution_new = new double [numNodes];

    bool converged = 0;
    while (!converged) {
		#pragma omp parallel for
        for (int i = 0; i < numNodes; i++) {
            solution_new[i] = 0;
			const Vertex* start = incoming_begin(g, i);
			const Vertex* end = incoming_end(g, i);
			for (const Vertex* vj = start; vj != end; vj++) {
				int num = outgoing_size(g, *vj);
				solution_new[i] += solution[*vj] / num;
			}
            solution_new[i] = (damping * solution_new[i]) + (1.0 - damping) / numNodes;
            solution_new[i] += damping * sum_total / numNodes;
        }
        sum_total = 0;
        double diff = 0;
		#pragma omp parallel for reduction(+: diff), reduction(+: sum_total)
        for (int i = 0; i < numNodes; i++) {
            diff += dabs(solution_new[i] - solution[i]);
            solution[i] = solution_new[i];
            if (outgoing_size(g, i) == 0)
                sum_total += solution[i];
        }
        if (diff < convergence) converged = 1;
    }

    delete [] solution_new;
}



    /* 418/618 Students: Implement the page rank algorithm here.  You
       are expected to parallelize the algorithm using openMP.  Your
       solution may need to allocate (and free) temporary arrays.

       Basic page rank pseudocode:

    // initialization: see example code above
    score_old[vi] = 1/numNodes;

    while (!converged) {

    // compute score_new[vi] for all nodes vi:
    score_new[vi] = sum over all nodes vj reachable from incoming edges
    { score_old[vj] / number of edges leaving vj  }
    score_new[vi] = (damping * score_new[vi]) + (1.0-damping) / numNodes;

    score_new[vi] += sum over all nodes vj with no outgoing edges
    { damping * score_old[vj] / numNodes }

    // compute how much per-node scores have changed
    // quit once algorithm has converged

    global_diff = sum over all nodes vi { abs(score_new[vi] - score_old[vi]) };
    converged = (global_diff < convergence)
    }

*/
