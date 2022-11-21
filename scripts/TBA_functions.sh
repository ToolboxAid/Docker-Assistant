#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# TBA_function.sh
#
#

SCRIPT="$0"
TEST="$1"

# try catch block
trap 'catch $? $LINENO' ERR
catch() {
	echo -e "${Red}"
    echo "----- Try Catch trap -----"
    echo "Error $1 occurred on $2"

    SITE_PATH=$PWD
    build_exit 99 $SITE_PATH
	echo -e "${Color_Off}"
}

# load_env   # optional, will default to $PWD/.env
# load_env ${file-to-load}
load_envg(){
	ENV_FILE=${1:-"$PWD/.env"}
    echo -e "${IBlue}***** Function:  ${FUNCNAME} $ENV_FILE *****${Color_Off}"
    path_exists -f $ENV_FILE
	set -o allexport
	source $ENV_FILE set
	+o allexport
	export ENV_FILE_USED=$ENV_FILE
    echo -e "${Green}Env file loaded${Color_Off}"
}

# load_env   # optional, will default to $PWD/.env
load_env__(){
	ENV_FILE_USED=${1:-"$PWD/.env"}
    echo "Loading ENV_FILE_USED: ${ENV_FILE_USED}"
    if [ -z ${ENV_FILE_USED} ]; then
        echo "Environment file was not found."
		exit 0
    else
	
		while read line; do
			if [[ ! -z "$line" ]] && [[ "$line" != \#* ]]; then

				key=$(echo "$line" | cut -d '=' -f 1)
				val=$(echo "$line" | cut -d '=' -f 2)
				echo "set $key $val"
				export $key
				echo $key
			fi
		done <${ENV_FILE_USED}	

        set ENV_FILE_USED

		printenv
    fi
    echo -e "${Green}Env file '$ENV_FILE_USED' loaded${Color_Off}"
}

# load_env ${file-to-load}
load_env(){

	ENV_FILE=${1:-"$PWD/.env"}
    echo -e "${IBlue}***** Function:  ${FUNCNAME} ${ENV_FILE} *****${Color_Off}"
    path_exists -f $ENV_FILE
	
	source $ENV_FILE
	
#	printenv

	export ENV_FILE_USED=$ENV_FILE
    echo -e "${Purple}Env file '$ENV_FILE' loaded${Color_Off}"
}

# load_env   # optional, will default to $PWD/.env
# load_env ${file-to-load}
load_env2(){

	ENV_FILE=${1:-"$PWD/.env"}
    echo -e "${IBlue}***** Function:  ${FUNCNAME} ${ENV_FILE} *****${Color_Off}"
    path_exists -f $ENV_FILE
	

#	. $ENV_FILE
	source $ENV_FILE
	
	echo -e "${Cyan}---"
	{ # try
		cat $ENV_FILE | while read line 
			do
				if [[ ! -z "$line" ]] && [[ "$line" != \#* ]]; then
					# do something with $line here
#					echo $line
#					export "$line"
					key=$(echo "$line" | cut -d '=' -f 1)
					value=$(echo "$line" | cut -d '=' -f 2-)
					envv="export \${key}=\${value}"
					envv="export ${key}=${value}"
					echo $envv					
					export $envv
					exec "$@"
				fi
			done
			
		printenv
	} || { #catch
	    echo -e "${Red}Cannot load environment file: '$ENV_FILE' ${Color_Off}"
		exit 0
	}
printenv
	export ENV_FILE_USED=$ENV_FILE
    echo -e "${Green}Env file '$ENV_FILE' loaded${Color_Off}"
}

# load_env   # optional, will default to $PWD/.env
# load_env ${file-to-load}
load_env1(){

	ENV_FILE=${1:-"$PWD/.env"}
    echo -e "${IBlue}***** Function:  ${FUNCNAME} ${ENV_FILE} *****${Color_Off}"
    path_exists -f $ENV_FILE
	
	. $ENV_FILE
	
	{ # try
		export $(sed 's/#.*//g' $ENV_FILE | xargs)
		export $(grep -v '^#' $ENV_FILE | xargs)
		#export $(grep -v '^#' $ENV_FILE | xargs -d '\n')
		printenv
	} || { #catch
	    echo -e "${Red}Cannot load environment file: '$ENV_FILE' ${Color_Off}"
		exit 0
	}
	
	export ENV_FILE_USED=$ENV_FILE
    echo -e "${Green}Env file '$ENV_FILE' loaded${Color_Off}"
}

env_cleanup(){
	SITE_PATH=$1

    echo -e "${Green}"

    if [ $1 ]; then
	    SITE_PATH=$1
	else
        SITE_PATH=./
        echo "Defaulting site path to: $INCLUDE_PATH"
    fi

#    cd  ${SITE_PATH}

    echo "Cleaning up ENV_FILE_USED: ${ENV_FILE_USED}"
    if [ -z ${ENV_FILE_USED} ]; then
        echo "Environment file was not loaded.(unset not possible)"
    else

		while read line; do
			if [[ ! -z "$line" ]] && [[ "$line" != \#* ]]; then

				key=$(echo "$line" | cut -d '=' -f 1)
#				echo $key
				unset $key
			fi
		done <${ENV_FILE_USED}	
				
#        unset $(grep -v '^#' ${ENV_FILE_USED} | sed -E 's/(.*)=.*/\1/' | xargs)
        unset ENV_FILE_USED
    fi
}

# build_exit ${EXIT_CODE} ${SITE_PATH}
# build_exit 123 $PWD
build_exit(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
    EXIT_CODE=$1
    SITE_PATH=$2

	echo "env_cleanup $SITE_PATH"
	env_cleanup $SITE_PATH
	
    # Exit_code stores $1 argument passed to function
	echo -e "${Red}>>>>>>>>>>>>>>>>>>>> exit $EXIT_CODE <<<<<<<<<<<<<<<<<<<<${Color_Off}"
    exit $EXIT_CODE 
}

# all_done ${SITE_PATH}
all_done(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"

    if [ $1 ]; then
	    SITE_PATH=$1
	else
        SITE_PATH=./
    fi

	echo -e "${Yellow}-----------------------------------------"
    echo -e "use command: ${Cyan}'cd $SITE_PATH'${Green}" 
    echo -e "use: ${Cyan}'ls -la'${Green} to see current directory listing"
 	echo    "Plese review/update files created for correctness"
	echo    "example of editor: 'notepad' 'vi .env' 'vim .env' or 'nano .env' " 
    echo    "Some directories/files may require 'root' access to view/edit"
	echo -e "when ready use: ${Cyan}'sudo ./up.sh'${Green} to start the container"

	env_cleanup $SITE_PATH

	echo -e "All Done!${Color_off}"
	
	exit 0  # do not remove
}

# setup_complete ${COMMON_ENV}
setup_complete(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"

	COMMON_ENV=./templates/.common.env
    if [ $1 ]; then
	    COMMON_ENV=$1
	else
        echo "connom.env path: '$COMMON_ENV'"
    fi

#cat  ${COMMON_ENV}

	echo  -e "${Yellow}-----------------------------------------"
 	echo "Plese review/update files created for correctness"
	echo "example of editor: 'notepad' 'vi .env' 'vim .env' or 'nano .env' " 
    echo "Some directories/files may require 'root' access to view/edit"
	echo -e "Setup Complete!${Color_off}"

	exit 0  # do not remove
}

# requires_root
requires_root(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
    if [[ $EUID -ne 0 ]]; then
        SITE_PATH=$PWD
        echo -e "${Red}This script must be run as  '${URed}ROOT${Red}'.${Color_Off}"
        build_exit 02 ${SITE_PATH}
    fi
}

# check if path DOES exists $F_OR_D $PATH_TO, if not, error
path_exists(){
    F_OR_D=$1   # options are -f for file and -d for directory
    PATH_TO=$2  #-path-to-(file/directory)

    echo -e "${IBlue}***** Function:  ${FUNCNAME} $F_OR_D $PATH_TO  *****${Color_Off}"
    if [ ! $F_OR_D $PATH_TO ]; then
	   SITE_PATH=$PWD
       echo -e "Location NOT found, but should exist: '$F_OR_D' for '${Red}$PATH_TO${Color_Off}'"
	   build_exit 01 $SITE_PATH
    fi
}

# path_not_exists ${F_OR_D} ${PATH_TO}
# check if path DOES NOT exists $F_OR_D $PATH_TO, if does, error
path_not_exists(){
    F_OR_D=$1   # options are -f for file and -d for directory
    PATH_TO=$2  #-path-to-(file/directory)

    echo -e "${IBlue}***** Function:  ${FUNCNAME} $F_OR_D $PATH_TO  *****${Color_Off}"

    if [ $F_OR_D $PATH_TO ]; then
       SITE_PATH=$PWD
       echo -e "Location found, but should NOT: '$F_OR_D' for '${Red}$PATH_TO${Color_Off}'"
	   echo -e "For your protection:'${Red}script is stopping${Color_Off}'"
       build_exit 01 $SITE_PATH
    fi
}

# # path_not_exists ${F_OR_D} ${PATH_TO} ${F_OR_D} ${PATH_TO}
# check if site path already exists
check_site_path(){
	site_path=$1
	site=$2
	network=$3
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"

    REPLACE=False
    if [ -d "$site_path" ]; then
	    echo -e "site_path $site_path ${Yellow}"
        echo "************************************************"
        echo "**>>>  Delete and completely removes site  <<<**"
        echo "***    if this is prod, this is a problem    ***"
		echo "* * * also will delete network '${network} * * *"
        echo -e "************************************************ ${Color_Off}"
        echo " Site URL: ${site}"

        read -p "Do you wish to continue (y/n)? " var
        if [ "$var" != "y" ]; then
            echo "'y' was not entered, exiting!"
            build_exit 1 $site_path
        fi
        { # try
        docker network rm ${network}
        } || { #catch
        echo "no ${network} network"
        }

	    echo -e "${Yellow} rm -r  $site_path  ${Color_Off}"
        rm -r $site_path
		REPLACE=True
    fi
}	

# get user:group
get_user_group(){
	group_detail=$( cat /etc/group | grep ${SUDO_GID})
	IFS=":"
	read -a Arr <<< "${group_detail}"
	group=${Arr[0]}
	USER_GROUP=$(echo "$SUDO_USER:$group")
}

# intro $MESSAGE
display_function_intro(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
#	BASE_EXE=`basename "$0"`
#    echo ">>>>> $BASE_EXE <<<<<"
    echo -e "${UBlue}***** TBA_functions.sh -> loaded *****${Color_Off}"
	echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
}

	# cat /etc/TZ
	# cat /etc/timezone
	# date +"%Z %z"
	# date +%Z
get_system_time_zone(){
    echo -e "${Red}***** Function:  ${FUNCNAME} not complete*****${Color_Off}"

	## ls -l /etc/localtime
	## /etc/localtime -> /usr/share/zoneinfo/US/Eastern
	TIME_ZONE=$(ls -l /etc/localtime)
	
	loca=$(cut -d/ -f7 <<<"${TIME_ZONE}")
	zone=$(cut -d/ -f8 <<<"${TIME_ZONE}")
	
	TIME_ZONE="${loca}/${zone}"
}

get_web_time_zone(){
    echo -e "${Red}***** Function:  ${FUNCNAME} not complete*****${Color_Off}"
    TIME_ZONE=$(curl https://ipapi.co/timezone)
    #:~$ echo $TIME_ZONE
    #{'error': True, 'reason': 'RateLimited', 'message': 'Visit https://ipapi.co/ratelimited/ for details'}
}

# check_all_scripts_exists ${check_all_scripts_exists}
check_all_scripts_exists(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"

	if [ ! $INCLUDE_PATH ]; then
		INCLUDE_PATH=./
		echo "Defaulting script path to: $INCLUDE_PATH"
	fi

	# TBA_color.sh  TBA_env_file.sh  TBA_functions.sh  TBA_networking.sh  TBA_random.sh
	path_exists -f $INCLUDE_PATH/TBA_color.sh
    path_exists -f $INCLUDE_PATH/TBA_env_file.sh
    path_exists -f $INCLUDE_PATH/TBA_functions.sh
    path_exists -f $INCLUDE_PATH/TBA_networking.sh
    path_exists -f $INCLUDE_PATH/TBA_random.sh
}

# check_parameter_count ${requiredCount} ${actualCount}
check_parameter_count(){
	requiredCount=$1
	actualCount=$2
	correctCount=True

	if [ "$requiredCount" -ne "$actualCount" ]; then
		echo -e "${Red}Usage:  Illegal number of parameters:"
		echo -e "Required Count: $requiredCount"
		echo -e "Actual Count: $actualCount ${Color_Off}"
		correctCount=False
	fi
}

function_test_cases(){

    echo "========================================="
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
    echo -e "${Red}Build the rest of test cases out${Color_Off}"

	get_user_group
	echo "USER_GROUP: ${USER_GROUP}"

	path_not_exists -d /bogus/path
    path_not_exists -f /bogus/file.txt

	load_env .docker_zip.env
	printenv
    env_cleanup $INCLUDE_PATH
    printenv
	
	get_system_time_zone
	echo "TIME_ZONE: $TIME_ZONE"
	get_web_time_zone
	echo "TIME_ZONE: $TIME_ZONE"

    # must be last
    all_done
}

if [[ $SCRIPT =~ "TBA_functions" ]] && [ $TEST ] && [ $TEST == "test" ]; then
    clear

	INCLUDE_PATH=./
	
    . $INCLUDE_PATH/TBA_color.sh

    echo -e "${IBlue}***** ${Black}${On_White}TEST=$TEST${IBlue}, debug will run *****${Color_Off}"

	display_function_intro

    . $INCLUDE_PATH/TBA_networking.sh
	. $INCLUDE_PATH/TBA_random.sh

	echo -e "***** ${Black}${On_White}Running tests${Color_Off} *****"

	function_test_cases
else
	# show what we are doing
	display_function_intro
	check_all_scripts_exists
#	get_user_group
fi
