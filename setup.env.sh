#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# "env.setup.sh" 
#

INCLUDE_PATH=./scripts
COMMON_ENV=./templates/.common.env
PORT_ENV=$INCLUDE_PATH/.docker.port.number
ZIP_ENV=$INCLUDE_PATH/.docker.zip.env


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
    echo -e "\e[31mError: Directory does not exists -> '\e[31m../../scripts\e[0m'."
        exit 1
fi

# intro $MESSAGE
display_env_setup_intro(){
    echo -e "${UBlue}***** env.setup.sh -> loaded *****${Color_Off}"
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
}

usage(){
    echo -e "${Red}Usage: {script}"
    echo -e "  no parames required!${Color_off}"
    build_exit 1
}

echo "-----------------------------------------"
display_env_setup_intro

# Script path must exist before we continue
requires_root

get_user_group
echo -e "${Purple}USER_GROUP: ${USER_GROUP}${Color_OffUSER_GROUP}"

check_parameter_count 0 $#
if [ $correctCount != True ]; then
	usage
	build_exit 87 "./"
fi

if [ -r ${COMMON_ENV} ]; then
	echo -e "${Red}Location found, but should NOT: '$F_OR_D' for '${COMMON_ENV}'"
	echo -e "if the '${COMMON_ENV}' file exists:"
	echo -e "Setup has already run, and not able to run again."
	echo -e "${Color_Off}"
	build_exit 02 ./
fi

get_system_time_zone

get_gateway_info

echo -e "${Yellow}"
cat <<EOF
This is the IP address that Traefik will use and sould be outside of your DHCP range
It is a static IP and cannot be changed after Traefik has been setup as it's used by MAC-VLAN (created in next step)

Your subnet is: '$gateway_subnet'
Enter your MAC-VLAN IP as xxx.xxx.xxx.xxx 
EOF

echo -e "${White}"
read -p 'TRAEFIK_IP: ' TRAEFIK_IP

echo -e "${Yellow}"
echo "# This is the domain name you purchased"
echo -e "    example.com${White}"
read -p 'DOMAIN_NAME: ' DOMAIN_NAME

echo -e "${Yellow}"
echo "# This is your email address"
echo -e "    user@example.com${White}"
read -p 'EMAIL: ' EMAIL

echo -e "${Yellow}"
cat <<EOF
# External location to add to ip whitelist
#  If using DDclient, you may need to update the config files later
  Press enter if you do not have one.
EOF
echo -e "${White}"

read -p 'ADDITIONAL_WHITELIST_SITE: ' ADDITIONAL_WHITELIST_SITE

create_common_env $COMMON_ENV
create_port $PORT_ENV
create_zip $ZIP_ENV

mkdir ./lan
mkdir ./wan
mkdir ./dev

#set_permissions
echo "Setting permissions... '${USER_GROUP}' ...please wait..."
chown -R "${USER_GROUP}" $PWD/*
find $PWD/ -type d -exec chmod 775 {} +
find $PWD/ -type f -exec chmod 664 {} +

find $PWD/ -type f -name "*.env" -print0 |xargs -0 chmod 660
find $PWD/ -type f -name "*.lst" -print0 |xargs -0 chmod 660
find $PWD/ -type f -name "*.sh"  -print0 |xargs -0 chmod 775

echo -e "${Black} - Only if on color background"
echo -e "${White} - Script output"
echo -e "${Green} - Command executed sucessfully"
echo -e "${Blue} - ??? to dark to read"
echo -e "${Yellow} - Information"
echo -e "${Red} - Error"
echo -e "${Purple} - Environment variables (.env) files"
echo -e "${Cyan} - Command for you"

echo -e "${UBlue} - Shell (*.sh file)"
echo -e "${IBlue} - Function"

echo -e "${Yellow}"

cat <<EOF
>  '$0'
Directories created:
	- wan	
	- lan
	- dev
Files created: 
    - $COMMON_ENV
    - $PORT_ENV
    - $ZIP_ENV

Review these files created by setup:
EOF

echo -e "${White}Yours looks like:${Color_Off}"
echo -e "${Yellow}You should start with the default networks"
echo -e "${White}> ${Green}sudo docker network ls${White}"
cat <<EOF
NETWORK ID     NAME      DRIVER    SCOPE
xxxxxxxxxxxx   bridge    bridge    local
xxxxxxxxxxxx   host      host      local
xxxxxxxxxxxx   none      null      local
EOF

echo -e "${Cyan}'docker network ls'"
echo -e "${Yellow}Yours looks like:${Color_Off}"

docker network ls

setup_complete ${COMMON_ENV}
above line does not return, so no code executes here and blow

Resets all.
rm -r dev | rm -r lan | rm -r wan | rm ./templates/.common.env | chmod 775 setup.env.sh

