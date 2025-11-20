# dockerfiles/nginx/Dockerfile
FROM nginx:alpine

# Copiar página web personalizada
COPY ./html/ /usr/share/nginx/html/

# Exponer puerto
EXPOSE 80

# Punto de montaje para volumen
VOLUME ["/usr/share/nginx/html"]
