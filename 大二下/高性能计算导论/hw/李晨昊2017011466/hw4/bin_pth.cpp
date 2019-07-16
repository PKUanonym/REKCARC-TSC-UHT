#include "util.hpp"

u32 bin, n, th;
f32 min, max;
std::unique_ptr<u32[]> loc_cnt;
std::unique_ptr<f32[]> data;
pthread_barrier_t calc, reduce[32];

std::unique_ptr<f32[]> gen_data(u32 n, f32 min, f32 max) {
  std::unique_ptr<f32[]> ret(new f32[n]);
  for (u32 i = 0; i < n; ++i) {
    ret[i] = min + (max - min) * (f32(rand()) / RAND_MAX);
  }
  return ret;
}

void *thread_fn(void *_tid) {
  usize tid = (usize)_tid;
  u32 beg = n / th * tid, end = (tid == th - 1) ? n : n / th * (tid + 1);
  u32 *x = loc_cnt.get() + bin * tid;
  memset(x, 0, bin * sizeof(u32));
  for (u32 i = beg; i < end; ++i) {
    ++x[u32((data[i] - min) / ((max - min) / bin))];
  }
  pthread_barrier_wait(&calc);

  for (u32 i = 0; tid + (1 << i) < th && !(tid >> i & 1); ++i) {
    u32 *y = x + (bin << i);
    for (u32 j = 0; j < bin; ++j) {
      x[j] += y[j];
    }
    pthread_barrier_wait(&reduce[i]);
  }
  return nullptr;
}

i32 main() {
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

  data = gen_data(n, min, max);
  loc_cnt.reset(new u32[bin * th]);

  std::unique_ptr<pthread_t[]> ths(new pthread_t[th]);

  pthread_barrier_init(&calc, nullptr, th);
  for (u32 i = th, idx = 0; i != 1; ++idx, i = (i + 1) >> 1) {
    pthread_barrier_init(&reduce[idx], nullptr, i >> 1);
  }
  for (usize i = 0; i < th; ++i) {
    pthread_create(&ths[i], nullptr, thread_fn, (void *)i);
  }
  for (u32 i = 0; i < th; ++i) {
    pthread_join(ths[i], nullptr);
  }
  
  for (u32 i = 0; i < bin; ++i) {
    f32 loc_min = min + (max - min) / bin * i;
    f32 loc_max = min + (max - min) / bin * (i + 1);
    printf("%.3f-%.3f:\t", loc_min, loc_max);
    for (u32 j = 0; j < loc_cnt[i]; ++j) putchar('X');
    putchar('\n');
  }
#ifdef CHECK_SUM
  u32 sum = 0;
  for (u32 i = 0; i < bin; ++i) {
    sum += loc_cnt[i];
  }
  assert(sum == n);
#endif
}
