#!/usr/bin/env bash

##############################################Functions##############################################

function setPartition() {
	echo "Please enter the partition you want to install arch linux (eg.: sda1 or sd2...)."
	read partition
	clear

	mount /dev/$partition /mnt && echo "/dev/$partition mounted in /mnt" || { echo "Error: Please check if your typed the right partition and rettry." ; echo " Press any key to continue." ; read ; exit ; }	
}

function selectMirror() {
	cat /etc/pacman.d/mirrorlist > /etc/pacman.d/mirrorlist.backup
	cat /etc/pacman.d/mirrorlist | grep "\.br" > mirror
	cat mirror > /etc/pacman.d/mirrorlist
}

function baseInstall() {
	pacstrap /mnt base base-devel grub
	echo -e "\a"
}

function grubChroot() {
	echo "Generating fstab file."
	sleep 1
	genfstab /mnt >> /mnt/etc/fstab
	
	echo "Downloading chroot script."
	sleep 1
	wget https://raw.githubusercontent.com/Edmilson-Hao/ArchLinuxInstall/master/archchroot.sh
	cp archchroot.sh /mnt/tmp
	chmod +x /mnt/tmp/archchroot.sh

	echo "/tmp/archchroot.sh" > /mnt/root/.bashrc
	for i in /sys /proc /run /dev ; do mount --bind "$i" "/mnt$i"; done
	chroot /mnt /bin/bash
}

####################################################################################################

#Connection test
[[ $(ping -c2 archlinux.org) ]] || { echo "You don't have internet connection. Please connect a ethernet connection or use wifi-menu to set up a wifi networkin." ; exit ; }

#Information about how partitioning (Does not) work on this script.
echo "This script assumes that you have already formated the driver to a layout that"
echo "suits your need also if you want to create a swap driver make it yourself by"
echo "using mkswap and swapon. I think using a swapfile is a better idea."
echo
echo "Press enter to continue."
read
clear

option=1
while [ $option -ne 5 ] ; do
  echo "******************************************************************************"
  echo "*     1 - Select Disk Partition.                                             *"
  echo "*     2 - Select Mirrors.                                                    *"
  echo "*     3 - Install Base System.                                               *"
  echo "*     4 - Configure The Installation And Install GRUB to MBR (Optional).     *"
  echo "*     5 - Exit.                                                              *"
  echo "******************************************************************************"
  
  local PS1="Select your choise: "
  read -e option

  clear

  case $option in
  	1) setPartition ;;
  	2) selectMirror ;;
  	3) baseInstall ;;
  	4) grubChroot ; break ;;
  	5) break ;;
  esac
done
