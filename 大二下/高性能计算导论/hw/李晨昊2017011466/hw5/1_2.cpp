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

void run(int n) {
  i32 pid, nproc;
  f64 beg[2], elapsed[2];

  MPI_Init(nullptr, nullptr);
  MPI_Comm_rank(MPI_COMM_WORLD, &pid);
  MPI_Comm_size(MPI_COMM_WORLD, &nproc);

  u32 sq_nproc = sqrtf(nproc);
  if (sq_nproc * sq_nproc != nproc) {
    printf("nproc must be complete square number, but nproc= %d\n", nproc);
    exit(-1);
  }
  if (n % sq_nproc != 0) {
    printf("n must be divisible by sqrt(nproc), but n = %d, nproc= %d\n", n, nproc);
    exit(-1);
  }

  u32 each = n / sq_nproc;
  std::unique_ptr<f64[]> loc_mat(new f64[each * each]), vec(nullptr), ser_res;

  MPI_Datatype vec_t, block_t;
  MPI_Type_vector(each, each, n, MPI_DOUBLE, &vec_t);
  MPI_Type_create_resized(vec_t, 0, each * sizeof(f64), &block_t);
  MPI_Type_commit(&block_t);
  std::unique_ptr<i32[]> size(new i32[nproc]), off(new i32[nproc]);
  for (u32 i = 0; i < sq_nproc; ++i) {
    for (u32 j = 0; j < sq_nproc; ++j) {
      size[i * sq_nproc + j] = 1;
      off[i * sq_nproc + j] = i * n + j;
    }
  }

  std::unique_ptr<f64[]> mat(nullptr);
  if (pid == 0) {
    auto mat_vec = gen(n);
    ser_res = serial(mat_vec.first, mat_vec.second, n);
    mat = std::move(mat_vec.first);
    vec = std::move(mat_vec.second);
  } else {
    vec.reset(new f64[n]);
  }

  MPI_Barrier(MPI_COMM_WORLD);
  beg[0] = MPI_Wtime();

  MPI_Scatterv(mat.get(), size.get(), off.get(), block_t, loc_mat.get(), each * each, MPI_DOUBLE, 0, MPI_COMM_WORLD);
  MPI_Bcast(vec.get(), n, MPI_DOUBLE, 0, MPI_COMM_WORLD);

  MPI_Barrier(MPI_COMM_WORLD);
  beg[1] = MPI_Wtime();

  std::unique_ptr<f64[]> y(new f64[n]{});
  int vec_off = pid % sq_nproc * each, y_off = pid / sq_nproc * each;
  for (int i = 0; i < each; ++i) {
    f64 tmp = 0.0;
    for (int j = 0; j < each; ++j) {
      tmp += loc_mat[i * each + j] * vec[vec_off + j];
    }
    y[y_off + i] = tmp;
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

  MPI_Type_free(&block_t);
  MPI_Finalize();
}

i32 main(i32 argc, i8 **argv) {
  if (argc < 2) {
    printf("Usage: %s n\n", argv[0]);
    return -1;
  }
  run(atoi(argv[1]));
}