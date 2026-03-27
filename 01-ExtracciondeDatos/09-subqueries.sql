CREATE DATABASE bdsubqueries;

USE bdsubqueries;

CREATE TABLE clientes (
	id_cliente INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	nombre VARCHAR (50) NOT NULL,
	ciuddad VARCHAR (50) NOT NULL
);

CREATE TABLE pedidos (
	id_pedido INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	id_cliente INT NOT NULL,
	total money NOT NULL,
	fecha DATE NOT NULL
	CONSTRAINT fk_pedidos_clientes
	FOREIGN KEY (id_cliente)
	REFERENCES clientes (id_cliente)
	ON DELETE CASCADE
);

INSERT INTO clientes (nombre, ciuddad) VALUES
('Ana', 'CDMX'),
('Luis', 'Guadalajara'),
('Marta', 'CDMX'),
('Pedro', 'Monterrey'),
('Sofia', 'Puebla'),
('Carlos', 'CDMX'), 
('Artemio', 'Pachuca'), 
('Roberto', 'Veracruz');

INSERT INTO pedidos (id_cliente, total, fecha) VALUES
(1, 1000.00, '2024-01-10'),
(1, 500.00,  '2024-02-10'),
(2, 300.00,  '2024-01-05'),
(3, 1500.00, '2024-03-01'),
(3, 700.00,  '2024-03-15'),
(1, 1200.00, '2024-04-01'),
(2, 800.00,  '2024-02-20'),
(3, 400.00,  '2024-04-10');

SELECT * FROM clientes;
SELECT * FROM pedidos;

-- Subconsulta
SELECT
	MAX(total)
FROM pedidos

-- Consulta principal
SELECT * 
FROM pedidos
WHERE total = (
	SELECT MAX(total) FROM pedidos
);

SELECT TOP 1 * FROM
pedidos
ORDER BY total DESC

-- Seleccionar el cliente que hizo el pedido m�s caro 

--	Subconsulta
SELECT id_cliente
FROM pedidos
WHERE total = (SELECT MAX(total) FROM pedidos);

-- Consulta principal
SELECT TOP 1 * 
FROM pedidos
WHERE id_cliente =  (
	SELECT id_cliente
	FROM pedidos
	WHERE total = (SELECT MAX(total) FROM pedidos)
);

SELECT TOP 1 p.id_pedido, c.nombre, p.total, p.fecha
FROM pedidos AS p
INNER JOIN
clientes AS c
ON p.id_cliente = c.id_cliente
WHERE p.id_cliente =  (
	SELECT id_cliente
	FROM pedidos
	WHERE total = (SELECT MAX(total) FROM pedidos)
);

SELECT TOP 1 p.id_pedido, c.nombre, p.total, p.fecha, MAX (p.total) AS [Maximo]
FROM pedidos AS p
INNER JOIN
clientes AS c
ON p.id_cliente = c.id_cliente
GROUP BY p.id_pedido, c.nombre, p.total, p.fecha
ORDER BY total DESC

SELECT TOP 1 p.id_pedido, c.nombre, p.total, p.fecha
FROM pedidos AS p
INNER JOIN
clientes AS c
ON p.id_cliente = c.id_cliente
ORDER BY total DESC

-- Seleccionar los pedidos mayores al promedio

--Subconsulta
SELECT AVG (total)
FROM pedidos;

-- Consulta principal
SELECT  * 
FROM pedidos
WHERE total > (
SELECT AVG (total)
FROM pedidos
);

-- Mostrar el cliente con menor id

--Subconsulta
SELECT MIN (id_cliente)
FROM pedidos

-- Consulta principal
SELECT * 
FROM pedidos
WHERE id_cliente = (
	SELECT MIN (id_cliente)
	FROM pedidos
);

SELECT p.fecha, p.id_pedido, c.nombre, p.total 
FROM pedidos AS p
INNER JOIN 
clientes AS c
ON p.id_cliente = c. id_cliente
WHERE p.id_cliente = (
	SELECT MIN (id_cliente)
	FROM pedidos
);

-- Mostrar el �ltimo pedido realizado

-- Subconsulta
SELECT MAX (fecha)
FROM pedidos

-- Consulta principal
SELECT p.id_pedido, p.fecha, c.nombre, p.total
FROM pedidos AS p
INNER JOIN
clientes AS c
ON p.id_cliente = c.id_cliente
WHERE fecha = (
	SELECT MAX (fecha)
	FROM pedidos
);

-- Mostrar el pedido con el total m�s bajo

-- Subconsulta
SELECT MIN(total)
FROM pedidos

-- Consulta principal
SELECT *
FROM pedidos
WHERE total = (
	SELECT MIN(total)
	FROM pedidos
);

-- Seleccionar los pedidos con el nombre del cliente cuyo total (Freight) sea
-- mayor al promedio general de Freight

-- Subconsulta
SELECT AVG (Freight)
FROM orders;


--	Consulta principal
SELECT 
	o.orderid,
	c.companyName,
	o.Freight
FROM orders AS o
INNER JOIN 
customers AS c 
ON o.customerid = c.customerid
WHERE o.Freight > (
	SELECT AVG (Freight)
	FROM orders
)
ORDER BY Freight DESC;

-- Clientes que haN hecho pedidos

SELECT id_cliente
FROM pedidos;

SELECT * 
FROM clientes
WHERE id_cliente IN (
	SELECT id_cliente
	FROM pedidos
);

SELECT DISTINCT c.id_cliente, c.nombre, c.ciuddad
FROM clientes AS c
INNER JOIN pedidos AS p
ON c.id_cliente = p.id_cliente

-- Seleccionar clientes de CDMX que han hecho pedidos

-- Subconsulta
SELECT id_cliente
FROM clientes;

SELECT *
FROM clientes
WHERE ciuddad = 'CDMX'
AND id_cliente IN (
	SELECT id_cliente
	FROM clientes
);

--Seleccionar los pedidos de los clientes que viven en la CDMX

--Subconsulta
SELECT id_cliente
FROM clientes
WHERE ciuddad = 'CDMX';

--Consulta principal
SELECT p.id_cliente, c.ciuddad, p.fecha, c.nombre, p.total
FROM pedidos AS p
INNER JOIN clientes AS c
ON p.id_cliente = c.id_cliente
WHERE p.id_cliente IN (
	SELECT id_cliente
	FROM clientes
	WHERE ciuddad = 'CDMX'
);

--Seleccionar todos aquellos clientes que no han hecho pedidos

--Subconsulta
SELECT id_cliente
FROM pedidos;

SELECT *
FROM clientes
WHERE id_cliente NOT IN (
	SELECT id_cliente
	FROM pedidos
);

SELECT *
FROM clientes
WHERE id_cliente IN (
	SELECT id_cliente
	FROM pedidos
);

SELECT DISTINCT p.id_cliente, c.nombre, c.ciuddad
FROM clientes AS c
INNER JOIN pedidos AS p
ON c.id_cliente = p.id_cliente;

SELECT DISTINCT c.id_cliente, c.nombre, c.ciuddad
FROM clientes AS c
LEFT JOIN pedidos AS p
ON c.id_cliente = p.id_cliente
WHERE p.id_cliente IS NULL;

--Instruccion ANY

--Seleccionar todos los pedidos con un total mayor de algun pedido de Luis
SELECT total
FROM pedidos
WHERE id_cliente = 2;

SELECT total
FROM pedidos;

SELECT *
FROM clientes;

SELECT *
FROM pedidos 
WHERE total > ANY (
	SELECT total
	FROM pedidos
	WHERE id_cliente = 2
);

SELECT *
FROM pedidos 
WHERE total < ANY (
	SELECT total
	FROM pedidos
	WHERE id_cliente = 2
);

--Seleccionar todos los pedidos en donde el total sea mayor a algun pedido de Ana

SELECT total
FROM pedidos 
WHERE id_cliente = 1;

SELECT *
FROM pedidos 
WHERE total > ANY (
	SELECT total
	FROM pedidos
	WHERE id_cliente = 1
);
