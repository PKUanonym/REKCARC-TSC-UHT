#include <assert.h>
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>

#define ALL (10000000)
#define THREAD_NUM (4)
#define EACH (ALL / THREAD_NUM)

volatile intptr_t sum;
volatile intptr_t flag;

void *inc(void *_tid) {
  intptr_t tid = (intptr_t)_tid;
  for (int i = 0; i < EACH; ++i) {
    while (flag != tid)
      ;
    ++sum;
    flag = (flag + 1) % THREAD_NUM;
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

// void *hello(void *_) {
//   printf("hello world from %ld\n", (long)(_));
//   return NULL;
// }

// int main() {
//   pthread_t ths[10];
//   for (long i = 0; i < 10; ++i) {
//     pthread_create(&ths[i], NULL, hello, (void *)i);
//   }
//   for (long i = 0; i < 10; ++i) {
//     pthread_join(ths[i], NULL);
//   }
// }

//  intptr_t val1, val2;

// void *f1(void *_) {
//   val1 = 1;
//   return (void *)val2;
// }

// void *f2(void *_) {
//   val2 = 1;
//   return (void *)val1;
// }

// int main() {
//   int fail = 0;
//   for (int i = 0; i < 1000000; ++i) {
//     val1 = val2 = 0;
//     pthread_t th1, th2;
//     intptr_t ret1, ret2;
//     pthread_create(&th1, NULL, f1, NULL);
//     pthread_create(&th2, NULL, f2, NULL);
//     pthread_join(th1, (void **)&ret1);
//     pthread_join(th2, (void **)&ret2);
//     fail += (ret1 + ret2 == 0);
//   }
//   printf("%d/%d\n", fail, 1000000);
// }

// volatile bool val;

// void f1() {
//   sleep(1);
//   val = true;
//   while (true)
//     ;
// }

// void f2() {
//   while (!val)
//     ;
//   puts("thread 2 exit!");
// }

// int main() {
//   bool val = false;

//   std::thread th1(f1);
//   std::thread th2(f2);
//   // std::thread th1([&] {
//   //   sleep(1);
//   //   val = true;
//   //   while (true)
//   //     ;
//   // });
//   // std::thread th2([&] {
//   //   while (!val)
//   //     ;
//   //   puts("thread 2 exit!");
//   // });

//   th1.join();
//   th2.join();
// }