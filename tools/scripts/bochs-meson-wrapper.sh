#!/bin/bash

# To run the X terminal in WSL, WSL2 uses the windows ip address to connect to the network host while WSL uses the localhost
# WSl2 uses export DISPLAY = nameserver - (which changes) while WSL uses export DISPLAY = :0 or localhost:0.0 (127.0.0.1)
export DISPLAY=$(grep nameserver /etc/resolv.conf | awk '{print $2}'):0.0

# To supress libGL error on WSL2 when using VcXsrv Xserver: native opengl checked mark in options
# libgl error: No matching fbConfigs or visuals found, failed to load driver: swrast
export LIBGL_ALWAYS_INDIRECT=1

# Run image from build folder (cross = cross-compiled build, clang = clang/llvm build)
if [ "$NAME" == "cross" ]; then
  bochs -f .bochsrc -q
else [ "$NAME" == "clang" ]
  bochs -f ~/ibox-test/bochsrc.txt -q
fi
