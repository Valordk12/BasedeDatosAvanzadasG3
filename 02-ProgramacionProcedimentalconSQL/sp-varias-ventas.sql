USE bdStoredVentas;
GO

CREATE TYPE type_detalle_venta AS TABLE
(
    idProducto INT,   
    cantidad INT
);
GO


CREATE OR ALTER PROCEDURE usp_registrar_ventas
@idCliente NCHAR(5),
@detalles type_detalle_venta READONLY
AS
BEGIN
    DECLARE @idVenta INT;

    BEGIN TRY

    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE CustomerID = @idCliente)
    BEGIN
        THROW 50001, 'El Cliente No existe', 1;
    END


    IF NOT EXISTS (SELECT 1 FROM @detalles)
    BEGIN
        THROW 50002, 'No se recibieron productos en la venta', 1;
    END

    IF EXISTS (
        SELECT 1
        FROM @detalles AS d
        LEFT JOIN Producto AS p
        ON d.idProducto = p.ProductID
        WHERE p.ProductID IS NULL
    )
    BEGIN
        THROW 50003, 'Uno o más productos no existen', 1;
    END

    IF EXISTS (
        SELECT 1
        FROM @detalles
        WHERE cantidad <=0
    )
    BEGIN
        THROW 50004, 'La cantidad debe ser mayor a 0', 1;
    END

    IF EXISTS (
        SELECT 1
        FROM @detalles AS d
        INNER JOIN Producto AS p
        ON d.cantidad = p.UnitsInStock
        WHERE d.cantidad > p.UnitsInStock

    )
    BEGIN
        THROW 50005, 'No hay suficiente stock para uno o más productos', 1;
    END

    BEGIN TRANSACTION

    INSERT INTO Venta (fechaVenta,cliente_id)
    VALUES (GETDATE(), @idCliente);

    SET @idVenta = SCOPE_IDENTITY();

    INSERT INTO DetalleVenta (idVenta,idProducto,PrecioVenta,Cantidad)
    SELECT
        @idVenta,
        p.ProductID,
        p.UnitPrice,
        d.cantidad
    FROM @detalles AS d
    INNER JOIN Producto AS p
    ON d.idProducto = p.ProductID;

    UPDATE p
    SET p.UnitsInStock = p.UnitsInStock - d.cantidad
    FROM Producto AS p
    INNER JOIN @detalles AS d
    ON p.ProductID = d.idProducto;

    COMMIT;

    PRINT 'Venta hecha correctamente =)';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

            PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

DECLARE @productos AS type_detalle_venta;

INSERT INTO @productos (idProducto, cantidad)
VALUES
(1, 2),
(2, 1),
(3, 4);

EXEC usp_registrar_ventas
    @idCliente = 'ALFKI',
    @detalles = @productos;

    SELECT * FROM Venta;
    SELECT * FROM DetalleVenta;
    SELECT * FROM Producto;