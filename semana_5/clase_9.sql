-- =====================================================================
-- Semana 5 · Clase 9 · Tarea — Crear tablas y consultar ventas
-- Resolución / guía paso a paso
-- =====================================================================
--
-- CÓMO USAR ESTE ARCHIVO EN pgAdmin
--   * Ejecutá UN paso a la vez: seleccioná el bloque con el mouse y
--     apretá F5 (o ▶️). Si no seleccionás nada, pgAdmin ejecuta TODO.
--   * El resultado aparece abajo, en "Data Output" (consultas SELECT)
--     o en "Messages" (CREATE / INSERT).
-- =====================================================================


-- =====================================================================
-- PASO 0 — Crear la base de datos test_db
-- =====================================================================
-- 0.1  Abrí el Query Tool en la base "postgres" del servidor
--      "Bootcamp (Docker 5433)" y ejecutá SOLO esta línea:

-- CREATE DATABASE test_db;

-- 0.2  En el panel izquierdo: clic derecho en "Databases" → Refresh.
-- 0.3  Clic derecho en "test_db" → Query Tool.
--      El título de la pestaña tiene que decir: test_db/myuser@Bootcamp...
-- 0.4  Abrí este archivo en ESA pestaña y seguí con el Paso 1.
--      (Si ejecutás el resto en la base "postgres", las tablas quedan ahí.)


-- =====================================================================
-- PARTE 1 — Departamentos en venta / alquiler
-- =====================================================================

-- ---------------------------------------------------------------------
-- PASO 1 — Crear la tabla apartments
-- ---------------------------------------------------------------------
CREATE TABLE apartments (
    id             SERIAL PRIMARY KEY,   -- identificador único (se completa solo)
    name           VARCHAR(50),          -- nombre o código del departamento
    address        VARCHAR(100),         -- calle y número
    city           VARCHAR(50),          -- ciudad
    postal_code    VARCHAR(10),          -- código postal
    bedrooms       INT,                  -- cantidad de habitaciones
    area_m2        NUMERIC(6,2),         -- superficie en m²
    price          NUMERIC(10,2),        -- precio
    available      BOOLEAN,              -- disponible para alquiler o venta
    published_date DATE                  -- fecha de publicación
);


-- ---------------------------------------------------------------------
-- PASO 2 — Insertar 30 departamentos (datos inventados)
-- ---------------------------------------------------------------------
-- No se pasa el "id": como es SERIAL, Postgres lo numera solo (1, 2, 3...).
INSERT INTO apartments (name, address, city, postal_code, bedrooms, area_m2, price, available, published_date) VALUES
('Depto A01', 'Av. Corrientes 1234',      'Buenos Aires', 'C1043', 2,  55.50, 120000.00, TRUE,  '2023-08-01'),
('Depto A02', 'Av. Santa Fe 2850',        'Buenos Aires', 'C1425', 3,  85.00, 210000.00, TRUE,  '2023-08-03'),
('Depto A03', 'Thames 1560',              'Buenos Aires', 'C1414', 1,  38.00,  89000.00, FALSE, '2023-08-05'),
('Depto A04', 'Av. Cabildo 2100',         'Buenos Aires', 'C1428', 2,  48.00, 105000.00, TRUE,  '2023-08-07'),
('Depto A05', 'Billinghurst 890',         'Buenos Aires', 'C1174', 4, 120.00, 340000.00, TRUE,  '2023-08-10'),
('Depto A06', 'Av. Rivadavia 6500',       'Buenos Aires', 'C1406', 1,  32.50,  75000.00, TRUE,  '2023-08-12'),
('Depto B01', 'Bv. San Juan 450',         'Córdoba',      'X5000', 2,  60.00,  85000.00, TRUE,  '2023-08-02'),
('Depto B02', 'Av. Colón 1200',           'Córdoba',      'X5000', 3,  78.00, 110000.00, FALSE, '2023-08-06'),
('Depto B03', 'Obispo Trejo 320',         'Córdoba',      'X5000', 1,  35.00,  52000.00, TRUE,  '2023-08-09'),
('Depto B04', 'Av. Rafael Núñez 4500',    'Córdoba',      'X5009', 2,  52.00,  78000.00, TRUE,  '2023-08-14'),
('Depto B05', 'Belgrano 780',             'Córdoba',      'X5000', 3,  95.00, 135000.00, TRUE,  '2023-08-18'),
('Depto C01', 'Bv. Oroño 1100',           'Rosario',      'S2000', 2,  58.00,  82000.00, TRUE,  '2023-08-04'),
('Depto C02', 'Av. Pellegrini 900',       'Rosario',      'S2000', 3,  88.00, 125000.00, TRUE,  '2023-08-11'),
('Depto C03', 'Córdoba 1500',             'Rosario',      'S2000', 1,  40.00,  58000.00, FALSE, '2023-08-15'),
('Depto C04', 'San Martín 2300',          'Rosario',      'S2000', 2,  45.00,  69000.00, TRUE,  '2023-08-20'),
('Depto C05', 'Av. Francia 600',          'Rosario',      'S2000', 4, 110.00, 160000.00, FALSE, '2023-08-22'),
('Depto D01', 'Av. San Martín 1800',      'Mendoza',      'M5500', 2,  62.00,  90000.00, TRUE,  '2023-08-08'),
('Depto D02', 'Sarmiento 450',            'Mendoza',      'M5500', 1,  36.00,  55000.00, TRUE,  '2023-08-13'),
('Depto D03', 'Av. Emilio Civit 300',     'Mendoza',      'M5500', 3,  90.00, 140000.00, TRUE,  '2023-08-19'),
('Depto D04', 'Belgrano 1250',            'Mendoza',      'M5500', 2,  50.00,  76000.00, FALSE, '2023-08-25'),
('Depto E01', 'Calle 7 N° 850',           'La Plata',     'B1900', 2,  57.00,  80000.00, TRUE,  '2023-08-16'),
('Depto E02', 'Calle 50 N° 620',          'La Plata',     'B1900', 1,  34.00,  50000.00, TRUE,  '2023-08-21'),
('Depto E03', 'Diag. 74 N° 1400',         'La Plata',     'B1900', 3,  82.00, 115000.00, TRUE,  '2023-08-24'),
('Depto E04', 'Calle 12 N° 1100',         'La Plata',     'B1900', 2,  65.00,  92000.00, FALSE, '2023-08-28'),
('Depto F01', 'Av. Colón 2500',           'Mar del Plata','B7600', 2,  54.00,  88000.00, TRUE,  '2023-08-17'),
('Depto F02', 'Güemes 3100',              'Mar del Plata','B7600', 3,  76.00, 130000.00, TRUE,  '2023-08-23'),
('Depto F03', 'Bv. Marítimo 2800',        'Mar del Plata','B7600', 1,  42.00,  98000.00, TRUE,  '2023-08-27'),
('Depto F04', 'San Luis 1700',            'Mar del Plata','B7600', 2,  49.00,  72000.00, FALSE, '2023-08-30'),
('Depto G01', 'Av. Corrientes 950',       'Corrientes',   'W3400', 2,  59.00,  65000.00, TRUE,  '2023-08-26'),
('Depto G02', 'Junín 1400',               'Corrientes',   'W3400', 3,  80.00,  95000.00, TRUE,  '2023-08-29');


-- ---------------------------------------------------------------------
-- PASO 3 — Verificar que se cargaron (tiene que dar 30)
-- ---------------------------------------------------------------------
SELECT COUNT(*) FROM apartments;


-- ---------------------------------------------------------------------
-- PARTE 1 · Ejercicio 1
-- Departamentos disponibles, del más barato al más caro.
-- ---------------------------------------------------------------------
-- WHERE filtra las filas; ORDER BY ... ASC ordena de menor a mayor.
SELECT *
FROM apartments
WHERE available = TRUE
ORDER BY price ASC;


-- ---------------------------------------------------------------------
-- PARTE 1 · Ejercicio 2
-- Precio promedio por ciudad.
-- ---------------------------------------------------------------------
-- GROUP BY junta las filas de cada ciudad; AVG calcula el promedio.
-- ROUND(..., 2) deja 2 decimales para que se lea mejor.
SELECT city,
       ROUND(AVG(price), 2) AS precio_promedio
FROM apartments
GROUP BY city
ORDER BY precio_promedio DESC;


-- ---------------------------------------------------------------------
-- PARTE 1 · Ejercicio 3
-- Departamentos con 2 o más habitaciones y menos de 60 m².
-- ---------------------------------------------------------------------
-- AND exige que se cumplan las dos condiciones a la vez.
SELECT *
FROM apartments
WHERE bedrooms >= 2
  AND area_m2 < 60;


-- =====================================================================
-- PARTE 2 — Ventas
-- =====================================================================

-- ---------------------------------------------------------------------
-- PASO 4 — Crear la tabla sales
-- ---------------------------------------------------------------------
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    product VARCHAR(50),
    category VARCHAR(30),
    price NUMERIC,
    quantity INT,
    sale_date DATE
);


-- ---------------------------------------------------------------------
-- PASO 5 — Insertar las 31 ventas (datos que da el profe)
-- ---------------------------------------------------------------------
INSERT INTO sales (product, category, price, quantity, sale_date) VALUES
('Mouse', 'Electronics', 15, 4, '2023-07-10'),
('Keyboard', 'Electronics', 30, 2, '2023-07-11'),
('Notebook', 'Stationery', 8, 10, '2023-07-12'),
('Pen', 'Stationery', 2, 25, '2023-07-13'),
('Headphones', 'Electronics', 40, 3, '2023-07-14'),
('Monitor', 'Electronics', 120, 1, '2023-07-15'),
('Desk Chair', 'Furniture', 85, 2, '2023-07-16'),
('Notebook Case', 'Accessories', 25, 3, '2023-07-17'),
('Printer Paper', 'Stationery', 6, 15, '2023-07-18'),
('USB Drive', 'Electronics', 12, 5, '2023-07-19'),
('Desk Lamp', 'Furniture', 35, 4, '2023-07-20'),
('Stapler', 'Stationery', 7, 6, '2023-07-21'),
('Calculator', 'Electronics', 20, 3, '2023-07-22'),
('Water Bottle', 'Accessories', 10, 8, '2023-07-23'),
('Laptop Stand', 'Accessories', 45, 2, '2023-07-24'),
('Office Desk', 'Furniture', 150, 1, '2023-07-25'),
('Whiteboard', 'Furniture', 60, 1, '2023-07-26'),
('Marker Set', 'Stationery', 5, 12, '2023-07-27'),
('Mouse Pad', 'Accessories', 8, 7, '2023-07-28'),
('Webcam', 'Electronics', 50, 2, '2023-07-29'),
('Smartphone', 'Electronics', 300, 1, '2023-07-30'),
('Notebook Pro', 'Electronics', 900, 1, '2023-07-31'),
('File Cabinet', 'Furniture', 120, 1, '2023-08-01'),
('Backpack', 'Accessories', 40, 3, '2023-08-02'),
('Binder', 'Stationery', 4, 20, '2023-08-03'),
('Headset Stand', 'Accessories', 15, 5, '2023-08-04'),
('Desk Organizer', 'Accessories', 12, 6, '2023-08-05'),
('Laptop Sleeve', 'Accessories', 30, 2, '2023-08-06'),
('Paper Clips', 'Stationery', 1, 50, '2023-08-07'),
('Surge Protector', 'Electronics', 25, 3, '2023-08-08'),
('Pen Holder', 'Accessories', 5, 10, '2023-08-09');


-- ---------------------------------------------------------------------
-- PASO 6 — Verificar que se cargaron (tiene que dar 31)
-- ---------------------------------------------------------------------
SELECT COUNT(*) FROM sales;


-- ---------------------------------------------------------------------
-- PARTE 2 · Ejercicio 1
-- Todas las ventas de la categoría 'Electronics'.
-- ---------------------------------------------------------------------
-- Los textos van entre comillas simples y respetan mayúsculas.
SELECT *
FROM sales
WHERE category = 'Electronics';


-- ---------------------------------------------------------------------
-- PARTE 2 · Ejercicio 2
-- Total de ingresos por categoría (price * quantity).
-- ---------------------------------------------------------------------
-- Primero se calcula price * quantity en cada fila y SUM lo suma por grupo.
SELECT category,
       SUM(price * quantity) AS ingreso_total
FROM sales
GROUP BY category
ORDER BY ingreso_total DESC;


-- ---------------------------------------------------------------------
-- PARTE 2 · Ejercicio 3
-- Categoría con mayor ingreso total.
-- ---------------------------------------------------------------------
-- Igual que el ejercicio 2, pero ordenado de mayor a menor y LIMIT 1
-- para quedarnos solo con la primera fila.
SELECT category,
       SUM(price * quantity) AS ingreso_total
FROM sales
GROUP BY category
ORDER BY ingreso_total DESC
LIMIT 1;


-- ---------------------------------------------------------------------
-- PARTE 2 · Ejercicio 4
-- Ventas donde el precio del producto sea mayor a 20.
-- ---------------------------------------------------------------------
SELECT *
FROM sales
WHERE price > 20;


-- ---------------------------------------------------------------------
-- PARTE 2 · Ejercicio 5
-- Total de unidades vendidas (SUM(quantity)) por producto.
-- ---------------------------------------------------------------------
SELECT product,
       SUM(quantity) AS unidades_vendidas
FROM sales
GROUP BY product
ORDER BY unidades_vendidas DESC;


-- ---------------------------------------------------------------------
-- PARTE 2 · Ejercicio 6
-- Ingreso promedio por venta (AVG(price * quantity)) por producto.
-- ---------------------------------------------------------------------
SELECT product,
       ROUND(AVG(price * quantity), 2) AS ingreso_promedio
FROM sales
GROUP BY product
ORDER BY ingreso_promedio DESC;


-- ---------------------------------------------------------------------
-- PARTE 2 · Ejercicio 7
-- Los 3 productos con mayor cantidad total vendida (ORDER BY + LIMIT).
-- ---------------------------------------------------------------------
SELECT product,
       SUM(quantity) AS unidades_vendidas
FROM sales
GROUP BY product
ORDER BY unidades_vendidas DESC
LIMIT 3;


-- ---------------------------------------------------------------------
-- PARTE 2 · Ejercicio 8
-- Ventas realizadas después del 12 de julio de 2023.
-- ---------------------------------------------------------------------
-- Las fechas se escriben 'AAAA-MM-DD'. ">" deja afuera el día 12.
SELECT *
FROM sales
WHERE sale_date > '2023-07-12'
ORDER BY sale_date;


-- ---------------------------------------------------------------------
-- PARTE 2 · Ejercicio 9
-- Categoría e ingreso total, solo si el ingreso es mayor a 50 (HAVING).
-- ---------------------------------------------------------------------
-- WHERE filtra filas ANTES de agrupar; HAVING filtra grupos DESPUÉS.
-- Por eso, para filtrar por un SUM se usa HAVING.
SELECT category,
       SUM(price * quantity) AS ingreso_total
FROM sales
GROUP BY category
HAVING SUM(price * quantity) > 50
ORDER BY ingreso_total DESC;


-- ---------------------------------------------------------------------
-- PARTE 2 · Ejercicio 10
-- Ventas donde el producto comience con la letra H (LIKE 'H%').
-- ---------------------------------------------------------------------
-- El % significa "cualquier cosa después". LIKE distingue mayúsculas.
SELECT *
FROM sales
WHERE product LIKE 'H%';


-- ---------------------------------------------------------------------
-- PARTE 2 · Ejercicio 11
-- Cantidad promedio vendida (AVG(quantity)) por categoría.
-- ---------------------------------------------------------------------
SELECT category,
       ROUND(AVG(quantity), 2) AS cantidad_promedio
FROM sales
GROUP BY category
ORDER BY cantidad_promedio DESC;


-- ---------------------------------------------------------------------
-- PARTE 2 · Ejercicio 12
-- Todas las ventas con el ingreso por fila, de mayor a menor ingreso.
-- ---------------------------------------------------------------------
-- No hay GROUP BY: se calcula price * quantity en cada fila.
SELECT id,
       product,
       category,
       price,
       quantity,
       sale_date,
       price * quantity AS ingreso
FROM sales
ORDER BY ingreso DESC;


-- ---------------------------------------------------------------------
-- PARTE 2 · Ejercicio 13
-- Ventas de 'Electronics' con cantidad mayor a 2 y precio menor a 40.
-- ---------------------------------------------------------------------
SELECT *
FROM sales
WHERE category = 'Electronics'
  AND quantity > 2
  AND price < 40;
