#!/bin/sh

# enable tracing
echo 1 > /sys/kernel/debug/tracing/tracing_on

# select tracing events
echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_exception_hvc/enable
echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_guest_fault/enable
