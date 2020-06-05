#!/bin/bash

 1983  ./perf kvm record -e cs -a sleep 10
  1984  ./perf kvm report perf.data.guest


   2044  ./perf kvm stat record -a sleep 10
    2045  ./perf kvm stat report --event=vmexit

	./perf stat -e 'kvm:*' -a sleep 10
