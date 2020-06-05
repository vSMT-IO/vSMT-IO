KDIR = /lib/modules/`uname -r`/build
obj-m := vsmtiorr-test.o
M := make -C ${KDIR} M=`pwd`

all:
	${M} modules

clean-kernel:
	${M} clean

user: test
test_vsmtio_rr: test.c
	gcc -o test test.c -lpthread
clean-user:
	rm test

clean: clean-user clean-kernel
