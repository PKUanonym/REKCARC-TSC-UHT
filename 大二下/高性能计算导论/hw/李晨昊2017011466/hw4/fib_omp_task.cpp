#include "util.hpp"

usize seq_fib(usize n) {
  if (n <= 2) {
    return 1;
  }
  return seq_fib(n - 1) + seq_fib(n - 2);
}

usize par_fib(usize n) {
  if (n <= 20) {
    return seq_fib(n);
  }
  usize lres, rres;
#pragma omp task shared(lres)
  lres = par_fib(n - 1);
#pragma omp task shared(rres)
  rres = par_fib(n - 2);
#pragma omp taskwait
  return lres + rres;
}

i32 main(i32 argc, i8 **argv) {
  if (argc < 3) {
    printf("usage %s [n] [th]\n", argv[0]);
    exit(-1);
  }
  usize n = atoi(argv[1]);

  using namespace std::chrono;
  auto now = high_resolution_clock::now;

  auto beg = now();

  usize res;
#pragma omp parallel num_threads(atoi(argv[2]) + 1)
#pragma omp single
  res = par_fib(n);

  printf("par res: %lu\n", res);
  printf("par time: %.3f\n", duration<f32>(now() - beg).count());

  beg = now();
  printf("seq res: %lu\n", seq_fib(n));
  printf("seq time: %.3f\n", duration<f32>(now() - beg).count());
}