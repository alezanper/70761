USE TEST;

---------------------------
---Using GROUP Functions---
---------------------------
SELECT E.jobtitle,
	COUNT(*) AS TotalEmployees,				--Count full
	COUNT(E.salary) AS LocationNotNull,	--Count not nulls
	MIN(E.salary) AS lowestSalary,
	MAX(E.salary) AS HighestSalary,
	SUM(E.salary) AS totalSalaries
FROM DB.EMPLOYEES E
GROUP BY E.jobtitle;

-------------------------
---Using Grouping Sets---
-------------------------
SELECT e.jobtitle, E.location, COUNT(*) AS Total
FROM  DB.EMPLOYEES E
GROUP BY GROUPING SETS
(
( e.jobtitle, E.location ),
( e.jobtitle ),
( E.location ),
( )
)
ORDER BY 1, 3

----------------
---Using CUBE---
----------------
--Cube generates all posibilities
SELECT e.jobtitle, E.location, COUNT(*) AS Total
FROM  DB.EMPLOYEES E
GROUP BY CUBE( e.jobtitle, E.location )
ORDER BY 1, 3;

------------------
---Using ROLLUP---
------------------
--Rollup makes all possible combinations when there’s a natural hierarchy
SELECT E.location, E.jobtitle, COUNT(*) 
FROM db.EMPLOYEES E
GROUP BY ROLLUP( E.location, E.jobtitle );

--Pivoting Data
WITH PivotData AS
(
	SELECT
		< grouping column >,
		< spreading column >,
		< aggregation column >
	FROM < source table >
)
SELECT < select list >
FROM PivotData
	PIVOT( < aggregate function >(< aggregation column >)
		FOR < spreading column > IN (< distinct spreading values >) ) AS P;

--Example
---------------------------

--UnPivoting
SELECT < column list >, < names column >, < values column >
FROM < source table >
UNPIVOT( < values column > FOR < names column > IN( <source columns> ) ) AS U;

--Example
---------------------------

----------------------------
---Using Window Functions---
----------------------------
--Window aggregate functions
SELECT	E.boid, 
		E.jobtitle, 
		E.salary,
		SUM(E.SALARY) OVER(PARTITION BY E.jobtitle) AS areatotal,
		SUM(E.SALARY) OVER() AS totalcompany
FROM DB.EMPLOYEES E;

------------------------------------
---Using Window Ranking Functions---
------------------------------------
SELECT E.boid, E.jobtitle,
	ROW_NUMBER() OVER(ORDER BY E.jobtitle) AS rownum,
	RANK() OVER(ORDER BY E.jobtitle) AS rnk,
	DENSE_RANK() OVER(ORDER BY E.jobtitle) AS densernk,
	NTILE(100) OVER(ORDER BY E.jobtitle) AS ntile100
FROM DB.EMPLOYEES E

-----------------------------
---Window Offset Functions---
-----------------------------
SELECT E.boid, E.jobtitle, E.salary,
LAG(E.salary) OVER(PARTITION BY E.jobtitle
ORDER BY E.salary) AS prev_val,
LEAD(E.salary) OVER(PARTITION BY E.jobtitle
ORDER BY E.salary) AS next_val
FROM DB.EMPLOYEES E