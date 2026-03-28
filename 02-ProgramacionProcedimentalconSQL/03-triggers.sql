CREATE DATABASE db_triggers;
GO

USE db_triggers;
CREATE TABLE Products
(
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL (10,2)
);
GO

-- Ejercio 1 Evento Insert Trigger
CREATE OR ALTER TRIGGER trg_test_insert --SE CREA EL TRIGGER
ON Products -- TABLA A LA QUE SE ASOCIA EL TRIGGER
AFTER INSERT -- EL EVENTO CON EL QUE SE VA A DISPSARAR
AS
BEGIN
    SELECT * FROM inserted;
    SELECT * FROM Products;
    SELECT * FROM deleted;
    
END;
GO


-- EVALUAR 
INSERT INTO Products (id,nombre,precio)
VALUES (1, 'BACALAO', 300);

INSERT INTO Products (id,nombre,precio)
VALUES (2,'REYES', 300);

INSERT INTO Products (id,nombre,precio)
VALUES (3,'BUCAÑAS', 9570);

INSERT INTO Products (id,nombre,precio)
VALUES (4,'30x30', 18),
       (5, 'CHARANDA', 5.50);

INSERT INTO Products (id,nombre,precio)
VALUES (6,'Don Peter', 100),
       (7, 'Presimuerte', 98);
GO

SELECT * FROM Products
GO

-- Evento DELETE
CREATE OR ALTER TRIGGER trg_test_delete
ON Products
AFTER DELETE 
AS
BEGIN
    SELECT * FROM deleted
    SELECT * FROM inserted
    SELECT * FROM Products
END;
GO

DELETE FROM Products WHERE id =  1;
GO


-- Evento update

CREATE OR ALTER TRIGGER trg_test_update
ON Products
AFTER UPDATE
AS 
BEGIN
    SELECT * FROM inserted;
    SELECT * FROM deleted;
END;
GO 

UPDATE Products 
SET precio = 600 
WHERE id = 2;

-- Realizar un trigger que permita cancelar la operación si se insertan más
-- de un registro al mismo tiempo

CREATE TABLE Productos2
(
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL (10,2)
);
GO


CREATE OR ALTER TRIGGER trg_un_solo_registro
ON Productos2
AFTER INSERT
AS
BEGIN
    -- contar el numero de registros insertados
   IF (SELECT COUNT(*) FROM inserted) > 1
   BEGIN
     RAISERROR('SOLO SE PERMITE INSERTAR UN REGISTRO A LA VEZ',16,1);
     ROLLBACK TRANSACTION;
   END

END;
GO

SELECT * FROM Productos2

INSERT INTO Productos2 (id,nombre,precio)
VALUES (1,'Don Peter', 100),
       (2, 'Presimuerte', 98);
GO

-- Realizar un trigger que detecte un cambio en el precio y mande un mensaje 
-- de que el precio se cambio

CREATE OR ALTER TRIGGER trg_validar_cambio
ON Productos2
AFTER UPDATE
AS 
BEGIN

    IF EXISTS (
                SELECT 1 
                FROM inserted AS i
                INNER JOIN deleted AS d 
                ON i.id = d.id
                WHERE i.precio <> d.precio
    )
    BEGIN
        PRINT ('EL PRECIO FUE CAMBIADO')
    END
END;
GO

--REALIZAR UN Trigger que evite que se cambie el precio que se evite cambiar el cambio de precio de venta de la tabla de d detalle de venta

CREATE OR ALTER TRIGGER trg_evitar_cambio
ON Productos2
AFTER UPDATE
AS 
BEGIN

    IF EXISTS (
        SELECT 1 
        FROM inserted i
        INNER JOIN deleted d 
            ON i.id = d.id
        WHERE i.precio <> d.precio
    )
    BEGIN
        PRINT 'No se puede cambiar el precio';
        ROLLBACK TRANSACTION;
    END

END;
GO

SELECT * FROM Productos2

UPDATE Productos2 
SET precio = 600 
WHERE id = 1;