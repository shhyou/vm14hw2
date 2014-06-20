vm14hw2
=======

Virtual Machine Homework 2, Spring 2014

## Important Files & Directories

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

