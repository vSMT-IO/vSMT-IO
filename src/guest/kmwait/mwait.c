#include <linux/module.h>
#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <linux/delay.h>
#include <linux/cpu.h>
#include <linux/moduleparam.h>
#include <linux/kernel.h>
#include <linux/gfp.h>
#include <linux/io.h>
#include <linux/mm.h>
#include <linux/uaccess.h>
#include <linux/sched.h>
#include <linux/kallsyms.h>
#include <linux/kprobes.h>
#include <linux/dcache.h>
#include <linux/ctype.h>
#include <linux/syscore_ops.h>
#include <trace/events/sched.h>
#include <asm/msr.h>
#include <asm/processor.h>
#include <asm/mwait.h>

DECLARE_PER_CPU(unsigned long, mwait_wakeup_flag);

int ptr = 0;
/*wwj*/
static unsigned long __inline__ myrdtsc(void) {
		unsigned int tickl, tickh;
		__asm__ __volatile__("rdtscp":"=a"(tickl),"=d"(tickh)::"%ecx");
		return ((uint64_t)tickh << 32)|tickl;
}
/*end*/

static int mymwait_init(void)
{
  while (1) {
   __monitor((void *)&ptr, 0, 0);
   __sti_mwait(0,0);
   unsigned long *_ptr = per_cpu_ptr(&mwait_wakeup_flag, 1);
   if(ptr == 1) goto out;
   if(*_ptr == 2) goto out;
  }

out:
  return 0;
}

static void mymwait_exit(void)
{
	ptr = 1;
}

module_init(mymwait_init);
module_exit(mymwait_exit);
MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("Weiwei Jia");
