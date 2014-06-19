vm14hw2
=======

Virtual Machine Homework 2, Spring 2014

## Important Files & Directories

- `arch/arm/kvm`

    * `arm.c`
    * `handle_exit.h`
    * `trace.h`

- `arch/arm/include/asm`

    * `kvm_asm.h`

- `include/include/asm`

    * `kvm_host.h`

## Some random notes

kvm_arch_vcpu_ioctl_run

while (ret > 0) ... 迴圈的方式讓 CPU 一直 run, 除非 interrupt/trap 才離開
kvm_guest_enter();


ivm_timer_sync_hwstate
kvm_vgic_sync_hwstate
handle_exit => switch (exception_index) ....

arch/arm/kvm

trace.h

