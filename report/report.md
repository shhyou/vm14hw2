# Virtual Machine Homework (II) Report
## Introduction
- Topic: a study of system virtual machine

- Team

    * b00902064 Hao-En Sung @ ntu csie
    * b00902107 Shu-Hung You @ ntu csie

- Abstract

    Our code can be found at https://github.com/suhorng/vm14hw2

    > We study the same ISA system virtual machine on a simulated ARM Cortex A15x1
    platform. We build one host VM which runs one or more guest VMs, trace the hypervisor
    traps in the **kvm** module. We also run serveral benchmarks on multiple guest VMs
    to observe the loadings.

## Part I - Trap Profiling

In this experiment, we traced several events in the KVM to see how many traps are there.
We mainly focused on the HVC exception in the hypervisor mode and observed an unexpected
result.

### Virtual Machine Setup Difficulties

1. We chose to use the MMC file system instead of the NFS since there is little setup
required to use a disk image, and its construction is similar to the guest machine.
However, we initially only gave the host machine a 512MB disk, and was unable to put the 
guest inside the host for it was too large. Later we rebuild a host with enough disk space.

1. The given `qemu-system-arm` startup command was wrong. The given one was

    ```shell
    #!/bin/sh
    ./qemu-system-arm \
        -enable-kvm \
        -nographic \
        -kernel zImage \
        -dtb guest-a15.dtb \
        -m 512 -M vexpress-a15 -cpu cortex-a15 \
        -drive if=none,file=guest_disk1.img,id=fs \
        -device virtio-blk-device,drive=fs \
        -netdev type=user,id=net0 \
        -device virtio-net-device,netdev=net0,mac="52:54:00:12:34:50" \
        -append "console=ttyAMA0 mem=512 root=/dev/vda ip=dhcp"
    ```

    But the `mem=512` parameter should be `mem=512M`. If not, our guest would not have
    enough memory to run.

### The KVM Architecture Overview

### Implementation

### Trace Result

## Part II - Experimenting Multiple Guests



## Discussion

some notes on `kvm_emulate_insn`

## Conclusion

