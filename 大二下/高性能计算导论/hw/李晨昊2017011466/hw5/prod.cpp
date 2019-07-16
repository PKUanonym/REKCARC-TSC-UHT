#include <x86intrin.h>
#include <chrono>
#include <cstdio>
#include <memory>

using f64 = double;
using u32 = unsigned;
using f64x4 = __m256d;

f64 dot(f64 *a, f64 *b, int n) {
  f64x4 ymm0 = _mm256_setzero_pd();
  f64x4 ymm1 = _mm256_setzero_pd();
  f64x4 ymm2 = _mm256_setzero_pd();
  f64x4 ymm3 = _mm256_setzero_pd();
  f64x4 ymm4, ymm5, ymm6, ymm7;
  for (int i = 0; i < n; i += 32) {
    ymm4 = _mm256_loadu_pd(a + i + 0);
    ymm5 = _mm256_loadu_pd(a + i + 4);
    ymm6 = _mm256_loadu_pd(a + i + 8);
    ymm7 = _mm256_loadu_pd(a + i + 12);
    ymm4 = _mm256_fmadd_pd(ymm4, _mm256_loadu_pd(b + i + 0), ymm0);
    ymm5 = _mm256_fmadd_pd(ymm5, _mm256_loadu_pd(b + i + 4), ymm1);
    ymm6 = _mm256_fmadd_pd(ymm6, _mm256_loadu_pd(b + i + 8), ymm2);
    ymm7 = _mm256_fmadd_pd(ymm7, _mm256_loadu_pd(b + i + 12), ymm3);
    ymm0 = _mm256_loadu_pd(a + i + 16);
    ymm1 = _mm256_loadu_pd(a + i + 20);
    ymm2 = _mm256_loadu_pd(a + i + 24);
    ymm3 = _mm256_loadu_pd(a + i + 28);
    ymm0 = _mm256_fmadd_pd(ymm0, _mm256_loadu_pd(b + i + 16), ymm4);
    ymm1 = _mm256_fmadd_pd(ymm1, _mm256_loadu_pd(b + i + 20), ymm5);
    ymm2 = _mm256_fmadd_pd(ymm2, _mm256_loadu_pd(b + i + 24), ymm6);
    ymm3 = _mm256_fmadd_pd(ymm3, _mm256_loadu_pd(b + i + 28), ymm7);
  }
  ymm0 = _mm256_add_pd(ymm0, ymm2);
  ymm1 = _mm256_add_pd(ymm1, ymm3);
  ymm0 = _mm256_add_pd(ymm0, ymm1);
  f64 sum[4];
  _mm256_store_pd(sum, ymm0);
  return sum[0] + sum[1] + sum[2] + sum[3];
}

std::unique_ptr<double[]> prod(const std::unique_ptr<double[]> &mat, const std::unique_ptr<double[]> &vec, int n) {
  std::unique_ptr<double[]> ret(new double[n]);
  for (int i = 0; i < n; ++i) {
    ret[i] = dot(&mat[i * n], &vec[0], n);
  }
  return ret;
}

struct XorShiftRNG {
  u32 seed;

  XorShiftRNG(u32 seed) : seed(seed ? seed : 1) {}

  f64 gen() {
    seed ^= seed << 13;
    seed ^= seed >> 17;
    seed ^= seed << 5;
    return seed * (1.0 / -1u);
  }
};

int main(int argc, char **argv) {
  int N = atoi(argv[1]);
  std::unique_ptr<double[]> mat(new double[N * N]);
  std::unique_ptr<double[]> vec(new double[N]);

  XorShiftRNG rng{19260817};
  for (int i = 0; i < N; ++i) {
    for (int j = 0; j < N; ++j) {
      mat[i * N + j] = rng.gen();
    }
  }
  for (int i = 0; i < N; ++i) {
    vec[i] = rng.gen();
  }
  using namespace std::chrono;
  auto now = high_resolution_clock::now;
  auto beg = now();
  auto c = prod(mat, vec, N);
  printf("%f\n", duration<f64>(now() - beg).count());
}
