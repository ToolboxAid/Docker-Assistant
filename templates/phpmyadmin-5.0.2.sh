#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# "phpmyadmin-5.0.2.sh"
#
INCLUDE_PATH=../scripts
DEPLOYING=phpmyadmin
DEPLOYING_FOLDER=phpmyadmin-5.0.2
ENV=lan

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

SITE=$DEPLOYING.$ENV.$DOMAIN_NAME

echo "-----------------------------------------"

usage(){
    echo -e "${Red}Usage:  script {ENV} {SITE}'${Color_off}"
#    echo -e "${Red}Usage:  script {ENV} {SITE}"
#    echo " ENV: wan,i>>> lan<<<, dev"
#	echo -e " SITE is something like: 'example.com'${Color_off}"
    build_exit 1
}

check_parameter_count 0 $#
if [ $correctCount != True ]; then
	usage
	build_exit 87 "./"
fi


#ENV stores $1 argument passed to script
#ENV=$1

#site stores $2 argument passed to script
#SITE=$2

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

# verify paths
path_exists -d $DOCKER_PATH/templates/${DEPLOYING_FOLDER}
path_exists -d $DOCKER_PATH/$ENV
check_site_path  $DOCKER_PATH/$ENV/$SITE $SITE
verify_DNS_record $SITE

echo "-----------------------------------------"
echo "Setting up site '${SITE}' on '${ENV}'"

create_phpmyadmin         $DOCKER_PATH/templates/${DEPLOYING_FOLDER}/.env
echo `chown "$USER_GROUP" $DOCKER_PATH/templates/${DEPLOYING_FOLDER}/.env`
chown "$USER_GROUP"       $DOCKER_PATH/templates/${DEPLOYING_FOLDER}/.env
chmod 660                 $DOCKER_PATH/templates/${DEPLOYING_FOLDER}/.env

echo "mkdir $DOCKER_PATH/$ENV/$SITE"
mkdir       $DOCKER_PATH/$ENV/$SITE

echo "cp -r  $DOCKER_PATH/templates/${DEPLOYING_FOLDER}      $DOCKER_PATH/$ENV/$SITE"
cp -r        $DOCKER_PATH/templates/${DEPLOYING_FOLDER}/*    $DOCKER_PATH/$ENV/$SITE
cp           $DOCKER_PATH/templates/${DEPLOYING_FOLDER}/.env $DOCKER_PATH/$ENV/$SITE/

echo "$USER_GROUP" 
chown -R "$USER_GROUP" $DOCKER_PATH/$ENV/$SITE 
chmod 660              $DOCKER_PATH/$ENV/$SITE/*
chmod 770              $DOCKER_PATH/$ENV/$SITE/*.sh

# update .env file
sed -i "s/~SITE~/$SITE/g" $DOCKER_PATH/$ENV/$SITE/.env

#----------------------------------------------------------
get_router_IP
#echo $router_IP

get_gateway_info

whiteList="127.0.0.1/32"
whiteList="${whiteList},$gateway_subnet"

#echo "ADDITIONAL_WHITELIST_SITE : $ADDITIONAL_WHITELIST_SITE"
if [ $ADDITIONAL_WHITELIST_SITE ]; then
    get_site_ip $ADDITIONAL_WHITELIST_SITE
    if [ $site_ip ]; then
        whiteList="${whiteList},$site_ip/32"
    #   echo "set ADDITIONAL_WHITELIST_SITE : $ADDITIONAL_WHITELIST_SITE"
    fi
fi

#----------------------------------------------------------
sed -i "s/~SITE~/$SITE/g"                        $DOCKER_PATH/$ENV/$SITE/.env

TRAEFIK=${SITE//./-}
sed -i "s/~TRAEFIK~/$TRAEFIK/g"                  $DOCKER_PATH/$ENV/$SITE/.env

tmpTimeZone=$(echo $TIME_ZONE | sed 's;/;\\/;g')
sed -i "s/~TIME_ZONE~/$tmpTimeZone/g"            $DOCKER_PATH/$ENV/$SITE/.env

tmpWhiteList=$(echo $whiteList | sed 's;/;\\/;g')
sed -i "s/~IP_WHITE_LIST~/$tmpWhiteList/g"       $DOCKER_PATH/$ENV/$SITE/.env

# need to colect the list
tmpTrustedIpList=$(echo $whiteList | sed 's;/;\\/;g')
sed -i "s/~TRUSTED_IP_LIST~/$tmpTrustedIpList/g" $DOCKER_PATH/$ENV/$SITE/.env


sed -i "s/~LAN_2_DATABASE~/$LAN_2_DATABASE/g"     $DOCKER_PATH/$ENV/$SITE/.env
sed -i "s/~TRAEFIK_4_LAN~/$TRAEFIK_4_LAN/g"       $DOCKER_PATH/$ENV/$SITE/.env

#----------------------------------------------------------
# need to colect the list
tmpTrustedIpList=$(echo $whiteList | sed 's;/;\\/;g')
sed -i "s/~TRUSTED_IP_LIST~/$tmpTrustedIpList/g" $DOCKER_PATH/$ENV/$SITE/.env


cat <<EOF
>  '$0'

Remember to update your firewall rules for ports 80 & 443: network list below
If you see, 'docker-compose not able to connect to internet', most likely it's the firewal

Network created:
    - none
Directory:
    - $DOCKER_PATH/$ENV/$SITE
File created/updated:
    - $DOCKER_PATH/$ENV/$SITE/.env

EOF


all_done $DOCKER_PATH/$ENV/$SITE
above line does not return, so no code to execute here and blow
