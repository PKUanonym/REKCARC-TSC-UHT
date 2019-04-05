#ifndef __GRADE_H__
#define __GRADE_H__

#include <stdio.h>
#include <sstream>
#include <iomanip>
#include <chrono>

#include <type_traits>
#include <utility>

#include <float.h>
#include <cmath>

#include <omp.h>

#include "graph.h"
#include "graph_internal.h"
#include "contracts.h"

// Epsilon for approximate float comparisons
#define EPSILON 0.00000000001

// Output column size
#define COL_SIZE 15

// Point value for apps that are not run.
#define POINTS_NA -1

// Point value for apps that yeilded incorrect results.
#define POINTS_INCORRECT -2

/*
 * Printing functions
 */

static void sep(std::ostream& out, char separator = '-', int length = 78)
{
    for (int i = 0; i < length; i++)
      out << separator;
    out << std::endl;
}

static void printTimingApp(std::ostream& timing, const char* appName)
{
  std::cout << std::endl;
  std::cout << "Timing results for " << appName << ":" << std::endl;
  sep(std::cout, '=', 75);

  timing << std::endl;
  timing << "Timing results for " << appName << ":" << std::endl;
  sep(timing, '=', 75);
}

/*
 * Correctness checkers
 */

template <class T>
bool compareArrays(Graph graph, T* ref, T* stu)
{
  for (int i = 0; i < graph->num_nodes; i++) {
    if (ref[i] != stu[i]) {
      std::cerr << "*** Results disagree at " << i << " expected " 
        << ref[i] << " found " << stu[i] << std::endl;
      return false;
    }
  }
  return true;
}

template <class T>
bool compareApprox(Graph graph, T* ref, T* stu)
{
  for (int i = 0; i < graph->num_nodes; i++) {
    if (fabs(ref[i] - stu[i]) > EPSILON) {
      std::cerr << "*** Results disagree at " << i << " expected " 
        << ref[i] << " found " << stu[i] << std::endl;
      return false;
    }
  }
  return true;
}

template <class T>
bool compareArraysAndDisplay(Graph graph, T* ref, T*stu) 
{
  printf("\n----------------------------------\n");
  printf("Visualization of student results");
  printf("\n----------------------------------\n\n");

  int grid_dim = (int)sqrt(graph->num_nodes);
  for (int j=0; j<grid_dim; j++) {
    for (int i=0; i<grid_dim; i++) {
      printf("%02d ", stu[j*grid_dim + i]);
    }
    printf("\n");
  }
  printf("\n----------------------------------\n");
  printf("Visualization of reference results");
  printf("\n----------------------------------\n\n");

  grid_dim = (int)sqrt(graph->num_nodes);
  for (int j=0; j<grid_dim; j++) {
    for (int i=0; i<grid_dim; i++) {
      printf("%02d ", ref[j*grid_dim + i]);
    }
    printf("\n");
  }
  
  return compareArrays<T>(graph, ref, stu);
}

template <class T>
bool compareArraysAndRadiiEst(Graph graph, T* ref, T* stu) 
{
  bool isCorrect = true;
  for (int i = 0; i < graph->num_nodes; i++) {
    if (ref[i] != stu[i]) {
      std::cerr << "*** Results disagree at " << i << " expected "
        << ref[i] << " found " << stu[i] << std::endl;
	isCorrect = false;
    }
  }
  int stuMaxVal = -1;
  int refMaxVal = -1;
  #pragma omp parallel for schedule(dynamic, 512) reduction(max: stuMaxVal)
  for (int i = 0; i < graph->num_nodes; i++) {
	if (stu[i] > stuMaxVal)
		stuMaxVal = stu[i];
  }
  #pragma omp parallel for schedule(dynamic, 512) reduction(max: refMaxVal)
  for (int i = 0; i < graph->num_nodes; i++) {
        if (ref[i] > refMaxVal)
                refMaxVal = ref[i];
  }
 
  if (refMaxVal != stuMaxVal) {
	std::cerr << "*** Radius estimates differ. Expected: " << refMaxVal << " Got: " << stuMaxVal << std::endl;
	isCorrect = false;
  }   
  return isCorrect;
}

#endif /* __GRADE_H__ */
