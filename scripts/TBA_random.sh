#!/bin/bash
#
# Created by Quesenbery, D
# ToolbaxAid.com
# Date  10/20/2022
#
# TBA_random.sh
#
#

# need a dictionary of words to process
DICTIONARY_WORDS=english3
SCRIPT="$0"
TEST="$1"

check_dictionary(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
    if [ ! -f  "english3.txt" ]; then
		echo "........................................."
        echo "Setting up a word file"
        wget http://www.gwicks.net/textlists/$DICTIONARY_WORDS.zip

        echo "........................................."
        7z l english3.zip

        echo "........................................."
        7z e $DICTIONARY_WORDS.zip

        echo "........................................."
        rm $DICTIONARY_WORDS.zip
		words=$(wc -l $DICTIONARY_WORDS.txt)
		echo "Word count: $words"
        echo "Done..."
        echo "........................................."
#    else
##        echo "Your word dictionary exists."
#		echo "."
    fi
}

get_random_dictionary_word(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
    check_dictionary
    random_dictionary_word=$(shuf -n1 $DICTIONARY_WORDS.txt)
}

get_random_dictionary_word_concatenated(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
#  echo "The number of positional parameter : $#"
#  echo "All parameters or arguments passed to the function: '$@'"
#  echo
	COUNT=$1
	SEPERATOR=$2

    # $# is count of parameters
	if [ $# -ne 2 ];
	then
        echo "........................................."
        echo "Please specify how many random words would you like to concatenate !"
        echo "example: get_random_words 2 '-' "
        echo "This will generate 2 random words seperated by '-'"
        echo "........................................."

		build_exit 94 "./"
    fi

	# Constants
    X=0
    TMP_SEPERATOR=""

    # while loop to generate random words
    # number of random generated words depends on supplied argumenti
	random_dictionary_word_concatenated=""
    while [ "$X" -lt "$COUNT" ]
    do
	    get_random_dictionary_word
        random_dictionary_word_concatenated="$random_dictionary_word_concatenated$TMP_SEPERATOR$random_dictionary_word"
	    TMP_SEPERATOR=$SEPERATOR
        let "X = X + 1"
    done
}

#   https://unix.stackexchange.com/questions/230673/how-to-generate-a-random-string
#   !";#$%&'()*+,-./:;<=>?@[]^_`{|}~     ({ } [ ] ( ) / \ ' " ` ~ , ; : . < >
get_random_AZaz09(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
	LEN=$1
    random=$(head /dev/urandom | tr -dc A-Za-z0-9$%^[] | head -c $LEN)
#	head /dev/urandom | tr -dc A-Za-z0-9$%^[] | head -c 13 ; echo ''
}

# Random get_random_AZaz09_plus
get_random_AZaz09_plus(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
    LEN=$1
	random=$( head /dev/urandom | tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' | head -c $LEN)
#    head /dev/urandom | tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' | head -c 13  ; echo
}

# Random base64
get_random_base64(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
    LEN=$1
    random=$(openssl rand -base64 $LEN)
}

# Random hex
get_random_hex(){
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
    LEN=$1
	random=$(openssl rand -hex $LEN)
}

# intro $MESSAGE
display_random_info(){
    echo -e "${UBlue}***** TBA_random.sh -> loaded *****${Color_Off}"
    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"

}

test_cases(){

    echo -e "${IBlue}***** Function:  ${FUNCNAME} *****${Color_Off}"
    echo "========================================="

    echo "-----------------------------------------"
	get_random_dictionary_word
	echo "Random word is: $random_dictionary_word"

	COUNT=3
	SEPERATOR="-"
    get_random_dictionary_word_concatenated $COUNT $SEPERATOR
	echo "random_dictionary_word_concatenated: $random_dictionary_word_concatenated"

    get_random_dictionary_word_concatenated $COUNT $SEPERATOR
    echo "random_dictionary_word_concatenated: $random_dictionary_word_concatenated"

    get_random_dictionary_word_concatenated $COUNT $SEPERATOR
    echo "random_dictionary_word_concatenated: $random_dictionary_word_concatenated"

    get_random_dictionary_word_concatenated $COUNT $SEPERATOR
    echo "random_dictionary_word_concatenated: $random_dictionary_word_concatenated"

    echo "-----------------------------------------"
    LEN=5

    get_random_AZaz09 $LEN
	echo "random AZaz09     : $random"

    get_random_AZaz09_plus $LEN
    echo "random AZaz09_plus: $random"

    get_random_base64 $LEN
    echo "random _base64    : $random"

    get_random_hex $LEN
    echo "random hex        : $random"

    echo "-----------------------------------------"

    # must be last
    all_done
}

if [[ $SCRIPT =~ "TBA_random" ]] && [ $TEST ] && [ $TEST == "test" ]; then
    clear

	INCLUDE_PATH=./
    . $INCLUDE_PATH/TBA_color.sh

    echo -e "${IBlue}***** ${Black}${On_White}TEST=$TEST${IBlue}, debug will run *****${Color_Off}"

    . $INCLUDE_PATH/TBA_functions.sh

	display_random_info

    echo -e "***** ${Black}${On_White}Running test_cases${Color_Off} *****"

	test_cases
else
	# show what we are doing
	display_random_info
fi
