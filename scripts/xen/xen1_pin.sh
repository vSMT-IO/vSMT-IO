#!/bin/bash

#xm vcpu-pin  ID VCPU CPU
sudo xl vcpu-pin $1 0  0
sudo xl vcpu-pin $1 1  2
sudo xl vcpu-pin $1 2  4
sudo xl vcpu-pin $1 3  6
sudo xl vcpu-pin $1 4  8
sudo xl vcpu-pin $1 5  10
sudo xl vcpu-pin $1 6  12
sudo xl vcpu-pin $1 7  14
sudo xl vcpu-pin $1 8  16
sudo xl vcpu-pin $1 9  18
sudo xl vcpu-pin $1 10 20
sudo xl vcpu-pin $1 11 22
sudo xl vcpu-pin $1 12 24
sudo xl vcpu-pin $1 13 26
sudo xl vcpu-pin $1 14 28
sudo xl vcpu-pin $1 15 30
