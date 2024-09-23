#!/usr/bin/env bash

# Specify the binutils/gcc versions
BINUTILS_VERSION="binutils-2.42"
GCC_VERSION="gcc-13.3.0"

YELLOW_TEXT='\033[1;33m'  # Bold Yellow
GREEN_TEXT='\033[1;32m'   # Bold Green
NORMAL='\033[0;m'         # No color

echo '';
# If the number of arguments is not equal to 2, then display an error message
if [ "$#" -ne 2 ];
  then
    echo -e "${GREEN_TEXT}You must supply a target-arch and prefix-dir to use ${NORMAL}"
	exit 1
elif [ -d $2 ];
  then
    #echo -e "${GREEN_TEXT}Cross-compiler directory found, adding cross-compiler path:$2${NORMAL}"
    echo -e "${GREEN_TEXT}Cross-compiler directory found, adding cross-compiler path:${NORMAL}"
    export PATH="$2/bin:$PATH"
  exit 0
else
	echo -e "${GREEN_TEXT}No Cross-compiler directory found, building cross-compiler ${NORMAL}"
fi

# Todo: add a if/else sattement for os detection for other package managers (mainly for nixos)
# Dependencies to build the gcc cross-compiler
#sudo apt-get update && sudo apt-get install -y gcc wget m4 texinfo build-essential

# TODO: Add a if/else sattement for arch detection so we can build a cross-compiler for
#   both architectures (mainly for nixos)
# Create source directory and switch to it
mkdir -p src && cd src

# Download binutils / gcc 
echo ""
echo -e "${GREEN_TEXT}--> [STATUS] downloading sources... ${NORMAL}"
if [ -f $PWD/$BINUTILS_VERSION.tar.gz ] && [ -f $PWD/$GCC_VERSION.tar.gz ]
  then
	  echo "$BINUTILS_VERSION.tar.gz already exists" &&
    echo "$GCC_VERSION.tar.gz already exists"
  else
    wget https://ftp.gnu.org/gnu/binutils/$BINUTILS_VERSION.tar.gz &&
    wget https://ftp.gnu.org/gnu/gcc/$GCC_VERSION/$GCC_VERSION.tar.gz
fi

# Unpack binutils / gcc 
echo '';
echo -e "${GREEN_TEXT}--> [STATUS] unpacking source files${NORMAL}"
if [ -d $PWD/$BINUTILS_VERSION ] && [ -d $PWD/$GCC_VERSION ]
  then
    echo "$BINUTILS_VERSION already unpacked" &&
	  echo "$GCC_VERSION already unpacked"
  else
	  tar -xvzf $BINUTILS_VERSION.tar.gz &&
	  tar -xvzf $GCC_VERSION.tar.gz
fi

# Download dependencies for gcc
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
#make -j $(nproc) && make install
make && make install

# Build Gcc
cd ..
mkdir -p build-gcc && cd build-gcc
$PWD/../$GCC_VERSION/configure --target=$TARGET --prefix=$PREFIX --disable-nls --enable-languages=c,c++ --without-headers --disable-werror

#make -j $(nproc) all-gcc && make -j $(nproc) all-target-libgcc
#make install-gcc && make install-target-libgcc
make all-gcc && make all-target-libgcc
make install-gcc && make install-target-libgcc

# TODO: Add a if/else sattement for os detection for other package managers (mainly for nixos) 
#   which installs packages differently.
# Dependencies for build/running ibox
#sudo apt-get install -y nasm xorriso genisoimage
