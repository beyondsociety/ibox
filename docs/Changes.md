# Changes for Ibox Operating System

1. Complete rewrite and code factorization.

2. Support code for 32 and 64-bit systems and arm, support for BIOS and EFI loading.

3. Switch build system to Cmake or Tup depending on which works better for cross-compilation.

4. Makefile that can run cmake build system and script files, havent decided if i want to use make or ninja yet.

5. Options to build Ibox with CLANG/LLVM or gcc-cross-compiler, eventually want to switch to D and use their tools.

6. Code written in C and Intel Assembly, eventually want to switch code base to D.

7. Source-based and project auto documentation.

8. Debugging and IDE support.

9. Setup for testing on emulators and real hardware, Vagrant build / test server.
