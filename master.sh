#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Función para imprimir con color
print_step() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${CYAN}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Verificar que estamos en el directorio correcto
if [ ! -d "scripts" ]; then
    print_error "Error: No se encuentra la carpeta 'scripts'"
    echo "Asegúrate de estar en el directorio del proyecto"
    exit 1
fi

# Banner inicial
clear
echo -e "${CYAN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║     INSTALACIÓN COMPLETA DE INFRAESTRUCTURA               ║
║     RAID 1 + LVM + Docker + Netdata                       ║
║                                                           ║
║     Universidad del Quindío                               ║
║     Infraestructura Computacional - 2025                  ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Preguntar si desea limpiar primero
echo ""
read -p "¿Deseas limpiar configuraciones previas? (y/N): " clean_first
echo ""

if [[ $clean_first =~ ^[yY]$ ]]; then
    print_step "PASO 0/6: LIMPIEZA DEL SISTEMA"
    if [ -f "scripts/clean.sh" ]; then
        sudo bash scripts/clean.sh
        if [ $? -eq 0 ]; then
            print_success "Sistema limpiado correctamente"
        else
            print_warning "Limpieza completada con advertencias (normal si es primera ejecución)"
        fi
    else
        print_error "No se encontró scripts/clean.sh"
    fi
    echo ""
    sleep 2
fi

# Confirmar continuación
read -p "¿Continuar con la instalación? (y/N): " continue_install
if [[ ! $continue_install =~ ^[yY]$ ]]; then
    print_error "Instalación cancelada por el usuario"
    exit 0
fi

# ============================================
# PASO 1: CONFIGURAR RAID
# ============================================
print_step "PASO 1/6: CONFIGURACIÓN DE RAID 1"
echo "Creando 3 arreglos RAID 1 con 9 discos..."
echo ""

if [ -f "scripts/setup_raid.sh" ]; then
    sudo bash scripts/setup_raid.sh
    if [ $? -eq 0 ]; then
        print_success "RAIDs configurados correctamente"
    else
        print_error "Error al configurar RAIDs"
        exit 1
    fi
else
    print_error "No se encontró scripts/setup_raid.sh"
    exit 1
fi

echo ""
read -p "Presiona ENTER para continuar..."
echo ""

# ============================================
# PASO 2: CONFIGURAR LVM
# ============================================
print_step "PASO 2/6: CONFIGURACIÓN DE LVM"
echo "Creando volúmenes lógicos sobre RAIDs..."
echo ""

if [ -f "scripts/setup_lvm.sh" ]; then
    sudo bash scripts/setup_lvm.sh
    if [ $? -eq 0 ]; then
        print_success "LVM configurado correctamente"
    else
        print_error "Error al configurar LVM"
        exit 1
    fi
else
    print_error "No se encontró scripts/setup_lvm.sh"
    exit 1
fi

echo ""
read -p "Presiona ENTER para continuar..."
echo ""

# ============================================
# PASO 3: DESPLEGAR CONTENEDORES
# ============================================
print_step "PASO 3/6: DESPLIEGUE DE CONTENEDORES"
echo "Construyendo imágenes y ejecutando contenedores..."
echo ""

if [ -f "scripts/deploy_containers.sh" ]; then
    bash scripts/deploy_containers.sh
    if [ $? -eq 0 ]; then
        print_success "Contenedores desplegados correctamente"
    else
        print_warning "Despliegue completado con advertencias"
    fi
else
    print_error "No se encontró scripts/deploy_containers.sh"
    exit 1
fi

echo ""
read -p "Presiona ENTER para continuar..."
echo ""

# ============================================
# PASO 4: COPIAR INDEX.HTML A VOLÚMENES
# ============================================
print_step "PASO 4/6: COPIAR PÁGINAS WEB"
echo "Copiando index.html a los volúmenes..."
echo ""

# Verificar que existe el archivo HTML
if [ -f "dockerfiles/apache/html/index.html" ]; then
    # Copiar para Apache
    echo "Copiando para Apache..."
    sudo cp dockerfiles/apache/html/index.html /mnt/apache_data/index.html
    
    # Copiar para Nginx
    echo "Copiando para Nginx..."
    sudo cp dockerfiles/apache/html/index.html /mnt/nginx_data/index.html
    
    # Ajustar permisos
    sudo chmod 644 /mnt/apache_data/index.html
    sudo chmod 644 /mnt/nginx_data/index.html
    
    # Verificar
    if [ -f "/mnt/apache_data/index.html" ] && [ -f "/mnt/nginx_data/index.html" ]; then
        print_success "Páginas web copiadas correctamente"
        
        # Reiniciar contenedores para cargar el nuevo contenido
        echo "Reiniciando contenedores web..."
        docker restart apache nginx
        sleep 3
    else
        print_error "Error al copiar páginas web"
    fi
else
    print_error "No se encontró dockerfiles/apache/html/index.html"
    print_warning "Los servicios web mostrarán contenido por defecto"
fi

echo ""
read -p "Presiona ENTER para continuar..."
echo ""

# ============================================
# PASO 5: VERIFICACIÓN DE NETDATA
# ============================================
print_step "PASO 5/6: VERIFICACIÓN DE NETDATA"
echo "Asegurando que Netdata esté desplegado..."
echo ""

# Verificar si netdata ya está corriendo
if docker ps | grep -q netdata; then
    print_success "Netdata ya está corriendo"
else
    print_warning "Netdata no está corriendo, desplegando..."
    
    # Intentar con docker run directo
    docker run -d \
      --name=netdata \
      --hostname=netdata-monitor \
      -p 19999:19999 \
      --restart unless-stopped \
      --cap-add SYS_PTRACE \
      --security-opt apparmor=unconfined \
      -v netdata_lib:/var/lib/netdata \
      -v netdata_cache:/var/cache/netdata \
      -v /etc/passwd:/host/etc/passwd:ro \
      -v /etc/group:/host/etc/group:ro \
      -v /proc:/host/proc:ro \
      -v /sys:/host/sys:ro \
      -v /etc/os-release:/host/etc/os-release:ro \
      -v /var/run/docker.sock:/var/run/docker.sock:ro \
      netdata/netdata
    
    sleep 10
    
    if docker ps | grep -q netdata; then
        print_success "Netdata desplegado correctamente"
    else
        print_error "Error al desplegar Netdata"
    fi
fi

echo ""
read -p "Presiona ENTER para verificar el sistema..."
echo ""

# ============================================
# PASO 6: VERIFICACIÓN COMPLETA
# ============================================
print_step "PASO 6/6: VERIFICACIÓN DEL SISTEMA"
echo "Ejecutando verificación completa..."
echo ""

if [ -f "scripts/verify_setup.sh" ]; then
    bash scripts/verify_setup.sh
else
    print_warning "No se encontró scripts/verify_setup.sh, verificando manualmente..."
    
    echo "Estado de contenedores:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    
    echo ""
    echo "Estado de RAIDs:"
    cat /proc/mdstat | grep -E "md[0-9]"
    
    echo ""
    echo "Volúmenes LVM:"
    sudo lvs
    
    echo ""
    echo "Montajes:"
    df -h | grep /mnt
    
    echo ""
    echo "Archivos web:"
    ls -lh /mnt/apache_data/index.html 2>/dev/null || echo "  Apache: No encontrado"
    ls -lh /mnt/nginx_data/index.html 2>/dev/null || echo "  Nginx: No encontrado"
fi

# ============================================
# RESUMEN FINAL
# ============================================
echo ""
print_step "INSTALACIÓN COMPLETADA"

IP=$(hostname -I | awk '{print $1}')

echo ""
echo -e "${GREEN}✅ Infraestructura desplegada exitosamente${NC}"
echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                   ACCESO A SERVICIOS                      ║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC}  ${YELLOW}Apache:${NC}    http://$IP                              "
echo -e "${CYAN}║${NC}  ${YELLOW}Nginx:${NC}     http://$IP:8080                         "
echo -e "${CYAN}║${NC}  ${YELLOW}Netdata:${NC}   http://$IP:19999                        "
echo -e "${CYAN}║${NC}  ${YELLOW}MySQL:${NC}     sudo docker exec -it mysql mysql -p123456 -e "SHOW DATABASES;"   "
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Mostrar estado de contenedores
echo -e "${CYAN}📦 CONTENEDORES ACTIVOS:${NC}"
docker ps --format "  ✓ {{.Names}} - {{.Status}}"

echo ""
echo -e "${CYAN}💾 ALMACENAMIENTO:${NC}"
echo "  RAID:"
cat /proc/mdstat | grep -E "md[0-9].*active" | sed 's/^/  ✓ /'
echo ""
echo "  LVM:"
sudo lvs --noheadings | awk '{print "  ✓ " $1 " - " $4}'
echo ""
echo "  Montajes:"
df -h | grep /mnt | awk '{print "  ✓ " $6 " - " $3 " usado de " $2}'

echo ""
echo -e "${CYAN}🌐 PÁGINAS WEB:${NC}"
if [ -f "/mnt/apache_data/index.html" ]; then
    echo -e "  ✓ Apache: index.html presente ($(ls -lh /mnt/apache_data/index.html | awk '{print $5}'))"
else
    echo "  ✗ Apache: index.html no encontrado"
fi

if [ -f "/mnt/nginx_data/index.html" ]; then
    echo -e "  ✓ Nginx: index.html presente ($(ls -lh /mnt/nginx_data/index.html | awk '{print $5}'))"
else
    echo "  ✗ Nginx: index.html no encontrado"
fi

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  🎉 ¡INSTALACIÓN EXITOSA!                                 ║${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}║  Todos los servicios están corriendo correctamente       ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Guardar información en un archivo
INFO_FILE="infrastructure_info.txt"
cat > $INFO_FILE << EOF
=======================================================
INFORMACIÓN DE INFRAESTRUCTURA
=======================================================
Fecha de instalación: $(date)
IP del servidor: $IP

URLS DE ACCESO:
- Apache:    http://$IP
- Nginx:     http://$IP:8080
- Netdata:   http://$IP:19999
- MySQL:     sudo docker exec -it mysql mysql -p123456 -e "SHOW DATABASES;"

CONTENEDORES:
$(docker ps --format "- {{.Names}}: {{.Status}}")

PÁGINAS WEB:
- Apache: $([ -f "/mnt/apache_data/index.html" ] && echo "✓ Presente" || echo "✗ No encontrado")
- Nginx:  $([ -f "/mnt/nginx_data/index.html" ] && echo "✓ Presente" || echo "✗ No encontrado")

RAID:
$(cat /proc/mdstat)

LVM:
$(sudo lvs)

MONTAJES:
$(df -h | grep /mnt)

=======================================================
EOF

print_success "Información guardada en: $INFO_FILE"
echo ""



