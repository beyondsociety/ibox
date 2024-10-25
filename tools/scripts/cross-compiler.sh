#!/usr/bin/env bash

# Specify the binutils/gcc versions
BINUTILS_VERSION="binutils-2.42"
GCC_VERSION="gcc-13.3.0"

YELLOW_TEXT='\033[1;33m'  # Bold Yellow
GREEN_TEXT='\033[1;32m'   # Bold Green
NORMAL='\033[0;m'         # No color

setup(){
  echo '';

  # If the number of arguments is not equal to 2, then display an error message
  if [ "$?" -gt 2 ];
    then
      echo -e "${GREEN_TEXT}You must supply a target-arch and prefix-dir to use ${NORMAL}" 
	  return 1
  elif [ -d $2 ];
    then
      echo -e "${GREEN_TEXT}Cross-compiler directory found, adding cross-compiler path:${NORMAL}"
      export PATH="$2/bin:$PATH"
    return 0
  else
	  echo -e "${GREEN_TEXT}No Cross-compiler directory found, building cross-compiler ${NORMAL}"
  fi
}

detect_os(){
  #OS=$(echo -e "\e[32m" $(uname -s | tr A-Z a-z) "\e[0m")
  OS=$(uname -s | tr A-Z a-z)

  case $OS in
    # Must be first since Windows subsystem for linux will have Linux in the name too 
    *Microsoft*) 
       OS="WSL"
    ;;     

    # WARNING: My v2 uses ubuntu 20.4 at the moment slightly different name may not always work
    *microsoft*) 
      OS="WSL2"
    ;;
    
    linux*)
      source /etc/os-release

      case $ID in
        debian | ubuntu | mint)
          OS="Either Debian, Ubuntu, or Mint Linux"
        ;;
      
        fedora | rhel | centos)
          OS="Either Fedora, Rhel, or Centos Linux" 
        ;;
      
        nixos)
          grep ‘NAME=NixOS’ /etc/os-release
          OS="Nixos"
        ;;

        *)
          echo -n "Unsupported Linux Distro"
        ;;
      esac
    ;;

    darwin*)
      OS="Macos Darwin"
    ;;

    *)
      echo -n "Unsupported Operating System"
    ;;
  esac

  echo ${OS};
}

check_dependencies(){
  if [ -v nix ] || [ -n "$NIX_PATH" ]  &> /dev/null; then
    echo '';
    echo "If we are runing on a Nixos System, our our dependencies for the cross-compiler will be defined in a flake.nix file"
    echo "that opens a nix shell for us. If we are instead using the nix package manager on a distro that supports it,"
    echo "see https://nix-tuapttorial.gitlabpages.inria.fr/nix-tutorial/getting-started.html for more details"
  else    
    # Declare our dependencies to build and run the gcc cross-compiler
    declare -Ag deps=([os]='gcc wget m4 texinfo build-essential nasm xorriso genisoimage')

    # Declare a list of package managers and their usages
    declare -Ag package_manager_list=(
      [packman]='pacman  -Sy'

      [apt]='sudo apt update && sudo apt get install -y; 
        sudo apt-get update && apt-get install -y'
        #echo "deb https://deb.debian.org/debian buster-backports main contrib non-free" > /etc/apt/sources.list.d/buster-backports.list' 
    
      [yum]='yum install -y epel-release; 
        yum repolist -y; 
        yum install -y'
      )

    # Find the package manager on the system and install the package manager
    install_deps(){
      for package_manager in ${!package_managers_list[@]}
      do
        which $package_manager &?/dev/null && eval $(echo ${package_manager_list[$package_manager]} "$*")
      done
    }

    # Install missing dependencies
    test -z ${missing_deps[0]} || install_deps ${missing_deps[@]} || fail "Dependencies could not be provided"
  fi
}

# TODO: Add a if/else sattement for arch detection so we can build a cross-compiler for
#   both architectures (mainly for nixos)
# Create source directory and switch to it
mkdir -p src && cd src

download_deps(){
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
}

build_deps(){
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
}

main(){
  setup
  detect_os
  check_dependencies
  download_deps
  #build_deps
}

main
