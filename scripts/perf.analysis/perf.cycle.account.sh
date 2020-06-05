# perf stat -x, -o test.cvs --append -e cycles,inst_retired.any,cpu_clk_unhalted.thread,resource_stalls.any,cycle_activity.stalls_total,int_misc.recovery_cycles_any ./valgrind1 1000000
