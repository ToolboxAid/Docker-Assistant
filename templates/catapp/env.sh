#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# up.sh
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
    echo " TRAEFIK          : $TRAEFIK"
    echo " SITE             : $SITE"
    echo " RESTART          : $RESTART"
    echo " CERT_RESOLVER    : $CERT_RESOLVER"
    echo " TRUSTED_IP_LIST  : $TRUSTED_IP_LIST"
	echo " TRAEFIK_4_LAN    : $TRAEFIK_4_LAN"
    echo -e "${Color_Off}"
fi

