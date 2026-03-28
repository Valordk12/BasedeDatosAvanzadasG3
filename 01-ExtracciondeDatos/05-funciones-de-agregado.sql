/*
	Funciones de Agregado
	COUNT(*)
	COUNT(CAMPO)
	MAX()
	MIN()
	AVG() //Promedio
	SUM()

	Nota: Estas funciones por si solas
	generan un resultado escalar (solo un registro)

	GROUP BY
	HAVING
*/
SELECT *
FROM Orders;

SELECT COUNT(*) AS [N�mero de Ordenes]
FROM Orders;

SELECT	
	COUNT (ShipRegion) AS [N�mero de Regiones Existentes]
FROM Orders;

SELECT MAX(OrderDate) AS [�ltima Fecha de Compra]
FROM Orders;

SELECT MAX(UnitPrice) AS [Precio m�s Alto]
FROM Products;

SELECT MIN(UnitsInStock) AS [Stock Minimo]
FROM Products;

-- Total de ventas realizadas
SELECT *, (UnitPrice * Quantity - (1-Discount)) AS [Importe]
FROM [Order Details]

SELECT 
	ROUND(SUM(UnitPrice * Quantity - (1-Discount)),2) AS [Importe]
FROM [Order Details]

--Seleccionar el promedio de ventas
SELECT
	ROUND(AVG(UnitPrice * Quantity - (1-Discount)),2) 
	AS [Promedio de Ventas]
FROM [Order Details];

--Seleccionar el numero de ordenes
--Realizadas a alemania

SELECT *
FROM Orders;

SELECT *
FROM Orders
WHERE ShipCountry = 'Germany';

SELECT COUNT (*) AS [Total de Ordenes]
FROM Orders
WHERE ShipCountry = 'Germany'
AND CustomerID = 'LEHMS' ;

SELECT * 
FROM Customers;

--Seleccionar la suma de las cantidades vendidas
--por cada ordenid (agrupadas)
SELECT
	COUNT(orderid) AS [Total de Ordenes], 
	SUM(Quantity) AS [Total de Cantidades]
FROM [Order Details]

SELECT * FROM [Order Details]

SELECT
	OrderID, SUM(Quantity) AS [Total de Cantidades]
FROM [Order Details]
GROUP BY orderid;

--Seleccionar el numero de productos por categoria
SELECT 
	CategoryID, 
		Count(*) AS [Numero de Productos]
FROM Products
GROUP BY CategoryId;

SELECT 
	c.CategoryName AS [Categoria], 
		Count(*) AS [Numero de Productos]
FROM Products AS p
INNER JOIN Categories AS c
ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName;

SELECT 
	c.CategoryName AS [Categoria], 
		Count(*) AS [Numero de Productos]
FROM Products AS p
INNER JOIN Categories AS c
ON p.CategoryID = c.CategoryID
WHERE c.CategoryName in ('Beverages','Meat/Poultry')
GROUP BY c.CategoryName;

SELECT *
FROM Products;

--Obtener el total de pedidos realizados por cada cliente
--Obtener el numero total de pedidos que ha atendido cada empleado
SELECT 
	EmployeeID AS [Numero de empleado],
	COUNT(*) AS [Total de Ordenes]
FROM Orders
GROUP BY EmployeeID
ORDER BY [Total de Ordenes] DESC;

SELECT 
	e.FirstName,
	e.LastName,
	COUNT(*) AS [Total de Ordenes]
FROM Orders AS o
INNER JOIN Employees AS e
ON o.EmployeeID = e.EmployeeID
GROUP BY e.FirstName,
		 e.LastName
ORDER BY [Total de Ordenes] DESC;

SELECT 
	CONCAT(e.FirstName, ' ', e.LastName) AS [Nombre Completo],
	COUNT(*) AS [Total de Ordenes]
FROM Orders AS o
INNER JOIN Employees AS e
ON o.EmployeeID = e.EmployeeID
GROUP BY e.FirstName,
		 e.LastName
ORDER BY [Total de Ordenes] DESC

--Ventas totales por producto

SELECT p.ProductName, 
	   ROUND(SUM(od.Quantity * od.UnitPrice * (1-Discount)),2) AS [VENTAS Totales]
FROM [Order Details] AS od
INNER JOIN Products AS p
ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY 2 DESC;

SELECT od.ProductID, ROUND(SUM(od.Quantity * od.UnitPrice * (1-Discount)),2) AS [VENTAS Totales]
FROM [Order Details] AS od
WHERE ProductID IN (10,2,6)
GROUP BY od.ProductID;

--Calcular cuantos pedidos se realizaron por anio

SELECT DATEPART(YY, OrderDate) AS [AÑO], 
COUNT(*) AS [Número de Pedidos]
FROM Orders
GROUP BY DATEPART (YY,OrderDate);

--Cuantos productos ofrece cada proovedor

SELECT s.CompanyName AS [Proveedor],
COUNT(*) AS [Numero de Productos] 
FROM Products AS p
INNER JOIN Suppliers AS s
ON p.SupplierID = s.SupplierID
GROUP BY s.CompanyName
ORDER BY 2 DESC;


--Seleccionar el numero de pedidos por cliente que hayan realizado mas de 10
SELECT 
	c.CompanyName AS [Cliente] 
	,COUNT (*) AS [Numero de Pedidos]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName
HAVING COUNT(*) > 10; 

--Seleccionar los emepleado que hayn gestionado peidos por un total
--superior a 10000 en ventas (mostrar el  id del empleado, el nombre y el total de compras)

SELECT 
	o.EmployeeID AS [Numero Empleado]
	,CONCAT(e.FirstName , ' ' ,e.LastName) AS [Nombre Completo] 
	,ROUND(SUM (od.UnitPrice * od.Quantity * (1-od.Discount)),2) AS 
	[Total de Ventas]
FROM [Order Details] AS od
INNER JOIN Orders AS o 
ON od.OrderID = o.OrderID
INNER JOIN Employees AS e
ON e.EmployeeID = o.EmployeeID
GROUP BY o.EmployeeID,e.FirstName, e.LastName;
