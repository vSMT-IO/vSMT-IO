KDIR = /lib/modules/`uname -r`/build
obj-m := mwait.o
M := make -C ${KDIR} M=`pwd`

all:
	${M} modules

clean-kernel:
	${M} clean

clean: clean-kernel
