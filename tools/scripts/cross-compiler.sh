#!/bin/bash

# Specify the binutils/gcc versions
BINUTILS_VERSION="binutils-2.34"
GCC_VERSION="gcc-8.3.0"

GREEN_TEXT='\033[1;32m'  # Bold Green
NORMAL='\033[0;m'        # No color

# If the number of arguments is not equal to 2, then display an error message
if [ "$#" -ne 2 ];
  then
    echo "${GREEN_TEXT}You must supply a target-arch and prefix-dir to use${NORMAL}"
	exit 1
elif [ -d $2 ];
  then
    echo "${GREEN_TEXT}Cross-compiler directory found, adding cross-compiler path - $2${NORMAL}"
    export PATH="$2/bin:$PATH"
  exit 0
else
	echo "${GREEN_TEXT}No Cross-compiler directory found, building cross-compiler${NORMAL}"
fi

# Dependencies to build the gcc cross-compiler
sudo apt-get update && sudo apt-get install -y gcc wget m4 texinfo build-essential

# Create source directory and switch to it
mkdir -p src && cd src

# Download binutils/gcc and its dependencies
echo ""
echo "${GREEN_TEXT}--> [STATUS] downloading sources...${NORMAL}"
if [ ! -f $PWD/$BINUTILS_VERSION.tar.gz ] && [ ! -f $PWD/$GCC_VERSION.tar.gz ]
  then
	  wget https://ftp.gnu.org/gnu/binutils/$BINUTILS_VERSION.tar.gz &&
    wget https://ftp.gnu.org/gnu/gcc/$GCC_VERSION/$GCC_VERSION.tar.gz
  else
    echo "$BINUTILS_VERSION.tar.gz already exists" &&
    echo "$GCC_VERSION.tar.gz already exists"
fi

echo "${GREEN_TEXT}--> [STATUS] unpacking source files${NORMAL}"
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
sudo make -j $(nproc) && sudo make install

# Not sure why I need to sudo the configure/make/isntall commands in order to run?

# Build Gcc
cd ..
mkdir -p build-gcc && cd build-gcc
$PWD/../$GCC_VERSION/configure --target=$TARGET --prefix=$PREFIX --disable-nls --enable-languages=c,c++ --without-headers
sudo make -j $(nproc) all-gcc && sudo make -j $(nproc) all-target-libgcc
sudo make install-gcc && sudo make install-target-libgcc

# Dependencies for build/running ibox
sudo apt-get install -y nasm xorriso genisoimage
