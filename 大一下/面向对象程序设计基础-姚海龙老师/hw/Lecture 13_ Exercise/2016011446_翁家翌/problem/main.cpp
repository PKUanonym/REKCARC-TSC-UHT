#include <cstdio>
#include <cstring>
#include "method.h"

int main(int argc, char const *argv[])
{
    //deal with command line
    if(argc != 2)
        return!puts("Please input \"./main kmp\" or \"./main kr\"");
    //choose algorithm
    MethodPtr method;
    if(strcmp(argv[1], "kmp") == 0)
        method = get_kmp_algo();
    else if(strcmp(argv[1], "kr") == 0)
        method = get_karp_rabin_algo();
    else return!printf("Backend %s not recognized!\n", argv[1]);

    //read data
    RawData rawdata;
    PatternData pattern;
    printf("Read Data ... ");
    rawdata.read();
    pattern.read();
    puts("Done!");

    //compute
    method->compute(rawdata,pattern);

    return 0;
}
