#!/usr/bin/env bash

# To supress libGL error on WSL2 when using VcXsrv Xserver.
# Libgl error: No matching fbConfigs or visuals found, failed to load driver: swrast
export LIBGL_ALWAYS_INDIRECT=1

# To supprese the accessibility bug on WSL1 when using VcXsrv Xserver.
# Warning: dbind: Couldn't connect to accessibility bus: Failed to connect to socket /tmp/dbus-4TyNnZBUPT: Connection refused
export NO_AT_BRIDGE=1

# To run the X terminal in WSL, we must export the display which is different for versions 1 and 2.
# If using WSL2 on Windows 10/11, we will use the windows ip address to connect to the network host (nameserver) when using a third party
# X server to run. If we are using WSLG on WIndows 11, use the localhost (127.0.0.1) just like we would on WSL1.
if [[ "$(</proc/sys/kernel/osrelease)" == *microsoft* ]]; then
  echo Running on WSl2
  # We are using WSLg on windows 11, so we are using export DISPLAY=:0. If we were using WSL2 on Windows 10/11 with a third-party 
  # X server, we would use "export DISPLAY=$(grep nameserver /etc/resolv.conf | awk '{print $2}'):0.0".
  # See https://askubuntu.com/questions/1299323/how-to-set-up-display-variable-for-wsl2-of-ubuntu-20 for more info.
  export DISPLAY=:0
elif [[ "$(</proc/sys/kernel/osrelease)" == *Microsoft* ]]; then
  echo Running on WSL1
  # For Windows 10/11 under WSL1 using a third-party X server to run
  export DISPLAY=:0
else
  echo WSL1/WSL2 not detected, must be runing on Linux
fi

# Run image from build folder (cross = cross-compiled build, clang = clang/llvm build)
if [ "$NAME" == "cross" ]; then
  qemu-system-x86_64 -net none -boot order=d -vga std -serial file:${PWD}/serial.log -cdrom ${PWD}/cross-build/boot.iso
else [ "$NAME" == "clang" ]
  qemu-system-x86_64 -net none -boot order=d -vga std -serial file:${PWD}/serial.log -cdrom ${PWD}/boot.iso
fi
