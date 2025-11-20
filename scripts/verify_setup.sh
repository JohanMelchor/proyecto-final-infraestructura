#!/bin/bash
echo "VERIFICACIÓN COMPLETA DEL SISTEMA"
echo "===================================="

echo "1.Verificando RAIDs:"
cat /proc/mdstat
echo ""

echo "2.Verificando LVM:"
sudo lvs
echo ""

echo "3.Verificando montajes:"
df -h | grep /mnt
echo ""

echo "4.Verificando contenedores:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

echo "5. Verificando servicios web:"
echo "   Apache: $(curl -s -o /dev/null -w "%{http_code}" http://localhost)"
echo "   Nginx:  $(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)"
echo ""

echo "6.Verificando MySQL:"
docker exec -i mysql mysql -p123456 -e "SHOW DATABASES;" 2>/dev/null | grep -q "mysql" && echo "   MySQL: Funcionando" || echo "MySQL: Error"
echo ""

echo "7.Verificando Netdata:"
curl -s -o /dev/null -w "%{http_code}" http://localhost:19999 | grep -q "200" && echo "   Netdata: Funcionando" || echo "   Netdata: Error"

echo ""
echo "VERIFICACIÓN COMPLETADA"
