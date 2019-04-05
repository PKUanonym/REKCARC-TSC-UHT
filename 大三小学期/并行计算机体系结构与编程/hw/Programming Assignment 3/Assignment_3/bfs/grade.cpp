#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <string>
#include <unistd.h>
#include <limits>

#include <iostream>
#include <sstream>
#include <vector>

#include "../common/CycleTimer.h"
#include "../common/graph.h"
#include "../common/grade.h"
#include "bfs.h"

#define USE_BINARY_GRAPH 1

#define top_down 0
#define bott_up 1
#define hybrid 2

void reference_bfs_bottom_up(Graph graph, solution* sol);
void reference_bfs_top_down(Graph graph, solution* sol);
void reference_bfs_hybrid(Graph graph, solution* sol);

void usage(const char* binary_name) {
    std::cout << "Usage: " << binary_name << " [options] graphdir" << std::endl;
    std::cout << std::endl;
    std::cout << "Options:" << std::endl;
    std::cout << "  -n  INT number of threads" << std::endl;
    std::cout << "  -r  INT number of runs" << std::endl;
    std::cout << "  -h      this commandline help message" << std::endl;
}

graph* load_graph(std::string graph_filename) {
    graph* g;
    if (USE_BINARY_GRAPH) {
      g = load_graph_binary(graph_filename.c_str());
    } else {
        g = load_graph(graph_filename);
        printf("storing binary form of graph!\n");
        store_graph_binary(graph_filename.append(".bin").c_str(), g);
        delete g;
        exit(1);
    }
    return g;
}

double compute_score(std::string graph_name, bool correct, double ref_time, double stu_time) {
    bool small = false;
    if ((graph_name == "grid1000x1000.graph") || (graph_name == "soc-livejournal1_68m.graph") ||
            (graph_name == "com-orkut_117m.graph")) small = true;

    double max_score = (small) ? 3 : 6;
    double max_perf_score = 0.8 * max_score; //(small) ? 1.6 : 3.2;
    double correctness_score = 0.2 * max_score; //(small) ? 0.4 : 0.8;
    correctness_score = (correct) ? correctness_score : 0;

    double ratio = (ref_time/stu_time);

    double slope = max_perf_score/(0.7 - 0.3); //(small) ? 4 : 8;
    double offset = 0.3 * slope; //(small) ? 1.2 : 2.4;

    double perf_score = (correct) ? ratio*slope - offset : 0;

    if (perf_score < 0) perf_score = 0;
    if (perf_score > max_perf_score) perf_score = max_perf_score;

    return (correctness_score + perf_score);
}

void run_on_graph(int idx, graph* g, int num_threads, int num_runs,
    std::string graph_name, std::vector<std::vector<double>> &scores) {

    solution ref;
    ref.distances = new int[g->num_nodes];
    solution stu;
    stu.distances = new int[g->num_nodes];

    double start, time;

    omp_set_num_threads(num_threads);

    std::cout << "\nTop down bfs" << std::endl;
    double ref_top_down_time = std::numeric_limits<int>::max();
    for (int r = 0; r < num_runs; r++) {
        start = CycleTimer::currentSeconds();
        reference_bfs_top_down(g, &ref);
        time = CycleTimer::currentSeconds() - start;
        ref_top_down_time = std::min(ref_top_down_time, time);
    }

    double stu_top_down_time = std::numeric_limits<int>::max();
    for (int r = 0; r < num_runs; r++) {
        start = CycleTimer::currentSeconds();
        bfs_top_down(g, &stu);
        time = CycleTimer::currentSeconds() - start;
        stu_top_down_time = std::min(stu_top_down_time, time);
    }

    bool correct = compareArrays(g, ref.distances, stu.distances);

    if (!correct) {
        std::cout << "Top down bfs incorrect" << std::endl;
        std::cout << "ref_time: " <<  ref_top_down_time << "s" << std::endl;
    } else {
        std::cout << "ref_time: " <<  ref_top_down_time << "s" << std::endl;
        std::cout << "stu_time: " <<  stu_top_down_time << "s" << std::endl;
    }

    scores[idx][top_down] = compute_score(graph_name, correct, ref_top_down_time, stu_top_down_time);

    for (int i = 0; i < g->num_nodes; i++) {
        ref.distances[i] = -1;
        stu.distances[i] = -1;
    }

    double ref_bottom_up_time = std::numeric_limits<int>::max();
    for (int r = 0; r < num_runs; r++) {
        start = CycleTimer::currentSeconds();
        reference_bfs_bottom_up(g, &ref);
        time = CycleTimer::currentSeconds() - start;
        ref_bottom_up_time = std::min(ref_bottom_up_time, time);
    }

    std::cout << "\nBottom up bfs" << std::endl;
    double stu_bottom_up_time = std::numeric_limits<int>::max();
    for (int r = 0; r < num_runs; r++) {
        start = CycleTimer::currentSeconds();
        bfs_bottom_up(g, &stu);
        time = CycleTimer::currentSeconds() - start;
        stu_bottom_up_time = std::min(stu_bottom_up_time, time);
    }

    correct = compareArrays(g, ref.distances, stu.distances);

    if (!correct) {
        std::cout << "Bottom up bfs incorrect" << std::endl;
        std::cout << "ref_time: " <<  ref_bottom_up_time << "s" << std::endl;
    } else {
        std::cout << "ref_time: " <<  ref_bottom_up_time << "s" << std::endl;
        std::cout << "stu_time: " <<  stu_bottom_up_time << "s" << std::endl;
    }

    scores[idx][bott_up] = compute_score(graph_name, correct, ref_bottom_up_time, stu_bottom_up_time);


    for (int i = 0; i < g->num_nodes; i++) {
        ref.distances[i] = -1;
        stu.distances[i] = -1;
    }

    std::cout << "\nHybrid bfs" << std::endl;

    double ref_hybrid_time = std::numeric_limits<int>::max();
    for (int r = 0; r < num_runs; r++) {
        start = CycleTimer::currentSeconds();
        reference_bfs_hybrid(g, &ref);
        time = CycleTimer::currentSeconds() - start;
        ref_hybrid_time = std::min(ref_hybrid_time, time);
    }

    double stu_hybrid_time = std::numeric_limits<int>::max();
    for (int r = 0; r < num_runs; r++) {
        start = CycleTimer::currentSeconds();
        bfs_hybrid(g, &stu);
        time = CycleTimer::currentSeconds() - start;
        stu_hybrid_time = std::min(stu_hybrid_time, time);
    }

    correct = compareArrays(g, ref.distances, stu.distances);

    if (!correct) {
        std::cout << "Hybrid bfs incorrect" << std::endl;
        std::cout << "ref_time: " <<  ref_hybrid_time << "s" << std::endl;
    } else {
        std::cout << "ref_time: " <<  ref_hybrid_time << "s" << std::endl;
        std::cout << "stu_time: " <<  stu_hybrid_time << "s" << std::endl;
    }

    scores[idx][hybrid] = compute_score(graph_name, correct, ref_hybrid_time, stu_hybrid_time);

    delete(stu.distances);
    delete(ref.distances);
}

void print_separator_line() {
    for (int i = 0; i < 74; i++) {
        std::cout<<"-";
    }
    std::cout<<std::endl;
}

void print_scores(std::vector<std::string> grade_graphs, std::vector<std::vector<double>> scores) {

    std::cout.precision(5);
    std::cout.setf(std::ios::fixed, std:: ios::floatfield);
    std::cout<<std::endl<<std::endl;

    print_separator_line();

    std::cout<<"SCORES :";
    for (int i = 0; i < (28 - 8); i++) {
        std::cout<<" ";
    }

    std::cout<<"|   Top-Down    |   Bott-Up    |    Hybrid    |"<<std::endl;

    print_separator_line();

    double total_score = 0.0;

    for (int g = 0; g < grade_graphs.size(); g++) {
        auto& graph_name = grade_graphs[g];

        total_score += (scores[g][top_down] + scores[g][bott_up] + scores[g][hybrid]);

        bool small = false;
        if ((graph_name == "grid1000x1000.graph") || (graph_name == "soc-livejournal1_68m.graph") ||
                (graph_name == "com-orkut_117m.graph")) small = true;

        std::string max_score = (small) ? "3" : "6";

        std::cout<<graph_name;
        for (int i = 0; i < (28 - graph_name.length()); i++) {
            std::cout<<" ";
        }

        std::cout<<"| ";
        std::cout<<"  "<<scores[g][top_down]<<" / "<<max_score<<" |";
        std::cout<<"  "<<scores[g][bott_up]<<" / "<<max_score<<" |";
        std::cout<<"  "<<scores[g][hybrid]<<" / "<<max_score<<" |"<<std::endl;;

        print_separator_line();
    }

    std::cout<<"TOTAL";
    for (int i = 0; i < (59 - 5); i++) {
            std::cout<<" ";
    }
    std::cout<<"| ";
    std::cout<<total_score<<" / "<<"63"<<" |"<<std::endl;

    print_separator_line();

}

int main(int argc, char** argv) {

    int num_threads = omp_get_max_threads();
    int num_runs = 1;
    std::string graph_name, graph_dir;
    bool grade = false;

    int opt;
    while ((opt = getopt(argc,argv,"n:r:gh")) != EOF) {
        switch(opt) {
            case 'n':
                num_threads = atoi(optarg);
                break;
            case 'r':
                num_runs = atoi(optarg);
                break;
            case 'h':
            case '?':
            default:
                usage(argv[0]);
                exit(1);
        }
    }

    if (argc <= optind) {
        usage(argv[0]);
        exit(1);
    }

    graph_dir = argv[optind];

    printf("Max system threads = %d\n", omp_get_max_threads());
    printf("Running with %d threads\n", num_threads);

    std::vector<std::string> grade_graphs = { "grid1000x1000.graph",
                                              "soc-livejournal1_68m.graph",
                                              "com-orkut_117m.graph",
                                              "random_500m.graph",
                                              "rmat_200m.graph"};

    std::vector<std::vector<double>> scores(grade_graphs.size());
    // top_down 0
    // bott_up 1
    // hybrid 2
    for (int i = 0; i < grade_graphs.size(); i++) {
        scores[i] = std::vector<double>(3);
    }

    int idx = 0;
    for (auto& graph_name: grade_graphs) {
        graph* g = load_graph(graph_dir + '/' + graph_name);
        std::cout << "\nGraph: " << graph_name << std::endl;
        run_on_graph(idx, g, num_threads, num_runs, graph_name, scores);
        delete g;
        idx++;
    }

    print_scores(grade_graphs, scores);

    return 0;
}
