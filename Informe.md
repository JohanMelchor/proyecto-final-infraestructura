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

![image1](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image51.png?raw=true) 
![image2](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image26.png?raw=true) 
![image3](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/e5dae7d027c9d2b5cb5a5295ad93b4669258e6ef/docs/evidencias/image37.png)

### **4.1.3 Verificación del Estado RAID**

Se verifica el estado de sincronización de los RAIDs recién creados.

Confirmar que los discos se están sincronizando correctamente y que el RAID está operativo.

![image4](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image42.png?raw=true)
![image5](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image48.png?raw=true)  
![image6](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image4.png?raw=true)
![image7](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image28.png?raw=true)
![image8](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image20.png?raw=true)

## **4.2 Configuración de LVM**

### **4.2.1 Volúmenes Físicos y Grupos** 
Se inicializan los dispositivos RAID como "Physical Volumes" de LVM, luego se agrupan los volúmenes físicos en "Volume Groups" para después proceder a crear volúmenes lógicos de 1.5GB dentro de cada grupo de volúmenes.

![image9](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image49.png?raw=true) 
![image10](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image44.png?raw=true)  
![image11](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image5.png?raw=true)

### **4.2.2 Formateo y Montaje**
Se formatea el volumen lógico con sistema de archivos ext4, después se crea directorio de montaje y luego se monta el volumen en el directorio.

![image12](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image34.png?raw=true)
![image13](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image45.png?raw=true)
![image14](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image54.png?raw=true)
![image15](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image9.png?raw=true) 
![image16](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image53.png?raw=true)

Se agregan las configuraciones de montaje al archivo fstab.

## **4.3 Creación de Imágenes Docker Personalizadas**

![image17](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image22.png?raw=true)
![image18](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image6.png?raw=true)

Se crea una imagen personalizada basada en Apache Alpine donde Copia archivos HTML personalizados, Declara un volumen para persistencia y expone el puerto 80\.

Se crea una imagen MySQL personalizada que aplica configuración personalizada, ejecuta scripts de inicialización de BD, configura variables de entorno y declara volumen para datos.

Similar a Apache, se crea una imagen Nginx personalizada.

### **4.3.1 Dockerfile \- Apache**

![image19](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image16.png?raw=true)

### **4.3.2 Dockerfile \- MySQL**

![image20](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image17.png?raw=true)

### **4.3.3 Dockerfile \- Nginx**

![image21](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image13.png?raw=true)

### **4.3.4 Archivos adicionales para Apache**

![image22](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image24.png?raw=true)

### **4.3.5 Archivos adicionales para mysql**
### *custom.cnf*

![image23](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image41.png?raw=true)

### *01-init.sql*

![image24](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image11.png?raw=true)

### **4.3.6 Archivos adicionales para Nginx** 

![image25](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image23.png?raw=true)

### **4.3.7 Estructura**  

![image26](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image12.png?raw=true)

## **4.4 Despliegue de Contenedores**

#### **4.4.1 Construcción de Imágenes** Se construyen las imágenes Docker a partir de los Dockerfiles.

![image27](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image21.png?raw=true)
![image28](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image33.png?raw=true)
![image29](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image47.png?raw=true)
![image30](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image35.png?raw=true)

#### **4.4.2 Ejecución de Contenedores**

![image31](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image52.png?raw=true)
![image32](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image39.png?raw=true)

# **5.0 PRUEBAS Y RESULTADOS**

## **5.1 Verificación de Servicios Web**

### **5.1.1 Apache**

![image33](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image3.png?raw=true)

### **5.1.2 Nginx**

![image34](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image31.png?raw=true)

## **5.2 Pruebas de MySQL**

![image35](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image8.png?raw=true)
![image36](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image38.png?raw=true)

## **5.3 Pruebas de Persistencia**

### **5.3.1 Modificación de Contenido**

![image37](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image43.png?raw=true)
![image38](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image19.png?raw=true)
![image39](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image50.png?raw=true)
![image40](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image27.png?raw=true)
![image41](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image1.png?raw=true)
![image42](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image30.png?raw=true)
![image43](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image56.png?raw=true)
![image44](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image7.png?raw=true)

**Resultado:** 
El cambio persiste después del reinicio del contenedor.

### **5.3.2 Persistencia en MySQL**

![image45](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image46.png?raw=true)
![image46](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image15.png?raw=true)
![image47](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image55.png?raw=true)
![image48](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image25.png?raw=true)
![image49](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image2.png?raw=true)

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

![image50](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image32.png?raw=true)

**Volúmenes y Permisos Explicados**

* /var/run/docker.sock: Permite a Netdata acceder a la API de Docker  
* /proc y /sys: Para métricas del sistema  
* SYS\_PTRACE: Para profiling de aplicaciones  
* Puertos: 19999 para el dashboard web

### **Despliegue** Se ejecuta Netdata en segundo plano.

![image51](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image14.png?raw=true)
![image52](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image18.png?raw=true)

### **Resultados de la Monitorización**

![image53](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image29.png?raw=true)
![image54](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image10.png?raw=true)

#### **Contenedores Monitoreados**

* Apache: Métricas de CPU, memoria, red  
* MySQL: Uso de recursos, I/O de base de datos  
* Nginx: Tráfico HTTP, conexiones activas  
* Netdata: Auto-monitoreo

![image55](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image36.png?raw=true)

**Métricas del Host System**

* Uso de CPU y memoria del servidor  
* I/O de discos (incluyendo los RAIDs)  
* Tráfico de red  
* Uso de los volúmenes LVM

![image56](https://github.com/JohanMelchor/proyecto-final-infraestructura/blob/main/docs/evidencias/image40.png?raw=true)

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
