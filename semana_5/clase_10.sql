-- =====================================================================
-- Semana 5 · Clase 10 · Tarea — Relaciones con foreign keys
-- Base de datos: relaciones_db
-- =====================================================================

-- =====================================================================
-- PASO 0 — Crear la base relaciones_db
-- =====================================================================

-- CREATE DATABASE relaciones_db;

-- =====================================================================
-- PASO 1 — Relación UNO A UNO (1:1): conductores y vehículos
-- =====================================================================
-- Cada conductor tiene UN solo vehículo y cada vehículo tiene UN solo
-- conductor. La clave: la FK vehiculos.conductor_id es UNIQUE, así un
-- mismo conductor no puede aparecer en dos vehículos.

CREATE TABLE conductores (
    id            SERIAL PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL,           -- NOT NULL: el nombre es obligatorio
    licencia      VARCHAR(20)  NOT NULL UNIQUE,    -- UNIQUE: no puede repetirse
    fecha_ingreso DATE
);

CREATE TABLE vehiculos (
    id           SERIAL PRIMARY KEY,
    patente      VARCHAR(10) NOT NULL UNIQUE,      -- UNIQUE: no puede repetirse
    modelo       VARCHAR(50),
    conductor_id INT UNIQUE REFERENCES conductores(id)   -- FK + UNIQUE = 1:1
);


-- =====================================================================
-- PASO 2 — Relación UNO A MUCHOS (1:N): profesores y clases
-- =====================================================================
-- Un profesor dicta MUCHAS clases, pero cada clase tiene UN solo profesor.
-- La FK va en el lado "muchos" (clases) y es NOT NULL: toda clase
-- necesita un profesor.

CREATE TABLE profesores (
    id                 SERIAL PRIMARY KEY,
    nombre             VARCHAR(100) NOT NULL,
    especialidad       VARCHAR(100),
    fecha_contratacion DATE
);

CREATE TABLE clases (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    horario     VARCHAR(50),
    profesor_id INT NOT NULL REFERENCES profesores(id)   -- FK NOT NULL = 1:N
);


-- =====================================================================
-- PASO 3 — Relación MUCHOS A MUCHOS (N:N): pacientes y enfermedades
-- =====================================================================
-- Un paciente puede tener VARIAS enfermedades y una enfermedad puede
-- afectar a MUCHOS pacientes. Se resuelve con una tabla intermedia
-- (pacientes_enfermedades) cuya clave primaria compuesta evita que el
-- mismo diagnóstico se cargue dos veces.

CREATE TABLE pacientes (
    id               SERIAL PRIMARY KEY,
    nombre           VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    telefono         VARCHAR(20)
);

CREATE TABLE enfermedades (
    id             SERIAL PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    descripcion    TEXT,
    nivel_gravedad VARCHAR(10)
        CHECK (nivel_gravedad IN ('leve', 'moderada', 'grave'))  -- solo estos 3 valores
);

CREATE TABLE pacientes_enfermedades (
    paciente_id       INT REFERENCES pacientes(id),
    enfermedad_id     INT REFERENCES enfermedades(id),
    fecha_diagnostico DATE,
    PRIMARY KEY (paciente_id, enfermedad_id)   -- clave compuesta: sin duplicados
);


-- =====================================================================
-- PASO 4 — Verificar que se crearon las 7 tablas
-- =====================================================================
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- =====================================================================
-- PASO 5 — Generar el DER (diagrama) en pgAdmin   CAPTURA PARA ENTREGAR
-- =====================================================================

-- =====================================================================
-- PASO 6 — Insertar datos 
-- =====================================================================

--  Conductores
INSERT INTO conductores (nombre, licencia, fecha_ingreso) VALUES
('Juan Pérez',   'LIC-001', '2022-03-15'),
('María Gómez',  'LIC-002', '2021-07-01'),
('Carlos López', 'LIC-003', '2023-01-10');

--  Vehículos (cada uno con un conductor distinto)
INSERT INTO vehiculos (patente, modelo, conductor_id) VALUES
('AB123CD', 'Fiat Cronos',    1),
('EF456GH', 'Toyota Etios',   2),
('IJ789KL', 'Renault Kangoo', 3);

--   Profesores
INSERT INTO profesores (nombre, especialidad, fecha_contratacion) VALUES
('Ana Martínez',  'Bases de datos', '2020-02-01'),
('Pedro Ramírez', 'Python',         '2019-08-15'),
('Lucía Torres',  'Cloud',          '2022-05-20');

--  Clases (un profesor puede tener varias)
INSERT INTO clases (nombre, horario, profesor_id) VALUES
('SQL Básico',      'Lunes 18:00',     1),
('SQL Avanzado',    'Miércoles 18:00', 1),
('Python Inicial',  'Martes 19:00',    2),
('Intro a AWS',     'Jueves 18:30',    3);

-- Pacientes
INSERT INTO pacientes (nombre, fecha_nacimiento, telefono) VALUES
('Laura Fernández', '1985-04-12', '11-5555-1111'),
('Diego Sosa',      '1990-09-30', '11-5555-2222'),
('Marta Ruiz',      '1972-12-05', '11-5555-3333');

-- Enfermedades
INSERT INTO enfermedades (nombre, descripcion, nivel_gravedad) VALUES
('Asma',       'Enfermedad crónica de las vías respiratorias', 'moderada'),
('Gripe',      'Infección viral estacional',                    'leve'),
('Diabetes 2', 'Alteración del metabolismo de la glucosa',      'grave');

--  Diagnósticos (tabla intermedia N:N)

INSERT INTO pacientes_enfermedades (paciente_id, enfermedad_id, fecha_diagnostico) VALUES
(1, 1, '2020-06-10'),
(1, 2, '2024-03-02'),
(2, 1, '2018-11-21'),
(3, 3, '2015-01-17');


-- =====================================================================
-- PASO 7 — Verificar los datos y las relaciones con JOIN
-- =====================================================================

-- 7.1  Conductor y su vehículo (1:1) 
SELECT c.nombre AS conductor, v.patente, v.modelo
FROM conductores c
JOIN vehiculos v ON v.conductor_id = c.id;

-- 7.2  Profesor y sus clases (1:N) 
SELECT p.nombre AS profesor, cl.nombre AS clase, cl.horario
FROM profesores p
JOIN clases cl ON cl.profesor_id = p.id
ORDER BY p.nombre;

-- 7.3  Paciente y sus enfermedades (N:N) 
SELECT pa.nombre AS paciente, e.nombre AS enfermedad, e.nivel_gravedad, pe.fecha_diagnostico
FROM pacientes pa
JOIN pacientes_enfermedades pe ON pe.paciente_id = pa.id
JOIN enfermedades e            ON e.id = pe.enfermedad_id
ORDER BY pa.nombre;


-- =====================================================================
-- PASO 8 — Probar que las constraints funcionan
-- =====================================================================

-- ---------------------------------------------------------------------
-- 8.1  PRUEBA: dos vehículos al mismo conductor (rompe el 1:1)
-- ---------------------------------------------------------------------

--INSERT INTO vehiculos (patente, modelo, conductor_id) VALUES ('MN012OP', 'Peugeot 208', 1);
--
-- ERROR:  duplicate key value violates unique constraint "vehiculos_conductor_id_key"
-- DETAIL:  Key (conductor_id)=(1) already exists.
--

-- ---------------------------------------------------------------------
-- 8.2  (Extra) Licencia repetida
-- ---------------------------------------------------------------------
-- INSERT INTO conductores (nombre, licencia) VALUES ('Otro Conductor', 'LIC-001');
--
-- ERROR:  duplicate key value violates unique constraint "conductores_licencia_key"
-- DETAIL:  Key (licencia)=(LIC-001) already exists.

-- ---------------------------------------------------------------------
-- 8.3  (Extra) Nivel de gravedad inválido
-- ---------------------------------------------------------------------
-- INSERT INTO enfermedades (nombre, nivel_gravedad) VALUES ('Resfrío', 'critica');
--
-- ERROR:  new row for relation "enfermedades" violates check constraint "enfermedades_nivel_gravedad_check"
-- DETAIL:  Failing row contains (4, Resfrío, null, critica).

-- ---------------------------------------------------------------------
-- 8.4  (Extra) Clase sin profesor
-- ---------------------------------------------------------------------
-- INSERT INTO clases (nombre, horario) VALUES ('Clase huérfana', 'Viernes 10:00');
--
-- ERROR:  null value in column "profesor_id" of relation "clases" violates not-null constraint
-- DETAIL:  Failing row contains (5, Clase huérfana, Viernes 10:00, null).

-- ---------------------------------------------------------------------
-- 8.5  (Extra) Diagnóstico duplicado en la tabla N:N
-- ---------------------------------------------------------------------
-- INSERT INTO pacientes_enfermedades (paciente_id, enfermedad_id, fecha_diagnostico) VALUES (1, 1, '2025-01-01');
--
-- ERROR:  duplicate key value violates unique constraint "pacientes_enfermedades_pkey"
-- DETAIL:  Key (paciente_id, enfermedad_id)=(1, 1) already exists.

-- ---------------------------------------------------------------------
-- 8.6  (Extra) Vehículo con un conductor que no existe
-- ---------------------------------------------------------------------
-- INSERT INTO vehiculos (patente, modelo, conductor_id) VALUES ('QR345ST', 'VW Gol', 99);
--
-- ERROR:  insert or update on table "vehiculos" violates foreign key constraint "vehiculos_conductor_id_fkey"
-- DETAIL:  Key (conductor_id)=(99) is not present in table "conductores".
