#include "util.hpp"

usize seq_fib(usize n) {
  if (n <= 2) {
    return 1;
  }
  return seq_fib(n - 1) + seq_fib(n - 2);
}

OmpMutex mu;
u32 remain;

usize par_fib(usize n) {
  if (n <= 20) {
    return seq_fib(n);
  }
  bool spawn = false;
  {
    Locker<OmpMutex> _lk(&mu);
    if (remain) {
      --remain;
      spawn = true;
    }
  }
  if (spawn) {
    usize lres, rres;
#pragma omp parallel sections
    {
#pragma omp section
      lres = par_fib(n - 1);
#pragma omp section
      rres = par_fib(n - 2);
    }
    {
      Locker<OmpMutex> _lk(&mu);
      ++remain;
    }
    return lres + rres;
  } else {
    return par_fib(n - 1) + par_fib(n - 2);
  }
}

i32 main(i32 argc, i8 **argv) {
  if (argc < 3) {
    printf("usage %s [n] [th]\n", argv[0]);
    exit(-1);
  }
  usize n = atoi(argv[1]);
  remain = atoi(argv[2]);

  using namespace std::chrono;
  auto now = high_resolution_clock::now;

  auto beg = now();

  omp_set_dynamic(1);
  omp_set_nested(1);
  usize res = par_fib(n);

  printf("par res: %lu\n", res);
  printf("par time: %.3f\n", duration<f32>(now() - beg).count());

  beg = now();
  printf("seq res: %lu\n", seq_fib(n));
  printf("seq time: %.3f\n", duration<f32>(now() - beg).count());
}