#!/bin/bash
## GCC Cross Compiler ##

# Dependency to build gcc cross compiler
apt-get update && apt-get install -y gcc wget build-essential

# Specify binutils/gcc version
DOWNLOAD_BINUTILS=binutils-2.29
DOWNLOAD_GCC=gcc-7.1.0

# Download binutils/gcc and its dependencies
mkdir -p /src && cd /src
wget -q http://ftp.gnu.org/gnu/binutils/$DOWNLOAD_BINUTILS.tar.gz
tar -xzf $DOWNLOAD_BINUTILS.tar.gz

wget -q ftp://ftp.gnu.org/gnu/gcc/$DOWNLOAD_GCC/$DOWNLOAD_GCC.tar.gz
tar -xzf $DOWNLOAD_GCC.tar.gz

cd /src/$DOWNLOAD_GCC && contrib/download_prerequisites

# Specify PREFIX, TARGET and PATH
export PREFIX=/usr/local/cross
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

# Build binutils (perpare seperate directory only for build)
mkdir -p /src/build_binutils && cd /src/build_binutils
/src/$DOWNLOAD_BINUTILS/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make && make install

# Build gcc (perpare seperate directory only for build)
mkdir -p /src/build_gcc && cd /src/build_gcc
/src/$DOWNLOAD_GCC/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc && make all-target-libgcc
make install-gcc && make install-target-libgcc

## Grub-mkrescue ##
#apt-get install -y xorriso
