USE TEST;
--------------------------
---Conversion Functions---
--------------------------
SELECT TRY_CONVERT(DATE, '14/02/2017', 101) AS col1,	--NULL
TRY_CONVERT(DATE, '02/14/2017', 101) AS col2;	--2017-02-14

--------------------
---Date Functions---
--------------------
SELECT FORMAT(SYSDATETIME(), 'yyyy-MM-dd');	--2019-01-06
SELECT DATEPART(month, '20190212');	--2
SELECT DATENAME(month, '20190212');	--February
SELECT DATEFROMPARTS(2019, 02, 12);	--2017-02-12
SELECT EOMONTH(SYSDATETIME());	--2019-01-31 (End of month)
SELECT DATEADD(year, 1, '20190212');	--2020-02-12 00:00:00.000
SELECT DATEDIFF(day, '20190212', '20190212');	--366
SELECT DATEDIFF(year, '20191231', '20190101');	--1
SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '-08:00');

--------------------
---CHAR FUNCTIONS---
--------------------
SELECT SUBSTRING('abcde', 1, 3);	--abc
SELECT LEFT('abcde', 3);	--abc
SELECT RIGHT('abcde', 3);	--cde
SELECT CHARINDEX(' ', 'Alexander Benavides');	--10
SELECT LEN('Alex');	--4
SELECT REPLACE('A.L.E.X', '.', ' ');	--A L E X
SELECT REPLICATE('A', 5);	--AAAAA
SELECT FORMAT(2019, 'd10');	--0000002019

----------------------
---CASE EXPRESSIONS---
----------------------
SELECT C.*,
CASE c.contacttype
	WHEN 'A' THEN 'Address'
	WHEN 'C' THEN 'Phone'
	ELSE 'Unknown'
END AS Contact_Description
FROM DB.CONTACT C;

-------------------------
---Coalesce and Isnull---
-------------------------
DECLARE
@x AS VARCHAR(3) = NULL,
@y AS VARCHAR(10) = '1234567890';
SELECT COALESCE(@x, @y) AS [COALESCE], ISNULL(@x, @y) AS [ISNULL];

---------------------
--SYSTEM FUNCTIONS---
---------------------
--@@ROWCOUNT
--returns the number of rows affected by the last statement that you executed.
SELECT P.boid, P.ti, P.name, P.lastname
	FROM DB.PEOPLE P
WHERE P.boid = 11102;
IF @@ROWCOUNT = 0
PRINT CONCAT('Employee ', CAST(11102 AS VARCHAR(10)), ' was not found.');

--Context info
SELECT CAST(CONTEXT_INFO() AS VARCHAR(128)) AS mycontextinfo;
SELECT SESSION_CONTEXT(N'language') AS [language];
SELECT NEWID() AS myguid;	--Generating a unique identifier

-------------------------
---Arimethic Functions---
-------------------------
SELECT 11 / 2;	--5
SELECT CAST(9 AS NUMERIC(12, 2)) / CAST(2 AS NUMERIC(12, 2));	--4.500000000000000

--Using seed
SELECT RAND(1759);
SELECT RAND();

-------------------------
---Aggregate functions---
-------------------------
SELECT E.jobtitle, count(1) Total
	FROM DB.EMPLOYEES E
GROUP BY E.jobtitle
ORDER BY 2 DESC

SELECT E.jobtitle, SUM(E.salary) Total_Salary
	FROM DB.EMPLOYEES E
GROUP BY E.jobtitle
ORDER BY 2 DESC