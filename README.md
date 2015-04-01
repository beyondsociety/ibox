# About Ibox 
Ibox is a operating system project being developed for research and academic purposes. Its intent is to create an operating system capable of supporting future and advancing technologies. One day it may become stable enough to be used in the embedded, high-end desktop, server, mainframe and research markets.

# Features
- Own custom multiboot bootloader capable of booting from numerous hardware device
- Written in a high level language that supports object oriented features and concurrency
- Uses a second generation microkernel based on ideas from L4
- Support for 64-bit, multicore and mutiprocessor systems including numa
- Support for homogeneous and heterogeneous distributed systems
- Support for computer clusters, grid computing and network nodes 

# Build Instructions
You need git, make, nasm, clang/llvm or gcc cross-compiler to build ibox. You may also have to add permissions to your system to get it to work, on some linux systems you will have to sudo which is bad. 

- First, you need to clone the repository with **git clone** or download / fork from the repo in the top right corner
- Then you need to **Cd** into the directory where you stored the repo
- In the main directory, type **make** to auto build
- Once its done building, type **make bochs** or **make qemu** to run the iso
- Type **make clean** to clean the build and start over

Ibox is built using **clang*8 and **LLVM** but also can be built with a **cross-compiled gcc** as well if you want, You just need to edit the rules.mk file and change **CC** from **'clang'** to **'cross-compiled gcc'** as well as the **LDFLAGS**. Eventually I want to switch to a build script to detect and auto build based on your installed tools.  
