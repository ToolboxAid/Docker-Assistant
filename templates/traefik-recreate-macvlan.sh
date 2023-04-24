#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  04/24/2023
#
# "traefik-recreate-macvlan.sh" 
#

INCLUDE_PATH=../scripts

if [ -d "${INCLUDE_PATH}" ]
then
    clear
    BASE_EXE=`basename "$0"`
    echo ">>>>> Executing: $BASE_EXE <<<<<"

    . $INCLUDE_PATH/TBA_color.sh
    . $INCLUDE_PATH/TBA_functions.sh
    . $INCLUDE_PATH/TBA_networking.sh
    . $INCLUDE_PATH/TBA_env_file.sh
else
    echo -e "Error: Directory does not exists -> '\e[31m${INCLUDE_PATH}\e[0m'."
        exit 1
fi

# Script path must exist before we continue
requires_root

get_user_group

load_env $PWD/.common.env

echo "-----------------------------------------"

usage(){
    echo -e "${Red}Usage: script"
    build_exit 1
}

check_parameter_count 0 $#
if [ $correctCount != True ]; then
	usage
	build_exit 69 "./"
fi

echo "-----------------------------------------"
echo "Recreating macvlan"

get_router_IP
get_gateway_info

echo "docker network delete macvlan"
docker network delete macvlan
echo "docker network create -d macvlan --subnet=$gateway_subnet --gateway=$gateway_IP -o parent=$gateway_card $ROUTER_2_TRAEFIK"
docker network create -d macvlan --subnet=$gateway_subnet --gateway=$gateway_IP -o parent=$gateway_card $ROUTER_2_TRAEFIK

cat <<EOF
>  '$0'

Network created:
    - '$ROUTER_2_TRAEFIK : $r2t'
EOF


all_done $DOCKER_PATH/$ENV/$SITE
above line does not return, so no code to execute here and blow
