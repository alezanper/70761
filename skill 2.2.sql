USE TSQLV4;

--Derived tables
SELECT
ROW_NUMBER() OVER(PARTITION BY categoryid
ORDER BY unitprice, productid) AS rownum,
categoryid, productid, productname, unitprice
FROM Production.Products;

--Common table expressions
--Using a single table expression
WITH <CTE_name>
AS
(
<inner_query>
)
<outer_query>;

--Using multiple table expressions
WITH C1 AS
(
SELECT ...
FROM T1
WHERE ...
),
C2 AS
(
SELECT
FROM C1
WHERE ...
)
SELECT ...
FROM C2
WHERE ...;

--Example
WITH C AS
(
SELECT ROW_NUMBER() OVER(PARTITION BY categoryid
ORDER BY unitprice, productid) AS rownum,
categoryid, productid, productname, unitprice
FROM Production.Products
)
SELECT categoryid, productid, productname, unitprice
FROM C
WHERE rownum <= 2;

--Views and inline table-valued functions--
DROP VIEW IF EXISTS Sales.RankedProducts;
GO
CREATE VIEW Sales.RankedProducts
AS
SELECT
ROW_NUMBER() OVER(PARTITION BY categoryid
ORDER BY unitprice, productid) AS rownum,
categoryid, productid, productname, unitprice
FROM Production.Products;
GO

--Return table 
DROP FUNCTION IF EXISTS HR.GetManagers;
GO
CREATE FUNCTION HR.GetManagers(@empid AS INT) RETURNS TABLE
AS
RETURN
WITH EmpsCTE AS
(
SELECT empid, mgrid, firstname, lastname, 0 AS distance
FROM HR.Employees
WHERE empid = @empid
UNION ALL
SELECT M.empid, M.mgrid, M.firstname, M.lastname, S.distance + 1 AS distance
FROM EmpsCTE AS S
JOIN HR.Employees AS M
ON S.mgrid = M.empid
)
SELECT empid, mgrid, firstname, lastname, distance
FROM EmpsCTE;
GO

