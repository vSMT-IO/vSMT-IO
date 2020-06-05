#!/bin/bash

sudo dd if=/dev/zero of=/var/lib/xen/images/xen1.img bs=1M seek=110096 count=0
