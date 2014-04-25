#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "Usage:"
	echo "	mirror.sh office"
	echo "	mirror.sh original"
	exit 1
fi



echo "Checking Ubuntu Version"
UB_VERSION=$(lsb_release -c | awk '{print $2}')
if [[ $UB_VERSION != saucy ]] && [[ $UB_VERSION != raring ]] && [[ $UB_VERSION != precise ]] && [[ $UB_VERSION != trusty ]]; then
	echo "You need Ubuntu to use this script"
	exit 1
fi



if [[ $1 == office ]]; then

	count=$(ping -c 1 mirror.despegar.it | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')

	if [ $count -eq 0 ]; then
		echo "Could not reach mirror host, you have a problem in your network or you are not in the office ;)"
		exit 1
	fi

	if [[ ! -f /etc/apt/sources.original ]]; then
		mv /etc/apt/sources.list /etc/apt/sources.original
	fi

	if [[ ! -f /etc/apt/sources.office ]]; then
	echo "Getting new sources.list"
	wget http://mirror.despegar.it/sources.txt	-O /etc/apt/sources.office
	sed -i "s/\$VERSION/$UB_VERSION/" /etc/apt/sources.office
	fi
	
	cp /etc/apt/sources.office /etc/apt/sources.list
	echo "Success!"
fi

if [[ $1 == original ]]; then

        if [[ ! -f /etc/apt/sources.original ]];then
                echo "You have the original sources.list"
                exit 1
        fi

	mv /etc/apt/sources.list /etc/apt/sources.list.bak
	cp /etc/apt/sources.original /etc/apt/sources.list
	echo "Success!"

exit 0

fi
