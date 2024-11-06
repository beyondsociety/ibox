#!/usr/bin/env bash

# Specify the binutils/gcc versions
BINUTILS_VERSION="binutils-2.43.1"
GCC_VERSION="gcc-13.3.0"

YELLOW_TEXT='\033[1;33m'  # Bold Yellow
GREEN_TEXT='\033[1;32m'   # Bold Green
NORMAL='\033[0;m'         # No color

detect_compiler_directory()
{
  echo '';

  # If the number of arguments is not equal to 2, then display an error message
  if [ "$?" -gt 2 ];
    then
      echo -e "${GREEN_TEXT}You must supply a target-arch and prefix-dir to use ${NORMAL}" 
	  return 1
  elif [ ! -d $2 ];
    then
      echo -e "${GREEN_TEXT}Cross-compiler directory found, adding cross-compiler path:${NORMAL}"
      #export PATH="$2/bin:$PATH"
      echo '';
    return 0
  else
	  echo -e "${GREEN_TEXT}No Cross-compiler directory found, building cross-compiler ${NORMAL}"
  fi
}

info()
{
  echo '';
  echo "In order to build the cross-compiler you will need to have access to root because of an issue with the build directories" 
  echo "not having root access (sudo), we will fix these permissions when we are dont building the cross-compiler. For now, either"
  echo "use "sudo -i" to gain root access or wait for the build script to ask for your user password."

  echo '';
  sleep 5;
}

detect_os()
{
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
      . /etc/os-release

      case $ID in
        debian | ubuntu | mint)
          OS="We are using a Debian, Ubuntu, or Mint Linux Distro"
        ;;
      
        fedora | rhel | centos)
          OS="We are using a Fedora, Rhel, or Centos Linux Distro" 
        ;;
      
        nixos)
          grep ‘NAME=NixOS’ /etc/os-release
          OS="We are using a Nixos DIstro"
        ;;

        *)
          echo -n "Unsupported Linux Distro"
        ;;
      esac
    ;;

    # TODO: Not needed, dont use a macos distro
    #darwin*)
    #  OS="We are using a Macos Darwin Distro"
    #;;

    *)
      echo -n "Otherwise, we are using a Unsupported Operating System"
    ;;
  esac

  echo ${OS};
}

check_dependencies()
{
  if command -v nix || -n "$NIX_PATH" &> /dev/null; then
    echo '';
    echo "If we are runing on a Nixos System, our our dependencies for the cross-compiler will be defined in a flake.nix file"
    echo "  that opens a nix shell for us. If we are instead using the nix package manager on a distro that supports it,"
    echo "see https://nix-tuapttorial.gitlabpages.inria.fr/nix-tutorial/getting-started.html for more details"
    echo '';
  else    
    echo -e "${GREEN_TEXT}No Nixos or nix package manager found${NORMAL}"
  fi
  
  # Declare our dependencies to build and run the gcc cross-compiler
  declare -Ag deps={[os]='gcc wget m4 texinfo build-essential nasm xorriso genisoimage'}

  # Declare a list of package managers and their usages
  declare -Ag package_managers_list={[apt]='apt update -y; apt update install -y'}
  #package_managers_list={ \
    #[packman]='which pacman' \ 
    #[apt]='apt install -y' \ 
    #[apt-get]'apt-get update -y; apt-get install -y' \
    #[yum]='yum install -y; epel-release; yum repolist -y; yum install -y'}

  # Find the package manager on the system and install the package manager
  install_deps()
  {
    for package_manager in ${!package_managers_list[@]}
     do
      which $package_manager &>/dev/null && eval $(echo ${package_managers_list[$package_manager]} "$*")
    done
  }

  #Find the missing packages from list of dependencies
  declare -Ag missing_deps=(gcc wget m4 texinfo build-essential nasm xorriso genisoimage)
  for package in ${!deps[@]}
    do
      which $package &>/dev/null || missing_deps+=(${deps[$package]})
  done

  # Install missing dependencies
  test -z ${missing_deps[0]} || install_deps ${missing_deps[@]} || { echo 'Dependencies could not be provided'; exit 1;}
}

# TODO: Add a if/else sattement for arch detection so we can build a cross-compiler for
#   both architectures (mainly for nixos)
# Create source directory and switch to it
#mkdir -p src && cd src

download_deps()
{
  mkdir -p src && cd src

  mkdir -p build-binutils 
  mkdir -p build-gcc

  # Download binutils / gcc 
  echo '';
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
	  tar -xvzf $PWD/$BINUTILS_VERSION.tar.gz &&
	  tar -xvzf $PWD/$GCC_VERSION.tar.gz
  fi
}

build_deps()
{
  # Download dependencies for gcc
  echo '';
  cd $GCC_VERSION && contrib/download_prerequisites
  echo '';

  # Specify PREFIX, TARGET, and PATH
  #export TARGET=$1
  export TARGET=i686-elf
  export PREFIX=/usr/local/cross32
  #export PREFIX=$2
  export PATH="$PREFIX/bin:$PATH"

  # Build Binutils
  cd ..
  
  #mkdir -p build-binutils && 
  cd build-binutils
  $PWD/../$BINUTILS_VERSION/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
  #make -j $(nproc) && make install
  sudo make && make install

  # Build Gcc
  cd ..
  #mkdir -p build-gcc && 
  cd build-gcc
  # IF we want to build a 32-bit cross-compiler, add --enable multilib, otherwsie us --disasble-multilib for a 64-bit crosscompiler 
  $PWD/../$GCC_VERSION/configure --target=$TARGET --prefix=$PREFIX --disable-nls --enable-languages=c,c++ --without-headers  

  #make -j $(nproc) all-gcc && make -j $(nproc) all-target-libgcc
  #make install-gcc && make install-target-libgcc
  make all-gcc && make all-target-libgcc
  make install-gcc && make install-target-libgcc
}

main()
{
  detect_compiler_directory
  info
  detect_os
  check_dependencies
  download_deps
  build_deps
}

main
