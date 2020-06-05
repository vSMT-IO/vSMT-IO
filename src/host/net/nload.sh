#!/bin/bash

#-a period       Sets the length in seconds of the time window for average calculation.
#				 Default is 300.

#-t interval     Determines the refresh interval of the display in milliseconds.
#                Default is 500.

#eno2 is the nic device.

nload -a 1 -t 200 eno2
