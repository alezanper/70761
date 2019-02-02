USE TEST;

-----------
---VIEWS---
-----------
--You can modify data through view with appropiate permissions
--You can add indexes to views
--You can't use order by in query
GO
CREATE OR ALTER VIEW DB.TotalSalary
--prevents structural changes to underlying objects while the view exists
WITH SCHEMABINDING
AS
SELECT E.jobtitle, SUM(E.salary) Total_Salary
	FROM DB.EMPLOYEES E
GROUP BY E.jobtitle
GO;

SELECT * FROM DB.TotalSalary;

----------------------------
---User-defined functions---
----------------------------
--You cannot:
--Use error handling
--Modify data (other than in table variables)
--Use data definition language (DDL)
--Use temporary tables
--Use dynamic SQL

--Scalar user-defined functions--
CREATE OR ALTER FUNCTION db.GetTotalSalary(@location AS NVARCHAR(30))
RETURNS MONEY
WITH SCHEMABINDING
AS
BEGIN
DECLARE @totalsalary AS MONEY;
WITH Emps AS
(
SELECT E.salary, E.location
FROM DB.EMPLOYEES E
WHERE E.location = @location
)
SELECT @totalsalary = SUM(salary)
FROM Emps;
RETURN @totalsalary;
END;
GO

--Testing
SELECT db.GetTotalSalary('Bogotá') AS TotalSalary;

------------------------
---Build in Functions---
------------------------
SELECT E.boid, SYSDATETIME() AS [SYSDATETIME], RAND() AS [RAND], NEWID() AS [NEWID]
FROM db.EMPLOYEES E;

----------------------------------------------
--Inline table-valued user-defined functions--
----------------------------------------------
--is very similar in concept to a view in the sense
--that it’s based on a single query, and you interact with it like a table expression, only unlike a
--view, it supports input parameters.

CREATE OR ALTER FUNCTION dbo.GetPage(@pagenum AS BIGINT, @pagesize AS BIGINT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
WITH C AS
(
SELECT ROW_NUMBER() OVER(ORDER BY orderdate, orderid) AS rownum,
orderid, orderdate, custid, empid
FROM Sales.Orders
)
SELECT rownum, orderid, orderdate, custid, empid
FROM C
WHERE rownum BETWEEN (@pagenum - 1) * @pagesize + 1 AND @pagenum * @pagesize;
GO


CREATE OR ALTER FUNCTION dbo.GetPage(@pagenum AS BIGINT, @pagesize AS BIGINT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
WITH C AS
(
SELECT ROW_NUMBER() OVER(ORDER BY orderdate, orderid) AS rownum,
orderid, orderdate, custid, empid
FROM Sales.Orders
)
SELECT rownum, orderid, orderdate, custid, empid
FROM C
WHERE rownum BETWEEN (@pagenum - 1) * @pagesize + 1 AND @pagenum * @pagesize;
GO






--For running use:
SELECT rownum, orderid, orderdate, custid, empid
FROM dbo.GetPage(3, 12) AS T;

--Stored procedures--
CREATE OR ALTER PROC dbo.GetOrders
@orderid AS INT = NULL,
@orderdate AS DATE = NULL,
@custid AS INT = NULL,
@empid AS INT = NULL
AS
SET XACT_ABORT, NOCOUNT ON;
SELECT orderid, orderdate, shippeddate, custid, empid, shipperid
FROM Sales.Orders
WHERE (orderid = @orderid OR @orderid IS NULL)
AND (orderdate = @orderdate OR @orderdate IS NULL)
AND (custid = @custid OR @custid IS NULL)
AND (empid = @empid OR @empid IS NULL);
GO

--For running use
EXEC dbo.GetOrders @orderdate = '20151111', @custid = 85;
EXEC dbo.GetOrders DEFAULT, '20151111', 85, DEFAULT;

--Using cursors--
DROP TABLE IF EXISTS dbo.Transactions;
GO
CREATE TABLE dbo.Transactions
(
txid INT NOT NULL CONSTRAINT PK_Transactions PRIMARY KEY,
qty INT NOT NULL,
depletionqty INT NULL
);
GO

TRUNCATE TABLE dbo.Transactions;
INSERT INTO dbo.Transactions(txid, qty)
VALUES(1,2),(2,5),(3,4),(4,1),(5,10),(6,3),(7,1),(8,2),(9,1),(10,2),(11,1),(12,9);

CREATE OR ALTER PROC dbo.ComputeDepletionQuantities
@maxallowedqty AS INT
AS
SET XACT_ABORT, NOCOUNT ON;
UPDATE dbo.Transactions
SET depletionqty = NULL
WHERE depletionqty IS NOT NULL;
DECLARE @qty AS INT, @sumqty AS INT = 0;
DECLARE C CURSOR FOR
SELECT qty
FROM dbo.Transactions
ORDER BY txid;
OPEN C;
FETCH NEXT FROM C INTO @qty;
WHILE @@FETCH_STATUS = 0
BEGIN
SET @sumqty += @qty;
IF @sumqty > @maxallowedqty
BEGIN
UPDATE dbo.Transactions
SET depletionqty = @sumqty
WHERE CURRENT OF C;
SET @sumqty = 0;
END;
FETCH NEXT FROM C INTO @qty;
END;
CLOSE C;
DEALLOCATE C;
SELECT txid, qty, depletionqty,
SUM(qty - ISNULL(depletionqty, 0))
OVER(ORDER BY txid ROWS UNBOUNDED PRECEDING) AS totalqty
FROM dbo.Transactions
ORDER BY txid;
GO




