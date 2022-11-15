#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# "docker_kill_all.sh" 
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

# intro $MESSAGE
display_docker_kill_all_intro(){
    echo -e "${UBlue}***** docker_kill_all.sh -> loaded *****${Color_Off}"
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
}
echo "-----------------------------------------"
display_docker_kill_all_intro


containers=$(docker ps -a -q)
containers=$(docker ps -q)
for container in $containers
do
	echo $container
	docker stop $container
done

echo "-----------------------------------------"
#echo "docker stop $(docker ps -a -q)"
echo "-----------------------------------------"
docker ps -a

all_done


containers=$(docker ps -q)
echo $containers
if [ ! -z $containers ]; then
  echo 
  docker kill $containers;
fi

KILL_LIST=.kill.lst

docker ps | awk {' print $1 '} | tail -n+2 > $KILL_LIST
cat $KILL_LIST
for line in $(cat $KILL_LIST); do
	echo "Killing: $line"
    docker kill $line;
done;

rm $KILL_LIST
