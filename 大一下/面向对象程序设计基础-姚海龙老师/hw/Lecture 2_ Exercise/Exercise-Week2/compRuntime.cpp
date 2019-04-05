#include <sys/time.h>
#include <sys/timeb.h>
#include <cstdlib>
#include <cstdio>
#include <windows.h>
#include <iostream>

using namespace std;

int main (int argc, char *argv[])
{
  LARGE_INTEGER winFreq;
  LARGE_INTEGER winStart, winNow;
  int i, j;

  if (!QueryPerformanceFrequency (&winFreq))
    printf ("QueryPerformanceFrequency failed\n");

  double polysum = 0;
  double posysum = 0;

  if (!QueryPerformanceCounter (&winStart))
    printf ("QueryPerformanceCounter failed\n");

  for (i = 0; i < 10000; i++)
    for (j = 0; j < 10000; j++)
    {
      //compute polynomial or posynomial functions using old or new method
      //polysum += or posysum += 
    }

  if (!QueryPerformanceCounter (&winNow))
    printf ("QueryPerformanceCounter failed\n");

  char buffer[1000];
  sprintf(buffer, "poly sum %g, posysum:%g, Total runtime of original method %g s\n", polysum, posysum, (double)(winNow.QuadPart - winStart.QuadPart) / (double)winFreq.QuadPart);
  cout << buffer <<endl;

  return 0;
}

