#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# htpasswd.add.sh
#

# https://httpd.apache.org/docs/2.4/programs/htpasswd.html

HTPASSWD_FILE=.traefik.htpasswd
BCRYPT=12
INCLUDE_PATH=../../scripts

#  71  htpasswd -B -C 12 ./htpasswd.txt davidq
#  72  htpasswd -v ./htpasswd.txt davidq
#  77  htpasswd -D ./htpasswd.txt davidq

clear

BASE_EXE=`basename "$0"`
echo ">>>>> $BASE_EXE <<<<<"

. $INCLUDE_PATH/TBA_color.sh
. $INCLUDE_PATH/TBA_functions.sh
echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"

load_env

if [ $USER == "root" ]; then

    echo -e "${Red}This is PROD${Color_Off}"

	if [[ $PWD != *"wan"* ]]; then
		    echo -e "${Yellow}Can only run from 'wan' folder${Color_Off}"
            build_exit 80 $PWD
	fi

	HTPASSWD_PATH=./data/$HTPASSWD_FILE
	if [ ! -f ${HTPASSWD_PATH} ]; then
		touch $HTPASSWD_PATH
	fi
else
	echo -e "${Cyan}This is test, will not update prod htpasswd${Color_Off}"

    if [[ $PWD != *"template"* ]]; then
            echo -e "${Yellow}Can only run from 'template' folder as non prod${Color_Off}"
            build_exit 81 $PWD
    fi

    HTPASSWD_PATH=./$HTPASSWD_FILE
    if [ ! -f ${HTPASSWD_PATH} ]; then
        touch $HTPASSWD_PATH
    fi
fi

read -p 'add/update user name: ' CHANGE_USER

htpasswd -B -C $BCRYPT  $HTPASSWD_PATH $CHANGE_USER

cat ./$HTPASSWD_PATH

echo -e "${Green} You must run 'restart.sh' for this change to take effect. ${Color_Off}"

echo "-----------------------------------------"
echo -e "${Green}Done!${Color_Off}"

