#!/bin/bash

#https://unix.stackexchange.com/questions/65595/how-to-know-if-a-disk-is-an-ssd-or-an-hdd


sudo apt-get install smartmontools

smartctl -a /dev/sda | grep Rotation
