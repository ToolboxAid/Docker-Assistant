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
    echo " TRAEFIK         : $TRAEFIK"
    echo " SITE            : $SITE"
    echo " RESTART         : $RESTART"
    echo " CERT_RESOLVER   : $CERT_RESOLVER"
    echo " TIME_ZONE       : $TIME_ZONE"

    echo " WP_USER         : $WP_USER"
    echo " WP_EMAIL        : $WP_EMAIL"
    echo " WP_PSWD         : $WP_PSWD"
    echo " WP_FIRST_NAME   : $WP_FIRST_NAME"
    echo " WP_LAST_NAME    : $WP_LAST_NAME"

    echo " DB_PORT         : $DB_PORT"
    echo " DB_NAME         : $DB_NAME"
    echo " DB_USER         : $DB_USER"
    echo " DB_PASSWORD     : $DB_PASSWORD"
    echo " ROOT_USER       : $ROOT_USER"
    echo " ROOT_PASSWORD   : $ROOT_PASSWORD"
    echo " TABLE_PREFIX    : $TABLE_PREFIX"

    echo " TRAEFIK_4_WAN   : $TRAEFIK_4_WAN"
    echo " LAN_2_DATABASE  : $LAN_2_DATABASE"
    echo " IP_WHITE_LIST   : $IP_WHITE_LIST"
    echo " TRUSTED_IP_LIST : $TRUSTED_IP_LIST"
    echo -e "${Color_Off}"
fi

