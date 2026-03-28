# Programación con Transact-SQL (T-SQL)

**Variables y Tipos de Datos**

Para declarar variables usamos la palabra clave DECLARE y el prefijo "@"

Declaración: DECLARE @NombreVariables TIPO_DE_DATO

Asignación: Se usa SET o SELECT.

## Tipos de datos comunes ##

1. Numéricos: INT, BIGINT, DECIMAL(p,s), FLOAT.

2. Texto: VARCHAR(n), CHAR(n), NVARCHAR(n)

3. Fecha: DATE, DATETIME, DATETIME2

Ejemplo:

```sql
DECLARE @EDAD INT = 25;
SET @EDAD = 30;
```

## Operadores ##

Tipo

1. Aritméticos: +, -, *, /, %

2. Relacionales =,<>, !=, <, >, <=, >=

3. Lógicos AND, OR, NOT, BETWEEN, LIKE

## Estructuras de Control y Ciclos

En T-SQL no existe el ciclo FOR. Todo se maneja con IF y WHILE

IF/ELSE

```sql
IF @Edad > 18
    PRINT 'Adulto';
ELSE
    PRINT 'Menor';
```

Ciclo WHILE

```sql
WHILE @Contador < 10
BEGIN
    SET @Contador += 1;
    IF @Contador = 5 CONTINUE;
    IF @Contador = 8 BREAK;
END
```

## Manejo de Excepciones y Transacciones ##

Las transacciones garantizan que todas las operaciones se ejecuten correctamente.
Si ocurre un error, se deshacen los cambios.

```sql
BEGIN TRY
    BEGIN TRANSACTION;
        -- Operaciones SQL
        INSERT INTO Ventas (ID) VALUES (1);
    COMMIT TRANSACTION; -- Confirma los cambios
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION; -- Deshace si hay error
    PRINT ERROR_MESSAGE();
END CATCH
```

## Objetos de Base de Datos ##


**Stored Procedures** 

(Procedimientos Almacenados)
Son ideales para ejecutar lógica de negocio compleja. Aceptan parámetros de entrada y salida.

```sql
CREATE PROCEDURE sp_ObtenerUsuario @ID INT
AS
BEGIN
    SELECT * FROM Usuarios WHERE Id = @ID;
END
```

**Funciones (UDF)**

Deben retornar un valor (escalar o tabla) y no pueden ejecutar acciones que cambien el estado de la base de datos (como INSERT o DELETE en tablas reales).

```sql
CREATE FUNCTION fn_Sumar (@a INT, @b INT)
RETURNS INT
AS
BEGIN
    RETURN @a + @b;
END
```

**Triggers (Disparadores)**

Triggers (Disparadores)
Se ejecutan automáticamente tras un INSERT, UPDATE o DELETE.

Tablas especiales: Inserted (datos nuevos) y Deleted (datos viejos).

```sql
CREATE TRIGGER trg_InsertUsuario
ON Usuarios–
AFTER INSERT
AS
BEGIN
    PRINT 'Se insertó un nuevo usuario';
END;
```

## Funciones Especiales y Formateo ##

Funciones de Cadena y Fecha

1. Cadenas: LEN(s), SUBSTRING(s, inicio, fin), REPLACE(s, viejo, nuevo), LTRIM/RTRIM.

```sql
SELECT 
    LEN('Hola') AS Longitud,
    SUBSTRING('Programacion', 1, 5) AS Subcadena,
    REPLACE('SQL Server', 'Server', '2022') AS Reemplazo,
    LTRIM('   Texto') AS SinEspaciosIzq,
    RTRIM('Texto   ') AS SinEspaciosDer;
```

2. Fechas: GETDATE(), DATEPART(year, fecha), DATEDIFF(day, f1, f2), DATEAD(month, 1, f1).

```sql
SELECT 
    GETDATE() AS FechaActual,
    DATEPART(YEAR, GETDATE()) AS Año,
    DATEDIFF(DAY, '2025-01-01', GETDATE()) AS DiasTranscurridos,
    DATEADD(MONTH, 1, GETDATE()) AS MesSiguiente;
```

Valores Nulos

1. ISNULL(@var, 0): Si es nulo, pone 0.

2. COALESCE(v1, v2, v3): Retorna el primer valor no nulo de la lista.

```sql
SELECT 
    ISNULL(NULL, 0) AS ValorConISNULL,
    COALESCE(NULL, NULL, 5, 10) AS PrimerNoNulo;
```

Format

Permite dar formato a fechas y números.

```sql
SELECT 
    FORMAT(GETDATE(), 'dd/MM/yyyy') AS FechaFormateada,
    FORMAT(12345.678, 'N2') AS NumeroFormateado;
```

**Lógica Condicional: CASE**

Permite evaluar condiciones dentro de una consulta.

```sql
SELECT Nombre,
       CASE 
           WHEN Puntos > 90 THEN 'Excelente'
           WHEN Puntos > 70 THEN 'Bueno'
           ELSE 'Regular'
       END AS Calificacion
FROM Estudiantes;
```