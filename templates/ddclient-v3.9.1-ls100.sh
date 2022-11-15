#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# "ddclient-v3.9.1-ls100.sh"
#

INCLUDE_PATH=../scripts
ENV=lan
SITE=ddclient-v3.9.1-ls100
LAN_2_ROUTER=$LAN_2_ROUTER

if [ -d "${INCLUDE_PATH}" ]
then
    clear
    BASE_EXE=`basename "$0"`
    echo ">>>>> Executing: $BASE_EXE <<<<<"

    . $INCLUDE_PATH/TBA_color.sh
    . $INCLUDE_PATH/TBA_functions.sh
    . $INCLUDE_PATH/TBA_networking.sh
    . $INCLUDE_PATH/TBA_env_file.sh
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
else
    echo -e "Error: Directory does not exists -> '\e[31m${INCLUDE_PATH}\e[0m'."
        exit 1
fi

# Script path must exist before we continue
requires_root

get_user_group

load_env $PWD/.common.env
#source $PWD/env.sh

echo "-----------------------------------------"

usage(){
    echo -e "${Red}Usage:  script "
    echo " ENV: wan"
	echo -e " No SITE required as it is not web enabled'${Color_off}"
    build_exit 1
}

check_parameter_count 0 $#
if [ $correctCount != True ]; then
	usage
	build_exit 87 "./"
fi

# validate ENV
if [ ! $ENV ]; then
    echo -e "${On_Red}Missing: ENV & SITE${Color_off}"
	usage
fi

# validate usage
if [ ! $SITE ]; then
    echo -e "${On_Red}Missing: SITE${Color_off}"
    usage
fi

# what are we doing? {dk or ws}
if [ $ENV = 'wan' ]; then
    echo "Building a WAN site"
elif [ $ENV = 'lan' ]; then
    echo "Building a LAN site"
elif [ $ENV = 'dev' ]; then
    echo "Building a DEV site"
else
    echo -e "${On_Red}What are we doing? Valid environments are {wan, lan or dev}${Color_off}"
	usage
fi

DEPLOYING=${SITE}

# verify paths
path_exists -d  $DOCKER_PATH/templates/${DEPLOYING}
path_exists -d  $DOCKER_PATH/$ENV
echo "check_site_path $DOCKER_PATH/$ENV/$SITE $SITE ${LAN_2_ROUTER}"
check_site_path $DOCKER_PATH/$ENV/$SITE $SITE ${LAN_2_ROUTER}
if [ $REPLACE == True ]; then
    rm  $DOCKER_PATH/templates/${DEPLOYING}/.env
    echo -e "${Yellow} rm  $DOCKER_PATH/templates/${DEPLOYING}/.env ${Color_Off}"
fi
#echo "REPLACE : $REPLACE"

echo "-----------------------------------------"
echo "Setting up site '${SITE}' on '${ENV}'"
create_ddclient $DOCKER_PATH/templates/${DEPLOYING}/.env 

echo "mkdir $DOCKER_PATH/$ENV/$SITE"
mkdir $DOCKER_PATH/$ENV/$SITE

cp -r  $DOCKER_PATH/templates/${DEPLOYING}/* $DOCKER_PATH/$ENV/$SITE
cp $DOCKER_PATH/templates/${DEPLOYING}/.env $DOCKER_PATH/$ENV/$SITE/

sed -i "s/~DEPLOYING~/$DEPLOYING/g" $DOCKER_PATH/$ENV/$SITE/.env
sed -i "s/~RESTART~/$RESTART/g" $DOCKER_PATH/$ENV/$SITE/.env
tmpTimeZone=$(echo $TIME_ZONE | sed 's;/;\\/;g')
sed -i "s/~TIME_ZONE~/$tmpTimeZone/g" $DOCKER_PATH/$ENV/$SITE/.env
sed -i "s/~LAN_2_ROUTER~/$LAN_2_ROUTER/g" $DOCKER_PATH/$ENV/$SITE/.env

echo "chown -R $USER_GROUP $DOCKER_PATH/$ENV/$SITE"
chown -R "${USER_GROUP}" $DOCKER_PATH/$ENV/$SITE 
chmod 660 $DOCKER_PATH/$ENV/$SITE/*
chmod 770 $DOCKER_PATH/$ENV/$SITE/*.sh
chown -R 1000:1000 $DOCKER_PATH/$ENV/$SITE/config

docker network create ${LAN_2_ROUTER}

cat <<EOF
>  '$0'
Network created:
    - '${LAN_2_ROUTER}'
File created: 
    - $DOCKER_PATH/$ENV/$SITE/.env
EOF

get_docker_subnet ${LAN_2_ROUTER}
echo -e "Remember to update your firewall rules for ports 80 & 443: ${Yellow}'$returnSubnet'${Color_Off}"lan2router
echo " ***** Not sure why, but I'm required to enter 'all' ports to get mine to work???"
echo "If you see, 'docker-compose not able to connect to internet', most likely it's the firewal"

all_done $DOCKER_PATH/$ENV/$SITE
above line does not return, so no code to execute here and blow

