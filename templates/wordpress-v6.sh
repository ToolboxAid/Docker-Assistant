#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# "phpmyadmin-5.0.2.sh"
#
INCLUDE_PATH=../scripts
TEMPLATE_FOLDER=wordpress-v6

if [ -d "${INCLUDE_PATH}" ]
then
    clear
    BASE_EXE=`basename "$0"`
    echo ">>>>> Executing: $BASE_EXE <<<<<"

    . $INCLUDE_PATH/TBA_color.sh
    . $INCLUDE_PATH/TBA_functions.sh
    . $INCLUDE_PATH/TBA_networking.sh
    . $INCLUDE_PATH/TBA_env_file.sh
    . $INCLUDE_PATH/TBA_random.sh
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
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
    echo -e "${Red}Usage:  script {ENV} {SITE}"
    echo " ENV: wan, lan, dev"
	echo -e " SITE is something like: 'example.com'${Color_off}"
    build_exit 1
}

check_parameter_count 2 $#
if [ $correctCount != True ]; then
	usage
	build_exit 87 "./"
fi


#ENV stores $1 argument passed to script
ENV=$1

#site stores $2 argument passed to script
SITE=$2

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
path_exists -d $DOCKER_PATH/templates/${TEMPLATE_FOLDER}
path_exists -d $DOCKER_PATH/$ENV

verify_DNS_record $SITE

#                $1 path                 $2 site $3 network
check_site_path  $DOCKER_PATH/$ENV/$SITE $SITE   ${SITE}-db
echo "REPLACE : $REPLACE"
if [ $REPLACE == True ]; then
    echo -e "${Yellow} rm  $DOCKER_PATH/templates/${TEMPLATE_FOLDER}/.env ${Color_Off}"
    rm  $DOCKER_PATH/templates/${TEMPLATE_FOLDER}/.env
fi

echo "-----------------------------------------"
echo "Setting up site '${SITE}' on '${ENV}'"

create_wordpress_docker   $DOCKER_PATH/templates/${TEMPLATE_FOLDER}/.env
echo `chown "$USER_GROUP" $DOCKER_PATH/templates/${TEMPLATE_FOLDER}/.env`
chown "$USER_GROUP"       $DOCKER_PATH/templates/${TEMPLATE_FOLDER}/.env
chmod 660                 $DOCKER_PATH/templates/${TEMPLATE_FOLDER}/.env

echo "docker network create ${SITE}-db"
docker network create "${SITE}-db"

echo "mkdir $DOCKER_PATH/$ENV/$SITE"
mkdir       $DOCKER_PATH/$ENV/$SITE

echo "cp -r  $DOCKER_PATH/templates/${TEMPLATE_FOLDER}      $DOCKER_PATH/$ENV/$SITE"
cp -r        $DOCKER_PATH/templates/${TEMPLATE_FOLDER}/*    $DOCKER_PATH/$ENV/$SITE
cp           $DOCKER_PATH/templates/${TEMPLATE_FOLDER}/.env $DOCKER_PATH/$ENV/$SITE/

echo "$USER_GROUP" 
chown -R "$USER_GROUP" $DOCKER_PATH/$ENV/$SITE 
chmod 660              $DOCKER_PATH/$ENV/$SITE/*
chmod 770              $DOCKER_PATH/$ENV/$SITE/*.sh

chmod 775       $DOCKER_PATH/$ENV/$SITE/mariadb
chown 1001:root $DOCKER_PATH/$ENV/$SITE/mariadb/conf
chmod 775       $DOCKER_PATH/$ENV/$SITE/mariadb/conf
chown 1001:root $DOCKER_PATH/$ENV/$SITE/mariadb/conf/*
chmod 664       $DOCKER_PATH/$ENV/$SITE/mariadb/conf/*

mkdir           $DOCKER_PATH/$ENV/$SITE/mariadb/data
chown 1001:root $DOCKER_PATH/$ENV/$SITE/mariadb/data
chmod 775       $DOCKER_PATH/$ENV/$SITE/mariadb/data

chown 1001:root $DOCKER_PATH/$ENV/$SITE/mariadb/scripts
chmod 775       $DOCKER_PATH/$ENV/$SITE/mariadb/scripts
chown 1001:root $DOCKER_PATH/$ENV/$SITE/mariadb/scripts/*
chmod 774       $DOCKER_PATH/$ENV/$SITE/mariadb/scripts/healthcheck.sh

chmod 775       $DOCKER_PATH/$ENV/$SITE/wordpress
chown 1:0       $DOCKER_PATH/$ENV/$SITE/wordpress/conf
chmod 775       $DOCKER_PATH/$ENV/$SITE/wordpress/conf
chown 1001:1001 $DOCKER_PATH/$ENV/$SITE/wordpress/conf/php.ini
chmod 600       $DOCKER_PATH/$ENV/$SITE/wordpress/conf/php.ini

mkdir           $DOCKER_PATH/$ENV/$SITE/wordpress/data
chown 1:0       $DOCKER_PATH/$ENV/$SITE/wordpress/data
chmod 775       $DOCKER_PATH/$ENV/$SITE/wordpress/data

chown 1:0       $DOCKER_PATH/$ENV/$SITE/wordpress/scripts
chmod 775       $DOCKER_PATH/$ENV/$SITE/wordpress/scripts
chown 1001:root $DOCKER_PATH/$ENV/$SITE/wordpress/scripts/*
chmod 664       $DOCKER_PATH/$ENV/$SITE/wordpress/scripts/alive.php
chmod 774       $DOCKER_PATH/$ENV/$SITE/wordpress/scripts/healthcheck.php

# update .env file
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

# CERT_RESOLVER options: staging or lets-encrypt
sed -i "s/~CERT_RESOLVER~/$CERT_RESOLVER/g"      $DOCKER_PATH/$ENV/$SITE/.env
sed -i "s/~RESTART~/$RESTART/g"                  $DOCKER_PATH/$ENV/$SITE/.env

# Database credetials
sed -i "s/~DB_PORT~/$DB_PORT/g"                  $DOCKER_PATH/$ENV/$SITE/.env
COUNT=2
SEPERATOR="_"
get_random_dictionary_word_concatenated $COUNT $SEPERATOR
sed -i "s/~DB_NAME~/$random_dictionary_word_concatenated/g"  $DOCKER_PATH/$ENV/$SITE/.env


get_random_dictionary_word_concatenated $COUNT $SEPERATOR
sed -i "s/~DB_USER~/$random_dictionary_word_concatenated/g"  $DOCKER_PATH/$ENV/$SITE/.env

LEN=16
get_random_AZaz09_plus_plus $LEN
sed -i "s/~DB_PASSWORD~/$random/g"               $DOCKER_PATH/$ENV/$SITE/.env

get_random_dictionary_word_concatenated $COUNT $SEPERATOR
sed -i "s/~ROOT_USER~/$random_dictionary_word_concatenated/g" $DOCKER_PATH/$ENV/$SITE/.env

get_random_AZaz09_plus_plus $LEN
sed -i "s/~ROOT_PASSWORD~/$random/g"             $DOCKER_PATH/$ENV/$SITE/.env

LEN=5
get_random_AZaz09_plus $LEN
sed -i "s/~TABLE_PREFIX~/${random}_/g"           $DOCKER_PATH/$ENV/$SITE/.env

tmpWhiteList=$(echo $whiteList | sed 's;/;\\/;g')
sed -i "s/~IP_WHITE_LIST~/$tmpWhiteList/g"       $DOCKER_PATH/$ENV/$SITE/.env

tmpTrustedIpList=$(echo $whiteList | sed 's;/;\\/;g')
sed -i "s/~TRUSTED_IP_LIST~/$tmpTrustedIpList/g" $DOCKER_PATH/$ENV/$SITE/.env

sed -i "s/~TRAEFIK_4_LAN~/$TRAEFIK_4_LAN/g"      $DOCKER_PATH/$ENV/$SITE/.env
sed -i "s/~TRAEFIK_4_WAN~/$TRAEFIK_4_WAN/g"      $DOCKER_PATH/$ENV/$SITE/.env
sed -i "s/~LAN_2_DATABASE~/$LAN_2_DATABASE/g"    $DOCKER_PATH/$ENV/$SITE/.env

# update docker-compose.ym: $ENV?
if [ $ENV = 'wan' ]; then
    echo "NO whitelist"
    sed -i "s/#~WAN~//g" $DOCKER_PATH/$ENV/$SITE/docker-compose.yml
    sed -i '/#~LAN~/d'   $DOCKER_PATH/$ENV/$SITE/docker-compose.yml
else
    echo "Using whitelist"
    sed -i "s/#~LAN~//g" $DOCKER_PATH/$ENV/$SITE/docker-compose.yml
    sed -i '/#~WAN~/d'   $DOCKER_PATH/$ENV/$SITE/docker-compose.yml
fi

sed -i "/#~/d"         $DOCKER_PATH/$ENV/$SITE/docker-compose.yml

cat <<EOF
>  '$0'

Remember to update your firewall rules for ports 80 & 443: network list below
If you see, 'docker-compose not able to connect to internet', most likely it's the firewal

Network created:
    - ${SITE}-db 
Directory:
    - $DOCKER_PATH/$ENV/$SITE
File created/updated:
    - $DOCKER_PATH/$ENV/$SITE/.env

EOF

all_done $DOCKER_PATH/$ENV/$SITE
above line does not return, so no code to execute here and blow
