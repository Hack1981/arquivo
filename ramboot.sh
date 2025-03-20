#!/bin/sh

# Configurações
RAMDISK_SIZE=2G
RAMDISK_MOUNT=/mnt/ramroot
DISK_DEV=/dev/sda1

echo "[*] Criando RAM disk em $RAMDISK_MOUNT com tamanho $RAMDISK_SIZE..."
mkdir -p $RAMDISK_MOUNT
mount -t tmpfs -o size=$RAMDISK_SIZE tmpfs $RAMDISK_MOUNT

echo "[*] Copiando sistema com UID/GID, arquivos de boot, e ignorando erros de leitura..."
rsync -aAXHv --numeric-ids --ignore-errors / $RAMDISK_MOUNT \
--exclude=/proc/* \
--exclude=/sys/* \
--exclude=/dev/* \
--exclude=/run/* \
--exclude=/mnt/* \
--exclude=/media/* \
--exclude=/tmp/*

echo "[*] Montando sistemas virtuais (dev, proc, sys, run)..."
mount --bind /dev $RAMDISK_MOUNT/dev
mount --bind /proc $RAMDISK_MOUNT/proc
mount --bind /sys $RAMDISK_MOUNT/sys
mount --bind /run $RAMDISK_MOUNT/run

echo "[*] Entrando no sistema RAM (chroot)..."
chroot $RAMDISK_MOUNT /bin/bash <<'EOF'
echo "[*] Você está agora 100% na RAM!"
echo "[*] Desmontando disco físico dentro da RAM..."

umount /dev/sda1 2>/dev/null
echo 1 > /sys/block/sda/device/delete

echo "[*] Disco físico /dev/sda1 foi desligado. Sistema rodando só na RAM."
EOF

echo "[*] Saindo do chroot. RAM disk operacional."
