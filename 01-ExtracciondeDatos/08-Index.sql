use SalesDB;

--Crear una tabla como una copia de Customers
SELECT * 
INTO Sales.DBCustomers
FROM Sales.Customers;

SELECT * 
FROM Sales.DBCustomers
WHERE CustomerID = 1;

--Crear un Clustered Index on Sales.DbCustomers usando el customerID
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers(CustomerID);