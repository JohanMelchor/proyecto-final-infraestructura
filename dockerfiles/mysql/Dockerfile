# dockerfiles/mysql/Dockerfile
FROM mysql:8.0

# Copiar configuración personalizada
COPY ./config/custom.cnf /etc/mysql/conf.d/

# Copiar script de inicialización
COPY ./init/01-init.sql /docker-entrypoint-initdb.d/

# Variables de entorno por defecto
ENV MYSQL_ROOT_PASSWORD=123456
ENV MYSQL_DATABASE=proyecto_final

# Volumen para persistencia
VOLUME ["/var/lib/mysql"]

EXPOSE 3306

# Volumen para datos persistentes
VOLUME ["/var/lib/mysql"]

CMD ["mysqld"]
