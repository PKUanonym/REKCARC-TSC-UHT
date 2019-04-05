#include <stdlib.h>
#include <stdio.h>
#include <getopt.h>
#include <string>

void saxpyCuda(int N, float alpha, float* x, float* y, float* result);
void printCudaInfo();


// return GB/s
float toBW(int bytes, float sec) {
  return static_cast<float>(bytes) / (1024. * 1024. * 1024.) / sec;
}


void usage(const char* progname) {
    printf("Usage: %s [options]\n", progname);
    printf("Program Options:\n");
    printf("  -n  --arraysize <INT>  Number of elements in arrays\n");
    printf("  -?  --help             This message\n");
}


int main(int argc, char** argv)
{

    int N = 20 * 1000 * 1000;

    // parse commandline options ////////////////////////////////////////////
    int opt;
    static struct option long_options[] = {
        {"arraysize",  1, 0, 'n'},
        {"help",       0, 0, '?'},
        {0 ,0, 0, 0}
    };

    while ((opt = getopt_long(argc, argv, "?n:", long_options, NULL)) != EOF) {

        switch (opt) {
        case 'n':
            N = atoi(optarg);
            break;
        case '?':
        default:
            usage(argv[0]);
            return 1;
        }
    }
    // end parsing of commandline options //////////////////////////////////////

    const float alpha = 2.0f;
    float* xarray = new float[N];
    float* yarray = new float[N];
    float* resultarray = new float[N];

    // load X, Y, store result
    for (int i=0; i<N; i++) {
        xarray[i] = yarray[i] = i % 10;
        resultarray[i] = 0.f;
   }

    printCudaInfo();

    for (int i=0; i<3; i++) {
      saxpyCuda(N, alpha, xarray, yarray, resultarray);
    }

    delete [] xarray;
    delete [] yarray;
    delete [] resultarray;

    return 0;
}
