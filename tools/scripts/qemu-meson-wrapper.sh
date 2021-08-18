#!/bin/bash

# To run the X terminal in WSL, WSL2 uses the windows ip address to connect to the network host while WSL uses the localhost
# WSl2 uses export DISPLAY = nameserver - (which changes) while WSL uses export DISPLAY = :0 or localhost:0.0 (127.0.0.1)
export DISPLAY=$(grep nameserver /etc/resolv.conf | awk '{print $2}'):0.0

# To supress libGL error on WSL2 when using VcXsrv Xserver: native opengl checked mark in options
# libgl error: No matching fbConfigs or visuals found, failed to load driver: swrast
export LIBGL_ALWAYS_INDIRECT=1

# Run image from build folder (cross = cross-compiled build, clang = clang/llvm build)
if [ "$NAME" == "cross" ]; then
  qemu-system-x86_64 -net none -boot order=d -M 512 -vga std -serial file:${PWD}/serial.log -cdrom ${PWD}/boot.iso
else [ "$NAME" == "clang" ]
  qemu-system-x86_64 -net none -boot order=d -vga std -serial file:${PWD}/serial.log -cdrom ${PWD}/boot.iso
fi
