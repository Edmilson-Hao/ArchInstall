#!/usr/bin/env bash

exitMessage="The installation is complete, type exit to leave chroot, remove the installation media and reboot the system."

function installGrub() {
	echo "Enter the disk to install GRUB (not the partition but the disk itself eg.: sda, sdb)"
	read disk
	clear
	grub-install /dev/$disk
	grub-mkconfig -o /boot/grub/grub.cfg
}

echo "Pleaze enter your current timezone (eg.: America/Recife, America/Argentina/Buenos_aires etc.)."
echo "If your not sure run select another tty and list all available options -> ls /usr/share/zoneinfo"
read myzoneinfo
ln -sf /usr/share/zoneinfo/$myzoneinfo /etc/localtime
sleep 1
clear
#Making initialRam disk file
mkinitcpio -p linux

echo "Do you want to install GRUB in the MBR? (Y/n)"
read -e option
#Ask if user wants to install grub
echo "Do you want to install grub to MBR?"
echo "1 - Yes"
echo "2 - No"
read grubOption

[[ $grubOption -eq 1 ]] && installGrub

exit
