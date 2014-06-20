#!/bin/sh

# enable tracing
echo 1 > /sys/kernel/debug/tracing/tracing_on

# select tracing events
echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_exchvc/enable
echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_hvc/enable
echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_entry/enable
echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_exit/enable
echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_guest_fault/enable
echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_userspace_exit/enable
