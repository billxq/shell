#!/bin/bash
cat << EOF
##########################################################################################################
############This script is to print hello to every user in passwd file and print its uid.#################
##########################################################################################################
EOF

read -p "Choose(1 to start;2 to exit.): " op

case $op in
	1)
	awk -F':' '{print "Hello,"$1".""Your uid is:"$3"."}' /etc/passwd
	;;
	2)
	exit
	;;
esac




