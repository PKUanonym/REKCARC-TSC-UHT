#include <algorithm>
#include "util.hpp"

void count(i32 *a, u32 n) {
  i32 *aux = (i32 *)malloc(n * sizeof(i32));
  for (u32 i = 0; i < n; ++i) {
    u32 cnt = 0;
    for (u32 j = 0; j < i; ++j) {
      cnt += a[j] <= a[i];
    }
    for (u32 j = i; j < n; ++j) {
      cnt += a[j] < a[i];
    }
    aux[cnt] = a[i];
  }
  memcpy(a, aux, n * sizeof(i32));
  free(aux);
}

void count_par(i32 *a, u32 n, u32 th) {
  i32 *aux = (i32 *)malloc(n * sizeof(i32));
#pragma omp parallel for num_threads(th)
  for (u32 i = 0; i < n; ++i) {
    u32 cnt = 0;
    for (u32 j = 0; j < i; ++j) {
      cnt += a[j] <= a[i];
    }
    for (u32 j = i; j < n; ++j) {
      cnt += a[j] < a[i];
    }
    aux[cnt] = a[i];
  }
  memcpy(a, aux, n * sizeof(i32));
  free(aux);
}

namespace detail {
i32 *a, *aux;
u32 n, th, each;
pthread_t *ths;
pthread_barrier_t calc, reduce[32];

void merge(i32 *first, i32 *mid, i32 *last, i32 *aux) {
  i32 *pos1 = first, *pos2 = mid, *pos = aux;
  while (pos1 != mid && pos2 != last) {
    i32 a = *pos1, b = *pos2;
    i32 cmp = b < a;
    *pos++ = cmp ? b : a;
    pos1 += cmp ^ 1, pos2 += cmp;
  }
  memcpy(pos, pos1, sizeof(i32) * (mid - pos1)), pos += mid - pos1;
  memcpy(first, aux, sizeof(i32) * (pos - aux));
}

void *thread_fn(void *_tid) {
  u32 tid = (u32)(usize)_tid;
  u32 beg = each * tid, end = (tid == th - 1) ? n : each * (tid + 1);
  i32 *a_off = a + beg, *aux_off = aux + beg;
  for (u32 i = beg; i < end; ++i) {
    u32 cnt = 0;
    for (u32 j = beg; j < i; ++j) {
      cnt += a[j] <= a[i];
    }
    for (u32 j = i; j < end; ++j) {
      cnt += a[j] < a[i];
    }
    aux_off[cnt] = a[i];
  }
  memcpy(a_off, aux_off, sizeof(i32) * (end - beg));
  pthread_barrier_wait(&calc);
  for (u32 i = 0; tid + (1 << i) < th && !(tid >> i & 1); ++i) {
    u32 right_tid = tid + (1 << (i + 1));
    u32 right = (right_tid >= th) ? n : each * right_tid;
    merge(a_off, a_off + (each << i), a + right, aux_off);
    pthread_barrier_wait(&reduce[i]);
  }
  return nullptr;
}
}  // namespace detail

void count_llx(i32 *a, u32 n, u32 th) {
  detail::a = a;
  detail::aux = (i32 *)malloc(n * sizeof(i32));
  detail::n = n;
  detail::th = th;
  detail::each = n / th;
  pthread_barrier_init(&detail::calc, nullptr, th);
  u32 reduce_idx = 0;
  for (u32 i = th; i != 1; ++reduce_idx, i = (i + 1) >> 1) {
    pthread_barrier_init(&detail::reduce[reduce_idx], nullptr, i >> 1);
  }
  detail::ths = (pthread_t *)malloc(th * sizeof(pthread_t));
  for (usize i = 0; i < th; ++i) {
    pthread_create(&detail::ths[i], nullptr, detail::thread_fn, (void *)i);
  }
  for (u32 i = 0; i < th; ++i) {
    pthread_join(detail::ths[i], nullptr);
  }
  free(detail::ths);
  pthread_barrier_destroy(&detail::calc);
  for (u32 i = 0; i < reduce_idx; ++i) {
    pthread_barrier_destroy(&detail::reduce[i]);
  }
  free(detail::aux);
}

void radix(i32 *_a, u32 n) {
  const u32 U = 256;
  u32 cnt[U], *a = (u32 *)_a;
  u32 *aux = (u32 *)malloc(n * sizeof(u32));
  memset(cnt, 0, sizeof cnt);
  for (u32 i = 0; i < n; ++i) ++cnt[a[i] & U - 1];
  for (u32 i = 1; i < U; ++i) cnt[i] += cnt[i - 1];
  for (u32 i = n - 1; ~i; --i) aux[--cnt[a[i] & U - 1]] = a[i];
  memset(cnt, 0, sizeof cnt);
  for (u32 i = 0; i < n; ++i) ++cnt[aux[i] >> 8 & U - 1];
  for (u32 i = 1; i < U; ++i) cnt[i] += cnt[i - 1];
  for (u32 i = n - 1; ~i; --i) a[--cnt[aux[i] >> 8 & U - 1]] = aux[i];
  memset(cnt, 0, sizeof cnt);
  for (u32 i = 0; i < n; ++i) ++cnt[a[i] >> 16 & U - 1];
  for (u32 i = 1; i < U; ++i) cnt[i] += cnt[i - 1];
  for (u32 i = n - 1; ~i; --i) aux[--cnt[a[i] >> 16 & U - 1]] = a[i];
  memset(cnt, 0, sizeof cnt);
  for (u32 i = 0; i < n; ++i) ++cnt[aux[i] >> 24 & U - 1];
  // notice this loop
  for (u32 i = U / 2 + 1; i < U + U / 2; ++i) cnt[i & U - 1] += cnt[(i - 1) & U - 1];
  for (u32 i = n - 1; ~i; --i) a[--cnt[aux[i] >> 24 & U - 1]] = aux[i];
  free(aux);
}

i32 main(i32 argc, i8 **argv) {
  if (argc < 3) {
    printf("usage: %s [algo] [n] <th>\n", argv[0]);
    puts("algo: 0 => count, 1 => count_par, 2 => count_llx, 3 => qsort, 4 => std::sort, 5 => radix");
    exit(1);
  }
  u32 algo = atoi(argv[1]);
  u32 n = atoi(argv[2]);
  std::unique_ptr<i32[]> a(new i32[n]);
  for (u32 i = 0; i < n; ++i) {
    a[i] = rand();
  }

  auto now = std::chrono::high_resolution_clock::now;
  auto beg = now();
  switch (algo) {
    case 0:
      count(a.get(), n);
      break;
    case 1:
      count_par(a.get(), n, argc == 4 ? atoi(argv[3]) : omp_get_max_threads());
      break;
    case 2:
      count_llx(a.get(), n, argc == 4 ? atoi(argv[3]) : omp_get_max_threads());
      break;
    case 3:
      // this may overflow in a general case
      // but rand() always return a integer in [0, RAND_MAX], so no problem here
      qsort(a.get(), n, sizeof(i32), [](const void *l, const void *r) { return *(i32 *)l - *(i32 *)r; });
      break;
    case 4:
      std::sort(a.get(), a.get() + n);
      break;
    case 5:
      radix(a.get(), n);
      break;
    default:
      printf("invalid algo type:%d", algo);
      exit(1);
      break;
  }
  printf("%.5f\n", std::chrono::duration<f32>(now() - beg).count());
  assert(std::is_sorted(a.get(), a.get() + n));
}
