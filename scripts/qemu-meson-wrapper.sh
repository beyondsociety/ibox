#!/bin/bash

export DISPLAY=:0
qemu-system-x86_64 -net none -boot order=d -cdrom boot.iso
