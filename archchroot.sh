#!/usr/bin/env bash

exitMessage="The installation is complete, type exit to leave chroot, remove the installation media and reboot the system."

function installGrub() {
	echo "Enter the disk to install GRUB (not the partition but the disk itself eg.: sda, sdb)"
	read disk
	clear
	grub-install /dev/$disk
	grub-mkconfig -o /boot/grub/grub.cfg
}

function setLocale() {
	echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
	echo 'LANG=pt_BR.UTF-8' >> /etc/locale.conf
	echo 'KEYMAP=br-abnt2' >> /etc/vconsole.conf
	localectl set-keymap br-abnt2
	echo 'arch' > /etc/hostname
	locale-gen
}

echo "Pleaze enter your current timezone (eg.: America/Recife, America/Argentina/Buenos_aires etc.)."
echo "If your not sure run select another tty and list all available options -> ls /usr/share/zoneinfo"
read myzoneinfo
timedatectl set-ntp true
ln -sf /usr/share/zoneinfo/$myzoneinfo /etc/localtime
sleep 1
clear
#Making initialRam disk file
mkinitcpio -p linux

#Enable DHCPCD
echo "Enable dhcpcd"
systemctl enable dhcpcd

#Set keyboard layout
echo "Configure Brazilian keyboard layout and lcoales?"
echo "(1) - Yes"
echo "(2) - No"
read kOption

if [[ $kOption -eq 1 ]] ; then
	setLocale
fi

#Ask if user wants to install grub
echo "Do you want to install grub to MBR?"
echo "(1) - Yes"
echo "(2) - No"
read option

[[ $option -eq 1 ]] && installGrub

exit
