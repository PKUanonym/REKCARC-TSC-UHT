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
#include "bfs.h"

#define USE_BINARY_GRAPH 1

void reference_bfs_bottom_up(Graph graph, solution* sol);
void reference_bfs_top_down(Graph graph, solution* sol);
void reference_bfs_hybrid(Graph graph, solution* sol);

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
        //Static assignment to get consistent usage across trials
        int max_threads = omp_get_max_threads();

        //static num_threadss
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

        solution sol1;
        sol1.distances = (int*)malloc(sizeof(int) * g->num_nodes);
        solution sol2;
        sol2.distances = (int*)malloc(sizeof(int) * g->num_nodes);
        solution sol3;
        sol3.distances = (int*)malloc(sizeof(int) * g->num_nodes);

        //Solution sphere
        solution sol4;
        sol4.distances = (int*)malloc(sizeof(int) * g->num_nodes);

        double hybrid_base, top_base, bottom_base;
        double hybrid_time, top_time, bottom_time;

        double ref_hybrid_base, ref_top_base, ref_bottom_base;
        double ref_hybrid_time, ref_top_time, ref_bottom_time;

        double start;
        std::stringstream timing;
        std::stringstream ref_timing;
        std::stringstream relative_timing;

        bool tds_check = true, bus_check = true, hs_check = true;

        timing << "Threads  Top Down              Bottom Up             Hybrid\n";
        ref_timing << "Threads  Top Down              Bottom Up             Hybrid\n";
        relative_timing << "Threads  Top Down       Bottom Up       Hybrid\n";

        //Loop through assignment values;
        for (int i = 0; i < n_usage; i++)
        {
            printf("----------------------------------------------------------\n");
            std::cout << "Running with " << num_threads[i] << " threads" << std::endl;
            //Set thread count
            omp_set_num_threads(num_threads[i]);

            //Run implementations
            start = CycleTimer::currentSeconds();
            bfs_top_down(g, &sol1);
            top_time = CycleTimer::currentSeconds() - start;

            //Run reference implementation
            start = CycleTimer::currentSeconds();
            reference_bfs_top_down(g, &sol4);
            ref_top_time = CycleTimer::currentSeconds() - start;

            std::cout << "Testing Correctness of Top Down\n";
            for (int j=0; j<g->num_nodes; j++) {
                if (sol1.distances[j] != sol4.distances[j]) {
                    fprintf(stderr, "*** Results disagree at %d: %d, %d\n", j, sol1.distances[j], sol4.distances[j]);
                    tds_check = false;
                    break;
                }
            }

            //Run implementations
            start = CycleTimer::currentSeconds();
            bfs_bottom_up(g, &sol2);
            bottom_time = CycleTimer::currentSeconds() - start;

            //Run reference implementation
            start = CycleTimer::currentSeconds();
            reference_bfs_bottom_up(g, &sol4);
            ref_bottom_time = CycleTimer::currentSeconds() - start;

            std::cout << "Testing Correctness of Bottom Up\n";
            for (int j=0; j<g->num_nodes; j++) {
                if (sol2.distances[j] != sol4.distances[j]) {
                    fprintf(stderr, "*** Results disagree at %d: %d, %d\n", j, sol2.distances[j], sol4.distances[j]);
                    bus_check = false;
                    break;
                }
            }


            start = CycleTimer::currentSeconds();
            bfs_hybrid(g, &sol3);
            hybrid_time = CycleTimer::currentSeconds() - start;

            //Run reference implementation
            start = CycleTimer::currentSeconds();
            reference_bfs_hybrid(g, &sol4);
            ref_hybrid_time = CycleTimer::currentSeconds() - start;

            std::cout << "Testing Correctness of Hybrid\n";
            for (int j=0; j<g->num_nodes; j++) {
                if (sol3.distances[j] != sol4.distances[j]) {
                    fprintf(stderr, "*** Results disagree at %d: %d, %d\n", j, sol3.distances[j], sol4.distances[j]);
                    hs_check = false;
                    break;
                }
            }


            if (i == 0)
            {
                hybrid_base = hybrid_time;
                ref_hybrid_base = ref_hybrid_time;
                top_base = top_time;
                bottom_base = bottom_time;
                ref_top_base = ref_top_time;
                ref_bottom_base = ref_bottom_time;

            }

            char buf[1024];
            char ref_buf[1024];
            char relative_buf[1024];

            sprintf(buf, "%4d:   %.4f (%.4fx)     %.4f (%.4fx)     %.4f (%.4fx)\n",
                    num_threads[i], top_time, top_base/top_time, bottom_time,
                    bottom_base/bottom_time, hybrid_time, hybrid_base/hybrid_time);
            sprintf(ref_buf, "%4d:   %.4f (%.4fx)     %.4f (%.4fx)     %.4f (%.4fx)\n",
                    num_threads[i], ref_top_time, ref_top_base/ref_top_time, ref_bottom_time,
                    ref_bottom_base/ref_bottom_time, ref_hybrid_time, ref_hybrid_base/ref_hybrid_time);
            sprintf(relative_buf, "%4d:   %.2fp     %.2fp     %.2fp\n",
                    num_threads[i], 100*top_time/ref_top_time, 100*bottom_time/ref_bottom_time, 100 * hybrid_time/ref_hybrid_time);

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
        if (!tds_check)
            std::cout << "Top Down Search is not Correct" << std::endl;
        if (!bus_check)
            std::cout << "Bottom Up Search is not Correct" << std::endl;
        if (!hs_check)
            std::cout << "Hybrid Search is not Correct" << std::endl;
        std::cout << std::endl << "Timing: " << std::endl <<  relative_timing.str();
    }
    //Run the code with only one thread count and only report speedup
    else
    {
        bool tds_check = true, bus_check = true, hs_check = true;
        solution sol1;
        sol1.distances = (int*)malloc(sizeof(int) * g->num_nodes);
        solution sol2;
        sol2.distances = (int*)malloc(sizeof(int) * g->num_nodes);
        solution sol3;
        sol3.distances = (int*)malloc(sizeof(int) * g->num_nodes);

        //Solution sphere
        solution sol4;
        sol4.distances = (int*)malloc(sizeof(int) * g->num_nodes);

        double hybrid_time, top_time, bottom_time;
        double ref_hybrid_time, ref_top_time, ref_bottom_time;

        double start;
        std::stringstream timing;
        std::stringstream ref_timing;


        timing << "Threads  Top Down    Bottom Up   Hybrid\n";
        ref_timing << "Threads  Top Down    Bottom Up   Hybrid\n";

        //Loop through assignment values;
        std::cout << "Running with " << thread_count << " threads" << std::endl;
        //Set thread count
        omp_set_num_threads(thread_count);

        //Run implementations
        start = CycleTimer::currentSeconds();
        bfs_top_down(g, &sol1);
        top_time = CycleTimer::currentSeconds() - start;

        //Run reference implementation
        start = CycleTimer::currentSeconds();
        reference_bfs_top_down(g, &sol4);
        ref_top_time = CycleTimer::currentSeconds() - start;

        std::cout << "Testing Correctness of Top Down\n";
        for (int j=0; j<g->num_nodes; j++) {
            if (sol1.distances[j] != sol4.distances[j]) {
                fprintf(stderr, "*** Results disagree at %d: %d, %d\n", j, sol1.distances[j], sol4.distances[j]);
                tds_check = false;
                break;
            }
        }


        //Run implementations
        start = CycleTimer::currentSeconds();
        bfs_bottom_up(g, &sol2);
        bottom_time = CycleTimer::currentSeconds() - start;

        //Run reference implementation
        start = CycleTimer::currentSeconds();
        reference_bfs_bottom_up(g, &sol4);
        ref_bottom_time = CycleTimer::currentSeconds() - start;

        std::cout << "Testing Correctness of Bottom Up\n";
        for (int j=0; j<g->num_nodes; j++) {
            if (sol2.distances[j] != sol4.distances[j]) {
                fprintf(stderr, "*** Results disagree at %d: %d, %d\n", j, sol2.distances[j], sol4.distances[j]);
                bus_check = false;
                break;
            }
        }


        start = CycleTimer::currentSeconds();
        bfs_hybrid(g, &sol3);
        hybrid_time = CycleTimer::currentSeconds() - start;

        //Run reference implementation
        start = CycleTimer::currentSeconds();
        reference_bfs_hybrid(g, &sol4);
        ref_hybrid_time = CycleTimer::currentSeconds() - start;

        std::cout << "Testing Correctness of Hybrid\n";
        for (int j=0; j<g->num_nodes; j++) {
            if (sol3.distances[j] != sol4.distances[j]) {
                fprintf(stderr, "*** Results disagree at %d: %d, %d\n", j, sol3.distances[j], sol4.distances[j]);
                hs_check = false;
                break;
            }
        }


        char buf[1024];
        char ref_buf[1024];

        sprintf(buf, "%4d:     %.4f     %.4f     %.4f\n",
                thread_count, top_time, bottom_time, hybrid_time);
        sprintf(ref_buf, "%4d:     %.4f     %.4f     %.4f\n",
                thread_count, ref_top_time, ref_bottom_time, ref_hybrid_time);

        timing << buf;
        ref_timing << ref_buf;
        if (!tds_check)
            std::cout << "Top Down Search is not Correct" << std::endl;
        if (!bus_check)
            std::cout << "Bottom Up Search is not Correct" << std::endl;
        if (!hs_check)
            std::cout << "Hybrid Search is not Correct" << std::endl;
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
