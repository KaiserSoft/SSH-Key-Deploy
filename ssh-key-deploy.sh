#!/bin/bash

# script to simplify mangement of the authorized_keys file
# * copy any .pub files which should be included into ./active/
# * copy any .pub files which should be removed into ./remove/
#
#
# Author: Mirko Kaiser, http://www.KaiserSoft.net
# Project URL: https://github.com/KaiserSoft/SSH-Key-Deploy/
# Support the software with Bitcoins !thank you!: 157Gh2dTCkrip8hqj3TKqzWiezHXTPqNrV
# Copyright (C) 2015 Mirko Kaiser
# First created in Germany on 2015-09-20
# License: New BSD License
#
# Example for current user: ./ssh-key-deploy.sh
# Example with custom key file: ./ssh-key-deploy.sh /home/foo/authorized_key


AUTHORIZED_KEYS="$HOME/.ssh/authorized_keys"



# custom authorized key file passed
if [ -n "$1" ]; then
	if [ $1 != '--force' ]; then
	        AUTHORIZED_KEYS=$1
	fi

	if [ -n "$2" ]; then
		AUTHORIZED_KEYS=$2
	fi	
fi



# process parameters
case "$1" in
	'--help')
		printf "./ssh-key-add.sh --force <path/to/authorized_keys>\n\n"
		printf "\t--force\tremove authorized_keys file befirst\n\n"
		exit 1
	        ;;

	'--force')
		printf "Using: $AUTHORIZED_KEYS\n"
		RET=`echo "" > $AUTHORIZED_KEYS 2>&1`
		if [ $? -eq 0 ]; then
			printf "File cleared\n"
		else
			printf "ERROR: clearing file: $RET\n\n"
			exit 1
		fi
                ;;

	*)
		printf "Using: $AUTHORIZED_KEYS\n"
		;;
esac




# create backup
if [ $1 != '--force' ] && [ -f "$AUTHORIZED_KEYS" ]; then
	KEY_BACK=$AUTHORIZED_KEYS".deploy"
	cp "$AUTHORIZED_KEYS" "$KEY_BACK"
	printf "Backup: $KEY_BACK\n"
fi


# process keys to be added
find ./active/  -type f -maxdepth 1 -name "*.pub" | while read FOUND 
do

	CONTENT=`cat $FOUND`

	grep "$CONTENT" "$AUTHORIZED_KEYS" 2&>1 /dev/null
	if [ $? -ne 0 ]; then
		#key not in authorized key file, add it
		cat "$FOUND" 2> /dev/null >> "$AUTHORIZED_KEYS"
		if [ $? -ne 0 ]; then
			printf "  * error writing to file\n"
		else
			printf "  + key added $FOUND\n"
		fi
	fi 
done




# process key removal 
find ./remove/  -type f -maxdepth 1 -name "*.pub" | while read FOUND
do

        CONTENT=`cat $FOUND`
        RET=`grep -n "$CONTENT" "$AUTHORIZED_KEYS" 2> /dev/null`
	item_src=`echo "$RET" |  awk -F":" '{print $1}'`

        if [ $? -eq 0 ]; then

		# prepare lines numbers for sed operation
		for item in ${item_src[@]}
		do

		        SEDOPTS="$SEDOPTS${item}d;"

		done

		if [ -n "$SEDOPTS" ]; then
			RETSED=`sed ${SEDOPTS}  < "$AUTHORIZED_KEYS" 2> /dev/null`
			if [ $? -ne 0 ]; then
                        	printf "  * error reading file\n"
			else

        	        	echo "$RETSED" > "$AUTHORIZED_KEYS"
                		if [ $? -ne 0 ]; then
                        		printf "  * error writing to file\n"
                		else
                        		printf "  - key removed $FOUND\n"
                		fi
			fi
		fi


        fi
done
