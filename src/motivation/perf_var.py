#!/usr/bin/python
#
# Performance variation for vPair research project.
#
#
# Weiwei Jia <harryxiyou@gmail.com> (Python) 2018

from time import sleep, strftime
import argparse
import signal
import sys
import time
import json
import os
import sys

#src = "/sys/fs/cgroup/cpuset/machine/" + str(sys.argv[1]) + ".libvirt-qemu/"
src_kvm1 = "/sys/fs/cgroup/cpuset/machine/kvm1.libvirt-qemu/"
src_kvm8 = "/sys/fs/cgroup/cpuset/machine/kvm8.libvirt-qemu/"
vCPU_num = 24
vCPU_start = 0
vCPU_end = 23

def ReadFile(filepath):
  f = open(filepath, "r")
  try:
    contents = f.read()
  finally:
    f.close()

  return contents

def WriteFile(filepath, buf):
  f = open(filepath, "w")
  try:
    f.write(buf)
  finally:
    f.close()

#print("Virtual Machine Path is: %s" % src)
for i in range(vCPU_start, vCPU_end):
  #print("This is vCPU %d" % i)
  kvm1= src_kvm1 + "vcpu%d/tasks" % i
  kvm8= src_kvm1 + "vcpu%d/tasks" % i
  if os.path.exists(kvm1) and os.path.exists(kvm8):
      kvm1_pid=ReadFile(kvm1)
      kvm8_pid=ReadFile(kvm8)
      try:
          kvm1_affinity = os.sched_getaffinity(int(kvm1_pid))
          kvm8_affinity = os.sched_getaffinity(int(kvm8_pid))
      except ProcessLookupError:
          print("Task %d or %d might be finished" % (kvm1_pid, kvm8_pid))
      print("kvm1's vcpu%d is on hyperthread %s" % (i, kvm1_affinity))
      print("kvm8's vcpu%d is on hyperthread %s" % (i, kvm8_affinity))
  else:
    sys.exit("Error: Cannot find %s or %s file." % (nes_src, new_des))
