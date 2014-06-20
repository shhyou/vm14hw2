#!/bin/sh
mount -t debugfs none /sys/kernel/debug
echo 102400 > /sys/kernel/debug/tracing/buffer_size_kb
