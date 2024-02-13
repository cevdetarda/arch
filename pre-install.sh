#!/bin/sh

# Create the partition table with sfdisk
sfdisk -q /dev/sda << EOF
label:gpt
size=512M, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B
type=4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709
EOF

# Format the partitions
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2

# Mount the partitions
mount /dev/sda2 /mnt
mount -m /dev/sda1 /mnt/boot

# Install
pacstrap -K /mnt base linux linux-firmware amd-ucode efibootmgr

# /etc/fstab
genfstab -U /mnt > /mnt/etc/fstab

# chroot
arch-chroot /mnt