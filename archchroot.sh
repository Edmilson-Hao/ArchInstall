#!/usr/bin/env bash

exitMessage="The installation is complete, type exit to leave chroot, remove the installation media and reboot the system."

echo "setting pt_BR to locale.gen"
echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen
locale-gen

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
[[ ! $option == "y" ]] && { echo $exitMessage ; exit ; }
[[ ! $option == "Y" ]] && { echo $exitMessage ; exit ; }

clear
echo "Enter the disk to install GRUB (not the partition but the disk itself eg.: sda, sdb)"
read disk
$(grub-install /dev/$disk)
grub-mkconfig -o /boot/grub/grub.cfg

exit
