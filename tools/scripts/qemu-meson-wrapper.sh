#!/bin/bash

export DISPLAY=:0
if [ "$NAME" == "cross" ]; then=
  qemu-system-x86_64 -net none -boot order=d -vga std -serial file:${PWD}/cross-build/serial.log -cdrom ${PWD}/cross-build/boot.iso
else [ "$NAME" == "clang" ]
  qemu-system-x86_64 -net none -boot order=d -vga std -serial file:${PWD}/clang-build/serial.log -cdrom ${PWD}/clang-build/boot.iso
fi
