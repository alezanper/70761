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

--------------------------------
---Function to return a table---
--------------------------------
DROP FUNCTION IF EXISTS DB.GetTeam;
GO
CREATE FUNCTION DB.GetTeam(@jobtitle AS NVARCHAR(50)) RETURNS TABLE
AS
RETURN
WITH Full_Employees AS
(
SELECT 
P.boid,
P.ti,
P.id,
P.name,
P.lastname,
E.jobtitle,
E.salary
 FROM DB.EMPLOYEES E
JOIN DB.PEOPLE P
ON E.boid = P.boid
WHERE E.jobtitle = @jobtitle
)
SELECT *
FROM Full_Employees;

--Get Team testers
SELECT *
FROM DB.GetTeam('Software Engineer') AS M;
GO