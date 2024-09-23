#!/usr/bin/env bash

# To supress libGL error on WSL2 when using VcXsrv Xserver.
# Libgl error: No matching fbConfigs or visuals found, failed to load driver: swrast
export LIBGL_ALWAYS_INDIRECT=1

# To supprese the accessibility bug on WSL1 when using VcXsrv Xserver.
# Warning: dbind: Couldn't connect to accessibility bus: Failed to connect to socket /tmp/dbus-4TyNnZBUPT: Connection refused
export NO_AT_BRIDGE=1

# To run the X terminal in WSL, we must export the display which is different for versions 1 and 2.
# WSL2 uses the windows ip address to connect to the network host (nameserver) while WSL uses the localhost (127.0.0.1)
if [[ "$(</proc/sys/kernel/osrelease)" == *microsoft* ]]; then
  echo Running on WSl2
  export DISPLAY=$(grep nameserver /etc/resolv.conf | awk '{print $2}'):0.0
elif [[ "$(</proc/sys/kernel/osrelease)" == *Microsoft* ]]; then
  echo Running on WSL1
  export DISPLAY=:0
else
  echo WSL1/WSL2 not detected, must be runing on Linux
fi

# Run image from build folder (cross = cross-compiled build, clang = clang/llvm build)
if [ "$NAME" == "cross" ]; then
  qemu-system-x86_64 -net none -boot order=d -vga std -serial file:${PWD}/serial.log -cdrom ${PWD}/boot.iso
else [ "$NAME" == "clang" ]
  qemu-system-x86_64 -net none -boot order=d -vga std -serial file:${PWD}/serial.log -cdrom ${PWD}/boot.iso
fi
