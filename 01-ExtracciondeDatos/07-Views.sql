
/* 
Una vista (view) es una tabla virtual basada en una consulta.
Sirve para reutilizar l�gica, simplificar consultas y controlar accesos.

Existen dos tipos:
- Vistas Almacenadas
- Vistas Materializadas (SQL SERVER Vistas Indexadas)

Sintaxis:

CREATE OR ALTER VIEW vw_nombre
AS
Definici�n de la vista
*/

USE dbexercises;

--SELECCIONAR TODAS LAS VENTAS POR CLIENTE
--FEHCA DE VENTA Y ESTADO

--BUENAS PRACTICAS:
--Nombre de las vista vw
--Evitar el Select * dentro de la vista
--Si se necesita ordenar hazlo al consultar la vista

CREATE VIEW vw_ventas_totales
AS
SELECT 
	v.VentaId,
	v.ClienteId,
	v.FechaVenta,
	v.Estado,
SUM (dv.Cantidad * dv.PrecioUnit * (1-dv.Descuento/100)) AS [Total]
FROM Ventas AS v
INNER JOIN DetalleVenta AS dv
ON v.VentaId = dv.VentaId
GROUP BY v.VentaId,
	v.ClienteId,
	v.FechaVenta,
	v.Estado;

--Trabajar con la vista
SELECT vt.VentaId,
	   vt.ClienteId,
	   c.Nombre,
	   total,
	   DATEPART(MONTH, vt.FechaVenta) AS [MES]
FROM vw_ventas_totales AS vt
INNER JOIN Clientes AS c
oN vt.ClienteId = c.ClienteId
WHERE DATEPART(MONTH, FechaVenta) = 1
AND Total >= 3130;

--CREAR UNA VISTA QUE SE LLAME vw_detalle_extendido que muestre
--LA ventaid, cliente (nombre), producto,
--Categoria (Nombre), cantidad vendidad, precio de la venta,
--Descuento y el total de la cada transaccion

--En la vista seleccionen 50 lineas ordenadas por la venta id de forma ascendente

SELECT * 
FROM Clientes;

CREATE VIEW vw_detalle_extendido
AS
SELECT TOP 50
	v.VentaId,
	c.Nombre AS [Cliente],
	p.Nombre AS [Producto],
	p.Categoria AS [Categoria],
	dv.Cantidad,
	dv.PrecioUnit AS [PrecioVenta],
	dv.Descuento,
	(dv.Cantidad * dv.PrecioUnit * (1-dv.Descuento/100)) AS [Total]
FROM Ventas as v
INNER JOIN Clientes AS c
ON v.ClienteId = c.ClienteId
INNER JOIN DetalleVenta AS dv
ON v.VentaId = dv.VentaId
INNER JOIN Productos AS p
ON dv.ProductoId = p.ProductoId
ORDER BY v.VentaId ASC


SELECT TOP 50
	v.VentaId,
	c.Nombre AS [Cliente],
	p.Nombre AS [Producto],
	p.Categoria AS [Categoria],
	dv.Cantidad,
	dv.PrecioUnit AS [Precio Venta],
	dv.Descuento,
	(dv.Cantidad * dv.PrecioUnit * (1-dv.Descuento/100)) AS [Total]
FROM Ventas as v
INNER JOIN Clientes AS c
ON v.ClienteId = c.ClienteId
INNER JOIN DetalleVenta AS dv
ON v.VentaId = dv.VentaId
INNER JOIN Productos AS p
ON dv.ProductoId = p.ProductoId
ORDER BY v.VentaId ASC

SELECT * FROM vw_detalle_extendido;

/*Crear vista: vw_ventas_con_impuesto
Que muestre:
VentaID
Cliente (Nombre completo)
Producto
Categoría
Cantidad
Precio
Subtotal (Cantidad * Precio)
IVA (16%)
Total con IVA
Reglas:
Mostrar solo las primeras 100 filas
Ordenadas por VentaID DESC*/

SELECT TOP 100
	v.VentaId AS [Venta ID],
	c.Nombre AS [Nombre Cliente],
	p.Nombre AS [Nombre Producto],
	p.Categoria AS [Categoria],
	dt.Cantidad AS [Cantidad],
	dt.PrecioUnit AS [Precio Venta],
	(dt.Cantidad * dt.PrecioUnit) AS [SUBTOTAL],
	(dt.Cantidad * dt.PrecioUnit) * 0.16 AS [IVA],
	(dt.Cantidad * dt.PrecioUnit) * 1.16 AS [TOTAL CON IVA]
FROM Ventas AS v
INNER JOIN Clientes AS c
ON v.ClienteId = c.ClienteId
INNER JOIN DetalleVenta AS dt
ON v.VentaId = dt.VentaId
INNER JOIN Productos AS p
ON dt.ProductoId = p.ProductoId
ORDER BY v.VentaId DESC

