USE TEST;

-----------
---VIEWS---
-----------
--You can modify data through view with appropiate permissions
--You can add indexes to views
--You can't use order by in query
GO
CREATE OR ALTER VIEW DB.VW_TotalSalary
--prevents structural changes to underlying objects while the view exists
WITH SCHEMABINDING
AS
SELECT E.jobtitle, SUM(E.salary) Total_Salary
	FROM DB.EMPLOYEES E
GROUP BY E.jobtitle;

SELECT * FROM DB.VW_TotalSalary;

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
CREATE OR ALTER FUNCTION db.GetPage(@startrow AS BIGINT, @endrow AS BIGINT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
WITH C AS
(
SELECT ROW_NUMBER() OVER (ORDER BY P.boid) rownum, 
P.boid, 
P.ti, 
P.id, 
P.name, 
P.lastname
FROM DB.PEOPLE P
)
SELECT rownum, boid, ti, id, name, lastname
FROM C
WHERE rownum BETWEEN @startrow AND @endrow;
GO

--For running use:
SELECT rownum, boid, ti, id, name, lastname
FROM db.GetPage(2, 10) AS T;

-----------------------
---Stored procedures---
-----------------------
CREATE OR ALTER PROC db.GetClient
@boid AS INT = NULL
AS
SET XACT_ABORT, NOCOUNT ON;

SELECT C.BOID, P.name, P.lastname, C.income, C.location FROM DB.CLIENTS C JOIN
DB.PEOPLE P ON
C.boid = P.boid
WHERE (C.boid = @boid OR @boid IS NULL)
GO

--For running use
EXEC db.GetClient @boid = '10005';
EXEC db.GetClient DEFAULT;

-------------
---Cursors---
-------------
DROP TABLE IF EXISTS db.Totalsum;
GO
CREATE TABLE db.Totalsum
(
id INT NOT NULL CONSTRAINT PK_TotalSum PRIMARY KEY,
qty INT NOT NULL,
tripleqty INT NULL
);
GO

--Including values
TRUNCATE TABLE db.Totalsum;
INSERT INTO db.Totalsum(id, qty)
VALUES(100,3),(101,4),(102,5),(103,5),(104,1),(105,12),(106,13),(107,9),(108,1),(109,10),(110,12),(111,14),(112,9);

--Using cursor on procedure
CREATE OR ALTER PROC db.Computetriple
@max AS INT
AS
SET XACT_ABORT, NOCOUNT ON;

DECLARE 
@qty AS INT, 
@tripleqty AS INT = 0;

DECLARE C CURSOR FOR
SELECT qty
FROM db.Totalsum
ORDER BY id;

OPEN C;

FETCH NEXT FROM C INTO @qty;
WHILE @@FETCH_STATUS = 0
BEGIN
SET @tripleqty = 3*@qty;

IF @tripleqty <= @max
BEGIN
UPDATE db.Totalsum
SET tripleqty = @tripleqty
WHERE CURRENT OF C;
SET @tripleqty = 0;
END;
ELSE
BEGIN
UPDATE db.Totalsum
SET tripleqty = @max
WHERE CURRENT OF C;
SET @tripleqty = 0;
END;

FETCH NEXT FROM C INTO @qty;
END;
CLOSE C;
DEALLOCATE C;

--Checking table
SELECT * FROM DB.Totalsum;

--Running procedure for 30
EXEC DB.Computetriple 30;

--Checking Again
SELECT * FROM DB.Totalsum;