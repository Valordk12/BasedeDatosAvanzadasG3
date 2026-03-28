--Consultas Simples
use Northwnd;

--Seleccionar cada una de la tablas de la bd northwind

SELECT *
FROM Customers;
GO

SELECT *
FROM Employees;
GO

SELECT *
FROM Orders;
GO

SELECT *
FROM [Order Details];
GO

SELECT * 
FROM Shippers;
GO

SELECT * 
FROM Suppliers;
GO

SELECT * 
FROM Products;
GO

-- Proyección de la tabla

SELECT ProductName, UnitsInStock, UnitPrice
FROM Products;

-- Alias de Columna

SELECT ProductName AS NombreProducto, 
UnitPrice 'Unidades Medida', 
UnitPrice AS [Precio Unitario]
FROM Products;

-- Campo calculado y Alias de tabla

SELECT 
		[Order Details].OrderID AS [NUMERO DE ORDEN], 
		Products.ProductID AS [NUMERO DE PRODUCTO],
		ProductName AS 'NOMBRE DE PRODUCTO', 
		Quantity CANTIDAD,
		Products.UnitPrice AS PRECIO, 
		(Quantity * [Order Details].UnitPrice) AS SUBTOTAL
FROM [Order Details]
INNER JOIN 
Products
ON Products.ProductID = [Order Details].ProductID;


SELECT 
		od.OrderID AS [NUMERO DE ORDEN], 
		pr.ProductID AS [NUMERO DE PRODUCTO],
		ProductName AS 'NOMBRE DE PRODUCTO', 
		Quantity CANTIDAD,
		od.UnitPrice AS PRECIO, 
		(Quantity * od.UnitPrice) AS SUBTOTAL
FROM [Order Details] AS od
INNER JOIN 
Products pr
ON pr.ProductID = od.ProductID;

--Operadores Relacionales (<, >, <=, >=, =, != o <>)
--Mostrar todos los productos con un precio mayor a 20
SELECT 
	ProductName AS [Nombre Producto], 
	QuantityPerUnit AS [Descripción],
	UnitPrice AS [Precio]
FROM Products
WHERE UnitPrice > 20;

--Seleccionar todos los clientes que no sean de Mexico
SELECT *
FROM Customers
WHERE Country <> 'Mexico';

--Seleccionar todas aquellas ordenes realizadas en  1997
SELECT 
	OrderID AS [Número de Orden], 
	OrderDate AS [Fecha de Orden],
	YEAR (OrderDate) AS [Año con Year],
	DATEPART (YEAR, OrderDate) AS [Año con DATEPART]
FROM Orders
WHERE YEAR(OrderDate) = 1997;

--Operadores Lógicos (AND OR NOT)
SELECT * FROM Products

SELECT 
	OrderID AS [Número de Orden], 
	OrderDate AS [Fecha de Orden],
	YEAR (OrderDate) AS [Año con Year],
	DATEPART (YEAR, OrderDate) AS [Año con DATEPART],
	DATEPART (QUARTER, OrderDate) AS Trimestre,
	DATEPART (WEEKDAY, OrderDate) AS [Dia Semana],
	DATENAME (WEEKDAY, OrderDate) AS [Nombre Dia Semana]
FROM Orders
WHERE YEAR(OrderDate) = 1997;

SET LANGUAGE Spanish
SELECT 
	OrderID AS [Número de Orden], 
	OrderDate AS [Fecha de Orden],
	YEAR (OrderDate) AS [Año con Year],
	DATEPART (YEAR, OrderDate) AS [Año con DATEPART],
	DATEPART (QUARTER, OrderDate) AS Trimestre,
	DATEPART (WEEKDAY, OrderDate) AS [Dia Semana],
	DATENAME (WEEKDAY, OrderDate) AS [Nombre Dia Semana]
FROM Orders
WHERE YEAR(OrderDate) = 1997; 

--Seleccionar los productos que tengan un precio mayor a 20
-- y un stock mayor a 30
SELECT 
	ProductID AS [Número Productos],
	ProductName AS [Nombre del Producto],
	UnitsInStock AS [Existena],
	UnitPrice AS [Precio],
	(UnitPrice * UnitsInStock) AS [Costo Inventario]
FROM Products
WHERE UnitPrice > 20
AND UnitsInStock > 30;


--Seleccionar a los clientes de Estados Unidos o Canada
SELECT 
	CustomerID,
	CompanyName,
	City,
	Country
FROM Customers
WHERE Country = 'USA' 
OR Country= 'Canada';

--Seleccionar los clientes de Brazil, Rio de janeiro y que tengan región
SELECT 
	CustomerID,
	CompanyName,
	ContactName,
	City AS [Ciudad],
	Region AS [Region],
	Country AS [País]
FROM Customers
WHERE Country = 'Brazil' 
AND  City= 'Rio de Janeiro' 
AND region IS NOT NULL;


--Operador IN 
--Seleccionar todos los clientes de estados unidos, alemania y francia
SELECT *
FROM Customers
WHERE Country = 'USA'
OR Country = 'Germany'
OR Country = 'France'
ORDER BY Country;

SELECT *
FROM Customers
WHERE Country in ('USA','Germany','France')
ORDER BY Country;

SELECT *
FROM Customers
WHERE Country in ('USA','Germany','France')
ORDER BY Country DESC;

--Seleccionar los nombres de 3 categorias especificas
SELECT 
	CategoryName
FROM Categories
WHERE CategoryID IN (1,4,8);


--Seleeccionar  los pedidos de 3 empleados en especifico
SELECT e.EmployeeID, 
CONCAT (e.FirstName,e.LastName) AS Fullname,
o.OrderDate
FROM Orders AS o
JOIN Employees e
ON o.EmployeeID = e.EmployeeID
WHERE o.EmployeeID IN (5,6,7)
ORDER BY 2 DESC;

SELECT *
FROM Employees
WHERE EmployeeID IN (5,6,7);

--Seleccionar todos los clientes que no sean de alemania, Mexico y Argentina
SELECT *
FROM Customers
WHERE Country <>  'Germany' AND Country<> 'Mexico' AND Country <> 'Argentina'
ORDER BY Country;

SELECT * 
FROM Customers
WHERE Country NOT IN ('Mexico', 'Germany', 'Argentina')
ORDER BY Country;

--Óperador BETWEEN
--Seleccionar todo los productos que su precio
--este entre 10 y 30
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice >= 10 
AND UnitPrice <= 30
ORDER BY 2 DESC;

SELECT ProductName, UnitPrice AS [precio]
FROM Products
WHERE UnitPrice >= 10 
AND UnitPrice <= 30
ORDER BY [precio] DESC;

SELECT ProductName, UnitPrice AS [precio]
FROM Products
WHERE UnitPrice BETWEEN 10 AND 30
ORDER BY [precio] DESC;

--Seleccionar todas las ordenes de 1995 a 1997
SELECT 
	OrderID AS [Número de Orden], 
	OrderDate AS [Fecha de Orden],
	YEAR (OrderDate) AS [Año con Year]
FROM Orders
WHERE  DATEPART (YEAR, OrderDate) BETWEEN 1995 AND 1997;

SELECT *
FROM Orders
WHERE  DATEPART (YEAR, OrderDate) BETWEEN 1995 AND 1997;

--Seleccionar todo los productos que no esten en un precio 
--entre 10 y 20
SELECT *
FROM Products
WHERE UnitPrice NOT BETWEEN 10 AND 20;

--Operador LIKE
--WILDCARDS (%, _, [], [^] ~)

--Seleccionar todos los clientes en donde su nombre 
--comienze con 'a'
SELECT * 
FROM Customers
WHERE CompanyName LIKE 'a%';

SELECT * 
FROM Customers
WHERE CompanyName LIKE 'an%';

--Seleccionar todos los clientes de una ciudad que comienza
--con L, seguido de cualquier caracter,
--despues nd y que termine con dos caracteres cualesquiera
SELECT *
FROM Customers
WHERE City LIKE 'L_nd__';

--Seleccionar todos los clientes que su nombre terminen con 'a'
SELECT *
FROM Customers
WHERE CompanyName LIKE '%a';

--Devolver todos los clientes que en la ciudad contenga la
--letra "l"

SELECT CustomerID, CompanyName, City
FROM Customers
WHERE City LIKE '%la%';

--Devolver todos los clientes 
--Que comienzen  con "a" o comienzan con "b"

SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName LIKE 'a%'
OR CompanyName LIKE 'b%';
GO

--Devolver todos los clientes que comienza con b y terminan con s
SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName LIKE 'b%'
AND CompanyName LIKE '%s';
GO

SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName LIKE 'b%s';
GO

--Devolver todos los clientes que comienzen con A y que tengan almenos 3 caracteres de longitud
SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName LIKE 'a__%';
GO

--Devolver todos los clientes que tienen r en la segunda posicion 
SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName LIKE '_r%';
GO

--Devolver todos los clientes que contengan a o b o c al inicio
SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName LIKE '[abc]%';

SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName NOT LIKE '[abc]%';

--Devolver todos los clientes que no contengan a o b o c al inicio
SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName LIKE '[^abc]%';

SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName LIKE '[a-f]%';

--Seleccionar todos los clientes de usa
--mostrando solo los 3 primeros
SELECT TOP 3 *
FROM Customers
WHERE Country = 'USA';

--Seleccionar todos los clientes ordenados de forma ascendente por su numero de cliente
--pero saltando las primeras 5 filas (offset)
SELECT *
FROM Customers
ORDER BY CustomerID ASC
OFFSET 5 ROWS;

SELECT *
FROM Customers
ORDER BY CustomerID ASC

--Seleccionar todos los clientes ordenados de forma ascendente por su numero de cliente
--pero saltando las primeras 5 filas (offset y FETCH) y mostrar las siguientes 10
SELECT *
FROM Customers
ORDER BY CustomerID ASC
OFFSET 5 ROWS
FETCH NEXT 10 ROWS ONLY;
