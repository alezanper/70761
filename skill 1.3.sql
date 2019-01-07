USE TSQLV4;

SELECT TRY_CONVERT(DATE, '14/02/2017', 101) AS col1,	--NULL
TRY_CONVERT(DATE, '02/14/2017', 101) AS col2;	--2017-02-14

SELECT FORMAT(SYSDATETIME(), 'yyyy-MM-dd');	--2019-01-06
SELECT DATEPART(month, '20170212');	--2
SELECT DATENAME(month, '20170212');	--February
SELECT DATEFROMPARTS(2017, 02, 12);	--2017-02-12
SELECT EOMONTH(SYSDATETIME());	--2019-01-31 (End of month)
SELECT DATEADD(year, 1, '20170212');	--2018-02-12 00:00:00.000
SELECT DATEDIFF(day, '20160212', '20170212');	--366
SELECT DATEDIFF(year, '20161231', '20170101');	--1
SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '-08:00');

--CHAR FUNCTIONS
SELECT SUBSTRING('abcde', 1, 3);	--abc
SELECT LEFT('abcde', 3);	--abc
SELECT RIGHT('abcde', 3);	--cde
SELECT CHARINDEX(' ', 'Alexander Benavides');	--10
SELECT LEN('Alex')	--4
SELECT REPLACE('A.L.E.X', '.', ' ');	--A L E X
SELECT REPLICATE('A', 5);	--AAAAA
SELECT FORMAT(2019, 'd10');	--0000002019

--CASE EXPRESSIONS
SELECT productid, productname, unitprice, discontinued,
CASE discontinued
	WHEN 0 THEN 'No'
	WHEN 1 THEN 'Yes'
	ELSE 'Unknown'
END AS discontinued_desc
FROM Production.Products;

--Coalesce and Isnull
DECLARE
@x AS VARCHAR(3) = NULL,
@y AS VARCHAR(10) = '1234567890';
SELECT COALESCE(@x, @y) AS [COALESCE], ISNULL(@x, @y) AS [ISNULL];

--SYSTEM FUNCTIONS
--@@ROWCOUNT
--returns the number of rows affected by the last statement that you executed.
SELECT empid, firstname, lastname
	FROM HR.Employees
WHERE empid = 10;
IF @@ROWCOUNT = 0
PRINT CONCAT('Employee ', CAST(10 AS VARCHAR(10)), ' was not found.');

--Context info
SELECT CAST(CONTEXT_INFO() AS VARCHAR(128)) AS mycontextinfo;
SELECT SESSION_CONTEXT(N'language') AS [language];
SELECT NEWID() AS myguid;	--Generating a unique identifier
