#include <stdlib.h>
#include <stdio.h>
#include <getopt.h>
#include <string>
#include <cstring>

#include "CycleTimer.h"

double cudaFindRepeats(int *input, int length, int *output, int *output_length); 
double cudaScan(int* start, int* end, int* resultarray);
double cudaScanThrust(int* start, int* end, int* resultarray);
void printCudaInfo();


void usage(const char* progname) {
    printf("Usage: %s [options]\n", progname);
    printf("Program Options:\n");
    printf("  -m  --test <TYPE>      Run specified function on input.  Valid tests are: scan, find_repeats\n"); 
    printf("  -i  --input <NAME>     Run test on given input type. Valid inputs  are: test1, random\n");
    printf("  -n  --arraysize <INT>  Number of elements in arrays\n");
    printf("  -t  --thrust           Use Thrust library implementation\n");
    printf("  -?  --help             This message\n");
}

void cpu_exclusive_scan(int* start, int* end, int* output)
{
#ifdef PARALLEL
    int N = end - start;
    memmove(output, start, N*sizeof(int));

    // upsweep phase
    for (int twod = 1; twod < N; twod*=2)
    {
        int twod1 = twod*2;
        // parallel
        for (int i = 0; i < N; i += twod1)
        {
            output[i+twod1-1] += output[i+twod-1];
        }
    }
    output[N-1] = 0;

    // downsweep phase
    for (int twod = N/2; twod >= 1; twod /= 2)
    {
        int twod1 = twod*2;
        // parallel
        for (int i = 0; i < N; i += twod1)
        {
            int tmp = output[i+twod-1];
            output[i+twod-1] = output[i+twod1-1];
            output[i+twod1-1] += tmp;
        }
    }
#endif
    int N = end - start;
    output[0] = 0;
    for (int i = 1; i < N; i++)
    {
        output[i] = output[i-1] + start[i-1];
    }
}

int cpu_find_repeats(int *start, int length, int *output){
    int count = 0, idx = 0;
    while(idx < length - 1){ 
        if(start[idx] == start[idx + 1]){
            output[count] = idx;
            count++;
        }   
        idx++;
    }   
    return count;
}


int main(int argc, char** argv)
{
    int N = 64;
    bool useThrust = false;
    std::string test; 
    std::string input;

    // parse commandline options ////////////////////////////////////////////
    int opt;
    static struct option long_options[] = {
        {"test",       1, 0, 'm'},
        {"arraysize",  1, 0, 'n'},
        {"input",      1, 0, 'i'},
        {"help",       0, 0, '?'},
        {"thrust",     0, 0, 't'},
        {0 ,0, 0, 0}
    };

    while ((opt = getopt_long(argc, argv, "m:n:i:?t", long_options, NULL)) != EOF) {
        switch (opt) {
        case 'm':
            test = optarg; 
            break;
        case 'n':
            N = atoi(optarg);
            break;
        case 'i':
            input = optarg;
            break;
        case 't':
            useThrust = true;
            break;
        case '?':
        default:
            usage(argv[0]);
            return 1;
        }
    }
    // end parsing of commandline options //////////////////////////////////////

    int* inarray = new int[N];
    int* resultarray = new int[N];
    int* checkarray = new int[N];

    if (input.compare("random") == 0) {

        srand(time(NULL));

        // generate random array
        for (int i = 0; i < N; i++) {
            int val = rand() % 10;
            inarray[i] = val;
            checkarray[i] = val;
        }
    } else {
        //fixed test case - you may find this useful for debugging
        for(int i = 0; i < N; i++) {
            inarray[i] = 1;
            checkarray[i] = 1;
        }  
    }

    printCudaInfo();

    double cudaTime = 50000.;

    if (test.compare("scan") == 0) { // test exclusive scan
        // run CUDA implementation
        for (int i=0; i<3; i++) {
            if (useThrust)
                cudaTime = std::min(cudaTime, cudaScanThrust(inarray, inarray+N, resultarray));
            else
                cudaTime = std::min(cudaTime, cudaScan(inarray, inarray+N, resultarray));
        }

        // run CPU implementation to check correctness
        cpu_exclusive_scan(inarray, inarray+N, checkarray);

        if (useThrust) { 
            printf("Thrust GPU time: %.3f ms\n", 1000.f * cudaTime);
        } else {    
            printf("GPU_time: %.3f ms\n", 1000.f * cudaTime);
        } 

        // validate results
        for (int i = 0; i < N; i++)
        {
            if(checkarray[i] != resultarray[i])
            {
                fprintf(stderr,
                        "Error: Device exclusive_scan outputs incorrect result."
                        " A[%d] = %d, expecting %d.\n",
                        i, resultarray[i], checkarray[i]);
                exit(1);
            }
        }
        printf("Scan outputs are correct!\n");
    } else if (test.compare("find_repeats") == 0) { // Test find_repeats
        
        // run CUDA implementation
        int cu_size;
        for (int i=0; i<3; i++) {
            cudaTime = std::min(cudaTime,
                            cudaFindRepeats(inarray, N, resultarray, &cu_size));
        }

        // run CPU implementation to check correctness 
        int serial_size = cpu_find_repeats(inarray, N, checkarray);

        printf("GPU_time: %.3f ms\n", 1000.f * cudaTime);

        // validate results
        if(serial_size != cu_size){
            fprintf(stderr,
                    "Error: Device find_repeats outputs incorrect size. "
                    "Expected %d, got %d.\n",
                    serial_size, cu_size);
            exit(1);
        }
        for (int i = 0; i < serial_size; i++)
        {
            if(checkarray[i] != resultarray[i])
            {
                fprintf(stderr,
                        "Error: Device find_repeats outputs incorrect result."
                        " A[%d] = %d, expecting %d.\n",
                        i, resultarray[i], checkarray[i]);
                exit(1);
            }
        }
        printf("Find_repeats outputs are correct!\n");

    } else { 
        usage(argv[0]); 
        exit(1); 
    }
    delete[] inarray;
    delete[] resultarray;
    delete[] checkarray;
    return 0;
}
