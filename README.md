vm14hw2
=======

Virtual Machine Homework 2, Spring 2014

## Overview

- Topic: a study of system virtual machine

- Team

    * b00902064 Hao-En Sung @ ntu csie
    * b00902107 Shu-Hung You @ ntu csie

- Abstract

    Our code can be found at https://github.com/suhorng/vm14hw2

    > We studied the same ISA system virtual machine on a simulated ARM Cortex A15x1
    platform. We built one host VM which ran one or more guest VMs, traced the hypervisor
    traps in the **kvm** module. We also ran serveral benchmarks on multiple guest VMs
    to observe the loadings.

- Source File Structure

    * `README.md`: some notes and explanation of the repo.
    * `report.pdf`: our study report
    * `linuv-kvm`: our **full** source code; build kernel image here.
    * `fs/`: where we put our `host_disk.img`; absent on the repo.
        + `fs/host_utils/`: the scripts we put on the host VM to help
            manipulating traces, launch the guest VM, etc.
    * `boot/`: our `params` file; the other `.dtb` files are not pushed
    * `report/`: the source of our report

- Virtual Machines' Screenshot

    ![VM screenshot](./report/host-guest-qemu.jpg)

## Homework Notes
### Important Files & Directories

- `arch/arm/kvm/`

    * `arm.c`: `int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)`
    * `handle_exit.c`: `int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,`
    * `trace.h`

- `arch/arm/include/asm/`

    * `kvm_asm.h`

- `include/include/`

    * `kvm_host.h`: `kvm_guest_exit(void)`
    * `context_tracking.h`: `guest_exit(void)`

- `virt/kvm/`

    * `kvm_main.c`: `int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)`

## Some random notes

kvm_arch_vcpu_ioctl_run

while (ret > 0) ... 迴圈的方式讓 CPU 一直 run, 除非 interrupt/trap 才離開
kvm_guest_enter();


ivm_timer_sync_hwstate
kvm_vgic_sync_hwstate
handle_exit => switch (exception_index) ....

arch/arm/kvm

trace.h

