#!/bin/bash

#xm vcpu-pin  ID VCPU CPU
sudo xl vcpu-pin xen1 0  0 0
sudo xl vcpu-pin xen1 1  2 2
sudo xl vcpu-pin xen1 2  4 4
sudo xl vcpu-pin xen1 3  6 6
sudo xl vcpu-pin xen1 4  8 8
sudo xl vcpu-pin xen1 5  10 10
sudo xl vcpu-pin xen1 6  12 12
sudo xl vcpu-pin xen1 7  14 14
sudo xl vcpu-pin xen1 8  16 16
sudo xl vcpu-pin xen1 9  18 18
sudo xl vcpu-pin xen1 10 20 20
sudo xl vcpu-pin xen1 11 22 22
sudo xl vcpu-pin xen1 12 24 24
sudo xl vcpu-pin xen1 13 26 26
sudo xl vcpu-pin xen1 14 28 28
sudo xl vcpu-pin xen1 15 30 30
