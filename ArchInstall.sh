#!/usr/bin/env bash

#################################Variables###########################################

set partition

#####################################################################################

loadkeys br-abnt2

clear
function setPartition() {
	echo "This script assumes that you have already formated the driver to a layout that"
	echo "suits your need also if you want to create a swap driver make it yourself by"
	echo "using mkswap and swapon. I think using a swapfile is a better idea."

	echo ; echo
	sleep 1

	echo "Please enter the partition you want to install arch linux (eg.: sda1 or sd2...)."
	echo -e "\a"

	read partition
	clear

	mount /dev/$partition /mnt && echo "/dev/$partition mounted in /mnt" ||  { echo "Error: Please check if your typed the right partition and rettry." ; exit ; }
	sleep 1
}

function selectMirror() {
	cat /etc/pacman.d/mirrorlist > /etc/pacman.d/mirrorlist.backup
	cat /etc/pacman.d/mirrorlist | grep "\.br" > mirror
	cat mirror > /etc/pacman.d/mirrorlist
}

function baseInstall() {
	pacstrap /mnt base
	read oi
	echo $oi
}

baseInstall
