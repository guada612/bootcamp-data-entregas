-- =====================================================================
-- Semana 6 · Clase 11 · Tarea — Diseñar una base de datos transaccional
-- Caso elegido: VETERINARIA
-- Resolución / guía paso a paso
-- Base de datos: veterinaria_db
-- =====================================================================
--
-- ┌───────────────────────────────────────────────────────────────────┐
-- │ QUÉ TENÉS QUE ENTREGAR (y qué va FUERA del SQL)                    │
-- ├───────────────────────────────────────────────────────────────────┤
-- │ 1. 📸 CAPTURA DEL DER de pgAdmin  ← es lo único fuera del SQL      │
-- │      Se saca en el PASO 5. Tienen que verse las 6 tablas y las     │
-- │      relaciones 1:1, 1:N y N:N.                                    │
-- │ 2. 📄 ESTE ARCHIVO .sql con los CREATE TABLE y los INSERT.         │
-- │                                                                    │
-- │ No piden captura de los errores del Paso 8 ni de los SELECT.       │
-- │ El Paso 8 es opcional (sirve para estudiar).                       │
-- │                                                                    │
-- │ Entrega: para la Clase 12.                                         │
-- └───────────────────────────────────────────────────────────────────┘
--
-- Qué pide el profe en los pasos:
--   * CREATE TABLE con PKs, FKs y un comentario "--" en cada relación.
--   * Usar AL MENOS UNA VEZ cada constraint: NOT NULL, UNIQUE, CHECK, DEFAULT.
--   * Generar el DER y verificar las relaciones 1:1, 1:N y N:N.
--   * Insertar AL MENOS 3 filas por tabla.
--
-- Dónde está cada constraint en este archivo:
--   NOT NULL  → duenos.nombre, mascotas.nombre, mascotas.dueno_id, etc.
--   UNIQUE    → duenos.email, historias_clinicas.mascota_id, tratamientos.nombre
--   CHECK     → mascotas.especie, citas.estado, tratamientos.precio, cantidad
--   DEFAULT   → duenos.fecha_registro, historias_clinicas.fecha_apertura,
--               citas.estado, cita_tratamiento.cantidad
--
-- CÓMO USAR ESTE ARCHIVO EN pgAdmin
--   * Ejecutá UN paso a la vez: seleccioná el bloque con el mouse y
--     apretá F5 (o ▶️). Si no seleccionás nada, pgAdmin ejecuta TODO.
--   * Los CREATE / INSERT se ven en "Messages"; los SELECT en "Data Output".
--   * Las líneas que empiezan con "--" son comentarios: no se ejecutan.
-- =====================================================================


-- =====================================================================
-- PASO 0 — Crear la base veterinaria_db
-- =====================================================================
-- 0.1  Abrí el Query Tool en la base "postgres" de "Bootcamp (Docker 5433)"
--      y ejecutá SOLO esta línea:

-- CREATE DATABASE veterinaria_db;

-- 0.2  Panel izquierdo: clic derecho en "Databases" → Refresh.
-- 0.3  Clic derecho en "veterinaria_db" → Query Tool.
--      El título de la pestaña tiene que decir: veterinaria_db/myuser@Bootcamp...
-- 0.4  Seguí con el Paso 1 en ESA pestaña.


-- =====================================================================
-- PASO 1 — Dueños, mascotas e historias clínicas
-- =====================================================================

CREATE TABLE duenos (
    id             SERIAL PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,              -- NOT NULL: obligatorio
    telefono       VARCHAR(20),
    email          VARCHAR(100) UNIQUE,                -- UNIQUE: no se repite
    fecha_registro DATE DEFAULT CURRENT_DATE           -- DEFAULT: si no se indica, hoy
);

-- Relación 1:N  duenos → mascotas
-- Un dueño puede tener VARIAS mascotas; cada mascota tiene UN solo dueño.
-- La FK va del lado "muchos" (mascotas) y es NOT NULL.
CREATE TABLE mascotas (
    id               SERIAL PRIMARY KEY,
    nombre           VARCHAR(100) NOT NULL,
    especie          VARCHAR(20)  NOT NULL
        CHECK (especie IN ('perro', 'gato', 'ave', 'conejo', 'otro')),   -- CHECK
    raza             VARCHAR(50),
    fecha_nacimiento DATE,
    dueno_id         INT NOT NULL REFERENCES duenos(id)
);

-- Relación 1:1  mascotas ↔ historias_clinicas
-- Cada mascota tiene UNA sola historia clínica y cada historia es de UNA
-- sola mascota. La clave: mascota_id es UNIQUE (FK + UNIQUE = 1:1).
CREATE TABLE historias_clinicas (
    id             SERIAL PRIMARY KEY,
    mascota_id     INT NOT NULL UNIQUE REFERENCES mascotas(id),
    fecha_apertura DATE DEFAULT CURRENT_DATE,
    alergias       TEXT,
    observaciones  TEXT
);


-- =====================================================================
-- PASO 2 — Citas
-- =====================================================================

-- Relación 1:N  mascotas → citas
-- Cada cita es de UNA mascota; una mascota puede tener MUCHAS citas.
CREATE TABLE citas (
    id         SERIAL PRIMARY KEY,
    mascota_id INT NOT NULL REFERENCES mascotas(id),
    fecha_hora TIMESTAMP NOT NULL,
    motivo     VARCHAR(200),
    estado     VARCHAR(15) NOT NULL DEFAULT 'programada'               -- DEFAULT
        CHECK (estado IN ('programada', 'realizada', 'cancelada'))      -- CHECK
);


-- =====================================================================
-- PASO 3 — Tratamientos y tabla intermedia (N:N)
-- =====================================================================

CREATE TABLE tratamientos (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    precio      NUMERIC(10,2) NOT NULL CHECK (precio >= 0)    -- no puede ser negativo
);

-- Relación N:N  citas ↔ tratamientos
-- Una cita puede incluir VARIOS tratamientos y un tratamiento puede estar
-- en MUCHAS citas. Se resuelve con esta tabla intermedia; la clave primaria
-- compuesta (cita_id, tratamiento_id) evita repetir el mismo par.
CREATE TABLE cita_tratamiento (
    cita_id        INT REFERENCES citas(id),
    tratamiento_id INT REFERENCES tratamientos(id),
    cantidad       INT NOT NULL DEFAULT 1 CHECK (cantidad > 0),
    PRIMARY KEY (cita_id, tratamiento_id)
);


-- =====================================================================
-- PASO 4 — Verificar que se crearon las 6 tablas
-- =====================================================================
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
-- Tienen que aparecer: cita_tratamiento, citas, duenos, historias_clinicas,
-- mascotas, tratamientos.


-- =====================================================================
-- PASO 5 — 📸 Generar el DER en pgAdmin   ← CAPTURA PARA ENTREGAR
-- =====================================================================
-- Esto es con el mouse, no con SQL:
--   1. Panel izquierdo: clic derecho sobre "veterinaria_db".
--   2. Elegí "ERD For Database".
--   3. Verificá que se vean las 6 tablas y las relaciones:
--        1:1  mascotas ↔ historias_clinicas
--        1:N  duenos → mascotas
--        1:N  mascotas → citas
--        N:N  citas ↔ tratamientos (a través de cita_tratamiento)
--   4. Si alguna línea tapa una tabla, arrastrá las tablas para ordenarlas.
--   5. Sacá la captura de pantalla (o usá el ícono de imagen 🖼️ de la
--      barra del DER) y guardala.


-- =====================================================================
-- PASO 6 — Insertar datos (al menos 3 filas por tabla)
-- =====================================================================
-- El orden importa: primero las tablas "padre" y después las que las
-- referencian (duenos → mascotas → historias/citas → tratamientos → intermedia).

-- 6.1  Dueños (fecha_registro no se indica: toma el DEFAULT = hoy)
INSERT INTO duenos (nombre, telefono, email) VALUES
('Ana Rodríguez', '11-4444-1111', 'ana@mail.com'),
('Bruno Díaz',    '11-4444-2222', 'bruno@mail.com'),
('Carla Méndez',  '11-4444-3333', 'carla@mail.com'),
('Diego Paz',     '11-4444-4444', 'diego@mail.com');

-- 6.2  Mascotas (Ana tiene 2: Luna y Michi)
INSERT INTO mascotas (nombre, especie, raza, fecha_nacimiento, dueno_id) VALUES
('Luna',   'perro', 'Labrador',      '2020-05-10', 1),
('Michi',  'gato',  'Siamés',        '2021-08-22', 1),
('Rocky',  'perro', 'Bulldog',       '2019-02-14', 2),
('Piolín', 'ave',   'Canario',       '2022-11-03', 3),
('Nina',   'gato',  'Común europeo', '2018-07-30', 4);

-- 6.3  Historias clínicas (una por mascota; fecha_apertura toma el DEFAULT)
INSERT INTO historias_clinicas (mascota_id, alergias, observaciones) VALUES
(1, 'Ninguna conocida',     'Control anual al día'),
(2, 'Alérgica al pollo',    'Dieta especial'),
(3, NULL,                   'Problemas articulares'),
(4, NULL,                   'Revisión de plumaje'),
(5, 'Alérgica a la penicilina', 'Peso por debajo del ideal');

-- 6.4  Citas
--      Estas 3 no indican "estado": toman el DEFAULT 'programada'.
INSERT INTO citas (mascota_id, fecha_hora, motivo) VALUES
(1, '2025-03-10 10:00', 'Control anual'),
(2, '2025-03-15 09:00', 'Desparasitación'),
(5, '2025-04-05 17:30', 'Control de peso');

--      Estas 3 indican el estado a mano.
INSERT INTO citas (mascota_id, fecha_hora, motivo, estado) VALUES
(1, '2025-04-02 11:30', 'Vacuna antirrábica',   'realizada'),
(3, '2025-03-20 16:00', 'Cojera pata trasera',  'realizada'),
(4, '2025-03-22 12:00', 'Revisión de plumaje',  'cancelada');

-- 6.5  Tratamientos
INSERT INTO tratamientos (nombre, descripcion, precio) VALUES
('Consulta general',   'Revisión clínica completa', 8000.00),
('Vacuna antirrábica', 'Dosis anual',               5000.00),
('Desparasitación',    'Antiparasitario oral',      3500.00),
('Radiografía',        'Placa de rayos X',         12000.00);

-- 6.6  Tratamientos aplicados en cada cita (tabla intermedia N:N)
--      DEFAULT en "cantidad" = 1. La cita 4 tiene 2 tratamientos.
INSERT INTO cita_tratamiento (cita_id, tratamiento_id, cantidad) VALUES
(1, 1, DEFAULT),
(2, 3, 2),
(3, 1, DEFAULT),
(4, 1, DEFAULT),
(4, 2, DEFAULT),
(5, 1, DEFAULT),
(5, 4, 1);


-- =====================================================================
-- PASO 7 — Verificar los datos y las relaciones con JOIN
-- =====================================================================

-- 7.1  Dueño → mascota → historia clínica (1:N y 1:1) — tienen que salir 5 filas
SELECT d.nombre AS dueno, m.nombre AS mascota, m.especie, h.alergias
FROM duenos d
JOIN mascotas m            ON m.dueno_id = d.id
JOIN historias_clinicas h  ON h.mascota_id = m.id
ORDER BY d.nombre, m.nombre;

-- 7.2  Citas con su mascota (1:N) y el estado — mirá las que tomaron el DEFAULT
SELECT c.id, m.nombre AS mascota, c.fecha_hora, c.motivo, c.estado
FROM citas c
JOIN mascotas m ON m.id = c.mascota_id
ORDER BY c.fecha_hora;

-- 7.3  Tratamientos de cada cita (N:N) con el total — tienen que salir 7 filas
SELECT c.id AS cita, m.nombre AS mascota, t.nombre AS tratamiento,
       ct.cantidad, t.precio * ct.cantidad AS subtotal
FROM cita_tratamiento ct
JOIN citas c         ON c.id = ct.cita_id
JOIN mascotas m      ON m.id = c.mascota_id
JOIN tratamientos t  ON t.id = ct.tratamiento_id
ORDER BY c.id, t.nombre;


-- =====================================================================
-- PASO 8 — (OPCIONAL) Probar que las constraints funcionan
-- =====================================================================
-- No lo pide la tarea. Sirve para ver cómo responde Postgres.
-- Cada INSERT está comentado porque FALLA a propósito.
-- Para probarlo: borrale el "-- " al INSERT, seleccionalo y apretá F5.
-- Volvé a comentarlo después, o ejecutar el archivo entero se va a cortar.

-- 8.1  Dos historias clínicas para la misma mascota (rompe el 1:1)
-- INSERT INTO historias_clinicas (mascota_id) VALUES (1);
--
-- ERROR:  duplicate key value violates unique constraint "historias_clinicas_mascota_id_key"
-- DETAIL:  Key (mascota_id)=(1) already exists.

-- 8.2  Especie que no está permitida (CHECK)
-- INSERT INTO mascotas (nombre, especie, dueno_id) VALUES ('Smaug', 'dragon', 1);
--
-- ERROR:  new row for relation "mascotas" violates check constraint "mascotas_especie_check"
-- DETAIL:  Failing row contains (6, Smaug, dragon, null, null, 1).

-- 8.3  Cita sin mascota (NOT NULL)
-- INSERT INTO citas (fecha_hora, motivo) VALUES ('2025-06-01 10:00', 'Control');
--
-- ERROR:  null value in column "mascota_id" of relation "citas" violates not-null constraint
-- DETAIL:  Failing row contains (7, null, 2025-06-01 10:00:00, Control, programada).

-- 8.4  Email de dueño repetido (UNIQUE)
-- INSERT INTO duenos (nombre, email) VALUES ('Otra Persona', 'ana@mail.com');
--
-- ERROR:  duplicate key value violates unique constraint "duenos_email_key"
-- DETAIL:  Key (email)=(ana@mail.com) already exists.

-- 8.5  Tratamiento con precio negativo (CHECK)
-- INSERT INTO tratamientos (nombre, precio) VALUES ('Prueba', -5);
--
-- ERROR:  new row for relation "tratamientos" violates check constraint "tratamientos_precio_check"
-- DETAIL:  Failing row contains (5, Prueba, null, -5.00).

-- 8.6  El mismo tratamiento dos veces en la misma cita (clave compuesta N:N)
-- INSERT INTO cita_tratamiento (cita_id, tratamiento_id) VALUES (1, 1);
--
-- ERROR:  duplicate key value violates unique constraint "cita_tratamiento_pkey"
-- DETAIL:  Key (cita_id, tratamiento_id)=(1, 1) already exists.
