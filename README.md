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
You Need git, make, nasm, clang/llvm and a gcc cross-compiler to build ibox. You may also have to add permissions to your system to get it to work, on some linux systems you will have to sudo which is bad. 

- First, you need to clone the repository with [code]git clone[/code] or download / fork from the repo in the top right corner
- Then you need to [code[Cd[/code] into the directory where you stored the repo
- In the main directory, type [code]make[/code] to auto build
- Once its done building, type [code]make bochs' or 'make qemu'[/code] to run the iso
- Type [code]'make clean'[/code] to clean the build and start over

