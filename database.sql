-- Agenda comunitaria: esquema relacional y datos de demostración.
-- Reejecutable: crea la base si falta y repone las cinco tablas del proyecto.
CREATE DATABASE IF NOT EXISTS agenda_comunitaria
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE agenda_comunitaria;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS inscripcion;
DROP TABLE IF EXISTS evento;
DROP TABLE IF EXISTS persona;
DROP TABLE IF EXISTS categoria;
DROP TABLE IF EXISTS lugar;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE persona (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(60) NOT NULL,
  apellido VARCHAR(60) NOT NULL,
  cedula VARCHAR(20) NOT NULL,
  email VARCHAR(150) NOT NULL,
  celular VARCHAR(20) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT uq_persona_cedula UNIQUE (cedula),
  CONSTRAINT uq_persona_email UNIQUE (email)
) ENGINE=InnoDB;

CREATE TABLE categoria (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(80) NOT NULL,
  descripcion VARCHAR(500) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT uq_categoria_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE lugar (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(120) NOT NULL,
  ciudad VARCHAR(80) NOT NULL,
  direccion VARCHAR(180) NOT NULL,
  capacidad INT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT uq_lugar_nombre_direccion UNIQUE (nombre, direccion),
  CONSTRAINT chk_lugar_capacidad CHECK (capacidad > 0)
) ENGINE=InnoDB;

CREATE TABLE evento (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  categoria_id INT UNSIGNED NOT NULL,
  lugar_id INT UNSIGNED NOT NULL,
  titulo VARCHAR(160) NOT NULL,
  descripcion VARCHAR(1000) NOT NULL,
  fecha_inicio DATETIME NOT NULL,
  fecha_fin DATETIME NOT NULL,
  estado ENUM('programado','cancelado','finalizado') NOT NULL DEFAULT 'programado',
  PRIMARY KEY (id),
  KEY ix_evento_categoria (categoria_id),
  KEY ix_evento_lugar (lugar_id),
  KEY ix_evento_fecha (fecha_inicio),
  CONSTRAINT fk_evento_categoria FOREIGN KEY (categoria_id)
    REFERENCES categoria(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_evento_lugar FOREIGN KEY (lugar_id)
    REFERENCES lugar(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_evento_fechas CHECK (fecha_fin > fecha_inicio)
) ENGINE=InnoDB;

CREATE TABLE inscripcion (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  persona_id INT UNSIGNED NOT NULL,
  evento_id INT UNSIGNED NOT NULL,
  fecha_inscripcion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  estado ENUM('confirmada','cancelada','asistio') NOT NULL DEFAULT 'confirmada',
  PRIMARY KEY (id),
  CONSTRAINT uq_inscripcion_persona_evento UNIQUE (persona_id, evento_id),
  KEY ix_inscripcion_evento (evento_id),
  CONSTRAINT fk_inscripcion_persona FOREIGN KEY (persona_id)
    REFERENCES persona(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_inscripcion_evento FOREIGN KEY (evento_id)
    REFERENCES evento(id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO categoria (nombre, descripcion) VALUES
('Cultura','Actividades artísticas y patrimonio local.'),
('Educación','Talleres y espacios de aprendizaje.'),
('Deporte','Actividad física y bienestar.'),
('Ambiente','Cuidado del entorno y sostenibilidad.'),
('Música','Conciertos y formación musical.'),
('Lectura','Clubes, ferias y promoción de lectura.'),
('Emprendimiento','Formación y redes para iniciativas locales.'),
('Salud','Promoción de hábitos saludables.'),
('Tecnología','Alfabetización y creación digital.'),
('Comunidad','Encuentros y participación ciudadana.');

INSERT INTO lugar (nombre, ciudad, direccion, capacidad) VALUES
('Casa Cultural La Ceiba','Bogotá','Calle 10 # 5-20',120),
('Biblioteca El Parque','Bogotá','Carrera 7 # 18-30',80),
('Polideportivo Central','Bogotá','Calle 22 # 12-15',300),
('Aula Ambiental Río Vivo','Bogotá','Avenida Verde # 40-12',60),
('Teatro del Barrio','Bogotá','Carrera 15 # 9-44',180),
('Centro Comunitario Norte','Bogotá','Calle 90 # 20-10',100),
('Plaza de Mercado Local','Bogotá','Carrera 30 # 25-05',250),
('Salón Comunal La Esperanza','Bogotá','Calle 45 # 8-31',70),
('Laboratorio Digital Abierto','Bogotá','Carrera 11 # 60-19',45),
('Parque de los Vecinos','Bogotá','Avenida 1 # 70-01',500);

INSERT INTO persona (nombre, apellido, cedula, email, celular) VALUES
('Persona','Demo 01','DEMO-000001','persona01@example.test','0000000001'),
('Persona','Demo 02','DEMO-000002','persona02@example.test','0000000002'),
('Persona','Demo 03','DEMO-000003','persona03@example.test','0000000003'),
('Persona','Demo 04','DEMO-000004','persona04@example.test','0000000004'),
('Persona','Demo 05','DEMO-000005','persona05@example.test','0000000005'),
('Persona','Demo 06','DEMO-000006','persona06@example.test','0000000006'),
('Persona','Demo 07','DEMO-000007','persona07@example.test','0000000007'),
('Persona','Demo 08','DEMO-000008','persona08@example.test','0000000008'),
('Persona','Demo 09','DEMO-000009','persona09@example.test','0000000009'),
('Persona','Demo 10','DEMO-000010','persona10@example.test','0000000010');

INSERT INTO evento (categoria_id, lugar_id, titulo, descripcion, fecha_inicio, fecha_fin, estado) VALUES
(1,1,'Muestra de teatro comunitario','Presentaciones creadas por grupos del barrio.','2026-11-14 10:00:00','2026-11-14 13:00:00','programado'),
(2,2,'Taller de escritura creativa','Ejercicios de narración y lectura colectiva.','2026-11-15 09:00:00','2026-11-15 11:30:00','programado'),
(3,3,'Jornada deportiva familiar','Encuentros recreativos para todas las edades.','2026-11-16 08:00:00','2026-11-16 12:00:00','programado'),
(4,4,'Limpieza y reconocimiento del río','Recorrido guiado y acciones de cuidado ambiental.','2026-11-17 08:30:00','2026-11-17 11:00:00','programado'),
(5,5,'Concierto de talentos locales','Presentación de músicos emergentes de la comunidad.','2026-11-18 18:00:00','2026-11-18 20:00:00','programado'),
(6,2,'Club de lectura abierta','Conversación alrededor de cuentos latinoamericanos.','2026-11-19 16:00:00','2026-11-19 18:00:00','programado'),
(7,7,'Mercado de emprendimientos','Feria para conectar productores y vecinos.','2026-11-20 09:00:00','2026-11-20 15:00:00','programado'),
(8,8,'Encuentro de bienestar','Charla práctica sobre autocuidado y salud.','2026-11-21 10:00:00','2026-11-21 12:00:00','programado'),
(9,9,'Introducción a la programación','Taller inicial de pensamiento computacional.','2026-11-22 09:00:00','2026-11-22 12:00:00','programado'),
(10,10,'Asamblea cultural vecinal','Espacio abierto para proponer actividades.','2026-11-23 14:00:00','2026-11-23 16:00:00','programado');

INSERT INTO inscripcion (persona_id, evento_id, fecha_inscripcion, estado) VALUES
(1,1,'2026-11-01 09:00:00','confirmada'),(2,1,'2026-11-01 09:15:00','confirmada'),
(3,2,'2026-11-01 09:30:00','confirmada'),(4,2,'2026-11-01 09:45:00','confirmada'),
(5,3,'2026-11-01 10:00:00','confirmada'),(6,3,'2026-11-01 10:15:00','confirmada'),
(7,4,'2026-11-01 10:30:00','confirmada'),(8,5,'2026-11-01 10:45:00','confirmada'),
(9,6,'2026-11-01 11:00:00','confirmada'),(10,7,'2026-11-01 11:15:00','confirmada'),
(1,8,'2026-11-01 11:30:00','confirmada'),(2,9,'2026-11-01 11:45:00','confirmada'),
(3,10,'2026-11-01 12:00:00','confirmada'),(4,1,'2026-11-01 12:15:00','confirmada'),
(5,2,'2026-11-01 12:30:00','confirmada');

-- Consultas de validación solicitadas por el taller.
SELECT 'persona' AS tabla, COUNT(*) AS total FROM persona UNION ALL
SELECT 'categoria', COUNT(*) FROM categoria UNION ALL
SELECT 'lugar', COUNT(*) FROM lugar UNION ALL
SELECT 'evento', COUNT(*) FROM evento UNION ALL
SELECT 'inscripcion', COUNT(*) FROM inscripcion;

SELECT e.id, e.titulo, c.nombre AS categoria, l.nombre AS lugar, e.fecha_inicio
FROM evento e JOIN categoria c ON c.id=e.categoria_id JOIN lugar l ON l.id=e.lugar_id
ORDER BY e.id;

SELECT p.nombre, p.apellido, e.titulo, i.estado
FROM inscripcion i JOIN persona p ON p.id=i.persona_id JOIN evento e ON e.id=i.evento_id
ORDER BY i.id;
