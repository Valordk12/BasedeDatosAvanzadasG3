CREATE DATABASE bdEjercicio
SELECT * FROM Products;
USE bdEjercicio;

SELECT 
ProductID,
ProductName,
UnitPrice,
UnitsInStock
INTO Producto
FROM NORTHWND.dbo.Products

SELECT
CustomerID,
CompanyName,
Country,
City
INTO Cliente
FROM NORTHWND.dbo.Customers

SELECT * FROM Cliente;

CREATE TABLE Venta(
	idVenta INT NOT NULL identity(1,1),
	fechaVenta DATE NOT NULL,
	cliente_id NCHAR(5),
	CONSTRAINT pk_ventas
	PRIMARY KEY(idVenta),
	CONSTRAINT fk_ventas_clientes
	FOREIGN KEY (cliente_id)
	REFERENCES Cliente (CustomerID)
);

CREATE TABLE DetalleVenta
(
idVenta INT NOT NULL,
idProducto INT NOT NULL,
PrecioVenta MONEY NOT NULL,
Cantidad INT NOT NULL,
CONSTRAINT pk_DetalleVenta
PRIMARY KEY(idVenta, idProducto),
CONSTRAINT fk_dv_producto
FOREIGN KEY (idProducto)
REFERENCES Producto (ProductID),
CONSTRAINT fk_dv_venta
FOREIGN KEY (idVenta)
REFERENCES Venta (idVenta)
)
GO

CREATE OR ALTER PROC ups_registro_Venta
@idCliente NCHAR (5),
@idProducto INT,
@cantidad INT
AS

BEGIN
	BEGIN TRY
	BEGIN TRANSACTION;

	DECLARE @idVenta INT
	DECLARE @stock INT
	DECLARE @precio MONEY
	
	IF EXISTS (SELECT 1 FROM Cliente WHERE CustomerID = @idCliente)
	BEGIN

	INSERT INTO Venta (fechaVenta, cliente_id)
	VALUES (GETDATE(),@idCliente)

	SET @idVenta = SCOPE_IDENTITY()
	
	END
	ELSE
	BEGIN
		PRINT 'El cliente no existe'
		ROLLBACK
		RETURN
	END


	IF EXISTS (SELECT 1 FROM Producto WHERE ProductID = @idProducto )
	BEGIN
		
		SELECT 
				@precio = UnitPrice,
				@stock = UnitsInStock
				FROM Producto
				WHERE ProductID = @idProducto

	
	IF @stock < @cantidad
	BEGIN
			PRINT 'No hay el suficiente stock'
			ROLLBACK
			RETURN
	END

			INSERT INTO DetalleVenta (idVenta, idProducto, PrecioVenta,Cantidad)
			VALUES (@idVenta, @idProducto, @precio, @cantidad)

			UPDATE Producto
			SET UnitsInStock = UnitsInStock - @cantidad
			WHERE ProductID = @idProducto
	
	END
	ELSE
	BEGIN
		PRINT 'El producto no existe'
		ROLLBACK
		RETURN
	END
	
	COMMIT

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK
		PRINT 'ERROR: ' + ERROR_MESSAGE(); 
	END CATCH
END;
GO

EXEC ups_registro_Venta @idCliente = 'ANTON', @idProducto = 8, @cantidad = 2;
EXEC ups_registro_Venta @idCliente = 'SDFGH', @idProducto = 8, @cantidad = 2;



SELECT * FROM Producto;
SELECT * FROM Cliente;
SELECT * FROM Producto;
SELECT * FROM DetalleVenta;






