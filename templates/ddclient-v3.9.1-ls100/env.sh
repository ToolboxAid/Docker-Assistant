#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# env.sh
#

if [ $USER == "root" ]; then
        load_env
else

        clear

    BASE_EXE=`basename "$0"`
    echo ">>>>> $BASE_EXE <<<<<"

        INCLUDE_PATH=../../scripts

    . $INCLUDE_PATH/TBA_color.sh
    . $INCLUDE_PATH/TBA_functions.sh
        . $INCLUDE_PATH/TBA_networking.sh
    . $INCLUDE_PATH/TBA_env_file.sh
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
        load_env

    echo -e "${Purple}"
    echo " NAME         : $NAME"
    echo " TIME_ZONE    : $TIME_ZONE"
    echo " RESTART      : $RESTART"
        echo " LAN_2_ROUTER : $LAN_2_ROUTER"
    echo -e "${Color_Off}"
fi
