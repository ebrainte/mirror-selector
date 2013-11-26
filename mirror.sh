#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "Usage:"
	echo "	mirror.sh office"
	echo "	mirror.sh original"
	exit 1
fi

if [[ $1 == office ]]; then

	count=$(ping -c 1 mirror.despegar.it | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')

	if [ $count -eq 0 ]; then
		echo "Could not reach mirror host, you have a problem in your network or you are not in the office ;)"
		exit 1
	fi

	if [[ ! -f /etc/apt/sources.internet ]]; then
		mv /etc/apt/sources.list /etc/apt/sources.internet
	fi

	echo "Getting new sources.list"
	wget http://10.254.130.200/sources.list	-O /etc/apt/sources.local
	mv /etc/apt/sources.list /etc/apt/sources.list.bak
	cp /etc/apt/sources.local /etc/apt/sources.list
	echo "Success!"
fi

if [[ $1 == original ]]; then

        if [[ ! -f /etc/apt/sources.internet ]];then
                cp /etc/apt/sources.list /etc/apt/sources.internet
        fi

	mv /etc/apt/sources.list /etc/apt/sources.list.bak
	cp /etc/apt/sources.internet /etc/apt/sources.list
	echo "Success!"

exit 0

fi
