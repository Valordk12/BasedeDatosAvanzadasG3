# Fundamentos Programables

1. ¿Qué es la parte programable de T-SQL?

Es todo lo que permite:

    Usar variables
    Control del Flujo
    Crear procedimientos almacenados (Store Procedures)
    Manejar Errores
    Crear Funciones
    Usar transacciones
    Disparadores (Triggers)

Nota: Es convertir SQL en un lenguaje casi como C/java pero dentro del engine

2. Variables
Una variable almacena un valor temporal

```sql
/*==========================Variables==============================*/
DECLARE @Edad INT 
SET @Edad = 42

SELECT @Edad AS Edad
PRINT CONCAT ('La edad es: ', ' ', @Edad)

/*========================Ejercicios Variables===================*/

/*
    1. Declarar una variable llamada precio 
    2. Asignarle el valor de 150 
    3. Calcular el iva del 16%
    4. Mostrar el total

*/

DECLARE @Precio MONEY = 150 -- Se le asigna un valor inicial
DECLARE @Total MONEY 

SET @Total = @Precio * 1.16

SELECT @Total AS [Total]
```

3. IF/ELSE

Permite ejectuar código según una condición


```sql
/*==========================IF/ELSE==============================*/

DECLARE @Edad2 INT 
SET @Edad2 = 17

If @Edad >= 18
BEGIN
    PRINT 'Es mayor de Edad'
    PRINT 'Felicidades'
END
Else 
    PRINT 'Es menor '

```

4. WHILE 

```sql
ECLARE @contador INT;
DECLARE @contador2 INT = 1;
SET @contador = 1;
SET @contador2 = 1;

WHILE @contador <= 5
BEGIN
	WHILE @contador2 <=5
	BEGIN
		PRINT CONCAT(@contador, '-', @contador2);
		SET @contador2 = @contador2 + 1
	END;
	SET @contador2 = 1
	SET @contador = @contador + 1;
END
GO

--Imprime los numeros del 10 al 1
DECLARE @contador INT;
SET @contador = 10

WHILE @contador >= 1
BEGIN
	PRINT @contador;
	SET @contador = @contador -1;
END;
GO
```

## Procedimientos Almacenados (Stored Procedures)

5. 👌¿Qué es un Stored Procedures?

Es un bloque de código guardado en la base de datos que se 
puede ejecutar cuando se necesite


```sql
CREATE PROCEDURE usp_objeto_accion
[Parameters]
AS
BEGIN
    --Body
END;

CREATE PROC usp_objeto_accion
[Parameters]
AS
BEGIN
    --Body
END;

CREATE OR ALTER PROCEDURE usp_objeto_accion
[Parameters]
AS
BEGIN
    --Body
END;

```

```sql
/*==================== STORED PROCEDURE ======================*/

CREATE PROCEDURE usp_mensaje_saludar
AS
BEGIN
    PRINT ('Hola Mundo Transact SQL')
END;
GO

EXECUTE usp_mensaje_saludar;
GO

EXEC usp_mensaje_saludar;
GO

ALTER PROCEDURE usp_mensaje_saludar
AS
BEGIN
    PRINT ('Hola Mundo Transact SQ - 2 ')
END;
GO

CREATE OR ALTER PROCEDURE usp_mensaje_saludar
AS
BEGIN
    PRINT ('Hola Mundo Transact SQL - 3')
END;
GO

--Eliminar un sp
--DROP PROCEDURE usp_mensaje_saludar;
--GO


/*============ EJERCICIOS ===============*/

--Crear un store procedure que imprima la fecha actual
CREATE OR ALTER PROCEDURE usp_fecha_mostrar
AS
BEGIN
    PRINT CONCAT ('La fecha es: ', ' ', GETDATE());
END;
GO

EXEC usp_fecha_mostrar;
GO

/*SELECT * FROM
Orders
WHERE EXISTS (
    SELECT 1
    FROM Customers
    WHERE CustomerID = 'ALFI'
)*/


--Crear un store procedure que muestre el nombre de la base de datos actual

CREATE OR ALTER PROC usp_nombredb_mostrar
AS
BEGIN
    SELECT DB_NAME() AS [Nombre DB];
END;
GO

EXEC usp_nombredb_mostrar;
GO

```


