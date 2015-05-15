#!/bin/sh
#rm rootfs_NoBuildroot.ubi
mkfs.ubifs -d $PWD/rootfs -e 126976 -c 2048 -m 2048 -x lzo -o ubifs.img
#ubinize -o rootfs_NoBuildroot.ubi -m 2048 -p 128KiB -s 2048 ubinize.cfg
ubinize -o ubi.img -m 2048 -p 128KiB -s 2048 ubinize.cfg
rm ubifs.img

