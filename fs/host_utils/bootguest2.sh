#!/bin/sh
./qemu-system-arm \
    -enable-kvm \
    -nographic \
    -kernel zImage \
    -dtb guest-a15.dtb \
    -m 512 -M vexpress-a15 -cpu cortex-a15 \
    -drive if=none,file=guest_disk2.img,id=fs \
    -device virtio-blk-device,drive=fs \
    -netdev type=user,id=net0 \
    -device virtio-net-device,netdev=net0,mac="52:54:00:12:34:51" \
    -append "console=ttyAMA0 mem=512M root=/dev/vda ip=dhcp"

