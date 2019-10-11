// Exercise 3.11(d)
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define LOCAL_N 10

int main(int argc, char **argv) {
  int pid, nproc;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &pid);
  MPI_Comm_size(MPI_COMM_WORLD, &nproc);
  srand(pid + time(NULL));
  int a[LOCAL_N];
  for (int i = 0; i < LOCAL_N; ++i) {
    a[i] = rand() % 10;
  }
  for (int i = 1; i < LOCAL_N; ++i) {
    a[i] += a[i - 1];
  }
  // Note: MPI_Scan(range, out range) won't work here
  // MPI_Scan actually do the op on every scalar in the range and result length won't change
  // so MPI_Scan(a, res, LOCAL_N, MPI_INT, MPI_SUM, MPI_COMM_WORLD)
  // will result in res = [prefix sum of a[0], ..., prefix sum of a[LOCAL_N - 1], 0 repeat LOCAL_N * (nproc - 1)]
  // so for proc 0, res = [self a[0], ... self a[LOCAL_N - 1], 0 repeat LOCAL_N * (nproc - 1)]
  int pre;
  MPI_Scan(&a[LOCAL_N - 1], &pre, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
  pre -= a[LOCAL_N - 1];
  for (int i = 0; i < LOCAL_N; ++i) {
    a[i] += pre;
  }
  if (pid == 0) {
    int *res = malloc(nproc * LOCAL_N * sizeof(int));
    MPI_Gather(a, LOCAL_N, MPI_INT, res, LOCAL_N, MPI_INT, 0, MPI_COMM_WORLD);
    for (int i = 0; i < nproc * LOCAL_N; ++i) {
      printf("%d ", res[i]);
    }
    puts("");
    free(res);
  } else {
    MPI_Gather(a, LOCAL_N, MPI_INT, NULL, LOCAL_N, MPI_INT, 0, MPI_COMM_WORLD);
  }
  MPI_Finalize();
}