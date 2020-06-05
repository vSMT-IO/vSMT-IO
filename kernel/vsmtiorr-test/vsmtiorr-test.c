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
#include <linux/errno.h>
#include <linux/syscore_ops.h>
#include <trace/events/sched.h>
#include <asm/msr.h>
#include <asm/processor.h>
#include <asm/mwait.h>

#define		REQUEST_ALL_CORES			(0)
#define		REQUEST_A_CORE				(1)

DECLARE_PER_CPU(unsigned long, mwait_wakeup_flag);
DECLARE_PER_CPU(unsigned long, mwait_success_counter);

static long vsmtiorr_ioctl(struct file *file, unsigned int cmd,
			    unsigned long arg)
{
  int cpu;
  unsigned long* _mwait_success_counter = (unsigned long*) arg;

  switch(cmd) {
	case REQUEST_A_CORE:
		cpu = (int) arg;
		unsigned long *ptr = per_cpu_ptr(&mwait_wakeup_flag, cpu);
		if (*ptr == 0) *ptr = 1;
		unsigned long *_msc_ptr = per_cpu_ptr(&mwait_success_counter, cpu);
		return *_msc_ptr;
	case REQUEST_ALL_CORES:
		//unsigned long* _mwait_success_counter = _msc_ptr;
		for_each_possible_cpu (cpu) {
			unsigned long *ptr = per_cpu_ptr(&mwait_wakeup_flag, cpu);
			//*ptr = 0xdead;
			if (*ptr == 0) {
				printk(KERN_INFO "before - CPU%d should mwait on virt (ptr addr):%p,  phy:%lx, *ptr is %ld.\n",
						cpu, ptr, __pa(ptr), *ptr);
				*ptr = 1;
				printk(KERN_INFO "after - CPU%d should mwait on virt (ptr addr):%p,  phy:%lx, *ptr is %ld.\n",
						cpu, ptr, __pa(ptr), *ptr);
			}
			unsigned long *_msc_ptr = per_cpu_ptr(&mwait_success_counter, cpu);
			_mwait_success_counter[cpu] = *_msc_ptr;
			return 0;
		}
	default:
		return -ENOIOCTLCMD;
  }
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
  unsigned long *_msc_ptr;
  printk(KERN_INFO "Init the miscdev vsmtiorr\n");
  err = misc_register(&vsmtiorr_miscdev);
  if (err < 0) {
    pr_err("Cannot register vsmtiorr device\n");
    return err;
  }
  for_each_possible_cpu (cpu) {
    ptr = per_cpu_ptr(&mwait_wakeup_flag, cpu);
    _msc_ptr = per_cpu_ptr(&mwait_success_counter, cpu);
	*_msc_ptr = 0;
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
