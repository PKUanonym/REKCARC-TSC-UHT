#ifndef _SYRAH_CYCLE_TIMER_H_
#define _SYRAH_CYCLE_TIMER_H_

#if defined(__APPLE__)
  #if defined(__x86_64__)
    #include <sys/sysctl.h>
  #else
    #include <mach/mach.h>
    #include <mach/mach_time.h>
  #endif // __x86_64__ or not

  #include <stdio.h>  // fprintf
  #include <stdlib.h> // exit

#elif _WIN32
#  include <windows.h>
#  include <time.h>
#else
#  include <stdio.h>
#  include <stdlib.h>
#  include <string.h>
#  include <sys/time.h>
#endif


  // This uses the cycle counter of the processor.  Different
  // processors in the system will have different values for this.  If
  // you process moves across processors, then the delta time you
  // measure will likely be incorrect.  This is mostly for fine
  // grained measurements where the process is likely to be on the
  // same processor.  For more global things you should use the
  // Time interface.

  // Also note that if you processors' speeds change (i.e. processors
  // scaling) or if you are in a heterogenous environment, you will
  // likely get spurious results.
  class CycleTimer {
  public:
    typedef unsigned long long SysClock;

    //////////
    // Return the current CPU time, in terms of clock ticks.
    // Time zero is at some arbitrary point in the past.
    static SysClock currentTicks() {
#if defined(__APPLE__) && !defined(__x86_64__)
      return mach_absolute_time();
#elif defined(_WIN32)
      LARGE_INTEGER qwTime;
      QueryPerformanceCounter(&qwTime);
      return qwTime.QuadPart;
#elif defined(__x86_64__)
      unsigned int a, d;
      asm volatile("rdtsc" : "=a" (a), "=d" (d));
      return static_cast<unsigned long long>(a) |
        (static_cast<unsigned long long>(d) << 32);
#elif defined(__ARM_NEON__) && 0 // mrc requires superuser.
      unsigned int val;
      asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r"(val));
      return val;
#else
      timespec spec;
      clock_gettime(CLOCK_THREAD_CPUTIME_ID, &spec);
      return CycleTimer::SysClock(static_cast<float>(spec.tv_sec) * 1e9 + static_cast<float>(spec.tv_nsec));
#endif
    }

    //////////
    // Return the current CPU time, in terms of seconds.
    // This is slower than currentTicks().  Time zero is at
    // some arbitrary point in the past.
    static double currentSeconds() {
      return currentTicks() * secondsPerTick();
    }

    //////////
    // Return the conversion from seconds to ticks.
    static double ticksPerSecond() {
      return 1.0/secondsPerTick();
    }

    static const char* tickUnits() {
#if defined(__APPLE__) && !defined(__x86_64__)
      return "ns";
#elif defined(__WIN32__) || defined(__x86_64__)
      return "cycles";
#else
      return "ns"; // clock_gettime
#endif
    }

    //////////
    // Return the conversion from ticks to seconds.
    static double secondsPerTick() {
      static bool initialized = false;
      static double secondsPerTick_val;
      if (initialized) return secondsPerTick_val;
#if defined(__APPLE__)
  #ifdef __x86_64__
      int args[] = {CTL_HW, HW_CPU_FREQ};
      unsigned int Hz;
      size_t len = sizeof(Hz);
      if (sysctl(args, 2, &Hz, &len, NULL, 0) != 0) {
         fprintf(stderr, "Failed to initialize secondsPerTick_val!\n");
         exit(-1);
      }
      secondsPerTick_val = 1.0 / (double) Hz;
  #else
      mach_timebase_info_data_t time_info;
      mach_timebase_info(&time_info);

      // Scales to nanoseconds without 1e-9f
      secondsPerTick_val = (1e-9*static_cast<double>(time_info.numer))/
        static_cast<double>(time_info.denom);
  #endif // x86_64 or not
#elif defined(_WIN32)
      LARGE_INTEGER qwTicksPerSec;
      QueryPerformanceFrequency(&qwTicksPerSec);
      secondsPerTick_val = 1.0/static_cast<double>(qwTicksPerSec.QuadPart);
#else
      FILE *fp = fopen("/proc/cpuinfo","r");
      char input[1024];
      if (!fp) {
         fprintf(stderr, "CycleTimer::resetScale failed: couldn't find /proc/cpuinfo.");
         exit(-1);
      }
      // In case we don't find it, e.g. on the N900
      secondsPerTick_val = 1e-9;
      while (!feof(fp) && fgets(input, 1024, fp)) {
        // NOTE(boulos): Because reading cpuinfo depends on dynamic
        // frequency scaling it's better to read the @ sign first
        float GHz, MHz;
        if (strstr(input, "model name")) {
          char* at_sign = strstr(input, "@");
          if (at_sign) {
            char* after_at = at_sign + 1;
            char* GHz_str = strstr(after_at, "GHz");
            char* MHz_str = strstr(after_at, "MHz");
            if (GHz_str) {
              *GHz_str = '\0';
              if (1 == sscanf(after_at, "%f", &GHz)) {
                //printf("GHz = %f\n", GHz);
                secondsPerTick_val = 1e-9f / GHz;
                break;
              }
            } else if (MHz_str) {
              *MHz_str = '\0';
              if (1 == sscanf(after_at, "%f", &MHz)) {
                //printf("MHz = %f\n", MHz);
                secondsPerTick_val = 1e-6f / GHz;
                break;
              }
            }
          }
        } else if (1 == sscanf(input, "cpu MHz : %f", &MHz)) {
          //printf("MHz = %f\n", MHz);
          secondsPerTick_val = 1e-6f / MHz;
          break;
        }
      }
      fclose(fp);
#endif

      initialized = true;
      return secondsPerTick_val;
    }

    //////////
    // Return the conversion from ticks to milliseconds.
    static double msPerTick() {
      return secondsPerTick() * 1000.0;
    }

  private:
    CycleTimer();
  };

#endif // #ifndef _SYRAH_CYCLE_TIMER_H_
