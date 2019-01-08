USE TEST;

--First name starting with A or B
SELECT *
FROM DB.people P
WHERE p.name LIKE '[AB]%'

--Filter by date
SELECT *
FROM DB.PEOPLE P
WHERE P.birthdate BETWEEN '19830101' and '19861231'

--Order (default is descending)
SELECT *
FROM HR.Employees H
ORDER BY H.empid

--Using Top(3)
SELECT TOP (3) orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

--Using with ties (For returning all values)
SELECT TOP (3) WITH TIES orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

--Using Percent
SELECT TOP (1) PERCENT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

--Using OFFSET-FETCH (Offset first 50 and return the next 25)
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC, orderid DESC
OFFSET 50 ROWS FETCH NEXT 25 ROWS ONLY;

USE TSQLV4;

--UNION and UNION ALL
--71 ROWS (Implicit distinct)
SELECT country, region, city
FROM HR.Employees
UNION 
SELECT country, region, city
FROM Sales.Customers;

--100 ROWS (Full columns)
SELECT country, region, city
FROM HR.Employees
UNION ALL
SELECT country, region, city
FROM Sales.Customers;

--INTERSECT (Implicit distinct, it includes NULLS)
SELECT country, region, city
FROM HR.Employees
INTERSECT
SELECT country, region, city
FROM Sales.Customers;

--EXCEPT (Implicit distinct)
SELECT country, region, city
FROM HR.Employees
EXCEPT
SELECT country, region, city
FROM Sales.Customers;