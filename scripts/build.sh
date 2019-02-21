#!/bin/bash
# Bash Menu Script Example

NORMAL='\033[0;m'        # No color
MENU='\033[0;36m'        # Cyan
NUMBER='\033[0;37m'      # White
GREEN_TEXT='\033[1;32m'  # Light Green
YELLOW_TEXT='\033[1;33m' # Light Yellow

show_menu()
{
	echo "${MENU}***********************************************${NORMAL}"
	echo "${MENU}** ${NUMBER}1) ${YELLOW_TEXT} Build Ibox with Cross-gcc ${NORMAL}"
	echo "${MENU}** ${NUMBER}2) ${YELLOW_TEXT} Build Ibox with Clang ${NORMAL}"
	echo "${MENU}** ${NUMBER}3) ${YELLOW_TEXT} Build Ibox Toolchain ${NORMAL}"
        echo "${MENU}** ${NUMBER}4) ${YELLOW_TEXT} Quit ${NORMAL}"
        echo "${MENU}***********************************************${NORMAL}"
	echo "${YELLOW_TEXT}Please select an option from the menu: ${NORMAL}"

        read opt
}

clear;
show_menu;
while [ opt != '' ]
	do
	if [ $opt = "" ]; then
		exit;
	else
		case $opt in
			1) clear;
			echo "${GREEN_TEXT}Running Build Script${NORMAL}";
                        sh ./scripts/run-cross.sh
                        echo '';
			show_menu;
			;;

			2) clear;
			echo "${GREEN_TEXT}Running Build Script${Normal}"
			sh ./scripts/run-clang.sh
			echo '';
			show_menu;
			;;

			4) break;
			;;

			*) clear;
			echo "${NUMBER}Pick an option from the menu${NORMAL}";
			echo '';
			show_menu;
			;;
		esac
	fi
done
