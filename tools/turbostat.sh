#!/bin/bash

turbo_bin="/usr/src/linux-3.16.39/tools/power/x86/turbostat/turbostat"

#sudo $turbo_bin -P -i 1 | awk '{print $19,$20}'
{ sudo $turbo_bin -P -i 1 | awk '{print $19}'; } &>> tmp
