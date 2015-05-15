#!/bin/sh

#At cortex-a8 to Use: ./emmc /dev/mmcblock1

umount $1*
DRIVE=$1
SD="/dev/mmcblk0"
dd if=/dev/zero of=$DRIVE bs=1024 count=1024

SIZE=`fdisk -l $DRIVE | grep Disk | awk '{print $5}'`

echo DISK SIZE - $SIZE bytes

CYLINDERS=`echo $SIZE/255/63/512 | bc`

echo CYLINDERS - $CYLINDERS
{
echo ,9,0x0C,*
echo ,,,-
} | sfdisk -D -H 255 -S 63 -C $CYLINDERS $DRIVE

echo "[Making filesystems...]"


mkfs.vfat -F 32 -n boot "$1"p1
echo y > mkfs.ext4 -L rootfs "$1"p2
#mkfs.msdos "$1"1
#mkfs.ext4  "$2"2

echo "cp partation BOOT.."
mount -t vfat "$1"p1 /mnt/emmc
mount -t vfat "$SD"p1 /mnt/sd
cp -rf /mnt/sd/EMMC_BOOT/* /mnt/emmc
sync
umount /mnt/emmc/
umount /mnt/sd

echo "cp partation ROOTFS.."
mount -t ext4 "$1"p2   /mnt/emmc/
tar xf rootfs.tar -C   /mnt/emmc/
sync
umount /mnt/emmc/
