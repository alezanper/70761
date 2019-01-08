USE TSQLV4;

--Group by shipperid
SELECT shipperid,
	COUNT(*) AS numorders,	--Count full
	COUNT(shippeddate) AS shippedorders,	--Count not nulls
	MIN(shippeddate) AS firstshipdate,
	MAX(shippeddate) AS lastshipdate,
	SUM(val) AS totalvalue
FROM Sales.OrderValues
GROUP BY shipperid;

--Working with multiple grouping sets
SELECT shipperid, YEAR(shippeddate) AS shipyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE shippeddate IS NOT NULL -- exclude unshipped orders
GROUP BY GROUPING SETS
(
( shipperid, YEAR(shippeddate) ),
( shipperid ),
( YEAR(shippeddate) ),
( )
);

--Using CUBE
--Cube generates all posibilities
SELECT shipperid, YEAR(shippeddate) AS shipyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE shippeddate IS NOT NULL
GROUP BY CUBE( shipperid, YEAR(shippeddate) );

--Using ROLLUP
--Rollup makes all possible combinations when there�s a natural hierarchy
SELECT shipcountry, shipregion, shipcity, COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY ROLLUP( shipcountry, shipregion, shipcity );

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
WITH PivotData AS
(
	SELECT
		custid, -- grouping column
		shipperid, -- spreading column
		freight -- aggregation column
	FROM Sales.Orders
)
SELECT custid, [1], [2], [3]
FROM PivotData
	PIVOT(SUM(freight) FOR shipperid IN ([1],[2],[3]) ) AS P;

--UnPivoting
SELECT < column list >, < names column >, < values column >
FROM < source table >
UNPIVOT( < values column > FOR < names column > IN( <source columns> ) ) AS U;

SELECT custid, shipperid, freight
FROM Sales.FreightTotals
UNPIVOT( freight FOR shipperid IN([1],[2],[3]) ) AS U;

--Using Window Functions

--Window aggregate functions
SELECT custid, orderid, val,
	SUM(val) OVER(PARTITION BY custid) AS custtotal,
	SUM(val) OVER() AS grandtotal
FROM Sales.OrderValues;

--Window Ranking Functions
SELECT custid, orderid, val,
	ROW_NUMBER() OVER(ORDER BY val) AS rownum,
	RANK() OVER(ORDER BY val) AS rnk,
	DENSE_RANK() OVER(ORDER BY val) AS densernk,
	NTILE(100) OVER(ORDER BY val) AS ntile100
FROM Sales.OrderValues;

--Window Offset Functions
SELECT custid, orderid, orderdate, val,
LAG(val) OVER(PARTITION BY custid
ORDER BY orderdate, orderid) AS prev_val,
LEAD(val) OVER(PARTITION BY custid
ORDER BY orderdate, orderid) AS next_val
FROM Sales.OrderValues;












