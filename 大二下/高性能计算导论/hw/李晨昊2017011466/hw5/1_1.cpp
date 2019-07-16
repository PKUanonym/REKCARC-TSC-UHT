#include <mpi.h>
#include "util.hpp"

std::pair<std::unique_ptr<f64[]>, std::unique_ptr<f64[]>> gen(u32 n) {
  std::unique_ptr<f64[]> mat(new f64[n * n]);
  std::unique_ptr<f64[]> vec(new f64[n]);
  for (u32 i = 0; i < n; ++i) {
    for (u32 j = 0; j < n; ++j) {
      mat[i * n + j] = -1 + rand() * 1.0 / RAND_MAX * 2;
    }
  }
  for (u32 i = 0; i < n; ++i) {
    vec[i] = -1 + rand() * 1.0 / RAND_MAX * 2;
  }
  return {std::move(mat), std::move(vec)};
}

std::unique_ptr<f64[]> serial(const std::unique_ptr<f64[]> &mat, const std::unique_ptr<f64[]> &vec, u32 n) {
  std::unique_ptr<f64[]> ret(new f64[n]);
  for (u32 i = 0; i < n; ++i) {
    f64 tmp = 0.0;
    for (u32 j = 0; j < n; ++j) {
      tmp += mat[i * n + j] * vec[j];
    }
    ret[i] = tmp;
  }
  return ret;
}

void run(u32 n) {
  i32 pid, nproc;
  f64 beg[2], elapsed[2];

  MPI_Init(nullptr, nullptr);
  MPI_Comm_rank(MPI_COMM_WORLD, &pid);
  MPI_Comm_size(MPI_COMM_WORLD, &nproc);

  if (n % nproc != 0) {
    printf("n must be divisible by nproc, but n = %d, nproc= %d\n", n, nproc);
    exit(-1);
  }

  u32 each = n / nproc;
  std::unique_ptr<f64[]> loc_mat(new f64[n * each]), loc_vec(new f64[each]), ser_res;

  MPI_Datatype vec_t, col_t;
  // vec_t is a type like struct { f64[each]@0, f64[each]@(n * sizeof(f64)), ..., f64[each]@((n * n - 1) * sizeof(f64))}
  MPI_Type_vector(n, each, n, MPI_DOUBLE, &vec_t);
  // col_t is a type like vec_t, but it behaves like sizeof(col_t) == each * sizeof(f64) in MPI_Scatter
  MPI_Type_create_resized(vec_t, 0, each * sizeof(f64), &col_t);
  MPI_Type_commit(&col_t);
  std::unique_ptr<int[]> size(new int[nproc]), off(new int[nproc]);
  for (u32 i = 0; i < nproc; ++i) {
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

  std::unique_ptr<f64[]> y(new f64[n]);
  for (u32 i = 0; i < n; ++i) {
    f64 tmp = 0.0;
    for (u32 j = 0; j < each; ++j) {
      tmp += loc_mat[i * each + j] * loc_vec[j];
    }
    y[i] = tmp;
  }

  beg[1] = MPI_Wtime() - beg[1];

  if (pid == 0) {
    std::unique_ptr<f64[]> res(new f64[n]);
    MPI_Reduce(y.get(), res.get(), n, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
    beg[0] = MPI_Wtime() - beg[0];

    MPI_Reduce(beg, elapsed, 2, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
    printf("prod(+MPI_Scatter): %.5lfs\n", elapsed[0]);
    printf("prod(-MPI_Scatter): %.5lfs\n", elapsed[1]);

    beg[0] = MPI_Wtime();

    f64 l2 = 0.0;
#pragma omp parallel for reduction(+ : l2)
    for (u32 i = 0; i < n; ++i) {
      l2 += (ser_res[i] - res[i]) * (ser_res[i] - res[i]);
    }
    l2 = sqrt(l2);

    beg[0] = MPI_Wtime() - beg[0];
    printf("calc 2 norm: %.5lfs\n", beg[0]);
    printf("2 norm: %.20lf\n", l2);
  } else {
    MPI_Reduce(y.get(), nullptr, n, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
    beg[0] = MPI_Wtime() - beg[0];
    MPI_Reduce(beg, elapsed, 2, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
  }
  MPI_Type_free(&col_t);
  MPI_Finalize();
}

i32 main(i32 argc, i8 **argv) {
  if (argc < 2) {
    printf("usage: %s [n]\n", argv[0]);
    exit(1);
  }
  run(atoi(argv[1]));
}
