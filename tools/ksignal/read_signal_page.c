#ifndef _GNU_SOURCE
#define _GNU_SOURCE             /* See feature_test_macros(7) */
#endif
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <err.h>
#include <errno.h>
#include <sched.h>
#include <sys/sysinfo.h>
#include <perfmon/pfmlib_perf_event.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <time.h>
#include <assert.h>
#include <pthread.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <getopt.h>
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <unistd.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <poll.h>
#include <sys/time.h>
#include <sys/resource.h>

#define debug_print(...) fprintf (stderr, __VA_ARGS__)

struct shim_signal_base
{
    unsigned long timestamp;
    int type;
    int size;
};
   

struct shim_schedule_signal
{
  unsigned long timestamp;
  int type;
  int size;
  int to_tid;
  int to_tgid;
  unsigned long to_fp;
  int from_tid;
  int from_tgid;    
  unsigned long from_fp;
};

struct shim_softirq_signal
{
    unsigned long timestamp;
    int type;
    int size;
    int vector;
    int tid;
    int tgid;
    unsigned long latency;
};

int fetch_signal_phy_address(char *path, int nr_cpu, unsigned long * signal_addr)
{
  int i;
  int fd;
  char buf[1024];
  if ((fd = open(path, O_RDONLY)) < 0){
    fprintf(stderr, "Can't open signal address file %s\n", path);
    return 1;
  }
  int nr_read = read (fd, buf, 1024);
  debug_print("read %d bytes %s from shim_sginal\n", nr_read, buf);
  signal_addr[0] = atol(buf);
  char *cur = buf;
  for (i=1; i<nr_cpu; i=i+1){
    while (*(cur++) != ',')
      ;
    signal_addr[i] = atol(cur);
  }
  close(fd);
  return 0;
}


int map_signal_phy_address(int cpuid, unsigned long *signal_addr, unsigned long **signal)
{

  unsigned long phy_addr = signal_addr[cpuid];
  unsigned long mmap_offset = phy_addr & ~(0x1000 - 1);
  int mmap_size = 0x1000;
  int signal_offset = phy_addr & (0x1000 - 1);
  int mmap_fd;

  if ((mmap_fd = open("/dev/mem", O_RDONLY)) < 0) {
    fprintf(stderr,"Can't open /dev/mem");
    return 1;
  }
  char *mmap_addr = mmap(0, mmap_size, PROT_READ, MAP_SHARED, mmap_fd, mmap_offset);
  if (mmap_addr == MAP_FAILED) {
    fprintf(stderr,"Can't mmap /dev/mem");
    return 1;
  }
  *signal = (unsigned long *)(mmap_addr + signal_offset);
  debug_print("map cpu%d signal_addr:0x%lx to virtual_addr:%p\n", cpuid, phy_addr, *signal);
  return 0;
}

static unsigned long __inline__ rdtscp(void)
{
  unsigned int tickl, tickh;
  __asm__ __volatile__("rdtscp":"=a"(tickl),"=d"(tickh)::"%ecx");
  return ((uint64_t)tickh << 32)|tickl;
}

int
main(int argc, char **argv)
{
  int i;
  if (argc != 2)
  {
      printf("read_signal_page #CPU\n");
      exit(0);
  }
      
  int targetCPU = atoi(argv[1]);
  unsigned long signal_phy_addr[16];
  fetch_signal_phy_address("/sys/module/ksignal/parameters/signal_page", 16, signal_phy_addr);
  for (i=0; i<16; i++) {
    printf("CPU %d task signal at phy addr 0x%lx\n", i, signal_phy_addr[i]);
  }

  volatile struct shim_signal_base *page_core0 = NULL;
  volatile unsigned long *shim_timestamp = NULL;
  volatile struct shim_softirq_signal * sf = NULL;
  volatile struct shim_schedule_signal *tf = NULL;
  map_signal_phy_address(targetCPU, signal_phy_addr, (unsigned long **)(&page_core0));
  shim_timestamp = &(page_core0->timestamp);
  sf = (struct shim_softirq_signal *)page_core0;
  tf = (struct shim_schedule_signal *)page_core0;
  printf("Map CPU %d's task signal to address %p\n", targetCPU, page_core0);

  volatile unsigned long stamp = *shim_timestamp;
 
  while (1) {
      unsigned long now = *shim_timestamp;
      if (now != stamp) {
	  stamp = now;
	  printf("Signal type:%d happened at %lu\n", page_core0->type, page_core0->timestamp);
      }
  }
}
