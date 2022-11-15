#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# "docker_prune.sh 
#
#

INCLUDE_PATH=./

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

#load_env $PWD/.backup_env
#load_env $PWD/.TBA_docker_zip_env

display_docker_prune_intro(){
    echo -e "${UBlue}***** docker_prune.sh -> loaded *****${Color_Off}"
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
}

echo "-----------------------------------------"

# show what we are doing
display_docker_prune_intro

docker container prune -f

all_done

docker system prune -f ; docker volume prune -f ;docker rm -f -v $(docker ps -q -a)
