**BITÁCORA \- PROYECTO FINAL INFRAESTRUCTURA COMPUTACIONAL** 

Johan Esteban Melchor Morales \- Karen Vanessa restrepo Morales \- Leonardo Gallego Rios

Programa de Ingeniería de Sistemas y Computación, Facultad de Ingeniería, Universidad del Quindío – Colombia

**Resumen** Este proyecto implementó una solución de virtualización basada en contenedores Docker con almacenamiento confiable mediante RAID 1 y LVM. Se desplegaron tres servicios fundamentales (Apache, MySQL, Nginx) en contenedores independientes con persistencia de datos garantizada a través de volúmenes lógicos montados sobre arreglos RAID.

**Abstract** This project implemented a virtualization solution based on Docker containers with reliable storage using RAID 1 and LVM. Three fundamental services (Apache, MySQL, Nginx) were deployed in independent containers with guaranteed data persistence through logical volumes mounted on RAID arrays.

# **INTRODUCCIÓN** 

La organización requería consolidar su infraestructura tecnológica mediante la implementación de una solución de virtualización que garantizara alta disponibilidad y persistencia de datos. El proyecto combinó tecnologías de contenedores (Docker) con sistemas de almacenamiento robustos (RAID1 \+ LVM) para centralizar los servicios críticos de la organización.

# **OBJETIVOS** 

# **2.1 Objetivo General**

Implementar una solución de virtualización basada en contenedores con almacenamiento confiable mediante RAID y LVM.

# **2.2 Objetivos Específicos**

* Configurar 3 arreglos RAID 1 con 9 discos de 2GB  
* Implementar LVM sobre cada arreglo RAID  
* Crear imágenes Docker personalizadas para Apache, MySQL y Nginx  
* Desplegar contenedores con volúmenes persistentes  
* Verificar persistencia y funcionamiento de servicios

# **3.0 METODOLOGÍAS Y HERRAMIENTAS** 

## **3.1 Herramientas Utilizadas**

* **Sistema Operativo:** Ubuntu Server 22.04 LTS  
* **Virtualización:** Docker 24.x  
* **Almacenamiento:** mdadm (RAID), LVM2  
* **Servicios:** Apache HTTPD, MySQL 8.0, Nginx

## **3.2 Enfoque Metodológico**

Se siguió un enfoque incremental:

* Configuración de almacenamiento (RAID \+ LVM)  
* Creación de imágenes Docker personalizadas  
* Despliegue de contenedores con volúmenes  
* Pruebas de funcionamiento y persistencia

# **4.0 DESARROLLO DEL PROYECTO**  
## **4.1 Configuración de RAID 1**

### **4.1.2 Creación de Arreglos RAID**  
Se crean tres arreglos RAID 1 independientes, cada uno usando 3 discos. RAID 1 significa "mirroring" \- los datos se duplican en todos los discos del array.

Para proporcionar redundancia \- si un disco falla, los datos permanecen accesibles en los otros dos discos del mismo RAID.

Parámetros explicados:

* \--level=1: Configura RAID 1 (mirroring)  
* \--raid-devices=3: Especifica que cada RAID usará 3 discos  
* /dev/md0, /dev/md1, /dev/md2: Nombres de los dispositivos RAID creados

![][image1](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image51.png?raw=true) 
![][image2](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image26.png?raw=true) 
![][image3](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image37.png?raw=true)

### **4.1.3 Verificación del Estado RAID**

Se verifica el estado de sincronización de los RAIDs recién creados.

Confirmar que los discos se están sincronizando correctamente y que el RAID está operativo.

![][image4]  
![][image5]  
![][image6]  
![][image7]  
![][image8]

## **4.2 Configuración de LVM**

### **4.2.1 Volúmenes Físicos y Grupos** 
Se inicializan los dispositivos RAID como "Physical Volumes" de LVM, luego se agrupan los volúmenes físicos en "Volume Groups" para después proceder a crear volúmenes lógicos de 1.5GB dentro de cada grupo de volúmenes.

![][image9]  
![][image10]  
![][image11]

### **4.2.2 Formateo y Montaje**
Se formatea el volumen lógico con sistema de archivos ext4, después se crea directorio de montaje y luego se monta el volumen en el directorio.

![][image12] 
![][image13] 
![][image14] 
![][image15] 
![][image16]

Se agregan las configuraciones de montaje al archivo fstab.

## **4.3 Creación de Imágenes Docker Personalizadas**

![][image17] 
![][image18]

Se crea una imagen personalizada basada en Apache Alpine donde Copia archivos HTML personalizados, Declara un volumen para persistencia y expone el puerto 80\.

Se crea una imagen MySQL personalizada que aplica configuración personalizada, ejecuta scripts de inicialización de BD, configura variables de entorno y declara volumen para datos.

Similar a Apache, se crea una imagen Nginx personalizada.

### **4.3.1 Dockerfile \- Apache**

![][image19]

### **4.3.2 Dockerfile \- MySQL**

![][image20]

### **4.3.3 Dockerfile \- Nginx**

![][image21]

### **4.3.4 Archivos adicionales para Apache**

![][image22]

### **4.3.5 Archivos adicionales para mysql**

![][image23]  
![][image24]

### **4.3.6 Archivos adicionales para Nginx** 

![][image25]

### **4.3.7 Estructura**  

![][image26]

## **4.4 Despliegue de Contenedores**

#### **4.4.1 Construcción de Imágenes** Se construyen las imágenes Docker a partir de los Dockerfiles.

![][image27]
![][image28]  
![][image29]  
![][image30]

#### **4.4.2 Ejecución de Contenedores**

![][image31]
![][image32]

# **5.0 PRUEBAS Y RESULTADOS**

## **5.1 Verificación de Servicios Web**

### **5.1.1 Apache**

![][image33]

### **5.1.2 Nginx**

![][image34]

## **5.2 Pruebas de MySQL**

![][image35]
![][image36]

## **5.3 Pruebas de Persistencia**

### **5.3.1 Modificación de Contenido**

![][image37]
![][image38]  
![][image39]  
![][image40]  
![][image41]  
![][image42]  
![][image43]  
![][image44]

**Resultado:** 
El cambio persiste después del reinicio del contenedor.

### **5.3.2 Persistencia en MySQL**

![][image45]
![][image46]
![][image47]
![][image48]  
![][image49]

**Resultado:** 
Los datos se mantuvieron después del reinicio.

# **IMPLEMENTACIÓN DE MONITORIZACIÓN CON NETDATA**  
**Objetivo de la Monitorización**
Implementar un sistema de monitorización en tiempo real para supervisar el rendimiento de los contenedores Docker y el host system.

**Configuración de Netdata**  
Se configura Netdata como contenedor con acceso a:

* Docker socket (para monitorizar contenedores)  
* Sistema de archivos /proc y /sys (para métricas del host)  
* Archivo Docker Compose  
  ![][image50]

**Volúmenes y Permisos Explicados**

* /var/run/docker.sock: Permite a Netdata acceder a la API de Docker  
* /proc y /sys: Para métricas del sistema  
* SYS\_PTRACE: Para profiling de aplicaciones  
* Puertos: 19999 para el dashboard web

### **Despliegue** Se ejecuta Netdata en segundo plano.

![][image51]
![][image52]

### **Resultados de la Monitorización**

![][image53]
![][image54]

#### **Contenedores Monitoreados**

* Apache: Métricas de CPU, memoria, red  
* MySQL: Uso de recursos, I/O de base de datos  
* Nginx: Tráfico HTTP, conexiones activas  
* Netdata: Auto-monitoreo

![][image55]
![][image56]

**Métricas del Host System**

* Uso de CPU y memoria del servidor  
* I/O de discos (incluyendo los RAIDs)  
* Tráfico de red  
* Uso de los volúmenes LVM

**ANÁLISIS DE RESULTADOS**

* **Disponibilidad:** Los RAIDs nivel 1 garantizan redundancia ante fallos de discos.  
* **Persistencia:** Los volúmenes LVM mantienen los datos independientemente del ciclo de vida de los contenedores.  
* **Escalabilidad:** LVM permite redimensionar volúmenes según necesidades futuras.  
* **Aislamiento:** Cada servicio funciona en contenedores independientes con su propio almacenamiento.

# **CONCLUSIONES** 

* Se implementó exitosamente una infraestructura de virtualización con Docker, RAID 1 y LVM.
* Los tres servicios (Apache, MySQL, Nginx) funcionan correctamente con persistencia de datos garantizada.  
* La combinación RAID1 \+ LVM \+ Docker proporciona una solución robusta y escalable.  
* Los volúmenes Docker montados sobre LVM demostraron efectividad en la persistencia de datos.  
* El proyecto cumple con todos los requerimientos establecidos en la especificación inicial.

**REFERENCIAS**

* Documentación Oficial de Docker: [https://docs.docker.com/](https://docs.docker.com/)

* Guías de LVM en Ubuntu: [https://ubuntu.com/server/docs/device-management-lvm](https://ubuntu.com/server/docs/device-management-lvm)

* Documentación de mdadm: [https://wiki.archlinux.org/title/RAID](https://wiki.archlinux.org/title/RAID)

* Universidad del Quindío. (2025). Material del curso Infraestructura Computacional.
