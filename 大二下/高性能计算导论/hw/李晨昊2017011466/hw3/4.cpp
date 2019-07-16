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

  int sq_nproc = sqrtf(nproc);
  if (sq_nproc * sq_nproc != nproc) {
    printf("nproc must be complete square number, but nproc= %d\n", nproc);
    exit(-1);
  }
  if (n % sq_nproc != 0) {
    printf("n must be divisible by sqrt(nproc), but n = %d, nproc= %d\n", n, nproc);
    exit(-1);
  }

  int each = n / sq_nproc;
  std::unique_ptr<double[]> loc_mat(new double[each * each]), vec(nullptr), ser_res;

  MPI_Datatype vec_t, block_t;
  MPI_Type_vector(each, each, n, MPI_DOUBLE, &vec_t);
  MPI_Type_create_resized(vec_t, 0, each * sizeof(double), &block_t);
  MPI_Type_commit(&block_t);
  std::unique_ptr<int[]> size(new int[nproc]), off(new int[nproc]);
  for (int i = 0; i < sq_nproc; ++i) {
    for (int j = 0; j < sq_nproc; ++j) {
      size[i * sq_nproc + j] = 1;
      off[i * sq_nproc + j] = i * n + j;
    }
  }

  std::unique_ptr<double[]> mat(nullptr);
  if (pid == 0) {
    auto mat_vec = gen(n);
    ser_res = serial(mat_vec.first, mat_vec.second, n);
    mat = std::move(mat_vec.first);
    vec = std::move(mat_vec.second);
  } else {
    vec.reset(new double[n]);
  }

  MPI_Barrier(MPI_COMM_WORLD);
  beg[0] = MPI_Wtime();

  MPI_Scatterv(mat.get(), size.get(), off.get(), block_t, loc_mat.get(), each * each, MPI_DOUBLE, 0, MPI_COMM_WORLD);
  MPI_Bcast(vec.get(), n, MPI_DOUBLE, 0, MPI_COMM_WORLD);

  MPI_Barrier(MPI_COMM_WORLD);
  beg[1] = MPI_Wtime();

  std::unique_ptr<double[]> y(new double[n]{});
  int vec_off = pid % sq_nproc * each, y_off = pid / sq_nproc * each;
  for (int i = 0; i < each; ++i) {
    double tmp = 0.0;
    for (int j = 0; j < each; ++j) {
      tmp += loc_mat[i * each + j] * vec[vec_off + j];
    }
    y[y_off + i] = tmp;
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

  MPI_Type_free(&block_t);
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