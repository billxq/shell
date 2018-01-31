#!/bin/bash
cat << EOF
##########################################################################################################
#############################This script is to tell you the system version.###############################
##########################################################################################################
EOF


a=$(cat /etc/centos-release | cut -d" " -f4|awk -F. '{print $1}')
b=$(uname -sr | cut -d- -f1)
echo "Your system is CentOS $a"
echo "Your kernel is $b"
