#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <pthread.h>
#include <signal.h>
#include <sys/ioctl.h>
#include <stdint.h>
#include <sys/wait.h>
#include <stdlib.h>
//#include <perfmon/pfmlib_perf_event.h>
#include <sched.h>
#include <syscall.h>
#include <linux/futex.h>

#ifdef DEBUG
#define PRINT_RAW_DATA
#define debug_print(...) fprintf (stderr, __VA_ARGS__)
#else
#define debug_print(...)
#endif

static unsigned long __inline__ rdtsc(void)
{
  unsigned int tickl, tickh;
  __asm__ __volatile__("rdtscp":"=a"(tickl),"=d"(tickh)::"%ecx");
  return ((uint64_t)tickh << 32)|tickl;
}

#define nop() asm volatile ("nop")

int main(int argc, char **argv)
{
  while(1){
    unsigned long begin = rdtsc();
	nop();
    unsigned long end = rdtsc();
    printf("nop %ld cycles\n", end - begin);
  }
}
