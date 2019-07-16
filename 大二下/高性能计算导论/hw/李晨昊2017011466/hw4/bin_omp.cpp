#include "util.hpp"

std::unique_ptr<f32[]> gen_data(u32 n, f32 min, f32 max) {
  std::unique_ptr<f32[]> ret(new f32[n]);
  for (u32 i = 0; i < n; ++i) {
    ret[i] = min + (max - min) * (f32(rand()) / RAND_MAX);
  }
  return ret;
}

i32 main() {
  u32 bin, n, th;
  f32 min, max;

  puts("Enter the number of bins");
  scanf("%d", &bin);
  puts("Enter the minimum measurement");
  scanf("%f", &min);
  puts("Enter the maximum measurement");
  scanf("%f", &max);
  puts("Enter the number of data");
  scanf("%d", &n);
  puts("Enter the number of threads");
  scanf("%d", &th);

  std::unique_ptr<u32[]> loc_cnt(new u32[bin * th]);
  std::unique_ptr<f32[]> data = gen_data(n, min, max);

#pragma omp parallel num_threads(th)
  {
#pragma omp for
    for (u32 tid = 0; tid < th; ++tid) {
      u32 beg = n / th * tid, end = (tid == th - 1) ? n : n / th * (tid + 1);
      u32 *x = loc_cnt.get() + bin * tid;
      memset(x, 0, bin * sizeof(u32));
      for (u32 i = beg; i < end; ++i) {
        ++x[u32((data[i] - min) / ((max - min) / bin))];
      }
    }
#pragma omp for
    for (u32 i = 0; i < bin; ++i) {
      u32 sum = 0;
      for (u32 j = 0; j < th; ++j) {
        sum += loc_cnt[j * bin + i];
      }
      loc_cnt[i] = sum;
    }
  }

  for (u32 i = 0; i < bin; ++i) {
    f32 loc_min = min + (max - min) / bin * i;
    f32 loc_max = min + (max - min) / bin * (i + 1);
    printf("%.3f-%.3f:\t", loc_min, loc_max);
    for (u32 j = 0; j < loc_cnt[i]; ++j) putchar('X');
    putchar('\n');
  }
}
