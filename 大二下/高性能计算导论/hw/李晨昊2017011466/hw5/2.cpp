#include <algorithm>
#include <list>
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

Mutex mu;
std::list<u32> lst;

struct ListOp {
  u32 ty, val;

  void operator()() {
    Locker<Mutex> _lk(&mu);
    switch (ty) {
      case 0:
      case 1:
        printf("insert %d\n", val);
        lst.push_back(val);
        break;
      case 2: {
        auto it = std::find(lst.begin(), lst.end(), val);
        if (it != lst.end()) {
          lst.erase(it);
          printf("remove %d succeed\n", val);
        } else {
          printf("remove %d fail\n", val);
        }
      } break;
      case 3: {
        auto it = std::find(lst.begin(), lst.end(), val);
        if (it != lst.end()) {
          printf("find %d succeed\n", val);
        } else {
          printf("find %d fail\n", val);
        }
      } break;
      case 4:
        printf("display [");
        for (u32 x : lst) {
          printf("%d, ", x);
        }
        printf("]\n");
        break;
      default:
        __builtin_unreachable();
    }
  }
};

i32 main(i32 argc, i8 **argv) {
  if (argc != 3) {
    printf("usage: %s [th] [task]\n", argv[0]);
    exit(1);
  }
  u32 th = atoi(argv[1]);
  u32 task = atoi(argv[2]);
  ThreadPool<ListOp> pool(th);
  for (u32 i = 0; i < task; ++i) {
    pool.push({u32(rand()) % 5, u32(rand()) % 1000});
  }
}