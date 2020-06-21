#!/bin/bash

# Specify the binutils/gcc versions
BINUTILS_VERSION="binutils-2.34"
GCC_VERSION="gcc-8.3.0"

# If the number of arguments is not equal to 2, then display an error message
if [ "$#" -ne 2 ];
   then
        echo "You must supply a target-arch and prefix-dir to use"
	exit 1

elif [ -d $2 ];
   then
	echo "Cross-compiler directory found, adding cross-compiler path:$2"
	export PATH=$2/bin:$PATH
        exit 0

else
	echo "No Cross-compiler directory found, building cross-compiler"
fi

# Dependencies to build the gcc cross-compiler
sudo apt-get update && sudo apt-get install -y gcc wget m4 texinfo build-essential

# Create source directory and switch to it
mkdir -p src && cd src

# Download binutils/gcc and its dependencies
echo ""
echo "--> [STATUS] downloading sources..."
if [ ! -f $PWD/$BINUTILS_VERSION.tar.gz ] && [ ! -f $PWD/$GCC_VERSION.tar.gz ]
   then
	wget https://ftp.gnu.org/gnu/binutils/$BINUTILS_VERSION.tar.gz &&
	wget https://ftp.gnu.org/gnu/gcc/$GCC_VERSION/$GCC_VERSION.tar.gz
else
	echo "$BINUTILS_VERSION.tar.gz already exists" &&
	echo "$GCC_VERSION.tar.gz already exists"
fi

echo "--> [STATUS] unpacking source files"
if [ ! -d $PWD/$BINUTILS_VERSION ] && [ ! -d $PWD/$GCC_VERSION ]
   then
	tar -xvzf $BINUTILS_VERSION.tar.gz &&
	tar -xvzf $GCC_VERSION.tar.gz
else
	echo "$BINUTILS_VERSION already unpacked" &&
	echo "$GCC_VERSION already unpacked"
fi

echo ""
cd $GCC_VERSION && contrib/download_prerequisites
echo ""

# Specify PREFIX, TARGET, and PATH
export TARGET=$1
export PREFIX=$2
export PATH="$PREFIX/bin:$PATH"

# Build Binutils
cd ..
mkdir -p build-binutils && cd build-binutils
$PWD/../$BINUTILS_VERSION/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j $(nproc) && make install
make && make install

# Build Gcc
cd ..
mkdir -p build-gcc && cd build-gcc
$PWD/../$GCC_VERSION/configure --target=$TARGET --prefix=$PREFIX --disable-nls --enable-languages=c,c++ --without-headers
make -j $(nproc) all-gcc && make -j $(nproc) all-target-libgcc
make install-gcc && make install-target-libgcc

# Dependencies for build/running ibox
sudo apt-get install -y nasm xorriso genisoimage

# Activate path for cross-compiler
export PATH=$PREFIX/bin:$PATH
