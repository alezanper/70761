USE TEST;

--First name starting with A or B
SELECT *
FROM DB.EMPLOYEES P
WHERE p.name LIKE '[AB]%'

--Filter by date
SELECT *
FROM DB.EMPLOYEES P
WHERE P.birthdate BETWEEN '19830101' and '19861231'

--Order (default is descending)
SELECT *
FROM DB.EMPLOYEES P
ORDER BY p.lastname

--Using Top(3)
SELECT TOP (3) p.personid, p.name, p.lastname, p.birthdate
FROM DB.EMPLOYEES P
ORDER BY p.birthdate DESC;

--Using with ties (For returning all values)
SELECT TOP (3) WITH TIES p.personid, p.name, p.lastname, p.birthdate
FROM DB.EMPLOYEES P
ORDER BY p.birthdate DESC;

--Using Percent
SELECT TOP (10) PERCENT p.personid, p.name, p.lastname, p.birthdate
FROM DB.EMPLOYEES P
ORDER BY p.birthdate DESC;

--Using OFFSET-FETCH (Offset first 5 and return the next 2)
SELECT p.personid, p.name, p.lastname, p.birthdate
FROM DB.EMPLOYEES P
ORDER BY p.birthdate DESC, p.personid DESC
OFFSET 5 ROWS FETCH NEXT 2 ROWS ONLY;

-------------------------
---UNION and UNION ALL---
-------------------------

--10 ROWS (Implicit distinct)
SELECT p.personid, p.name, p.lastname
FROM DB.EMPLOYEES p
UNION 
SELECT p.personid, p.name, p.lastname
FROM DB.EMPLOYEES p

--20 ROWS (Full rows)
SELECT p.personid, p.name, p.lastname
FROM DB.EMPLOYEES p
UNION ALL
SELECT p.personid, p.name, p.lastname
FROM DB.EMPLOYEES p

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