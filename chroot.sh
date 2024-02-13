#!/bin/sh

ln -sf /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
hwclock -w

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "arch" > /etc/hostname
echo "127.0.0.1 localhost
::1       localhost
127.0.1.1 arch.localdomain arch" > /etc/hosts

echo "[Match]
Name=enp3s0

[Network]
DHCP=yes" > /etc/systemd/network/00-enp3s0.network
ln -sf /usr/lib/systemd/resolv.conf /etc/resolv.conf
systemctl enable systemd-networkd systemd-resolved

mkinitcpio -P

sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
useradd -m -G audio,video,wheel -s /bin/bash c
passwd c
passwd

# Bootloader
ROOT=$(blkid -s PARTUUID -o value /dev/sda2)
bootctl --path=/boot install

echo "default arch.conf" > /boot/loader/loader.conf
echo "title arch
linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID='"${ROOT}"' rootfstype=ext4 rw" > /boot/loader/entries/arch.conf