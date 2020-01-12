#include <mpi.h>
#include <cmath>
#include <cstdio>
#include <memory>
#include <utility>

std::pair<std::unique_ptr<double[]>, std::unique_ptr<double[]>> gen(int n) {
  std::unique_ptr<double[]> mat(new double[n * n]);
  std::unique_ptr<double[]> vec(new double[n]);
  for (int i = 0; i < n; ++i) {
    for (int j = 0; j < n; ++j) {
      mat[i * n + j] = -1 + rand() * 1.0 / RAND_MAX * 2;
    }
  }
  for (int i = 0; i < n; ++i) {
    vec[i] = -1 + rand() * 1.0 / RAND_MAX * 2;
  }
  return {std::move(mat), std::move(vec)};
}

std::unique_ptr<double[]> serial(const std::unique_ptr<double[]> &mat, const std::unique_ptr<double[]> &vec, int n) {
  std::unique_ptr<double[]> ret(new double[n]);
  for (int i = 0; i < n; ++i) {
    double tmp = 0.0;
    for (int j = 0; j < n; ++j) {
      tmp += mat[i * n + j] * vec[j];
    }
    ret[i] = tmp;
  }
  return ret;
}

void run(int n) {
  int pid, nproc;
  double beg[2], elapsed[2];

  MPI_Init(nullptr, nullptr);
  MPI_Comm_rank(MPI_COMM_WORLD, &pid);
  MPI_Comm_size(MPI_COMM_WORLD, &nproc);

  if (n % nproc != 0) {
    printf("n must be divisible by nproc, but n = %d, nproc= %d\n", n, nproc);
    exit(-1);
  }

  int each = n / nproc;
  std::unique_ptr<double[]> loc_mat(new double[n * each]), loc_vec(new double[each]), ser_res;
  
  MPI_Datatype vec_t, col_t;
  // vec_t is a type like struct { double[each]@0, double[each]@(n * sizeof(double)), ..., double[each]@((n * n - 1) * sizeof(double))}
  MPI_Type_vector(n, each, n, MPI_DOUBLE, &vec_t);
  // col_t is a type like vec_t, but it behaves like sizeof(col_t) == each * sizeof(double) in MPI_Scatter
  MPI_Type_create_resized(vec_t, 0, each * sizeof(double), &col_t);
  MPI_Type_commit(&col_t);
  std::unique_ptr<int[]> size(new int[nproc]), off(new int[nproc]);
  for (int i = 0; i < nproc; ++i) {
    size[i] = 1;
    off[i] = i;
  }

  decltype(gen(n)) mat_vec(nullptr, nullptr);
  if (pid == 0) {
    mat_vec = gen(n);
    ser_res = serial(mat_vec.first, mat_vec.second, n);
  }
  
  MPI_Barrier(MPI_COMM_WORLD);
  beg[0] = MPI_Wtime();

  MPI_Scatterv(mat_vec.first.get(), size.get(), off.get(), col_t, loc_mat.get(), n * each, MPI_DOUBLE, 0, MPI_COMM_WORLD);
  MPI_Scatter(mat_vec.second.get(), each, MPI_DOUBLE, loc_vec.get(), each, MPI_DOUBLE, 0, MPI_COMM_WORLD);

  MPI_Barrier(MPI_COMM_WORLD);
  beg[1] = MPI_Wtime();

  std::unique_ptr<double[]> y(new double[n]);
  for (int i = 0; i < n; ++i) {
    double tmp = 0.0;
    for (int j = 0; j < each; ++j) {
      tmp += loc_mat[i * each + j] * loc_vec[j];
    }
    y[i] = tmp;
  }

  if (pid == 0) {
    std::unique_ptr<double[]> res(new double[n]);
    MPI_Reduce(y.get(), res.get(), n, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

    double now = MPI_Wtime();
    beg[0] = now - beg[0], beg[1] = now - beg[1];
    MPI_Reduce(beg, elapsed, 2, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
    printf("elapsed(+MPI_Scatter): %.4lfs\n", elapsed[0]);
    printf("elapsed(-MPI_Scatter): %.4lfs\n", elapsed[1]);

    double l1 = 0.0, l2 = 0.0, linf = 0.0;
    for (int i = 0; i < n; ++i) {
      double diff = fabs(ser_res[i] - res[i]);
      l1 += diff;
      l2 += diff * diff;
      linf = fmax(linf, diff);
    }
    l2 = sqrtf(l2);
    printf("error(1 norm): %.20lf\n", l1);
    printf("error(2 norm): %.20lf\n", l2);
    printf("error(infinite norm): %.20lf\n", linf);
  } else {
    MPI_Reduce(y.get(), nullptr, n, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

    double now = MPI_Wtime();
    beg[0] -= now, beg[1] -= now;
    MPI_Reduce(beg, elapsed, 2, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
  }
  MPI_Type_free(&col_t);
  MPI_Finalize();
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    printf("Usage: %s n\n", argv[0]);
    return -1;
  }
  int n = atoi(argv[1]);
  run(n);
}
