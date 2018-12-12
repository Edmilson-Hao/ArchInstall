#!/usr/bin/env bash
#
#
#######################################################
##### Author: Edmilson Hao <edmilsonwp@gmail.com> #####
##### Site: http://www.estudandolinux.com.br      #####
##### Version: 0.1                                #####
##### Date: 10/12/2018 10:43:50                   #####
#######################################################
#
#MIT License
#
#Copyright (c) 2018 Edmilson-Hao
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
#

##############################################Variables##############################################
set partition=0
#####################################################################################################

##############################################Functions##############################################

#[[ $(id -u) = 0 ]] || { echo "You must be root to execute script as root" ; exit ; }

#Enter partition to install the system
function setPartition() {
	if [[ $partition -eq 0 ]] ; then
		echo "Please enter the partition you want to install arch linux (e.g.: sda1 or sd2...): "
		read partition
	fi

	clear
	mkfs.xfs -f /dev/$partition
	mount /dev/$partition /mnt && echo "/dev/$partition mounted in /mnt" || { echo "Error: Please check if you have typed the right partition and try again." ; echo -e "\nPress any key to continue." ; read ; exit ; }
}

#select the mirrors
function selectMirror() {
	cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
	cat /etc/pacman.d/mirrorlist.backup | grep "\.br" > /etc/pacman.d/mirrorlist
}

#install the base of the system
function baseInstall() {
	pacstrap /mnt base base-devel grub
	echo -e "\a"
}

#chroot into new installation, configure it and asks if grub installation is needed
function grubChroot() {
	#Generating fstab file
	echo "Generating fstab file."
	sleep 1
	genfstab /mnt >> /mnt/etc/fstab
	
	#Downloading chroot script
	echo "Downloading chroot script."
	sleep 1
	wget https://raw.githubusercontent.com/Edmilson-Hao/ArchLinuxInstall/master/archchroot.sh
	cp archchroot.sh /mnt/tmp
	chmod +x /mnt/tmp/archchroot.sh

	#Configuring new system to start archroot.sh on chroot
	echo "/tmp/archchroot.sh" > /mnt/root/.bashrc
	for i in /sys /proc /run /dev ; do mount --bind "$i" "/mnt$i"; done
	chroot /mnt /bin/bash
}

#Information about how partitioning (Does not) work on this script.
function installerInfo(){
	clear
	echo
	echo
	echo "Before proceeding, make sure the disk has a partition available for installation..."
	echo
	echo
	echo "Press enter to continue (ctrl+c to quit)."
	read
}

#The function that show the menu
function installerMenu(){
	echo "********************************************************************************"
	echo "*     (1) - Select Disk Partition.                                             *"
	echo "*     (2) - Select Mirrors (Brazil only).                                      *"
	echo "*     (3) - Install Base System.                                               *"
	echo "*     (4) - Configure The Installation And Install GRUB to MBR (Optional).     *"
	echo "*     (5) - Lazy mode (Brazil only).										     *"
	echo "*     (6) - Exit.                                                              *"
	echo "********************************************************************************"
  
	echo "Select your choise: "
}

function lazyMode() {
	echo "Root partition (sda1, sda2 etc: "
	read partition
	setPartition
	selectMirror
	baseInstall
	grubChroot
}
####################################################################################################

#Connection test
echo "Testing your connection."
[[ $(ping -c2 archlinux.org) ]] || { echo "You don't have internet connection. Please connect a ethernet connection or use wifi-menu to set up a wifi networkin." ; exit ; }



installerInfo

clear
option=1
while [ $option -ne 5 ] ; do

	installerMenu
	
	read option
  
	clear

	case $option in
		1) setPartition ;;
		2) selectMirror ;;
		3) baseInstall ;;
		4) grubChroot ; break ;;
		5) lazyMode ; break ;;
		6) break ;;
	esac
done
