CREATE DATABASE bdstored;
GO

USE bdstored;
GO

-- Stored Procedure

CREATE OR ALTER PROC spu_persona_saludar
    @nombre VARCHAR (50) --Parametro de entrada
AS
BEGIN 
    PRINT 'Hola ' + @nombre;
END;

EXEC spu_persona_saludar 'Donato';
EXEC spu_persona_saludar 'Roberta';
EXEC spu_persona_saludar 'Monico';
EXEC spu_persona_saludar 'Luisa';
GO

SELECT CustomerID, CompanyName, City, Country 
INTO Customers
FROM 
NORTHWND.dbo.Customers;
GO

--Realizar un stored que reciba un paramateo de un cliente en particular y
--lo muestre
SELECT * FROM Customers;
GO

CREATE OR ALTER PROCEDURE spu_cliente_consultarporid
    @id NCHAR(10)
AS
BEGIN
    SELECT CustomerID AS [NUMERO],
           CompanyName AS [CLIENTE],
           City AS [CIUDAD],
           Country AS [PAIS]
    FROM Customers
    WHERE CustomerID = @id;
END;
GO

EXEC spu_cliente_consultarporid 'ANTON';
GO

SELECT * FROM Customers
WHERE EXISTS (SELECT 1 --siempre usarlo para ver si existe
FROM Customers
where CustomerID = 'ANTONT')
GO

DECLARE @valor int

SET @valor = (SELECT 1
FROM Customers
where CustomerID = 'ANTON')

IF @valor = 1
BEGIN
    PRINT 'Existe'
END;
ELSE
BEGIN
    PRINT 'No Existe'
END;
GO

CREATE OR ALTER PROCEDURE spu_cliente_consultarporid2
    @id NCHAR(10)
AS
DECLARE @valor int

SET @valor = (SELECT 1
FROM Customers
where CustomerID = @id)

IF @valor = 1
BEGIN
    SELECT CustomerID AS [NUMERO],
           CompanyName AS [CLIENTE],
           City AS [CIUDAD],
           Country AS [PAIS]
    FROM Customers
    WHERE CustomerID = @id;
END;
ELSE
BEGIN
    PRINT 'No Existe Checale bien'
END;
GO

EXEC spu_cliente_consultarporid2 'ANTONT';
GO

CREATE OR ALTER PROCEDURE spu_cliente_consultarporid3
    @Id CHAR(10)
AS
BEGIN
    IF LEN(@Id)> 5
    BEGIN
    RAISERROR('EL ID DEL CLIENTE DEBE SER MENOS O IGUAL A 5',16,1);
    --;THROW 5001, 'EL NUMERO DE CLIENTE DEBE SER MENOR O IGUAL A 5', 1

    RETURN
    END;

    IF EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @Id)
    BEGIN
         SELECT CustomerID AS [NUMERO],
           CompanyName AS [CLIENTE],
           City AS [CIUDAD],
           Country AS [PAIS]
           FROM Customers
           WHERE CustomerID = @id;

           RETURN;
    END
        PRINT 'El Cliente no Existe'
END;
GO

EXEC spu_cliente_consultarporid3  @Id = 'ANTON';
GO

DECLARE @Id2 AS CHAR(10) = (SELECT CustomerID FROM Customers WHERE CustomerID = 'ANTON');

EXEC spu_cliente_consultarporid3 @Id2;

DECLARE @Id3 CHAR(10);

SELECT @Id3 = (SELECT CustomerID FROM Customers WHERE CustomerID = 'ANTON');

EXEC spu_cliente_consultarporid3 @Id3;
GO

--Parametros OUTPUT

CREATE OR ALTER PROCEDURE spu_operacion_sumar
    @a INT,
    @b AS INT,
    @resultado INT OUTPUT
AS
BEGIN
    SET @resultado = @a + @b;
END;
GO

--Utilizar la variable de salida
DECLARE @res INT;
EXEC spu_operacion_sumar 4,5,@res OUTPUT;
SELECT @res AS [SUMA];
GO

--Crear un store procedure con parametros de entrada y salida
--para calcular el area de un triangulo

CREATE OR ALTER PROCEDURE spu_area_triangulo
    @b INT,
    @h AS INT,
    @resultado INT OUTPUT

AS
BEGIN
    SET @resultado = (@b * @h)/2;
END;
GO

--Utilizar la variable de salida
DECLARE @res INT;
EXEC spu_area_triangulo 4,6,@res OUTPUT;
SELECT @res AS [AREA TRIANGULO];
GO

/*============ LOGICA DENTRO DEL SP ====================*/

-- CREAR UN SP QUE EVALUE LA EDAD DE UNA PERSONA

CREATE OR ALTER PROC usp_Persona_EvaluarEdad
@edad int
AS
BEGIN
    IF @edad >= 18 AND @edad <=45
        BEGIN
            PRINT('Eres un Adulto Sin pensi�n')
        END
    ELSE
        BEGIN
            PRINT('Eres Menor de Edad')
        END
END;
GO

EXEC usp_Persona_EvaluarEdad 22;
EXEC usp_Persona_EvaluarEdad  @edad = 2;
GO

CREATE OR ALTER PROC usp_Valores_Imprimir
    @n as int
AS
BEGIN

    IF @n <= 0
    BEGIN
        PRINT ('ERROR: VALOR DE N NO V�LIDO')
        RETURN;
    END;

    DECLARE @i AS INT
    SET @i = 1;

    WHILE (@i <= @n)
    BEGIN
        PRINT CONCAT('Este es el numero: ' ,@i);
        SET @i = @i + 1;
    END
END;
GO

EXEC usp_Valores_Imprimir 9;
GO

CREATE OR ALTER PROC usp_Valores_Tabla
    @n as int
AS
BEGIN

    IF @n <= 0
    BEGIN
        PRINT ('ERROR: VALOR DE N NO V�LIDO')
        RETURN;
    END;

    DECLARE @i AS INT
    DECLARE @j INT = 1;
    SET @i = 1;

    WHILE (@i <= @n)
    BEGIN
        WHILE(@j <=10)
        BEGIN
            PRINT CONCAT(@i, '*', @j, '=', @i*@j);
            SET @j = @j+1
        END
        PRINT (CHAR(13) + CHAR(10));
        SET @i = @i+1;
        SET @j = 1;
    END
END;
GO

EXEC usp_Valores_Tabla 2;
GO


/*================ CASE ====================*/

-- Sirve para evañiar condiciones como un switch o if multiple

CREATE OR ALTER PROC usp_Calificacion_Evaluar
    @calificacion AS INT 
AS
BEGIN
    SELECT 
    CASE
        WHEN @calificacion >= 90 THEN 'EXCELENTE'
        WHEN @calificacion >= 70 THEN 'APROBADO'
        WHEN @calificacion >= 60 THEN 'REGULAR'
        ELSE 'NO ACREDITADO'
    END AS [Resultado]
END;
GO

EXEC usp_Calificacion_Evaluar 89
GO

USE NORTHWND;
SELECT *
FROM Products

SELECT 
    ProductName, 
    UnitPrice,
    CASE    
        WHEN UnitPrice >= 200 THEN 'CARO'
        WHEN UnitPrice >= 100 THEN 'MEDIO'
        ELSE 'BARATO'
    END AS [CATEGORIA]
FROM Products;
GO

CREATE OR ALTER PROC usp_comision_ventas
    @idCliente nchar(10)
AS
BEGIN
    IF LEN(@idCliente) > 5
    BEGIN
        PRINT('El tamaño del id del cliente deber ser de 5');
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @idCliente)
    BEGIN
        PRINT('CLIENTE NO EXISTE');
        RETURN;
    END

    DECLARE @comision DECIMAL (10,2);
    DECLARE @total MONEY
    
    SET @total = (
                    SELECT SUM(UnitPrice * Quantity) 
                    FROM [Order Details] AS od 
                    INNER JOIN Orders AS o
                    ON o.OrderID = od.OrderID
                    WHERE o.CustomerID = @idCliente
                  );

    SET @comision =
        CASE
            WHEN @total >= 19000 THEN 5000
            WHEN @total >= 15000 THEN 2000
            WHEN @total >= 10000 THEN 1000
        ELSE 500

        END;  

        PRINT CONCAT('TOTAL DE VENTAS: ' , @total, CHAR(13) + CHAR(10),  'Comisión: ', @comision, 'Ventas mas comision: ' , @total + @comision);
END;
GO

EXEC usp_comision_ventas @idCliente = 'ANTON';

SELECT o.CustomerID,SUM(od.Quantity * od.UnitPrice) AS [Total]
FROM [Order Details] AS od
INNER JOIN Orders AS o
ON o.OrderID = od.OrderID
GROUP BY o.CustomerID

/*======================== CRUD =================================*/

-- EJEMPLO INSERT

USE bdstored;

CREATE TABLE productos 
(
    id INT IDENTITY,
    nombre VARCHAR (50),
    precio DECIMAL (10,2)
);
GO

/* SP PARA INSERT */
CREATE OR ALTER PROCEDURE usp_InsertarCliente
@nombre VARCHAR(50), 
@precio DECIMAL (10,2)
AS
BEGIN 
    INSERT INTO productos (nombre, precio) 
    VALUES (@nombre, @precio);

END;
GO

EXEC usp_InsertarCliente @nombre = 'coca de piña', @precio = 22.5;

SELECT * FROM productos;
GO

/* SP PARA UPDATE */
CREATE OR ALTER PROC usp_Actualizar_precio
@id INT, 
@precio DECIMAL (10,2)
AS
BEGIN

    IF EXISTS (SELECT 1 FROM productos WHERE  id = @id)
    BEGIN
        UPDATE productos
        SET precio = @precio
        WHERE id = @id;
        RETURN;
    END

    PRINT 'El id del producto no existe, no se realizo la modificacion';
    
END;
GO

SELECT * FROM productos;


EXEC usp_Actualizar_precio 12,78.6;
EXEC usp_Actualizar_precio 1,11233.01;
GO

/* SP PARA DELETE */
CREATE OR ALTER PROC usp_Delete_precio
@id AS INT
AS
BEGIN 
   IF EXISTS (SELECT 1 FROM productos WHERE id = @id)
    BEGIN
        DELETE FROM productos
        WHERE id = @id;

        PRINT 'Producto eliminado correctamente';
        RETURN;
    END

    PRINT 'El id del producto no existe, no se elimino nada';
END;
GO

EXEC usp_Delete_precio 1;
GO
--Validar

/*======================== MANEJO DE ERRORES =================================*/

--SIN MANEJO DE ERRORES
SELECT 10/0;
--Esto genera un error o una excepcion y detiene la ejecucion

BEGIN TRY
    SELECT 10/0;
END TRY
BEGIN CATCH
    PRINT 'Ocurrio el error';
END CATCH
GO

BEGIN TRY
    SELECT 10/0;
END TRY
BEGIN CATCH
    PRINT 'Mensaje: ' + ERROR_MESSAGE();
    PRINT 'Numero: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'Linea: ' + CAST(ERROR_LINE() AS VARCHAR);
    
END CATCH
GO

-- USO CON INSERT

CREATE TABLE productos2
(
id int PRIMARY KEY,
nombre varchar (50),
precio DECIMAL (10,2)
);

DROP TABLE productos2

INSERT INTO productos2
VALUES (1, 'Pitufo', 359.0);

BEGIN TRY
    INSERT INTO productos2 
    VALUES (1, 'Quemadito', 65.0);
END TRY
BEGIN CATCH
    PRINT 'Error al insertar ' + ERROR_MESSAGE();
    PRINT 'Line:  ' + CAST(ERROR_LINE() AS VARCHAR);
    PRINT 'Numero: ' + CAST(ERROR_NUMBER() AS VARCHAR);
END CATCH
GO

SELECT * FROM productos2

-- Ejemplo de uso de una transacción
BEGIN TRANSACTION;

SELECT * FROM Customers;
SELECT * FROM productos2;

INSERT INTO productos2
VALUES (2, 'Pitufina', 56.9);

ROLLBACK; -- CANCELA LA TRANSACCION, PERMITE QUE LA BASE DE DATOS NO QUEDA INCONSISTENTE
COMMIT; --CONFIRMA LA TRANSACCION

/*===================================== USO DE TRANSACCIONES =============================*/

-- EJERCICIO PARA VERIFICAR EN DONDE EL TRY CATHC SE VUELVE PODEROSO

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO productos2
    VALUES (3, 'Charro Negro', 123.0);

    INSERT INTO productos2
    VALUES (3, 'Pantera Rosa', 345.0);

    COMMIT;
END TRY 
BEGIN CATCH
    ROLLBACK;
    PRINT 'SE HIZO UN ROLLBACK CON ERROR'
    PRINT 'ERROR: ' + ERROR_MESSAGE(); 
END CATCH;

-- VALIDAR SI UNA TRANSACCIÓN ESTA ACTIVA 

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO productos2
    VALUES (3, 'Charro Negro', 123.0);

    INSERT INTO productos2
    VALUES (3, 'Pantera Rosa', 345.0);

    COMMIT;
END TRY 
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK
    PRINT 'SE HIZO UN ROLLBACK CON ERROR'
    PRINT 'ERROR: ' + ERROR_MESSAGE(); 
END CATCH;


