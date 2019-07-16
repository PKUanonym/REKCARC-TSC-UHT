#include <omp.h>
#include <pthread.h>
#include <atomic>
#include <cassert>
#include <chrono>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <memory>

using i8 = char;
using u8 = unsigned char;
using i32 = int;
using u32 = unsigned;
using u64 = unsigned long long;
using usize = std::size_t;
using f32 = float;
using f64 = double;

struct Mutex {
  pthread_mutex_t inner;
  Mutex() { pthread_mutex_init(&inner, nullptr); }
  Mutex(const Mutex &) = delete;
  Mutex &operator=(const Mutex &) = delete;
  void lock() { pthread_mutex_lock(&inner); }
  void unlock() { pthread_mutex_unlock(&inner); }
  ~Mutex() { pthread_mutex_destroy(&inner); }
};

struct CondVar {
  pthread_cond_t inner;
  CondVar() { pthread_cond_init(&inner, nullptr); }
  void wait(Mutex *mu) { pthread_cond_wait(&inner, &mu->inner); }
  void notify_one() { pthread_cond_signal(&inner); }
  void notify_all() { pthread_cond_broadcast(&inner); }
  ~CondVar() { pthread_cond_destroy(&inner); }
};

struct OmpMutex {
  omp_lock_t inner;
  OmpMutex() { omp_init_lock(&inner); }
  OmpMutex(const Mutex &) = delete;
  OmpMutex &operator=(const OmpMutex &) = delete;
  void lock() { omp_set_lock(&inner); }
  void unlock() { omp_unset_lock(&inner); }
  ~OmpMutex() { omp_destroy_lock(&inner); }
};

template <typename M>
struct Locker {
  M *inner;
  Locker(M *mu) : inner(mu) { inner->lock(); }
  Locker(const Locker &) = delete;
  Locker &operator=(const Locker &) = delete;
  ~Locker() { inner->unlock(); }
};