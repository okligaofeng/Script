#!/bin/bash

if [[ -z $1 || -z $2 || -z $3 ]]
then
	echo "mksd-sama5d3x Usage:"
	echo "	mksd-sama5d3x <device> <boot.bin> <sama5d31ek.dtb> <zImage> <u-boot.bin>"
	echo "	Example: ./mksd-sama5d3x.sh /dev/sdd boot.bin sama5d31ek.dtb zImage u-boot.bin"
	exit
fi



#if ! [[ -e $2 ]]
#then
#	echo "Incorrect boot.bin location!"
#	exit
#fi

#if ! [[ -e $3 ]]
#then
#	echo "Incorrect sama5d31ek.dtb location!"
#	exit
#fi

#if ! [[ -e $4 ]]
#then
#	echo "Incorrect zImage location!"
#	exit
#fi


echo "All data on "$1" now will be destroyed! Continue? [y/n]"
read ans
if ! [ $ans == 'y' ]
then
	exit
fi

echo "[Partitioning $1...]"

DRIVE=$1
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


mkfs.msdos  "$1"1
mkfs.ext4   "$1"2
#mkfs.vfat -F 32 -n boot "$1"1 &> /dev/null
#mkfs.ext4 -L rootfs "$1"2 &> /dev/null

echo "[Copying Boot_1 files...]"

#mount "$1"1 /mnt/tmp/
#cp /mnt/hgfs/share/A5/5c-lsd/u-boot-emmc/$2 /mnt/tmp/boot.bin
#cp /mnt/hgfs/share/A5/5c-lsd/u-boot-emmc/$3 /mnt/tmp/sama5d31ek.dtb
#cp /mnt/hgfs/share/A5/5c-lsd/u-boot-emmc/$4 /mnt/tmp/zImage
#cp /mnt/hgfs/share/A5/5c-lsd/u-boot-emmc/$5 /mnt/tmp/u-boot.bin
echo "[Sync Boot_1]"
#sync
#umount "$1"1

echo "[Copying Boot_2 files...]"
#mount "$1"2 /mnt/tmp/
#cp -rf  nfs_rootfs/5C_LSD_V2.0/* /mnt/tmp/
#chmod 755 /mnt/tmp/
#echo "[Sync Boot_2]"
#sync
#umount "$1"2

echo "[Done]"
