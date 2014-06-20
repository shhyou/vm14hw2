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
        -drive if=none,file=guest_disk.img,id=fs \
        -device virtio-blk-device,drive=fs \
        -netdev type=user,id=net0 \
        -device virtio-net-device,netdev=net0,mac="52:54:00:12:34:50" \
        -append "console=ttyAMA0 mem=512 root=/dev/vda ip=dhcp"
    ```

    But the `mem=512` parameter should be `mem=512M`. If not, our guest would not have
    enough memory to run.

After booting up the host/guest virtual machine, we checked for its `cpuinfo` and
happliy found that our virtual machines are indeed working.

![cpuinfo](./cpuinfo.jpg)

### The KVM Architecture Overview

XXX TODO insert KVM architecture graph here

As depicted in the graph, the KVM is a kernel module running inside the host VM that
helps the guest VM to virtualize the CPU. For the I/O part, guest-issued I/O requests
will be forwared to the QEMU emulation system.

After entering the hypervisor mode of the ARM processor, the KVM kernel module can
fully realize its potential in simplifying and speeding up the CPU virtualization.
The interface of the KVM kernel module to the outside world is, as usual, via the
`ioctl` function. The handler `kvm_vm_ioctl` and `kvm_vcpu_ioctl` are at
`virt/kvm/kvm_main.c` with architecture-dependent functionalities be forwarded to,
say, `kvm_arch_vcpu_ioctl1` in `arch/arm/kvm/arm.c`.

It mainly has the following instructions:

1. Create a virtual CPU

    ```cpp
    static long kvm_vm_ioctl(/* ... */) {
      /* ... */
      switch (ioctl) {
      case KVM_CREATE_VCPU:
        r = kvm_vm_ioctl_create_vcpu(kvm, arg);
        break;
        /* ... */

    static int kvm_vm_ioctl_create_vcpu(/* ... */) {
      /* ... */
      vcpu = kvm_arch_vcpu_create(kvm, id);
      /* ... */
      r = kvm_arch_vcpu_setup(vcpu);
      /* ... */

    struct kvm_vcpu *kvm_arch_vcpu_create(/* ... */) {
      int err; struct kvm_vcpu *vcpu;
      vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
      /* ... */
      err = kvm_vcpu_init(vcpu, kvm, id);
      /* ... */
    ```

1. Run on a virtual CPU

    ```cpp
    static long kvm_vcpu_ioctl(/* ... */) {
      /* ... */
      switch (ioctl) {
      case KVM_RUN:
        r = -EINVAL;
        if (arg)
          goto out;
        r = kvm_arch_vcpu_ioctl_run(vcpu, vcpu->run);
        trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
        break;
        /* ... */

    int kvm_arch_vcpu_ioctl_run(/* ... */) {
      /* our main modifications here! */
      /* ... *virtualize* the cpu; enter guest mode and execute! */
    ```

1. Get/set virtual CPU register
1. Initialize a ARM CPU from use request

    ```cpp
    long kvm_arch_vcpu_ioctl(/* ... */) {
      /* ... */
      switch (ioctl) {
      case KVM_ARM_VCPU_INIT: {
        /* ... */
    ```

To use CPU virtualization, we shall more or less go through the above two
instructions.

### Implementation

Our implementation made two changes to the KVM, and we simply utilize other existing
tracing points to make our observation. The first one is add an *exit count* to the
original `kvm_exit` trace event. `kvm_exit` traces when the processor leaves non-
hypervisor mode and back to the KVM run loop:

```cpp
 while (ret > 0) {
   /* ... */
   local_irq_disable();
   /* ... */
   trace_kvm_entry(*vcpu_pc(vcpu));
   kvm_guest_enter();
   vcpu->mode = IN_GUEST_MODE;

   ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);

   vcpu->mode = OUTSIDE_GUEST_MODE;
   vcpu->arch.last_pcpu = smp_processor_id();
   kvm_guest_exit();
-  trace_kvm_exit(*vcpu_pc(vcpu));
+  ++vcpu->cnt_exit;
+  trace_kvm_exit(*vcpu_pc(vcpu), vcpu->cnt_exit);
   /* ... */
```

### Trace Result

## Part II - Experimenting Multiple Guests



## Discussion

some notes on `kvm_emulate_insn`

## Conclusion

