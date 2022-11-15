#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# log.error.sh
#

INCLUDE_PATH=../../scripts

if [ -d "${INCLUDE_PATH}" ]
then
    clear
    BASE_EXE=`basename "$0"`
    echo ">>>>> Executing: $BASE_EXE <<<<<"

    . $INCLUDE_PATH/TBA_color.sh
    . $INCLUDE_PATH/TBA_functions.sh

    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
else
    echo -e "Error: Directory does not exists -> '\e[31m../../scripts\e[0m'."
    exit 1
fi

# Script path must exist before we continue
requires_root

source ./env.sh

echo "-----------------------------------------"
echo "docker logs -f ${NAME} 2>/dev/null"
docker logs -f ${NAME} 2>/dev/null
echo "-----------------------------------------"
echo -e "${Green}Done!${Color_off}"
