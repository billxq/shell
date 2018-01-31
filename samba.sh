#!/bin/bash
## This is a shell to autoinstal samba service.
function check_status() {
	if [ $? -eq 0 ];then
	echo "OK!"
	else
	echo "Wrong!"
	fi
}


stop_firewalld() {
	systemctl status firewalld 2>&1
	if [ $? == 0 ]; then
	echo "Stopping the firewalld now. Stopped"
	systemctl stop firewalld  2>&1 
	systemctl disable firewalld 2>&1 
	check_status
	else
	echo "The firewalld has already been stopped!"
	fi
}

disable_selinux() {
	if [ $(getenforce) == 'Disabled' ];then
	echo "Selinux has been disabled!"
	elif [ $(getenforce) == 'Permissive' ]; then
		echo "Disable Selinux now!"
		sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
		check_status
	else
		                echo "Disable Selinux now!"
                sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
                check_status
	fi
}


install_samba() {
	echo "Samba Directory is '${smb_path}'"
	read -p "Please input samba user:" user
	read -p "Please input samba user passwd:" psd
	echo "###########################Installing samba-service now!#######################"
	useradd $user -s /sinb/nologin
	yum -y install samba samba-client
	check_status
	cat > /etc/samba/smb.conf << EOF
[global]
	workgroup = WORKGROUP
	security = user
	passdb backend = tdbsam
	printing = cups
	printcap name = cups
	load printers = yes
	cups options = raw
[myshare]
	comment = My Samba Server
	path = 
	browseable = yes
	read only = no
	writable = yes
	public = no
EOF
	sed -i 's#path =#path = '${smb_path}'#' /etc/samba/smb.conf
	touch /etc/samba/smbpasswd
	chmod +x /etc/samba/smbpasswd
	echo -e "$psd\n$psd" | smbpasswd -a $user -s
	[ -d ${smb_path} ] || mkdir -p ${smb_path}
	chmod -R 777 ${smb_path}
	systemctl start smb nmb 2>&1
	check_status
	echo -e "Samba service has been started! \n Please enjoy!"
}

smb_path=$1
global smb_path
disable_selinux
check_status
install_samba



