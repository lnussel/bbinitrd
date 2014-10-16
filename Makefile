LIB=lib
DIRS=etc etc/init.d proc sys dev $(LIB) bin mnt home/joesix

nothing:

all: busybox

libc: root
	install -m 644 /$(LIB)/libc.so.6 root/$(LIB)
	install -m 755 /$(LIB)/ld-linux-x86-64.so.2 root/$(LIB) || install -m 755 /$(LIB)/ld-linux.so.2 root/$(LIB)

root:
	for i in $(DIRS); do install -d -m 755 root/$$i; done
	echo root:x:0:0:root:/:/bin/sh > root/etc/passwd
	echo joesix:x:100:100:Joe Sixpack:/home/joesix:/bin/sh >> root/etc/passwd
	echo root:x:0: > root/etc/group
	echo users:x:100: >> root/etc/group
	echo 'alias l="ls -al"' > root/.profile
	install -m 755 rcS root/etc/init.d

busybox: libc
	busybox.install root --symlinks --noclobber
	ln -sf bin/busybox root/init

initrd:
	(cd root; find | cpio -H newc --create --owner 0:0 | gzip) > initrd

clean:
	rm -rf root

.PHONY: root
