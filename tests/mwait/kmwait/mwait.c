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

int ptr = 0;

static int mymwait_init(void)
{
  printk("wwj - set mwait and monitor.\n");
  while (ptr != 1) {
    __monitor((void *)&ptr, 0, 0);
  	__sti_mwait(0,0);
	msleep(5);
  }
  printk("wwj - called monitor.\n");
  printk("wwj - called mwait done.\n");
  return 0;
}

static void mymwait_exit(void)
{
    printk("wwj - change monitored mem addr.\n");
	ptr = 1;
}

module_init(mymwait_init);
module_exit(mymwait_exit);
MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("wwj");
