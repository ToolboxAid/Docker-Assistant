#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# "docker_zip_backup.sh"
#

INCLUDE_PATH=../scripts

if [ -d "${INCLUDE_PATH}" ]
then
    clear
    BASE_EXE=`basename "$0"`
    echo ">>>>> Executing: $BASE_EXE <<<<<"

    . $INCLUDE_PATH/TBA_color.sh
    . $INCLUDE_PATH/TBA_functions.sh
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
else
    echo -e "Error: Directory does not exists -> '\e[31m${INCLUDE_PATH}\e[0m'."
        exit 1
fi

# Script path must exist before we continue
requires_root

#load_env $PWD/.backup_env
load_env $PWD/.docker.zip.env

usage(){
    echo -e "${Red}Usage: docker_zip_backup.sh {TYPE}"
	echo " TYPE: base - backup only custom_data, scripts & templates"
	echo " TYPE: site - backup only wan, lan, dev directories"
	echo " TYPE: full - backup site & base"
    build_exit 1
}

# intro $MESSAGE
display_docker_backup_intro(){
    echo -e "${UBlue}***** docker_zip_backup.sh -> loaded *****${Color_Off}"
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
}

check_parameter_count 1 $#
if [ $correctCount != True ]; then
	usage
	build_exit 87 "./"
fi

echo "-----------------------------------------"
TYPE=$1
FULL_BACKUP_NAME=$FULL_BACKUP_NAME
SITE_BACKUP_NAME=$SITE_BACKUP_NAME
BASE_BACKUP_NAME=$BASE_BACKUP_NAME

# show what we are doing
display_docker_backup_intro

if [ "$#" -ne 1 ]; then
    echo -e "${On_Red}Illegal number of parameters${Color_off}"
	usage
fi

# what are we doing? {dk or ws}
if [ $TYPE = 'full' ]; then
    echo "Full backup"
	BACKUP_NAME=$FULL_BACKUP_NAME
    INCLUDE=$FULL_INCLUDE
elif [ $TYPE = 'site' ]; then
    echo "Site backup"
	BACKUP_NAME=$SITE_BACKUP_NAME
    INCLUDE=$SITE_INCLUDE
elif [ $TYPE = 'base' ]; then
    echo "Base backup"
	BACKUP_NAME=$BASE_BACKUP_NAME
    INCLUDE=$BASE_INCLUDE
else
    echo -e "${On_Red}What are we doing? Valid environments are {full, site, base)${Color_off}"
    usage
fi

echo "-----------------------------------------"
echo $BACKUP_NAME
echo $INCLUDE
echo "-----------------------------------------"

SCRIPTDIR=$PWD
#echo $SCRIPTDIR

cd ..
DA_PATH=$PWD
#echo "DA_PATH: $DA_PATH"

DA_PATH=./$(echo "${DA_PATH##/*/}")
#echo "DA_PATH: $DA_PATH"

cd ..
#echo "PWD: $PWD"

TIME_STAMP=_$(date '+%Y-%m-%d_%H-%M-%S')
#echo "Time Stamp: $TIME_STAMP"

echo "-----------------------------------------"
echo $SCRIPTDIR/$INCLUDE
cat $SCRIPTDIR/$INCLUDE
echo "-----------------------------------------"

TRIMMED=$(echo "$BACKUP_PATH" | sed 's:/*$::')
BACKUP_PATH=$TRIMMED/$BACKUP_NAME$TIME_STAMP.zip

#echo "zip -r $BACKUP_PATH $DA_PATH/ -i@$SCRIPTDIR/$INCLUDE"
zip -r $BACKUP_PATH  $DA_PATH -i@$SCRIPTDIR/$INCLUDE

echo "-----------------------------------------"
cd $SCRIPTDIR

echo -e "${Green}Backup complete...to : $BACKUP_PATH ${Color_Off}"
ls -la $BACKUP_PATH
echo "-----------------------------------------"


