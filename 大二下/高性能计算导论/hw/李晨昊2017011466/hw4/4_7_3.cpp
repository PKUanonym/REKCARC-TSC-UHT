#include "util.hpp"

const u32 MAX_MSG = 100;
Mutex mu;
bool ok;
i8 msg[MAX_MSG];
u32 recv, n;

void *thread_fn(void *_tid) {
  usize tid = (usize)_tid;
  bool sended = false, recved = false;
  while (!sended || !recved) {
    Locker<Mutex> _lk(&mu);
    if (ok) {
      if (!recved && recv == tid) {
        printf("%lu: get msg: %s\n", tid, msg);
        ok = false;
        recved = true;
      }
    } else if (!sended) {
      sprintf(msg, "hello world from tid = %lu", tid);
      ok = true;
      sended = true;
      recv = (tid + 1) % n;
    }
  }
  return nullptr;
}

i32 main(i32 argc, i8 **argv) {
  if (argc < 2 || (n = atoi(argv[1])) == 0) {
    printf("usage %s [thread count](positive)\n", argv[0]);
    exit(-1);
  }
  std::unique_ptr<pthread_t[]> ths(new pthread_t[n]);
  for (usize i = 0; i < n; ++i) {
    pthread_create(&ths[i], nullptr, thread_fn, (void *)i);
  }
  for (u32 i = 0; i < n; ++i) {
    pthread_join(ths[i], nullptr);
  }
}