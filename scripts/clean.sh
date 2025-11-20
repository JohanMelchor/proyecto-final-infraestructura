#!/bin/bash
echo "LIMPIEZA DEL SISTEMA"
echo "======================"

read -p "¿Estás seguro de limpiar todos los contenedores y configuraciones? (y/N): " confirm

if [[ $confirm == [yY] ]]; then
    echo "Deteniendo y eliminando contenedores..."
    docker stop $(docker ps -aq) 2>/dev/null
    docker rm $(docker ps -aq) 2>/dev/null
    echo "Eliminando imágenes personalizadas..."
    docker rmi apache_custom mysql_custom nginx_custom 2>/dev/null
    echo "Desmontando volúmenes..."
    sudo umount /mnt/apache_data /mnt/mysql_data /mnt/nginx_data 2>/dev/null
    echo "Eliminando configuraciones LVM..."
    sudo lvremove -y /dev/vg_apache/lv_apache /dev/vg_mysql/lv_mysql /dev/vg_nginx/lv_nginx 2>/dev/null
    sudo vgremove vg_apache vg_mysql vg_nginx 2>/dev/null
    sudo pvremove /dev/md0 /dev/md1 /dev/md2 2>/dev/null
    echo "Deteniendo RAIDs..."
    sudo mdadm --stop /dev/md0 /dev/md1 /dev/md2 2>/dev/null
    echo "Limpieza completada"
else
    echo "Limpieza cancelada"
fi
