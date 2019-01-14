USE TEST;
--Join (It shows only matches)
SELECT P.BOID, P.NAME, P.LASTNAME, E.JOBTITLE, E.HIREDATE, E.SALARY
FROM DB.PEOPLE P 
INNER JOIN DB.EMPLOYEES AS E
ON E.BOID = P.BOID;

--Left Join (Full people, including not employees. NULL for not employees)
SELECT P.BOID, P.NAME, P.LASTNAME, E.JOBTITLE, E.HIREDATE, E.SALARY
FROM DB.PEOPLE P 
LEFT JOIN DB.EMPLOYEES AS E
ON E.BOID = P.BOID;

--Join does not includes nulls
SELECT C.boid, E.JOBTITLE, E.HIREDATE, E.SALARY, E.LOCATION
FROM DB.CLIENTS C
INNER JOIN DB.EMPLOYEES AS E
ON C.income = E.salary;

-- Including null handling (low performance)
SELECT C.boid, E.JOBTITLE, E.HIREDATE, E.SALARY, E.LOCATION
FROM DB.CLIENTS C
INNER JOIN DB.EMPLOYEES AS E
ON ISNULL(C.income, 0) = ISNULL(E.salary, 0);

-- (high performance)
SELECT C.boid, E.JOBTITLE, E.HIREDATE, E.SALARY, E.LOCATION
FROM DB.CLIENTS C
INNER JOIN DB.EMPLOYEES AS E
ON C.income = E.salary
OR (C.income IS NULL AND E.salary IS NULL);

--Wrong query
SELECT
S.companyname AS supplier, S.country,
P.productid, P.productname, P.unitprice,
C.categoryname
FROM Production.Suppliers AS S
LEFT OUTER JOIN Production.Products AS P
ON S.supplierid = P.supplierid
INNER JOIN Production.Categories AS C
ON C.categoryid = P.categoryid
WHERE S.country = N'Japan';

--Correct query
SELECT
S.companyname AS supplier, S.country,
P.productid, P.productname, P.unitprice,
C.categoryname
FROM Production.Suppliers AS S
LEFT OUTER JOIN
(Production.Products AS P
INNER JOIN Production.Categories AS C
ON C.categoryid = P.categoryid)
ON S.supplierid = P.supplierid
WHERE S.country = N'Japan';