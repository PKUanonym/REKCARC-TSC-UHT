#ifndef __GRAPH_H__
#define __GRAPH_H__

using Vertex = int;

struct graph
{
    // Number of edges in the graph
    int num_edges;
    // Number of vertices in the graph
    int num_nodes;

    // The node reached by vertex i's first outgoing edge is given by
    // outgoing_edges[outgoing_starts[i]].  To iterate over all
    // outgoing edges, please see the top-down bfs implementation.
    int* outgoing_starts;
    Vertex* outgoing_edges;

    int* incoming_starts;
    Vertex* incoming_edges;
};

using Graph = graph*;

/* Getters */
static inline int num_nodes(const Graph);
static inline int num_edges(const Graph);

static inline const Vertex* outgoing_begin(const Graph, Vertex);
static inline const Vertex* outgoing_end(const Graph, Vertex);
static inline int outgoing_size(const Graph, Vertex);

static inline const Vertex* incoming_begin(const Graph, Vertex);
static inline const Vertex* incoming_end(const Graph, Vertex);
static inline int incoming_size(const Graph, Vertex);


/* IO */
Graph load_graph(const char* filename);
Graph load_graph_binary(const char* filename);
void store_graph_binary(const char* filename, Graph);

void print_graph(const graph*);


/* Deallocation */
void free_graph(Graph);


/* Included here to enable inlining. Don't look. */
#include "graph_internal.h"

#endif
