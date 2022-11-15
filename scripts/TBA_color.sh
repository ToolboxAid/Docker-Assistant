#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# TBA_color.sh
#
#

# Reset
Color_Off='\033[0m'       # Text Reset
NC='\033[0m'			  # No Color

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

# intro $MESSAGE
display_color_intro(){
    echo -e "${UBlue}***** TBA_color.sh -> loaded *****${Color_Off}"
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
}

color_test_cases(){
#    . ../scripts/TBA_color.sh

    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
    echo "========================================="


	echo -e "I ${Red}love${NC} Bash"
	echo -e "\033[32mThis is in green\033[0m"
    echo -e "${Red}${On_Yellow}This is in Red on Yellow${Color_Off}"
    echo -e "${BIRed}${On_Yellow}This is in Int Red on Yellow${Color_Off}"
    echo -e "${UBlack}${On_White}This is in Black on White${Color_Off}"
    echo -e "Default/color off"

    echo "-----------------------------------------"
    echo -e "${Green}"
	echo "Multi Line Green"
	echo "line 1 G"
	echo "line 2 G"
	echo "line 3 G"
	echo -e "${Color_Off}"

    echo "-----------------------------------------"
    echo -e "${Yellow}"
    echo "Multi Line"
    echo "line 1 Y"
    echo "line 2 Y"
    echo "line 3 Y"
    echo -e "${Color_Off}"

    echo "-----------------------------------------"
    echo -e "${Red}This is in Red${Color_Off}"
    echo -e "${BRed}This is in BRed${Color_Off}"
    echo -e "${URed}This is in URed${Color_Off}"
    echo -e "${On_Red}This is in On_Red${Color_Off}"
    echo -e "${IRed}This is in IRed${Color_Off}"
    echo -e "${BIRed}This is in BIRed${Color_Off}"
    echo -e "${On_IRed}This is in On_IRed${Color_Off}"

    echo "-----------------------------------------"
    echo -e "${Black}This is in Black${Color_Off}"
    echo -e "${Red}This is in Red${Color_Off}"
    echo -e "${Green}This is in Green${Color_Off}"
    echo -e "${Yellow}This is in Yellow${Color_Off}"
    echo -e "${Blue}This is in Blue${Color_Off}"
    echo -e "${Purple}This is in Purple${Color_Off}"
    echo -e "${Cyan}This is in Cyan${Color_Off}"
    echo -e "${White}This is in White${Color_Off}"

    echo "-----------------------------------------"
    echo -e "${White}This is in White${Color_Off}"
    echo -e "${BWhite}This is in BWhite${Color_Off}"
    echo -e "${UWhite}This is in UWhite${Color_Off}"
    echo -e "${On_White}This is in On_White${Color_Off}"
    echo -e "${IWhite}This is in IWhite${Color_Off}"
    echo -e "${BIWhite}This is in BIWhite${Color_Off}"
    echo -e "${On_IWhite}This is in On_IWhite${Color_Off}"

    echo "-----------------------------------------"
    echo -e "${White}This is in White${BWhite}This is in BWhite${UWhite}This is in UWhite${Color_Off}${On_White}This is in On_White${Color_Off}${IWhite}This is in IWhite${Color_Off}${BIWhite}This is in BIWhite${Color_Off}${On_IWhite}This is in On_IWhite${Color_Off}"
	
    # must be last
    all_done
}

TEST="$1"
if [[ $SUDO_COMMAND =~ "TBA_color" ]] && [ $TEST ] && [ $TEST == "yes" ]; then
    clear

	INCLUDE_PATH=./

	display_color_intro

    echo -e "${IBlue}***** ${Black}${On_White}TEST=$TEST${IBlue}, debug will run *****${Color_Off}"

    . $INCLUDE_PATH/TBA_functions.sh
    . $INCLUDE_PATH/TBA_networking.sh
	. $INCLUDE_PATH/TBA_random.sh

    echo -e "***** ${Black}${On_White}Running test_cases${Color_Off} *****"
	
	color_test_cases
else
	# show what we are doing
	display_color_intro	
fi

#if [[ $SUDO_COMMAND =~ "color" ]]; then
#	echo "COLOR"
#else
#	echo $SUDO_COMMAND
#	echo "not color"
#fi

