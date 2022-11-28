#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# TBA_env.sh
#
#

write_header(){

	ENV_PATH=$1
	
	# Over write file
	cat >${ENV_PATH} <<EOL
# Created by Quesenbery, D
# ToolbaxAid.com
#
# ${ENV_PATH}
#
# Date $(date) 
#
# Created by TBA_env_file.sh
#

EOL
}

#-------------------------------------------------------------------
create_common_env(){
	ENV_PATH=$1
	OVER_RIDE=$2
		
	echo -e "${IBlue}***** Function:  ${FUNCNAME} ${ENV_PATH} *****${Color_Off}"

	if [ $OVER_RIDE ] && [ $OVER_RIDE == "yes" ]; then
		rm $ENV_PATH
	fi

	echo "If path found, that means you have already created your file: $ENV_PATH" 
	path_not_exists -f $ENV_PATH

    ROUTER_2_TRAEFIK=router2traefik
    TRAEFIK_4_WAN=traefik4wan
    WAN_2_DATABASE_SUFFIX=wan2database
    LAN_2_DATABASE=lan2database
    TRAEFIK_4_LAN=traefik4lan
    LAN_2_WAN=lan2wan
	LAN_2_ROUTER=lan2router
    CERT_RESOLVER=lets-encrypt

	write_header $ENV_PATH
	
	# Append to file
	cat >>${ENV_PATH} <<EOL
# this is the path where you cloned to
DOCKER_PATH=$PWD

# This is your TimeZone
# TZ database, 
# Look under name column: https://en.m.wikipedia.org/wiki/List_of_tz_database_time_zones
TIME_ZONE=$TIME_ZONE

# This is the IP address that Traefik will use
# It must be static IP and cannot be changed after Traefik has been setup
TRAEFIK_IP=$TRAEFIK_IP

# CERT_RESOLVER options: staging or lets-encrypt
CERT_RESOLVER=$CERT_RESOLVER

# This is the domain name you purchased
DOMAIN_NAME=$DOMAIN_NAME

# external location to add to ip whitelist
#  if using DDclient, you may need to update the config files later
ADDITIONAL_WHITELIST_SITE=$ADDITIONAL_WHITELIST_SITE

# Options: no, allways, on-failure,  unless-stopped
RESTART=unless-stopped

#
ROUTER_2_TRAEFIK=$ROUTER_2_TRAEFIK

#
TRAEFIK_4_WAN=$TRAEFIK_4_WAN

#
# SITE_2_DATABASE= created individually per deployment

# WAN_2_DATABASE_SUFFIX
WAN_2_DATABASE_SUFFIX=$WAN_2_DATABASE_SUFFIX

#
LAN_2_DATABASE=$LAN_2_DATABASE

#
TRAEFIK_4_LAN=$TRAEFIK_4_LAN

#
LAN_2_WAN=$LAN_2_WAN

#
LAN_2_ROUTER=$LAN_2_ROUTER

#
EMAIL=$EMAIL

#-----------------------------------------------------------------------------
# Below this line not required
# Used for running test methods in TBA scripts
#-----------------------------------------------------------------------------

# This is a DNS record pointed to you external IP
SAMPLE_DNS_SITE=$SAMPLE_DNS_SITE

EOL

#	cat ${ENV_PATH} 

}

create_port(){
	ENV_PATH=$1
	OVER_RIDE=$2
		
	if [ $OVER_RIDE ] && [ $OVER_RIDE == "yes" ]; then
		rm $ENV_PATH
	fi


	cat >>${ENV_PATH} <<EOL
10000
EOL

#	cat ${ENV_PATH} 

}

create_zip(){
	ENV_PATH=$1
	OVER_RIDE=$2
		
	if [ $OVER_RIDE ] && [ $OVER_RIDE == "yes" ]; then
		rm $ENV_PATH
	fi

	echo -e "${IBlue}***** Function:  ${FUNCNAME} ${ENV_PATH} *****${Color_Off}"

	write_header $ENV_PATH
	
	cat >>${ENV_PATH} <<EOL
# this is the path where you cloned to
BACKUP_PATH=~/
#ACKUP_PATH=/volume1/backups/q-bytes.world

FULL_BACKUP_NAME=docker_FULL.zip
SITE_BACKUP_NAME=docker_SITE.zip
BASE_BACKUP_NAME=docker_BASE.zip

FULL_INCLUDE=.docker.zip.include.full.lst
SITE_INCLUDE=.docker.zip.include.site.lst
BASE_INCLUDE=.docker.zip.include.base.lst

EOL

#	cat ${ENV_PATH} 

}


#-------------------------------------------------------------------
create_catapp(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
    ENV_PATH=$1
    write_header $ENV_PATH

    cat >>${ENV_PATH} <<EOL

# TRAEFIK Stuff
TRAEFIK=~TRAEFIK~
SITE=~SITE~
RESTART=unless-stopped

CERT_RESOLVER=lets-encrypt

TIME_ZONE=~TIME_ZONE~

# Network Stuff
IP_WHITE_LIST=~IP_WHITE_LIST~
TRUSTED_IP_LIST=~TRUSTED_IP_LIST~

TRAEFIK_4_LAN=~TRAEFIK_4_LAN~

TRAEFIK_4_WAN=~TRAEFIK_4_WAN~

EOL
}


create_ddclient(){
	ENV_PATH=$1
	OVER_RIDE=$2
		
	if [ $OVER_RIDE ] && [ $OVER_RIDE == "yes" ]; then
		rm $ENV_PATH
	fi
	echo "If path found, that means you have already created your file: $ENV_PATH" 
	path_not_exists -f $ENV_PATH
	
	echo -e "${IBlue}***** Function:  ${FUNCNAME} ${ENV_PATH} *****${Color_Off}"

	write_header $ENV_PATH
	
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
    ENV_PATH=$1
    write_header $ENV_PATH

    cat >>${ENV_PATH} <<EOL

# TRAEFIK Stuff
NAME=~DEPLOYING~

RESTART=~RESTART~
TIME_ZONE=~TIME_ZONE~

# Network Stuff
LAN_2_ROUTER=~LAN_2_ROUTER~
EOL

}

#-------------------------------------------------------------------
create_traefik(){
	echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
		ENV_PATH=$1
	write_header $ENV_PATH

    cat >>${ENV_PATH} <<EOL

# TRAEFIK Stuff
TRAEFIK=~TRAEFIK~
SITE=~SITE~
RESTART=unless-stopped

TRAEFIK_IP=~TRAEFIK_IP~

# CERT_RESOLVER options: staging or lets-encrypt
CERT_RESOLVER=~CERT_RESOLVER~

TIME_ZONE=~TIME_ZONE~

# Network Stuff
ROUTER_2_TRAEFIK=~ROUTER_2_TRAEFIK~
TRAEFIK_4_WAN=~TRAEFIK_4_WAN~
TRAEFIK_4_LAN=~TRAEFIK_4_LAN~

IP_WHITE_LIST=~IP_WHITE_LIST~
TRUSTED_IP_LIST=~TRUSTED_IP_LIST~

# APP Stuff
EMAIL=~EMAIL~

EOL
}

#-------------------------------------------------------------------
create_whoami(){
	echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
	ENV_PATH=$1
	write_header $ENV_PATH

    cat >>${ENV_PATH} <<EOL

# TRAEFIK Stuff
TRAEFIK=~TRAEFIK~
SITE=~SITE~
RESTART=unless-stopped

CERT_RESOLVER=lets-encrypt
#CERT_RESOLVER=staging

TIME_ZONE=~TIME_ZONE~

# Network Stuff
IP_WHITE_LIST=~IP_WHITE_LIST~
TRUSTED_IP_LIST=~TRUSTED_IP_LIST~

TRAEFIK_4_LAN=~TRAEFIK_4_LAN~

TRAEFIK_4_WAN=~TRAEFIK_4_WAN~

EOL
}

#-------------------------------------------------------------------
create_phpmyadmin(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
    ENV_PATH=$1
    write_header $ENV_PATH

    cat >>${ENV_PATH} <<EOL

# TRAEFIK Stuff
TRAEFIK=~TRAEFIK~
SITE=~SITE~
RESTART=unless-stopped

CERT_RESOLVER=lets-encrypt
#CERT_RESOLVER=staging

TIME_ZONE=~TIME_ZONE~

# Network Stuff
IP_WHITE_LIST=~IP_WHITE_LIST~
TRUSTED_IP_LIST=~TRUSTED_IP_LIST~

LAN_2_DATABASE=~LAN_2_DATABASE~

TRAEFIK_4_LAN=~TRAEFIK_4_LAN~

EOL

}

#-------------------------------------------------------------------
create_portainer(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
    ENV_PATH=$1
    write_header $ENV_PATH

    cat >>${ENV_PATH} <<EOL

# TRAEFIK Stuff
TRAEFIK=~TRAEFIK~
SITE=~SITE~
SITE2=~SITE2~

RESTART=unless-stopped

CERT_RESOLVER=lets-encrypt
#CERT_RESOLVER=staging

TIME_ZONE=~TIME_ZONE~

# Network Stuff
IP_WHITE_LIST=~IP_WHITE_LIST~
TRUSTED_IP_LIST=~TRUSTED_IP_LIST~

TRAEFIK_4_LAN=~TRAEFIK_4_LAN~

EOL

}

#-------------------------------------------------------------------
create_wordpress_docker(){
	echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
	ENV_PATH=$1
	write_header $ENV_PATH

    cat >>${ENV_PATH} <<EOL

# TRAEFIK Stuff
TRAEFIK=~TRAEFIK~
SITE=~SITE~
RESTART=~RESTART~
CERT_RESOLVER=~CERT_RESOLVER~
TIME_ZONE=~TIME_ZONE~

# Wordpress Stuff
WP_USER=TBA_user
WP_EMAIL=TBA@example.com
WP_PSWD=password_not_secure
WP_FIRST_NAME=delete_this_admin
WP_LAST_NAME=not_so_secure

# Database Stuff
DB_PORT=3306
DB_NAME=~DB_NAME~
DB_USER=~DB_USER~
DB_PASSWORD=~DB_PASSWORD~
ROOT_USER=~ROOT_USER~
ROOT_PASSWORD=~ROOT_PASSWORD~
TABLE_PREFIX=~TABLE_PREFIX~

# Network Stuff
TRAEFIK_4_WAN=~TRAEFIK_4_WAN~
TRAEFIK_4_LAN=~TRAEFIK_4_LAN~
LAN_2_DATABASE=~LAN_2_DATABASE~
IP_WHITE_LIST=~IP_WHITE_LIST~
TRUSTED_IP_LIST=~TRUSTED_IP_LIST~

EOL

    chown "$USER_GROUP" $ENV_PATH
    chmod 660 $ENV_PATH

}

# intro $MESSAGE
display_env_file_intro(){
    echo -e "${UBlue}*****  TBA_env_file.sh -> loaded *****${Color_Off}"
	echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
}

env_test_cases(){

	OVER_RIDE=yes
	echo "OVER_RIDE: $OVER_RIDE"

    echo "-----------------------------------------"
    env_file="$PWD/../dev/.port.number.test"
    create_port $env_file $OVER_RIDE
	
    env_file="$PWD/../dev/.docker_zip.env.test"
    create_zip $env_file $OVER_RIDE
	
	common_env="../dev/.env.common.test"
	create_common_env $common_env $OVER_RIDE

    echo "-----------------------------------------"
    env_file="$PWD/../dev/.env.ddclient.test"
    create_ddclient $env_file $OVER_RIDE

    echo "-----------------------------------------"
	env_file="$PWD/../dev/.env.traefik.test"
	create_traefik $env_file

    echo "-----------------------------------------"
	env_file="$PWD/../dev/.env.whoami.test"
	create_whoami $env_file

    echo "-----------------------------------------"
	env_file="$PWD/../dev/.env.php.test"
	create_phpmyadmin $env_file

    echo "-----------------------------------------"
	env_file="$PWD/../dev/.env.wordpress.test"
	create_wordpress_docker $env_file

    echo -e "${Red}Build the rest of test cases out${Color_Off}"

	# must be last
    all_done
}

#if [[ $SUDO_COMMAND =~ "env_file" ]]; then
#	echo "TBA_env_file"
#else
#	echo $SUDO_COMMAND
#	echo "not TBA_env_file"
#fi

TEST="$1"
if [[ $SUDO_COMMAND =~ "TBA_env_file" ]] && [ $TEST ] && [ $TEST == "yes" ]; then
    clear

	INCLUDE_PATH=../scripts
	
    . $INCLUDE_PATH/TBA_color.sh

	display_env_file_intro

    echo -e "${IBlue}***** ${Black}${On_White}TEST=$TEST${IBlue}, debug will run *****${Color_Off}"

    . $INCLUDE_PATH/TBA_functions.sh
    . $INCLUDE_PATH/TBA_networking.sh
	. $INCLUDE_PATH/TBA_random.sh

    echo -e "***** ${Black}${On_White}Running test_cases${Color_Off} *****"

	get_web_time_zone
	echo $TIME_ZONE
	get_system_time_zone
	echo $TIME_ZONE

	env_test_cases
else
	display_env_file_intro
fi

