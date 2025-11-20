CREATE DATABASE IF NOT EXISTS proyecto_web;
USE proyecto_web;

CREATE TABLE IF NOT EXISTS visitas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pagina VARCHAR(100) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO visitas (pagina) VALUES ('Página de inicio Apache');
INSERT INTO visitas (pagina) VALUES ('Página de inicio Nginx');
