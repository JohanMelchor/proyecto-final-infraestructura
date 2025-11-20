#!/bin/bash
echo "=== DESPLIEGUE DE NETDATA ==="

# Verificar que Docker esté funcionando
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker no está corriendo"
    exit 1
fi

# Desplegar Netdata
echo "Desplegando Netdata..."
docker-compose -f docker-compose.netdata.yml up -d

# Esperar inicialización
echo "Esperando inicialización..."
sleep 10

# Verificar estado
if docker ps | grep -q netdata; then
    echo "Netdata desplegado correctamente"
    # Mostrar información de acceso
    IP=$(hostname -I | awk '{print $1}')
    echo ""
    echo "Dashboard disponible en:"
    echo "  http://$IP:19999"
    echo ""
    echo "🔍 Verificando contenedores detectados..."
    sleep 5
    curl -s http://localhost:19999/api/v1/containers | jq -r '.containers[] | "\(.container_name) - \(.status)"' 2>/dev/null || echo "Ejecuta 'curl http://localhost:19999/api/v1/containers' para ver contenedores"
else
    echo "Error desplegando Netdata"
    docker logs netdata
    exit 1
fi

echo "=== NETDATA CONFIGURADO ==="
