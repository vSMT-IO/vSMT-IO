#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <fcntl.h>
#include <assert.h>
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
#include <sys/sysinfo.h>

#ifdef DEBUG
#define PRINT_RAW_DATA
#define debug_print(...) fprintf (stderr, __VA_ARGS__)
#else
#define debug_print(...)
#endif

#define handle_error(msg) \
	do { perror(msg); exit(EXIT_FAILURE); } while (0)

//#define			INIT_DESCHED_T			(1000ULL) //microseconds
#define			INIT_DESCHED_T			(3000ULL) //microseconds
#define			STEP_DESCHED_T			(0.1)
#define			TIME_PERIOD_LEN			(30000ULL)

#define			REQUEST_ALL_CORES			(0)
#define			REQUEST_A_CORE				(1)

/*initial value of descheduling threshold*/
uint64_t desched_thresh_init = INIT_DESCHED_T;
/*the step/delta for adjusting descheduling threshold*/
uint64_t desched_thresh_delta = INIT_DESCHED_T * STEP_DESCHED_T;

unsigned long* _mwait_success_counter;

/*TODO: attach descheduling threshold to each SMT core*/

static unsigned long __inline__ rdtsc(void)
{
  unsigned int tickl, tickh;
  __asm__ __volatile__("rdtscp":"=a"(tickl),"=d"(tickh)::"%ecx");
  return ((uint64_t)tickh << 32)|tickl;
}

void free_resources(void) {
	if (_mwait_success_counter!=NULL) {
		free(_mwait_success_counter);
		exit(EXIT_SUCCESS);
	}
}

void sig_handler(int signo) { 
	if (signo == SIGINT) {
		printf("Free resource ...\n");
		free_resources();
	} else
		handle_error("Signal Error!\n");
}

unsigned long
do_mwait_success_counter(int fd, int cmd, int core_num, uint64_t sleep_time) {
	  int i = 0;
	  usleep(sleep_time);
	  unsigned long msc_start = ioctl(fd, cmd, core_num);
	  unsigned long msc_total = 0;
	  unsigned long msc_cur = 0;
	  for (i = 0; i < TIME_PERIOD_LEN;) {
		  usleep(sleep_time); //500us
    //unsigned long begin = rdtsc();
		  msc_cur = ioctl(fd, cmd, core_num);
		  msc_total = msc_total + (msc_cur - msc_start);
		  msc_start = msc_cur;
		  i = i + sleep_time;
	  }

	  return msc_total;
}

int64_t
choose_next_threshold(unsigned long msc_total_1st, unsigned long msc_total_2nd,
		unsigned long msc_total_3rd, uint64_t desched_thresh_init) {
	if (msc_total_1st >= msc_total_2nd && msc_total_1st >= msc_total_3rd)
		return desched_thresh_init;
	else if (msc_total_2nd >= msc_total_1st && msc_total_2nd >= msc_total_3rd)
		return desched_thresh_init+desched_thresh_delta;
	else if (msc_total_3rd >= msc_total_1st && msc_total_3rd >= msc_total_2nd)
		return desched_thresh_init-desched_thresh_delta;
}

int main(int argc, char **argv)
{
  int fd = open("/dev/vsmtiorr", O_RDONLY| O_CLOEXEC);
  if (fd < 0){
    fprintf(stderr, "Can't open /dev/vsmtiorr\n");
    exit(0);
  }

  int core_nums = get_nprocs();
  _mwait_success_counter = (unsigned long*) malloc(sizeof(unsigned long) * core_nums);
  assert(_mwait_success_counter!=NULL);

  printf("init deschedule threshold: %lu\n", desched_thresh_init);
  printf("deschedule threshold delta: %lu\n", desched_thresh_delta);

  if (signal(SIGINT, sig_handler) == SIG_ERR) {
	  handle_error("SIGINT error!\n");
  }

  while(1){
#if 0
    //usleep(3000); //3ms
	  usleep(desched_thresh_init);
	  unsigned long msc_start = ioctl(fd, REQUEST_A_CORE, 5);
	  unsigned long msc_total_1st = 0;
	  unsigned long msc_cur = 0;
	  for (i = 0; i < TIME_PERIOD_LEN;) {
		  usleep(desched_thresh_init); //500us
    //unsigned long begin = rdtsc();
		  msc_cur = ioctl(fd, REQUEST_A_CORE, 5);
		  msc_total_1st = msc_total_1st + (msc_cur - msc_start);
		  msc_start = msc_cur;
		  i = i + desched_thresh_init;
	  }
    //unsigned long end = rdtsc();
    //printf("napping %ld cycles\n", end - begin);
#endif
	  printf("resouce retention length is %lu microseconds.\n", desched_thresh_init);
	  unsigned long msc_total_1st = do_mwait_success_counter(fd, REQUEST_A_CORE, 5, desched_thresh_init);
	  unsigned long msc_total_2nd = do_mwait_success_counter(fd, REQUEST_A_CORE, 5, desched_thresh_init+desched_thresh_delta);
	  unsigned long msc_total_3rd = do_mwait_success_counter(fd, REQUEST_A_CORE, 5, desched_thresh_init-desched_thresh_delta);
	  printf("msc_total_1st/2nd/3rd: %lu/%lu/%lu.\n", msc_total_1st, msc_total_2nd, msc_total_3rd);
	  desched_thresh_init = choose_next_threshold(msc_total_1st, msc_total_2nd, msc_total_3rd, desched_thresh_init);
  }
}
