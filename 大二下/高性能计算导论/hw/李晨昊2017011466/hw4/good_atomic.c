#include <assert.h>
#include <pthread.h>
#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>

#define ALL (10000000)
#define THREAD_NUM (4)
#define EACH (ALL / THREAD_NUM)

intptr_t sum;
_Atomic intptr_t flag;

void *inc(void *_tid) {
  intptr_t tid = (intptr_t)_tid;
  for (int i = 0; i < EACH; ++i) {
    while (atomic_load_explicit(&flag, memory_order_acquire) != tid)
      ;
    ++sum;
    intptr_t new_flag = atomic_load_explicit(&flag, memory_order_relaxed);
    new_flag = (new_flag + 1) % THREAD_NUM;
    atomic_store_explicit(&flag, new_flag, memory_order_release);
  }
  return NULL;
}

int main() {
  pthread_t th[THREAD_NUM];
  for (intptr_t i = 0; i < THREAD_NUM; ++i) {
    pthread_create(&th[i], NULL, inc, (void *)i);
  }
  for (intptr_t i = 0; i < THREAD_NUM; ++i) {
    pthread_join(th[i], NULL);
  }
  printf("%ld %d\n", sum, ALL);
}