#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <string>
#include <getopt.h>

#include <iostream>
#include <sstream>
#include <vector>

#include "../common/CycleTimer.h"
#include "../common/graph.h"
#include "../common/grade.h"
#include "page_rank.h"

#define USE_BINARY_GRAPH 1

#define PageRankDampening 0.3f
#define PageRankConvergence 1e-7d

void reference_pageRank(Graph g, double* solution, double damping,
                        double convergence);

int main(int argc, char** argv) {

    int  num_threads = -1;
    std::string graph_filename;

    if (argc < 2)
    {
        std::cerr << "Usage: <path/to/graph/file> [manual_set_thread_count]\n";
        std::cerr << "To get results across all thread counts: <path/to/graph/file>\n";
        std::cerr << "Run with certain threads count (no correctness run): <path/to/graph/file> <thread_count>\n";
        exit(1);
    }

    int thread_count = -1;
    if (argc == 3)
    {
        thread_count = atoi(argv[2]);
    }

    graph_filename = argv[1];

    Graph g;

    printf("----------------------------------------------------------\n");
    printf("Max system threads = %d\n", omp_get_max_threads());
    if (thread_count > 0)
    {
        thread_count = std::min(thread_count, omp_get_max_threads());
        printf("Running with %d threads\n", thread_count);
    }
    printf("----------------------------------------------------------\n");

    printf("Loading graph...\n");
    if (USE_BINARY_GRAPH) {
      g = load_graph_binary(graph_filename.c_str());
    } else {
        g = load_graph(argv[1]);
        printf("storing binary form of graph!\n");
        store_graph_binary(graph_filename.append(".bin").c_str(), g);
        delete g;
        exit(1);
    }
    printf("\n");
    printf("Graph stats:\n");
    printf("  Edges: %d\n", g->num_edges);
    printf("  Nodes: %d\n", g->num_nodes);

    //If we want to run on all threads
    if (thread_count <= -1)
    {
        //Static num_threads to get consistent usage across trials
        int max_threads = omp_get_max_threads();

        std::vector<int> num_threads;

        //dynamic num_threads
        //for (int i = 1; i < max_threads; i *= 2) {
        //  num_threads.push_back(i);
        //}
        //num_threads.push_back(max_threads);

        // kayvonf: hardcoding thread counts for Tsinghua machines
        for (int i = 1; i <= 8; i *= 2)
            num_threads.push_back(i);
        num_threads.push_back(12);
        num_threads.push_back(24);

        int n_usage = num_threads.size();

        double* sol1;
        sol1 = (double*)malloc(sizeof(double) * g->num_nodes);
        double* sol2;
        sol2 = (double*)malloc(sizeof(double) * g->num_nodes);
        double* sol3;
        sol3 = (double*)malloc(sizeof(double) * g->num_nodes);

        //Solution sphere
        double* sol4;
        sol4 = (double*)malloc(sizeof(double) * g->num_nodes);

        double pagerank_base;
        double pagerank_time;

        double ref_pagerank_base;
        double ref_pagerank_time;

        double start;
        std::stringstream timing;
        std::stringstream ref_timing;
        std::stringstream relative_timing;

        bool pr_check = true;

        timing << "Threads  Page Rank\n";
        ref_timing << "Threads  Page Rank\n";
        relative_timing << "Threads  Page Rank\n";

        //Loop through num_threads values;
        for (int i = 0; i < n_usage; i++)
        {
            printf("----------------------------------------------------------\n");
            std::cout << "Running with " << num_threads[i] << " threads" << std::endl;
            //Set thread count
            omp_set_num_threads(num_threads[i]);

            //Run implementations
            start = CycleTimer::currentSeconds();
            pageRank(g, sol1, PageRankDampening, PageRankConvergence);
            pagerank_time = CycleTimer::currentSeconds() - start;

            //Run reference implementation
            start = CycleTimer::currentSeconds();
            reference_pageRank(g, sol4, PageRankDampening,
                               PageRankConvergence);
            ref_pagerank_time = CycleTimer::currentSeconds() - start;


            if (num_threads[i] == 1) {
                pagerank_base = pagerank_time;
                ref_pagerank_base = ref_pagerank_time;
            }

            std::cout << "Testing Correctness of Page Rank\n";
            if (!compareApprox(g, sol4, sol1)) {
              pr_check = false;
              //break;
            }

            char buf[1024];
            char ref_buf[1024];
            char relative_buf[1024];

            sprintf(buf, "%4d:    %.4f sec (%.4fx)\n",
                    num_threads[i], pagerank_time, pagerank_base/pagerank_time);
            sprintf(ref_buf, "%4d:    %.4f sec (%.4fx)\n",
                    num_threads[i], ref_pagerank_time,
                    ref_pagerank_base/ref_pagerank_time);
            sprintf(relative_buf, "%4d:     %.2f\n",
                    num_threads[i], pagerank_time/ref_pagerank_time);

            timing << buf;
            ref_timing << ref_buf;
            relative_timing << relative_buf;
        }

        printf("----------------------------------------------------------\n");
        std::cout << "Timing Summary" << std::endl;
        std::cout << timing.str();
        printf("----------------------------------------------------------\n");
        std::cout << "Reference Summary" << std::endl;
        std::cout << ref_timing.str();
        printf("----------------------------------------------------------\n");
        std::cout << "For grading reference (based on execution times)" << std::endl << std::endl;
        std::cout << "Correctness: " << std::endl;
        if (!pr_check)
            std::cout << "Page Rank is not Correct" << std::endl;
        else
            std::cout << "Passed correctness check" << std::endl;

        std::cout << std::endl << "Performance relative to reference: " << std::endl <<  relative_timing.str();
    }
    //Run the code with only one thread count and only report speedup
    else
    {
        bool pr_check = true;
        double* sol1;
        sol1 = (double*)malloc(sizeof(double) * g->num_nodes);
        double* sol2;
        sol2 = (double*)malloc(sizeof(double) * g->num_nodes);
        double* sol3;
        sol3 = (double*)malloc(sizeof(double) * g->num_nodes);

        //Double* sphere
        double* sol4;
        sol4 = (double*)malloc(sizeof(double) * g->num_nodes);

        double pagerank_base;
        double pagerank_time;

        double ref_pagerank_base;
        double ref_pagerank_time;

        double start;
        std::stringstream timing;
        std::stringstream ref_timing;

        timing << "Threads  Page Rank\n";
        ref_timing << "Threads  Page Rank\n";

        //Loop through assignment values;
        std::cout << "Running with " << thread_count << " threads" << std::endl;
        //Set thread count
        omp_set_num_threads(thread_count);

        //Run implementations
        start = CycleTimer::currentSeconds();
        pageRank(g, sol1, PageRankDampening, PageRankConvergence);
        pagerank_time = CycleTimer::currentSeconds() - start;

        //Run reference implementation
        start = CycleTimer::currentSeconds();
        reference_pageRank(g, sol4, PageRankDampening, PageRankConvergence);
        ref_pagerank_time = CycleTimer::currentSeconds() - start;

        std::cout << "Testing Correctness of Page Rank\n";
        if (!compareApprox(g, sol4, sol1)) {
          pr_check = false;
        }


        char buf[1024];
        char ref_buf[1024];

        sprintf(buf, "%4d:   %.4f sec\n",
                thread_count, pagerank_time);
        sprintf(ref_buf, "%4d:   %.4f sec\n",
                thread_count, ref_pagerank_time);

        timing << buf;
        ref_timing << ref_buf;
        if (!pr_check)
            std::cout << "Page Rank is not Correct" << std::endl;
        printf("----------------------------------------------------------\n");
        std::cout << "Timing Summary" << std::endl;
        std::cout << timing.str();
        printf("----------------------------------------------------------\n");
        std::cout << "Reference Summary" << std::endl;
        std::cout << ref_timing.str();
        printf("----------------------------------------------------------\n");
    }

    delete g;

    return 0;
}
