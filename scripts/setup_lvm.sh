#!/bin/bash
echo "=== CONFIGURACIÓN LVM ==="

# Para Apache
echo "Configurando LVM para Apache..."
sudo pvcreate /dev/md0
sudo vgcreate vg_apache /dev/md0
sudo lvcreate -L 1.5G -n lv_apache vg_apache
sudo mkfs.ext4 /dev/vg_apache/lv_apache
sudo mkdir -p /mnt/apache_data
sudo mount /dev/vg_apache/lv_apache /mnt/apache_data

# Para MySQL
echo "🔹 Configurando LVM para MySQL..."
sudo pvcreate /dev/md1
sudo vgcreate vg_mysql /dev/md1
sudo lvcreate -L 1.5G -n lv_mysql vg_mysql
sudo mkfs.ext4 /dev/vg_mysql/lv_mysql
sudo mkdir -p /mnt/mysql_data
sudo mount /dev/vg_mysql/lv_mysql /mnt/mysql_data

# Para Nginx
echo "Configurando LVM para Nginx..."
sudo pvcreate /dev/md2
sudo vgcreate vg_nginx /dev/md2
sudo lvcreate -L 1.5G -n lv_nginx vg_nginx
sudo mkfs.ext4 /dev/vg_nginx/lv_nginx
sudo mkdir -p /mnt/nginx_data
sudo mount /dev/vg_nginx/lv_nginx /mnt/nginx_data

# Configurar montaje automático
echo "Configurando montaje automático..."
echo "/dev/vg_apache/lv_apache  /mnt/apache_data  ext4  defaults  0  2" | sudo tee -a /etc/fstab
echo "/dev/vg_mysql/lv_mysql    /mnt/mysql_data   ext4  defaults  0  2" | sudo tee -a /etc/fstab
echo "/dev/vg_nginx/lv_nginx    /mnt/nginx_data   ext4  defaults  0  2" | sudo tee -a /etc/fstab

# Verificar
echo "Verificando configuración LVM:"
sudo lvs
echo ""
df -h | grep /mnt

echo "=== LVM CONFIGURADO EXITOSAMENTE ==="
