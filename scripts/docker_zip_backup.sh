#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# "docker_zip_backup.sh"
#

INCLUDE_PATH=../scripts

if [ -d "${INCLUDE_PATH}" ]
then
    clear
    BASE_EXE=`basename "$0"`
    echo ">>>>> Executing: $BASE_EXE <<<<<"

    . $INCLUDE_PATH/TBA_color.sh
    . $INCLUDE_PATH/TBA_functions.sh
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
else
    echo -e "Error: Directory does not exists -> '\e[31m${INCLUDE_PATH}\e[0m'."
        exit 1
fi

# Script path must exist before we continue
requires_root

#load_env $PWD/.backup_env
load_env $PWD/.docker.zip.env
echo "PWD: ${PWD}"

usage(){
    echo -e "${Red}Usage: docker_zip_backup.sh {TYPE}"
	echo " TYPE: base - backup only custom_data, scripts & templates"
	echo " TYPE: site - backup only wan, lan, dev directories"
	echo " TYPE: full - backup base & site"
    build_exit 1
}

# intro $MESSAGE
display_docker_backup_intro(){
    echo -e "${UBlue}***** docker_zip_backup.sh -> loaded *****${Color_Off}"
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
}

check_parameter_count 1 $#
if [ $correctCount != True ]; then
	usage
	build_exit 87 "./"
fi

echo "-----------------------------------------"
TYPE=$1
#FULL_BACKUP_NAME=$FULL_BACKUP_NAME
SITE_BACKUP_NAME=$SITE_BACKUP_NAME
BASE_BACKUP_NAME=$BASE_BACKUP_NAME

# show what we are doing
display_docker_backup_intro

if [ "$#" -ne 1 ]; then
    echo -e "${On_Red}Illegal number of parameters${Color_off}"
	usage
fi

# what are we doing? {dk or ws}
if [ $TYPE = 'full' ]; then
    echo "Full backup"
elif [ $TYPE = 'site' ]; then
    echo "Site backup"
elif [ $TYPE = 'base' ]; then
    echo "Base backup"
else
    echo -e "${On_Red}What are we doing? Valid environments are {full, site, base)${Color_off}"
    usage
fi

## Make sure backup directory exists
if [ ! -d "$BACKUP_PATH" ]; then
	echo "Directory does not exist: $BACKUP_PATH"
    mkdir -p "${BACKUP_PATH}"
    chmod 750 "${BACKUP_PATH}"
fi

SCRIPTDIR=$PWD
echo "Scripts: ${SCRIPTDIR}"
cd ..
DA_PATH=$PWD
echo "DA_PATH: $DA_PATH"

#DA_PATH=./$(echo "${DA_PATH##/*/}")
#echo "DA_PATH: $DA_PATH"

cd ..
echo "PWD: $PWD"

# Create the timestamp with an underscore
TIME_STAMP=_$(date '+%Y-%m-%d_%H-%M-%S')

# Remove the leading underscore using parameter expansion
TIME_STAMP=${TIME_STAMP#_}

# Print the modified timestamp
#echo "Time Stamp: $TIME_STAMP"

# Base and Full backup
if [ $TYPE = 'base' ] || [ $TYPE = 'full' ] ; then

    TRIMMED=$(echo "$BACKUP_PATH" | sed 's:/*$::')
    BACKUP_NAME=$BASE_BACKUP_NAME
    INCLUDE=$BASE_INCLUDE

	echo "DA_PATH: $DA_PATH"
	echo "PWD:     $PWD"
	echo "TRIMMED: $TRIMMED"
    echo "BKP_PATH:$BACKUP_PATH"
	echo "BKP_NAME:$BACKUP_NAME"
    echo "BASE_NAME:$BASE_BACKUP_NAME"
    echo "SCRIPTDIR:$SCRIPTDIR/"
    # Get the contents of the file
    echo "INCLUDE: $INCLUDE"
	file_contents=$(cat < ${DA_PATH}/scripts/${INCLUDE})
    echo -e "X_X_X_ file_contents=\n${file_contents}\n"

    while IFS= read -r directory; do
        # Check if the directory exists
        if [ -d "$DA_PATH/$directory" ]; then
            # ZIP the contents of the directory
            echo "----------------------------------"
            echo "ZIP contents of '$directory':"
     	    ZIP_BACKUP_PATH=$TRIMMED/$BACKUP_NAME.$directory.$TIME_STAMP.zip
            echo "zip -r $ZIP_BACKUP_PATH  $DA_PATH/$directory"
    		zip -r $ZIP_BACKUP_PATH  $DA_PATH/$directory
    else
            echo "Directory $DA_PATH/$directory does not exist."
        fi
    	echo ""
    done < "${DA_PATH}/scripts/${INCLUDE}"

fi

# Site and Full backup
if [ $TYPE = 'site' ] || [ $TYPE = 'full' ] ; then

    TRIMMED=$(echo "$BACKUP_PATH" | sed 's:/*$::')
	BACKUP_NAME=$SITE_BACKUP_NAME
    INCLUDE=$SITE_INCLUDE

    echo "DA_PATH: $DA_PATH"
    echo "PWD:     $PWD"
    echo "TRIMMED: $TRIMMED"
    echo "BKP_PATH:$BACKUP_PATH"
    echo "BKP_NAME:$BACKUP_NAME"
    echo "BASE_NAME:$SITE_BACKUP_NAME"
    echo "SCRIPTDIR:$SCRIPTDIR/"
    # Get the contents of the file
    echo "INCLUDE: $INCLUDE"
    file_contents=$(cat < ${DA_PATH}/scripts/${INCLUDE})
    echo -e "X_X_X_ file_contents=\n${file_contents}\n"


	root_directory=${DA_PATH}/scripts/${INCLUDE}
	echo "Root Dir: $root_directory"
	# Use find to list directories recursively and pipe the output to the outer loop
	#find "${root_directory}" -type d | while IFS= read -r directory; do
	while IFS= read -r directory; do
		path_to_data=${DA_PATH}/${directory}
	    echo "Base Directory: ${path_to_data}"
		echo "     Directory: ${directory}"
		
	    find "${path_to_data}" -maxdepth 1 -type d | while IFS= read -r file; do
	        echo "----------------------------------"
	        if [ $(basename "${directory}") !=  $(basename "${file}") ] ; then
		        base_dir=$(basename "${directory}")
		        base_file=$(basename "${file}")
                echo "dir: $directory"
                echo "fil: $file"

				echo "base dir: ${base_dir}"
                echo "base fil: ${base_file}"

	            # ZIP the contents of the directory
	            echo "ZIP contents of '$directory':"
				echo $TIME_STAMP
	            ZIP_BACKUP_PATH=$TRIMMED/$BACKUP_NAME.${base_dir}.${base_file}.$TIME_STAMP.zip
	            echo "zip -r $ZIP_BACKUP_PATH $file" 
				zip -r $ZIP_BACKUP_PATH $file
	            #zip -r $ZIP_BACKUP_PATH  $DA_PATH/$directory
			else
				echo "Skip root directory: $directory"
			fi
	    done
	done < "${DA_PATH}/scripts/${INCLUDE}"
	fi

echo "-----------------------------------------"
cd $SCRIPTDIR

echo -e "${Green}Backup complete to $BACKUP_PATH with TimeStamp: $TIME_STAMP. ${Color_Off}"
#ls -la $BACKUP_PATH
echo "-----------------------------------------"

