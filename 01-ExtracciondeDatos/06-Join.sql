USE NORTHWND;

SELECT TOP 0 CategoryID, CategoryName
INTO Categoriesnew
FROM Categories;

ALTER TABLE categoriesnew
ADD CONSTRAINT pk_categories_new
PRIMARY KEY (Categoryid);

SELECT TOP 0 productid, ProductName, CategoryID
INTO productsnew
FROM Products;

ALTER TABLE productsnew
ADD CONSTRAINT pk_products_new
PRIMARY KEY (productid);

ALTER TABLE productsnew
ADD CONSTRAINT fk_products_categories2
FOREIGN KEY (categoryid)
REFERENCES categoriesnew (categoryid)
ON DELETE CASCADE;

INSERT INTO Categoriesnew
VALUES
('C1'),
('C2'),
('C3'),
('C4');

INSERT INTO productsnew
VALUES
('P1',1),
('P2',1),
('P3',2),
('P4',2),
('P5',4),
('P6',NULL);

SELECT *
FROM Categoriesnew;

SELECT *
FROM productsnew;

SELECT *
FROM Categoriesnew AS c
INNER JOIN 
productsnew AS p
ON p.CategoryID = c.CategoryID;

SELECT *
FROM Categoriesnew AS c
LEFT JOIN 
productsnew AS p
ON p.CategoryID = c.CategoryID

SELECT *
FROM Categoriesnew AS c
LEFT JOIN 
productsnew AS p
ON p.CategoryID = c.CategoryID
WHERE ProductID is NULL;

SELECT *
FROM Categoriesnew AS c
RIGHT JOIN 
productsnew AS p
ON p.CategoryID = c.CategoryId

SELECT *
FROM productsnew AS p
LEFT JOIN
Categoriesnew AS c
ON p.CategoryID = c.CategoryID;

SELECT *
FROM Categoriesnew AS c
RIGHT JOIN 
productsnew AS p
ON p.CategoryID = c.CategoryID
WHERE c.CategoryID is NULL;

SELECT
CategoryID AS [Número],
CategoryName AS [Nombre],
[Description] AS [Descripción]
FROM Categories;

SELECT TOP 0
CategoryID AS [Número],
CategoryName AS [Nombre],
[Description] AS [Descripción]
INTO Categories_nuevas
FROM Categories;

ALTER TABLE categories_nuevas
ADD CONSTRAINT pk_categorias_nuevas
PRIMARY KEY ([Número]);

SELECT  *
FROM Categories_nuevas;

INSERT INTO Categories
VALUES ('Ropa','Ropa de paca',NULL),
	   ('lINEA Blanca', 'Ropa de Robin',NULL);

SELECT *
FROM Categories AS c
INNER JOIN Categories_nuevas AS cn
ON c.CategoryID = cn.Número;

SELECT *
FROM Categories AS c
LEFT JOIN Categories_nuevas AS cn
ON c.CategoryID = cn.Número;

SELECT *
FROM Categories;

SELECT *
FROM Categories_nuevas;

INSERT INTO Categories_nuevas
SELECT c.CategoryName, c.Description
FROM Categories AS c
LEFT JOIN Categories_nuevas AS cn
ON c.CategoryID = cn.Número
WHERE cn.[Número] IS NULL;

SELECT *
FROM Categories_nuevas;

INSERT INTO Categories
VALUES ('Bebidas','Bebidas corrientes',NULL),
	   ('Deportes', 'Para los que pierden',NULL);

SELECT c.CategoryName, c.Description
FROM Categories AS c
LEFT JOIN Categories_nuevas AS cn
ON c.CategoryID = cn.Número
WHERE cn.[Número] IS NULL;

SELECT *
FROM Categories_nuevas;

INSERT INTO Categories_nuevas
SELECT UPPER (c.CategoryName) AS [Categories], 
	   UPPER (CAST(c.Description AS varchar)) AS [Descripcion]
FROM Categories AS c
LEFT JOIN Categories_nuevas AS cn
ON c.CategoryID = cn.Número
WHERE cn.[Número] IS NULL;

SELECT *
FROM Categories AS c
INNER JOIN Categories_nuevas AS cn
ON c.CategoryID = cn.Número;

DELETE Categories_nuevas;

--Reinicial los identity (no se puede cuando las tablas tienen integridad referencial,
--sino utilizar truncate)
DBCC CHECKIDENT ('categories_nuevas', RESSED, 0);

--El truncate elimina los datos de la tabla al igual que el delete 
--pero solamente funcioan sino tiene integridad referencial
--y además reinicia los identity
TRUNCATE TABLE categories_nuevas;


--FULL JOIN
SELECT *
FROM Categoriesnew AS c
FULL JOIN
productsnew AS p
ON c.CategoryID = p.CategoryID;


--Cross Join
SELECT * FROM 
Categoriesnew AS c
CROSS JOIN
productsnew AS p;



