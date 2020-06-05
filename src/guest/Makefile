KDIR = /lib/modules/`uname -r`/build
obj-m := vsmtiorr.o
M := make -C ${KDIR} M=`pwd`

all:
	${M} modules

clean-kernel:
	${M} clean

user: test_vsmtiorr
test_vsmtio_rr: test_vsmtiorr.c
	gcc -o test_vsmtiorr test_vsmtiorr.c -lpthread
clean-user:
	rm test_vsmtiorr

clean: clean-user clean-kernel
