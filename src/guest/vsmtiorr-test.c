#include <linux/module.h>
#include <linux/miscdevice.h>
#include <linux/fs.h>
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

#define MWAIT_RR_THRESHOLD			(6000000UL)    //3ms

DECLARE_PER_CPU(unsigned long, mwait_wakeup_flag);
DECLARE_PER_CPU(unsigned long, mwait_timer_flag);
DECLARE_PER_CPU(unsigned long, mwait_begin_cycles);
int nr_cpu;

static unsigned long __inline__ myrdtsc(void) {
	unsigned int tickl, tickh;
	__asm__ __volatile__("rdtscp":"=a"(tickl),"=d"(tickh)::"%ecx");
	return ((uint64_t)tickh << 32)|tickl;
}

static long vsmtiorr_ioctl(struct file *file, unsigned int cmd,
			    unsigned long arg)
{
  int cpu;
/*  nr_cpu = num_possible_cpus();
  int ret = sched_setaffinity(0, cpumask_of(nr_cpu - 1));*/
  for_each_possible_cpu (cpu) {
	unsigned long *mbc_ptr = per_cpu_ptr(&mwait_begin_cycles, cpu);
	unsigned long *mtf_ptr = per_cpu_ptr(&mwait_timer_flag, cpu);
	unsigned long end = myrdtsc();
	if ((*mtf_ptr == 0) &&
			((end - *mbc_ptr) >= MWAIT_RR_THRESHOLD)) {
		*mtf_ptr = 1;
	}
    unsigned long *ptr = per_cpu_ptr(&mwait_wakeup_flag, cpu);
	//*ptr = 0xdead;
	*ptr = 1;
#if 0
	if (*ptr == 0) {
		printk(KERN_INFO "before - CPU%d should mwait on virt (ptr addr):%p,  phy:%lx, *ptr is %ld.\n", cpu, ptr, __pa(ptr), *ptr);
		*ptr = 1;
		printk(KERN_INFO "after - CPU%d should mwait on virt (ptr addr):%p,  phy:%lx, *ptr is %ld.\n", cpu, ptr, __pa(ptr), *ptr);
	}
#endif
  }
  return 0;
}

static const struct file_operations vsmtiorr_fops = {
	.owner = THIS_MODULE,
	.unlocked_ioctl = vsmtiorr_ioctl,
	.compat_ioctl = vsmtiorr_ioctl,
	.llseek = noop_llseek,
};

static struct miscdevice vsmtiorr_miscdev = {
  MISC_DYNAMIC_MINOR,
  "vsmtiorr",
  &vsmtiorr_fops
};

static int vsmtiorr_init(void)
{
  int err;
  int cpu;
  unsigned long *ptr;
  //nr_cpu = num_possible_cpus();

  printk(KERN_INFO "Init the miscdev vsmtiorr\n");
  err = misc_register(&vsmtiorr_miscdev);
  if (err < 0) {
    pr_err("Cannot register vsmtiorr device\n");
    return err;
  }
  /*printk(KERN_INFO "nr_cpu: %d\n", nr_cpu);
  int ret = sched_setaffinity(0, cpumask_of(nr_cpu - 1));
  printk(KERN_INFO "sched_setaffinity ret: %d\n", ret);*/
  for_each_possible_cpu (cpu) {
    ptr = per_cpu_ptr(&mwait_wakeup_flag, cpu);
    printk(KERN_INFO "CPU%d should mwait on virt:%p,  phy:%lx\n", cpu, ptr, __pa(ptr));
  }
  return 0;
}

static void vsmtiorr_exit(void)
{
  printk(KERN_INFO "Deregister the miscdev vsmtiorr\n");
  misc_deregister(&vsmtiorr_miscdev);
}

module_init(vsmtiorr_init);
module_exit(vsmtiorr_exit);
MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("Weiwei Jia");
