#!/bin/bash
echo "=== CONFIGURACIÓN DE RAID 1 ==="

# Verificar que tenemos 9 discos disponibles
echo "Verificando discos disponibles..."
sudo fdisk -l | grep -E "Disk /dev/sd[b-j]" | wc -l

# Crear RAIDs
echo "Creando RAID para Apache..."
sudo mdadm --create /dev/md0 --level=1 --raid-devices=3 /dev/sdb /dev/sdc /dev/sdd --force

echo "Creando RAID para MySQL..."
sudo mdadm --create /dev/md1 --level=1 --raid-devices=3 /dev/sde /dev/sdf /dev/sdg --force

echo "Creando RAID para Nginx..."
sudo mdadm --create /dev/md2 --level=1 --raid-devices=3 /dev/sdh /dev/sdi /dev/sdj --force

# Configuración persistente
echo " Configurando persistencia..."
sudo mkdir -p /etc/mdadm
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u

# Verificar estado
echo " Estado final de los RAIDs:"
cat /proc/mdstat
echo ""
sudo mdadm --detail /dev/md0 | grep -E "State|Raid Level|Active|Working|Failed"

echo "=== RAID CONFIGURADO EXITOSAMENTE ==="
