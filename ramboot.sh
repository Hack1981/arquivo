#!/bin/sh

RAMDISK_SIZE=2G
RAMDISK_MOUNT=/mnt/ramroot

echo "[*] Criando RAM disk em $RAMDISK_MOUNT..."
mkdir -p $RAMDISK_MOUNT
mount -t tmpfs -o size=$RAMDISK_SIZE tmpfs $RAMDISK_MOUNT

echo "[*] Copiando sistema (/) para RAM..."
rsync -aAXv / $RAMDISK_MOUNT \
--exclude=/proc/* \
--exclude=/sys/* \
--exclude=/dev/* \
--exclude=/run/* \
--exclude=/mnt/* \
--exclude=/media/* \
--exclude=/tmp/*

echo "[*] Montando /dev, /proc, /sys, /run..."
mount --bind /dev $RAMDISK_MOUNT/dev
mount --bind /proc $RAMDISK_MOUNT/proc
mount --bind /sys $RAMDISK_MOUNT/sys
mount --bind /run $RAMDISK_MOUNT/run

echo "[*] Entrando no sistema RAM (chroot)..."
chroot $RAMDISK_MOUNT /bin/bash <<'EOF'
echo "[*] Rodando 100% na RAM agora!"
EOF

echo "[*] Desmontando e desligando /dev/sda1..."
umount /dev/sda1

echo 1 > /sys/block/sda/device/delete
echo "[*] Disco /dev/sda1 foi desligado. Sistema está na RAM."
