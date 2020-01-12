#include "util.hpp"

const u32 MAX_MSG = 100;
Mutex mu;
bool ok;
i8 msg[MAX_MSG];

void* cons(void*) {
  while (true) {
    Locker<Mutex> _lk(&mu);
    if (ok) {
      printf("get msg %s\n", msg);
      break;
    }
  }
  return nullptr;
}

void* prod(void*) {
  Locker<Mutex> _lk(&mu);
  strcpy(msg, "hello world!");
  ok = true;
  return nullptr;
}

i32 main() {
  pthread_t cons, prod;
  pthread_create(&cons, nullptr, ::cons, nullptr);
  pthread_create(&prod, nullptr, ::prod, nullptr);

  pthread_join(cons, nullptr);
  pthread_join(prod, nullptr);
}