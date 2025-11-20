# dockerfiles/apache/Dockerfile
FROM httpd:alpine

# Copiar página web personalizada
COPY ./html/ /usr/local/apache2/htdocs/

# Exponer puerto
EXPOSE 80

# Punto de montaje para volumen
VOLUME ["/usr/local/apache2/htdocs"]
