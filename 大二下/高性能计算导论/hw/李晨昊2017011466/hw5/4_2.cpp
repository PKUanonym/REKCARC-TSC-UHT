#include <queue>
#include "util.hpp"

template <typename T>
struct ThreadPool {
  std::unique_ptr<pthread_t[]> ths;
  u32 n;
  std::atomic<bool> no_more;
  Mutex mu;
  CondVar cv;
  std::queue<T> q;

  static void *task(void *arg) {
    ThreadPool *self = (ThreadPool *)arg;
    while (true) {
      self->mu.lock();
      // Mesa monitor
      while (self->q.empty() && !self->no_more) {
        self->cv.wait(&self->mu);
      }
      if (self->q.empty()) {  // no more
        self->mu.unlock();
        break;
      }
      T t = self->q.front();
      self->q.pop();
      self->mu.unlock();
      t();
    }
    return nullptr;
  }

  ThreadPool(u32 n) : ths(new pthread_t[n]), n(n), no_more(false) {
    for (u32 i = 0; i < n; ++i) {
      pthread_create(&ths[i], nullptr, task, this);
    }
  }

  // this will wait until all tasks are finished
  ~ThreadPool() {
    no_more = true;
    cv.notify_all();
    for (u32 i = 0; i < n; ++i) {
      pthread_join(ths[i], nullptr);
    }
  }

  void push(T t) {
    mu.lock();
    q.push(t);
    cv.notify_one();
    mu.unlock();
  }
};

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

u32 n;
std::pair<std::unique_ptr<f64[]>, std::unique_ptr<u32[]>> pr;
std::unique_ptr<f64[]> s;

struct Op {
  u32 beg, end;
  void operator()() {
    for (u32 i = beg; i < end; ++i) {
      f64 x = 0;
      u32 b = pr.second[i];
      for (u32 j = 0; j < b; ++j) {
        x += pr.first[i * n + j];
      }
      s[i] = x / b;
    }
  }
};

i32 main(i32 argc, i8 **argv) {
  if (argc != 4) {
    printf("usage: %s [n] [th] [blk]\n", argv[0]);
    exit(1);
  }
  n = atoi(argv[1]);
  u32 th = atoi(argv[2]);
  u32 blk = atoi(argv[3]);
  pr = gen(n);
  s.reset(new f64[n]);
  auto now = std::chrono::high_resolution_clock::now;
  auto beg = now();
  {
    ThreadPool<Op> pool(th);
    u32 i = 0;
    for (; i + blk <= n; i += blk) {
      pool.push(Op{i, i + blk});
    }
    if (i != n) {
      pool.push(Op{i, n});
    }
  }
  printf("%.5f\n", std::chrono::duration<f64>(now() - beg).count());
}