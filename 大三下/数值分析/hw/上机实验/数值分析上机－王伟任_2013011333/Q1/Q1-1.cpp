#include <cstdio>
#include <time.h>

int main(){
    float s2, s1 = 0.0;
    float adder;
    long i = 0;
    time_t start, finish;
    start = clock();
    do{
        i++;
        adder = 1.0 / i;
        s2 = s1;
        s1 = s2 + adder;
    } while(s1 != s2);
    finish = clock();
    printf("Answer is %ld\n", i);
    printf("The summary is %f\n", s1); 
    printf("Time cost: %ld\n", finish - start);
    return 0;
}
