#!/bin/sh

# select tracing events
echo 0 > /sys/kernel/debug/tracing/events/kvm/kvm_exception_hvc/enable
echo 0 > /sys/kernel/debug/tracing/events/kvm/kvm_guest_fault/enable

# disable tracing
echo 0 > /sys/kernel/debug/tracing/tracing_on
