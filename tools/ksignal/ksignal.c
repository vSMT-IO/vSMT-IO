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

#define NR_SHIM_CPU (100)

DECLARE_PER_CPU(unsigned int, shim_curr_flag);
DECLARE_PER_CPU(unsigned long, shim_curr_task);
DECLARE_PER_CPU(unsigned long *, shim_signal);

static unsigned long task_signal[NR_SHIM_CPU];
module_param_array(task_signal, ulong, NULL, 0644);
MODULE_PARM_DESC(task_signal, "Per-CPU signal shows the running task.");

static unsigned long signal_page[NR_SHIM_CPU];
module_param_array(signal_page, ulong, NULL, 0644);
MODULE_PARM_DESC(signal_page, "Per-CPU signal shows the running task.");

static unsigned long flag_signal[NR_SHIM_CPU];
module_param_array(flag_signal, ulong, NULL, 0644);
MODULE_PARM_DESC(flag_signal, "Per-CPU signal shows the status of the current running task.");

static int ksignals_init(void)
{
  int cpu;
  volatile unsigned long * shim_task_signal = NULL;
  volatile unsigned int * shim_flag_signal = NULL;
  volatile unsigned long * signal_page_address = NULL;

  for_each_possible_cpu (cpu) {
    if (cpu >= NR_SHIM_CPU)
      break;

    shim_task_signal = per_cpu_ptr(&shim_curr_task, cpu);
    shim_flag_signal = per_cpu_ptr(&shim_curr_flag, cpu);
    signal_page_address = per_cpu(shim_signal, cpu);

    task_signal[cpu] = (unsigned long)__pa(shim_task_signal);
    flag_signal[cpu] = (unsigned long)__pa(shim_flag_signal);
    signal_page[cpu] = (unsigned long)__pa(signal_page_address);

    pr_debug("CPU %d SHIM_TASK, va %p, pa %lx\n", cpu, shim_task_signal, __pa(shim_task_signal));
    pr_debug("CPU %d SHIM_SIGNAL, va %lx, pa %lx\n", cpu, (unsigned long)signal_page_address, __pa(signal_page_address));
  }
  return 0;
}

static void ksignals_exit(void)
{
}

module_init(ksignals_init);
module_exit(ksignals_exit);
MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("Xi Yang");
