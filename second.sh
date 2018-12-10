#!/usr/bin/env bash
pacstrap /mnt grub
cp archchroot.sh /mnt/tmp
chmod +x /mnt/tmp/archchroot.sh

echo "/tmp/archchroot.sh" >> /mnt/root/.bashrc
for i in /sys /proc /run /dev ; do mount --bind "$i" "/mnt$i"; done
chroot /mnt /bin/bash

genfstab /mnt >> /mnt/etc/fstab
