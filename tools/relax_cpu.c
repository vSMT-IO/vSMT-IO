#define _GNU_SOURCE             /* See feature_test_macros(7) */
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <err.h>
#include <errno.h>
#include <sched.h>
#include <sys/sysinfo.h>
//#include <perfmon/pfmlib_perf_event.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <time.h>
#include <assert.h>
#include <pthread.h>
#include <math.h>

static void __inline__ relax_cpu()
{
	__asm__ volatile("rep; nop\n\t"::: "memory");
}

int main (int argc, char **argv) {
	while (1) {
		relax_cpu();
	}

	return 0;
}
