#include "util.hpp"

Mutex mu;
u32 remain;

usize seq_fib(usize n) {
  if (n <= 2) {
    return 1;
  }
  return seq_fib(n - 1) + seq_fib(n - 2);
}

void *par_fib(void *_n) {
  usize n = (usize)_n;
  if (n <= 20) {
    return (void *)seq_fib(n);
  }
  bool spawn = false;
  {
    Locker<Mutex> _lk(&mu);
    if (remain) {
      --remain;
      spawn = true;
    }
  }

  if (spawn) {
    pthread_t r;
    usize rres;
    pthread_create(&r, nullptr, par_fib, (void *)(n - 2));
    usize lres = (usize)par_fib((void *)(n - 1));
    pthread_join(r, (void **)&rres);
    {
      Locker<Mutex> _lk(&mu);
      ++remain;
    }
    return (void *)(lres + rres);
  } else {
    return (void *)((usize)par_fib((void *)(n - 1)) + (usize)par_fib((void *)(n - 2)));
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
  printf("par res: %lu\n", (usize)par_fib((void *)n));
  printf("par time: %.3f\n", duration<f32>(now() - beg).count());

  beg = now();
  printf("seq res: %lu\n", seq_fib(n));
  printf("seq time: %.3f\n", duration<f32>(now() - beg).count());
}