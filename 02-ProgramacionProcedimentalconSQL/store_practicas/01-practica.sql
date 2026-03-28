CREATE DATABASE bdStoredVentas;
GO

USE bdStoredVentas;
GO

SELECT 
ProductID,
ProductName,
UnitPrice,
UnitsInStock
INTO Producto
FROM NORTHWND.dbo.Products;

ALTER TABLE Producto
ADD CONSTRAINT pk_producto PRIMARY KEY (ProductID);
GO

SELECT
CustomerID,
CompanyName,
Country,
City
INTO Cliente
FROM NORTHWND.dbo.Customers;

ALTER TABLE Cliente
ADD CONSTRAINT pk_cliente PRIMARY KEY (CustomerID);
GO

CREATE TABLE Venta(
idVenta INT IDENTITY(1,1) PRIMARY KEY,
fechaVenta DATE NOT NULL,
cliente_id NCHAR(5),
CONSTRAINT fk_ventas_clientes
FOREIGN KEY (cliente_id)
REFERENCES Cliente(CustomerID)
);

CREATE TABLE DetalleVenta(
idVenta INT NOT NULL,
idProducto INT NOT NULL,
PrecioVenta MONEY NOT NULL,
Cantidad INT NOT NULL,
CONSTRAINT pk_detalle PRIMARY KEY(idVenta, idProducto),
CONSTRAINT fk_detalle_producto
FOREIGN KEY (idProducto)
REFERENCES Producto(ProductID),
CONSTRAINT fk_detalle_venta
FOREIGN KEY (idVenta)
REFERENCES Venta(idVenta)
);
GO

CREATE OR ALTER PROC ups_insertar_venta
@idCliente NCHAR (5),
@idProducto INT,
@cantidad INT
AS
BEGIN

    DECLARE @existencia INT
    DECLARE @idVenta INT
    DECLARE @precio MONEY
    
    BEGIN TRY

    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE CustomerID = @idCliente)
    BEGIN 
        THROW 50001, 'EL CLIENTE NO EXISTE', 1;
    END

    IF NOT EXISTS (SELECT 1 FROM Producto WHERE ProductID = @idProducto)
    BEGIN
        THROW 50002, 'EL PRODUCTO NO EXISTE', 1;
    END

    SELECT
        @precio = UnitPrice,
        @existencia = UnitsInStock
    FROM Producto
    WHERE ProductID = @idProducto

    IF @existencia < @cantidad
    BEGIN
        THROW 50003, 'NO HAY SUFICIENTE STOCK', 1;
    END
    
  
    BEGIN TRANSACTION

    INSERT INTO Venta (fechaVenta, cliente_id)
    VALUES (GETDATE(),@idCliente)

    SET @idVenta = SCOPE_IDENTITY()

    INSERT INTO DetalleVenta (idVenta,idProducto,PrecioVenta,Cantidad)
    VALUES (@idVenta, @idProducto, @precio, @cantidad)

    UPDATE Producto
    SET UnitsInStock = UnitsInStock - @cantidad
    WHERE ProductID = @idProducto

    COMMIT;


    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        ROLLBACK;

        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH

END;
GO

EXEC ups_insertar_venta @idCliente = 'ALFKI', @idProducto = 1, @cantidad = 3;
EXEC ups_insertar_venta @idCliente = 'SDFGH', @idProducto = 8, @cantidad = 2;

SELECT * FROM Producto;
SELECT * FROM Cliente;
SELECT * FROM Venta;
SELECT * FROM DetalleVenta;
GO

CREATE OR ALTER TRIGGER trg_noeditar_precioventa
ON DetalleVenta
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
       SELECT 1 
       FROM inserted i
       INNER JOIN deleted d 
       ON i.idVenta = d.idVenta 
       AND i.idProducto = d.idProducto
       WHERE i.PrecioVenta <> d.PrecioVenta
    )
BEGIN
      PRINT 'No se puede cambiar detalle venta';
      ROLLBACK TRANSACTION;
END
END;
GO