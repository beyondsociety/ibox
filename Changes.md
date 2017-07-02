# Changes for Ibox Operating System

Complete re-write and code factorization.

Support code for 32 and 64-bit systems and arm, support for BIOS and EFI loading.

Switch build system to cmake or Tup depending on which works better for cross-compilation.

Make file that run cmake build system and script files, havent decided if i want to use make or ninja yet.

Opions to build Ibox with CLANG/LLVM or gcc-cross-compiler, eventually want to switch to D and use their tools.

Code written in C amd Intel Assembly, eventually switching code base to D.

Source-based and project auto documentation.

Debugging and IDE support.

Setup for testing on emulators and real hardware, Vagrant build/test server.
