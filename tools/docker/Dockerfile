# Use an Ubuntu 20.04 LTS base image
FROM ubuntu:20.04

# Set the working directory to /build
WORKDIR /build

# Copy the current directory contents into the container at /build
ADD . /build

# Install any needed packages
RUN apt-get update && apt-get -y install \
wget \
g++ \
make \
flex \
bison \
libgmp3-dev \
libmpfr-dev \
libmpc-dev \
texinfo \
grub-common \
grub-pc-bin \
xorriso

RUN mkdir $HOME/src
WORKDIR $HOME/src

# Specify the binutils/gcc versions
BINUTILS_VERSION="binutils-2.34"
GCC_VERSION="gcc-8.3.0"

RUN wget https://ftp.gnu.org/gnu/binutils/BINUTILS_VERSION.tar.gz
RUN wget ftp://ftp.gnu.org/gnu/gcc/gcc-7.2.0/GCC_VERSION.tar.gz

RUN tar -xf BINUTILS_VERSION.tar.gz
RUN tar -xf GCC_VERSION.tar.gz

ENV PREFIX="$HOME/opt/cross"
ENV TARGET=i686-elf
ENV PATH="$PREFIX/bin:$PATH"

RUN mkdir build-binutils
WORKDIR build-binutils

RUN ../BINUTILS_VERSION/configure --target=$TARGET --prefix=$PREFIX --with-sysroot --disable-nls --disable-werror
RUN make
RUN make install

WORKDIR $HOME/src
RUN which -- $TARGET-as || echo $TARGET-as is not in the PATH

RUN mkdir build-gcc
WORKDIR build-gcc

RUN ../GCC_VERSION/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
RUN make all-gcc
RUN make all-target-libgcc
RUN make install-gcc
RUN make install-target-libgcc

ENV PATH="$HOME/opt/cross/bin:$PATH"
WORKDIR /build
