#!/bin/bash
echo "=== DESPLIEGUE DE CONTENEDORES ==="

# Construir imágenes
echo "Construyendo imágenes Docker..."
docker build -t apache_custom dockerfiles/apache/
docker build -t mysql_custom dockerfiles/mysql/
docker build -t nginx_custom dockerfiles/nginx/

# Verificar que las imágenes se crearon
echo "Imágenes creadas:"
docker images | grep custom

# Ejecutar contenedores
echo "Ejecutando contenedores..."

# MySQL
echo "Iniciando MySQL..."
docker run -d --name mysql \
  -v /mnt/mysql_data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -p 3306:3306 \
  mysql_custom

# Apache
echo "Iniciando Apache..."
docker run -d --name apache \
  -v /mnt/apache_data:/usr/local/apache2/htdocs \
  -p 80:80 \
  apache_custom

# Nginx
echo "Iniciando Nginx..."
docker run -d --name nginx \
  -v /mnt/nginx_data:/usr/share/nginx/html \
  -p 8080:80 \
  nginx_custom

# Netdata
echo "Desplegando Netdata..."
docker-compose -f docker-compose.netdata.yml up -d

# Esperar a que los servicios estén listos
echo "Esperando inicialización de servicios..."
sleep 15

# Verificar estado
echo "Estado final de contenedores:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Mostrar URLs de acceso
IP=$(hostname -I | awk '{print $1}')
echo ""
echo "URLs de acceso:"
echo "  Apache:    http://$IP"
echo "  Nginx:     http://$IP:8080"
echo "  Netdata:   http://$IP:19999"
echo "  MySQL:     mysql -h $IP -P 3306 -u root -p123456"

echo "=== DESPLIEGUE COMPLETADO ==="
