#include "util.hpp"

const u32 MAX_MSG = 100;
Mutex mu;
bool ok;
i8 msg[MAX_MSG];

void *thread_fn(void *_tid) {
  usize tid = (usize)_tid;
  if (tid % 2 == 0) {  // prod
    while (true) {
      Locker<Mutex> _lk(&mu);
      if (!ok) {
        sprintf(msg, "hello world from tid = %lu", tid);
        ok = true;
        break;
      }
    }
  } else {  // cons
    while (true) {
      Locker<Mutex> _lk(&mu);
      if (ok) {
        printf("%lu: get msg: %s\n", tid, msg);
        ok = false;
        break;
      }
    }
  }
  return nullptr;
}

i32 main(i32 argc, i8 **argv) {
  u32 n;
  if (argc < 2 || (n = atoi(argv[1])) == 0 || n % 2 == 1) {
    printf("usage %s [thread count](positive even)\n", argv[0]);
    exit(-1);
  }

  Mutex mu;
  std::unique_ptr<i8[]> msg;
  std::unique_ptr<pthread_t[]> ths(new pthread_t[n]);

  for (usize i = 0; i < n; ++i) {
    pthread_create(&ths[i], nullptr, thread_fn, (void *)i);
  }

  for (u32 i = 0; i < n; ++i) {
    pthread_join(ths[i], nullptr);
  }
}