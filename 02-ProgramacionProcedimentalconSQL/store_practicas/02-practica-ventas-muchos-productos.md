## Documentación del Store Procedure ##

## Instrucciones del Procedimiento Almacenado

Se debe crear un Store Procedure que registre una venta cumpliendo con los siguientes puntos:

1. **Manejo de errores y transacciones**
   - Implementar control de errores mediante TRYCATCH.
   - Utilizar transacciones (BEGIN TRANSACTION COMMIT, ROLLBACK) para asegurar la integridad de los datos.

2. **Inserción de la venta**
   - Registrar una nueva venta incluyendo la fecha actual.
   - Verificar que el cliente que realiza la compra exista en la base de datos.

3. **Registro del detalle de la venta**
   - Registrar el detalle con un solo producto.
   - Verificar que el producto exista.
   - Obtener el precio actual del producto.
   - Registrar el precio en el detalle de venta para mantener el historial.
   - Verificar que el producto tenga suficiente existencia.

4. **Actualización de inventario**
   - Actualizar la existencia del producto en base a la cantidad vendida.

**Requerimientos**

El procedimiento tiene estos requerimientos:

1. Manejo de errores y transacciones por medio del uso de TRYCATCH
2. Uso de BEGIN TRANSACTION, COMMIT y ROLLBACK
3. Inserción de venta
4. Se registra la fecha actual (GETDATE())
5. Se valida que el cliente exista
6. Registro del detalle de venta
7. Se valida que el producto exista
8. Se obtiene el precio actual del producto
9. Se verifica que exista stock suficiente
10. Se registra un solo producto por ejecución
11. Actualización de inventario
12. Se descuenta la cantidad vendida del stock
13. Protección del precio histórico
14. Se utiliza un trigger para evitar modificaciones en detalleVenta

## Explicación de Código ##

```sql
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
```

## Diagrama de Base de Datos ##

![Diagrama ER](../../img/diagrama2.png)

Se crea la base de datos llamada bdStoredVentas, la cual será utilizada para almacenar la información relacionada con ventas, productos y clientes. Posteriormente, se selecciona dicha base de datos con USE.


**Tabla Producto**

La tabla Producto se crea a partir de la base de datos de ejemplo Northwind, utilizando la instrucción SELECT INTO.
Se importan los siguientes campos:

1. ProductID
2. ProductName
3. UnitPrice
4. UnitsInStock

Después de su creación, se define la clave primaria (PRIMARY KEY) sobre el campo ProductID.

Esta tabla funciona como catálogo de productos.

**Tabla Cliente**

La tabla Cliente también se genera a partir de la base de datos Northwind, importando los campos:

1. CustomerID
2. CompanyName
3. Country
4. City

Luego, se establece la clave primaria sobre CustomerID.

Esta tabla funciona como catálogo de clientes.

**Tabla Venta**

La tabla Venta se crea manualmente y representa el encabezado de una venta.

Campos:

1. idVenta: clave primaria autoincremental.
2. fechaVenta: almacena la fecha en que se realiza la venta.
3. cliente_id: referencia al cliente que realiza la compra.

Se coloco una (FOREIGN KEY) que relaciona cliente_id con CustomerID de la tabla Cliente.

**Tabla DetalleVenta**

La tabla DetalleVenta almacena el detalle de cada venta

Campos:

1. idVenta: referencia a la venta.
2. idProducto: referencia al producto.
3. PrecioVenta: precio del producto al momento de la venta.
4. Cantidad: número de unidades vendidas.

Se puso una clave primaria compuesta (idVenta, idProducto)

Además, se colocaron dos llaves foráneas:

idProducto hacia la tabla Producto
idVenta hacia la tabla Venta

Esta tabla es la que lleva un historial de precios, ya que el precio se guarda en el momento de la venta.

## Diseño del Stored Procedure 

```sql
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
```

Para el procedimiento almacenado se declararon 3 parametros porque es necesario identificar quién va a realizar la compra, indicar que productos se va a vender y cuantas unidades se van a registrar en la venta

Luego se declararon 3 variables esto porque se necesita almacenar temporalmente los datos obtenidos de la base de datos que en este caso son guardar el sotck del productos, obtener el precio actual del producto en el momento de la venta y guardar el id al insertar la venta

**Dentro del sp se agregaron las siguientes validaciones**

```sql
IF NOT EXISTS (SELECT 1 FROM Cliente WHERE CustomerID = @idCliente)
```

Para evitar registrar ventas con clientes que no existen

```sql
IF NOT EXISTS (SELECT 1 FROM Producto WHERE ProductID = @idProducto)
```

Para asegurar que el producto que se intenta vender está registrado en el sistema.

```sql
SELECT @precio = UnitPrice, @existencia = UnitsInStock
FROM Producto
WHERE ProductID = @idProducto
```

Para obtener el precio actual y stock

```sql
IF @existencia < @cantidad
```

Para impedir vender más productos de los disponibles.

```sql
BEGIN TRANSACTION
```

Porque la operación de venta hace múltiples pasos que deben ejecutarse como uno solo en 
caso de fallar todo se revierte con ROLLBACK.

**Operaciones principaless**

```sql
INSERT INTO Venta (fechaVenta, cliente_id)
VALUES (GETDATE(), @idCliente)
```

Para registrar la fenta con fhecha actual y su cliente asociado

```sql
SET @idVenta = SCOPE_IDENTITY()
```

Para obtener el identificador de la venta recién creada y poder relacionarla con el detalle.

```sql
INSERT INTO DetalleVenta (idVenta,idProducto,PrecioVenta,Cantidad)
    VALUES (@idVenta, @idProducto, @precio, @cantidad)
```

Registrar el producto vendido, cantidad y su precio en ese momento y se guarda el precio aquí para mantener el historial, aunque el precio del producto cambie después.

```sql
 UPDATE Producto
    SET UnitsInStock = UnitsInStock - @cantidad
    WHERE ProductID = @idProducto
```

Reduce el inventario según la cantidad vendida

```sql
COMMIT
```

Asegura que las operaciones hechas se guarden de manera correcta en la base de datos si todo funciono bien

**Manejo de errores**

```sql
BEGIN CATCH
```
Para capturar cualquier error que ocurra durante la ejecución.

```sql
 IF @@TRANCOUNT > 0
 ROLLBACK;

 PRINT 'Error: ' + ERROR_MESSAGE();
```

Nos indica si hay transacciones activas antes de intentar hacer un rollback y en caso de ejectuar el rollback revierte los cambios y despues muestrar el mensaje de error


## TRIGGER ##

```sql
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
```

El funcionamiento de este trigger se basa en el que al momento de querer intentar hacer un update en la tabla detalle venta este evitar que se haga por medio del uso de un inner join entre la trabla inserted y deleted donde al revisar que el precio venta de inserted es diferente al de deleted entonces este manda un mensaje de que no se puede cambiar detalle venta y luego ejecutar un rollback transaction;

