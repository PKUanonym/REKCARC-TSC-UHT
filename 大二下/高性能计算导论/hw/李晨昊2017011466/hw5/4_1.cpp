#include "util.hpp"

struct XorShiftRNG {
  u32 seed;

  f64 gen_f64() {
    seed ^= seed << 13;
    seed ^= seed >> 17;
    seed ^= seed << 5;
    return seed * (1.0 / -1u);
  }

  u32 gen_u32() {
    seed ^= seed << 13;
    seed ^= seed >> 17;
    seed ^= seed << 5;
    return seed;
  }
};

std::pair<std::unique_ptr<f64[]>, std::unique_ptr<u32[]>> gen(u32 n) {
  std::unique_ptr<f64[]> a(new f64[n * n]);
  std::unique_ptr<u32[]> b(new u32[n]);
  XorShiftRNG rng{u32(time(nullptr))};
  for (u32 i = 0; i < n; ++i) {
    for (u32 j = 0; j < n; ++j) {
      a[i * n + j] = rng.gen_f64();
    }
  }
  for (u32 i = 0; i < n; ++i) {
    b[i] = rng.gen_u32() % n + 1;
  }
  return {std::move(a), std::move(b)};
}

i32 main(i32 argc, i8** argv) {
  if (argc != 3) {
    printf("usage: %s [n] [th]\n", argv[0]);
    exit(1);
  }
  u32 n = atoi(argv[1]);
  u32 th = atoi(argv[2]);
  auto pr = gen(n);
  std::unique_ptr<f64[]> s(new f64[n]);
  auto now = std::chrono::high_resolution_clock::now;
  auto beg = now();
#pragma omp parallel for schedule(runtime) num_threads(th)
  for (u32 i = 0; i < n; ++i) {
    f64 x = 0;
    u32 b = pr.second[i];
    for (u32 j = 0; j < b; ++j) {
      x += pr.first[i * n + j];
    }
    s[i] = x / b;
  }
  printf("%.5f\n", std::chrono::duration<f64>(now() - beg).count());
}