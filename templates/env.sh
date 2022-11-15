#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# up.sh
#

ENV_FILE_PATH=$PWD/.common.env

if [ $USER == "root" ]; then
	load_env $ENV_FILE_PATH
else
	clear

    BASE_EXE=`basename "$0"`
    echo ">>>>> $BASE_EXE <<<<<"

    INCLUDE_PATH=../scripts

    . $INCLUDE_PATH/TBA_color.sh
    . $INCLUDE_PATH/TBA_functions.sh
    . $INCLUDE_PATH/TBA_networking.sh
    . $INCLUDE_PATH/TBA_env_file.sh

    load_env $ENV_FILE_PATH

    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"

    echo -e "${Purple}"
    echo " DOCKER_PATH        : $DOCKER_PATH"
    echo " TIME_ZONE          : $TIME_ZONE"
    echo " TRAEFIK_IP         : $TRAEFIK_IP"
    echo " DOMAIN_NAME        : $DOMAIN_NAME"
    echo " CERT_RESOLVER      : $CERT_RESOLVER"

    echo " ADD_WHITELIST_SITE : $ADDITIONAL_WHITELIST_SITE"
    echo " RESTART            : $RESTART"
    echo " ROUTER_2_TRAEFIK   : $ROUTER_2_TRAEFIK"
    echo " TRAEFIK_4_LAN      : $TRAEFIK_4_LAN"
    echo " TRAEFIK_4_WAN      : $TRAEFIK_4_WAN"
    echo " LAN_2_DATABASE     : $LAN_2_DATABASE"
    echo " TRAEFIK_4_LAN      : $TRAEFIK_4_LAN"
    echo " LAN_2_WAN          : $LAN_2_WAN"
	echo " LAN_2_ROUTER       : $LAN_2_ROUTER"
    echo " WAN_2_DB_SUFFIX    : $WAN_2_DATABASE_SUFFIX"
    echo " EMAIL              : $EMAIL"
    echo -e "${Color_Off}"
fi

exit 0


