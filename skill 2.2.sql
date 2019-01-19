USE TEST;

--------------------
---Derived tables---
--------------------
SELECT
ROW_NUMBER() OVER(PARTITION BY E.jobtitle
ORDER BY E.jobtitle) AS rownum,
E.boid, e.jobtitle, e.location
FROM DB.EMPLOYEES E;

------------------------------
---Common table expressions---
------------------------------
--Using a single table expression
WITH FULL_CLIENTS AS
(
SELECT C.boid, 
P.name, 
P.lastname, 
P.ti, P.id, 
C.income, 
C.location, 
C.score, 
C.segment
FROM DB.CLIENTS C
JOIN DB.PEOPLE P
ON C.boid = P.boid
)
SELECT F.boid, F.name, F.lastname, F.score
FROM FULL_CLIENTS F;

---------------------------------------------
---Views and inline table-valued functions---
---------------------------------------------
DROP VIEW IF EXISTS DB.VW_FULL_CLIENTS;
GO

CREATE VIEW DB.VW_FULL_CLIENTS
AS
SELECT C.boid, 
P.name, 
P.lastname, 
P.ti, P.id, 
C.income, 
C.location, 
C.score, 
C.segment
FROM DB.CLIENTS C
JOIN DB.PEOPLE P
ON C.boid = P.boid
GO;

SELECT * FROM DB.VW_FULL_CLIENTS;


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

