#!/usr/bin/env bash

NORMAL='\033[0;m'          # No color
MENU='\033[0;1;36m'        # Bold Cyan
NUMBER='\033[0;1;37m'      # Bold White
YELLOW_TEXT='\033[1;33m'   # Bold Yellow
GREEN_TEXT='\033[1;32m'    # Bold Green

show_menu()
{
  echo '';
  echo -e "${MENU}**************************************************************${NORMAL}"
	echo -e "${MENU}** ${NUMBER}1) ${YELLOW_TEXT} Build Ibox with Cross-gcc ${NORMAL}"
	echo -e "${MENU}** ${NUMBER}2) ${YELLOW_TEXT} Build Ibox with Clang ${NORMAL}"
	echo -e "${MENU}** ${NUMBER}3) ${YELLOW_TEXT} Build Ibox Toolchain ${NORMAL}"
	echo -e "${MENU}** ${NUMBER}4) ${YELLOW_TEXT} Run Qemu ${NORMAL}"
	echo -e "${MENU}** ${NUMBER}5) ${YELLOW_TEXT} Run Bochs ${NORMAL}"
	echo -e "${MENU}** ${NUMBER}6) ${YELLOW_TEXT} Quit ${NORMAL}"
	echo -e "${MENU}**************************************************************${NORMAL}"
	echo -en "${YELLOW_TEXT}Please select an option from the menu: ${NORMAL}"

  read opt
}

show_menu;

while [ opt != '' ]
  do
    if [ $opt = "" ]; then
      exit;
    else
      case $opt in

  1) clear;
	  echo '';
    sh ./tools/scripts/run-cross.sh 
    echo '';
	  show_menu;
	;;

	2) clear;
	  echo '';
	  sh ./tools/scripts/run-clang.sh
	  echo '';
	  show_menu;
	;;

	3) clear;
	  echo '';
	  echo "Please specify a build-target (i686-elf or x86_64-elf) and prefix-dir (location of toolchain) \
	    to build the toolchain"; sleep 3;
	  read -p $'\e[1;33mbuild-target\e[0m: ' TARGET; read -p $'\e[1;33mprefix-dir\e[0m: ' PREFIX
          sh ./tools/scripts/cross-compiler.sh $TARGET $PREFIX
	  echo '';
	  show_menu;
	;;

	4) clear;
	  echo '';
	  read -p $'\e[1;33mPass the name of the build-toolchain for Qemu to run (cross or clang)\e[0m: ' NAME
	    if [ "$NAME" == "cross" ]; then
	      ninja -C cross-build qemu
	    elif [ "$NAME" == "clang" ]; then 
	      ninja -C clang-build qemu
      else  
        echo -e ${GREEN_TEXT}"No build-toolchain found, must be either cross or clang"${NORMAL}
      fi
      
	  echo '';
	  show_menu;
	;;

	5) clear;
	  echo '';
	  read -p $'\e[1;33mPass the name of the build-tool for Bochs to run (cross or clang)\e[0m: ' NAME
      if [ "$NAME" == "cross" ]; then
	      ninja -C cross-build bochs
	    elif [ "$NAME" == "clang" ]; then
	      ninja -C clang-build bochs
      else
        echo -e ${GREEN_TEXT}"No build-toolchain found, must be either cross or clang"${NORMAL} 
	    fi
	  
    echo '';
	  show_menu;
	;;

	# Quit
	6) break;
	  ;;

	# Clears the screen and shows memu
	*) clear;
	  show_menu;
	  ;;
	  esac
  fi
done
