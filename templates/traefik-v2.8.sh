#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# "traefik-v2.8.sh" 
#

INCLUDE_PATH=../scripts
DEPLOYING=traefik-v2.8

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
    echo -e "  'wan' only as it is accessable from Internet (but the interface will be whitelisted)${Color_off}"
    build_exit 1
}

check_parameter_count 0 $#
if [ $correctCount != True ]; then
	usage
	build_exit 87 "./"
fi

ENV=wan

#set path to traefik based on traefik.wan.{domain_nam}
SITE=traefik.wan.${DOMAIN_NAME}
echo $SITE

# verify paths
path_exists -d $DOCKER_PATH/templates/${DEPLOYING}
path_exists -d $DOCKER_PATH/$ENV
verify_DNS_record $SITE
check_site_path $DOCKER_PATH/$ENV/$SITE $SITE $ROUTER_2_TRAEFIK

echo "REPLACE : $REPLACE"
if [ $REPLACE == True ]; then
    echo -e "${Yellow} rm  $DOCKER_PATH/templates/${DEPLOYING}/.env ${Color_Off}"
    rm  $DOCKER_PATH/templates/${DEPLOYING}/.env
	docker network rm $TRAEFIK_4_WAN
    docker network rm $TRAEFIK_4_LAN
    docker network rm $LAN_2_DATABASE
fi

echo "-----------------------------------------"
echo "Setting up site '${SITE}' on '${ENV}'"
create_traefik $DOCKER_PATH/templates/${DEPLOYING}/.env

chown "${USER_GROUP}" $DOCKER_PATH/templates/${DEPLOYING}/.env
chmod 660 $DOCKER_PATH/templates/${DEPLOYING}/.env

echo "mkdir $DOCKER_PATH/$ENV/$SITE"
mkdir $DOCKER_PATH/$ENV/$SITE

echo "cp -r  $DOCKER_PATH/templates/${DEPLOYING} $DOCKER_PATH/$ENV/$SITE"
cp -r  $DOCKER_PATH/templates/${DEPLOYING}/* $DOCKER_PATH/$ENV/$SITE
cp $DOCKER_PATH/templates/${DEPLOYING}/.env $DOCKER_PATH/$ENV/$SITE/

mkdir $DOCKER_PATH/$ENV/$SITE/data/
touch $DOCKER_PATH/$ENV/$SITE/data/access.log
touch $DOCKER_PATH/$ENV/$SITE/data/acme.json
touch $DOCKER_PATH/$ENV/$SITE/data/.traefik.htpasswd
touch $DOCKER_PATH/$ENV/$SITE/data/traefik.log

echo "chown -R $USER_GROUP $DOCKER_PATH/$ENV/$SITE"
chown -R "${USER_GROUP}" $DOCKER_PATH/$ENV/$SITE
chmod 660 $DOCKER_PATH/$ENV/$SITE/*
chmod 770 $DOCKER_PATH/$ENV/$SITE/*.sh
chmod 660 $DOCKER_PATH/$ENV/$SITE/data/*.log
chmod 770 $DOCKER_PATH/$ENV/$SITE/data

chown root:root $DOCKER_PATH/$ENV/$SITE/data/acme.json
chmod 600       $DOCKER_PATH/$ENV/$SITE/data/acme.json
chown root:root $DOCKER_PATH/$ENV/$SITE/data/.traefik.htpasswd
chmod 600       $DOCKER_PATH/$ENV/$SITE/data/.traefik.htpasswd

get_router_IP
get_gateway_info

#docker network create -d macvlan --subnet=93.68.10.0/24 --gateway=93.68.10.1 -o parent=eth0 macvlan-net
echo "docker network create -d macvlan --subnet=$gateway_subnet --gateway=$gateway_IP -o parent=$gateway_card $ROUTER_2_TRAEFIK"
docker network create -d macvlan --subnet=$gateway_subnet --gateway=$gateway_IP -o parent=$gateway_card $ROUTER_2_TRAEFIK

echo "docker network create $TRAEFIK_4_WAN"
docker network create "$TRAEFIK_4_WAN"

echo "docker network create $TRAEFIK_4_LAN"
docker network create "$TRAEFIK_4_LAN"

echo "docker network create $LAN_2_DATABASE"
docker network create "$LAN_2_DATABASE"

whiteList="127.0.0.1/32"
whiteList="${whiteList},$gateway_subnet"

echo "ADDITIONAL_WHITELIST_SITE : $ADDITIONAL_WHITELIST_SITE"
if [ $ADDITIONAL_WHITELIST_SITE ]; then
	get_site_ip $ADDITIONAL_WHITELIST_SITE
	if [ $site_ip ]; then 
		whiteList="${whiteList},$site_ip/32"
	#	echo "set ADDITIONAL_WHITELIST_SITE : $ADDITIONAL_WHITELIST_SITE"
	fi
fi
echo "back............................"
# update site .env file
sed -i "s/~TRAEFIK_IP~/$TRAEFIK_IP/g"             $DOCKER_PATH/$ENV/$SITE/.env
sed -i "s/~SITE~/$SITE/g"                         $DOCKER_PATH/$ENV/$SITE/.env

TRAEFIK=${SITE//./-}
sed -i "s/~TRAEFIK~/$TRAEFIK/g"                   $DOCKER_PATH/$ENV/$SITE/.env
tmpTimeZone=$(echo $TIME_ZONE | sed 's;/;\\/;g')
sed -i "s/~TIME_ZONE~/$tmpTimeZone/g"             $DOCKER_PATH/$ENV/$SITE/.env
sed -i "s/~CERT_RESOLVER~/$CERT_RESOLVER/g"       $DOCKER_PATH/$ENV/$SITE/.env

tmpWhiteList=$(echo $whiteList | sed 's;/;\\/;g')
sed -i "s/~IP_WHITE_LIST~/$tmpWhiteList/g"        $DOCKER_PATH/$ENV/$SITE/.env
sed -i "s/~ROUTER_2_TRAEFIK~/$ROUTER_2_TRAEFIK/g" $DOCKER_PATH/$ENV/$SITE/.env
sed -i "s/~TRAEFIK_4_WAN~/$TRAEFIK_4_WAN/g"       $DOCKER_PATH/$ENV/$SITE/.env
sed -i "s/~TRAEFIK_4_LAN~/$TRAEFIK_4_LAN/g"       $DOCKER_PATH/$ENV/$SITE/.env

sed -i "s/~EMAIL~/$EMAIL/g"                       $DOCKER_PATH/$ENV/$SITE/.env

# need to correct the list
tmpTrustedIpList=$(echo $whiteList | sed 's;/;\\/;g')
sed -i "s/~TRUSTED_IP_LIST~/$tmpTrustedIpList/g"  $DOCKER_PATH/$ENV/$SITE/.env

# dynamic.yml
tmpWhiteIpList=$(echo $whiteList | sed 's;/;\\/;g')
sed -i "s/~IP_WHITE_LIST~/$tmpWhiteList/g"  $DOCKER_PATH/$ENV/$SITE/dynamic.yml
sed -i "s/~DOMAIN_NAME~/$DOMAIN_NAME/g"     $DOCKER_PATH/$ENV/$SITE/dynamic.yml
sed -i "s/~SITE~/$SITE/g"                   $DOCKER_PATH/$ENV/$SITE/dynamic.yml
sed -i "s/~CERT_RESOLVER~/$CERT_RESOLVER/g" $DOCKER_PATH/$ENV/$SITE/dynamic.yml

# traefik.yml
sed -i "s/~EMAIL~/$EMAIL/g"                      $DOCKER_PATH/$ENV/$SITE/traefik.yml
sed -i "s/~TRUSTED_IP_LIST~/$tmpTrustedIpList/g" $DOCKER_PATH/$ENV/$SITE/traefik.yml

# info
get_docker_subnet ${ROUTER_2_TRAEFIK}
r2t=$returnSubnet
get_docker_subnet ${TRAEFIK_4_WAN}
t4w=$returnSubnet
get_docker_subnet ${TRAEFIK_4_LAN}
t4l=$returnSubnet
get_docker_subnet ${LAN_2_DATABASE}
l2d=$returnSubnet

cat <<EOF
>  '$0'

Remember to update your firewall rules for ports 80 & 443: network list below
If you see, 'docker-compose not able to connect to internet', most likely it's the firewal

# To create user:password pair, it's possible to use this command:
 Add user to '.traefik.htpasswd' (currently empty) use the 'htpasswd.*.sh' scripts

Network created:
    - '$ROUTER_2_TRAEFIK : $r2t'
    - '$TRAEFIK_4_WAN    : $t4w'
    - '$TRAEFIK_4_LAN    : $t4l'
    - '$LAN_2_DATABASE   : $l2d'
File created/updated:
    - $DOCKER_PATH/$ENV/$SITE/.env
    - $DOCKER_PATH/$ENV/$SITE/traefik.yml
    - $DOCKER_PATH/$ENV/$SITE/dynamic.yml
EOF


all_done $DOCKER_PATH/$ENV/$SITE
above line does not return, so no code to execute here and blow

echo "sed -i `s/~IP-WHITELIST~/\"${whiteList}\"/g` $DOCKER_PATH/$ENV/$SITE/.env"
sed -i `s/~IP-WHITELIST~/\"${whiteList}\"/g` $DOCKER_PATH/$ENV/$SITE/.env

