USE TEST;

--Using subqueries (single value)
SELECT P.boid, P.name, P.lastname, P.birthdate
FROM DB.PEOPLE P
WHERE P.birthdate =
(SELECT MIN(P.birthdate)
FROM DB.PEOPLE P);

--Using subqueries (multiple values)
SELECT C.clientid, C.boid, C.location 
FROM DB.CLIENTS C
WHERE C.clientid IN
(SELECT C.clientid 
FROM DB.CLIENTS C
WHERE C.location = N'Bogotá')

--Using ALL operator
SELECT productid, productname, unitprice
FROM Production.Products
WHERE unitprice <= ALL (SELECT unitprice FROM Production.Products);

--Using ANY operator
SELECT productid, productname, unitprice
FROM Production.Products
WHERE unitprice > ANY (SELECT unitprice FROM Production.Products);

--Correlated Query
SELECT categoryid, productid, productname, unitprice
FROM Production.Products AS P1
WHERE unitprice =
(SELECT MIN(unitprice)
FROM Production.Products AS P2
WHERE P2.categoryid = P1.categoryid);

--Using Exist and Not Exist
SELECT custid, companyname
FROM Sales.Customers AS C
WHERE EXISTS
(SELECT *
FROM Sales.Orders AS O
WHERE O.custid = C.custid
AND O.orderdate = '20070212');

--Using CROSS APPLY
SELECT S.supplierid, S.companyname AS supplier, A.*
FROM Production.Suppliers AS S
CROSS APPLY (SELECT TOP (2) productid, productname, unitprice
FROM Production.Products AS P
WHERE P.supplierid = S.supplierid
ORDER BY unitprice, productid) AS A
WHERE S.country = N'Japan';

--Using OUTER APPLY
SELECT S.supplierid, S.companyname AS supplier, A.*
FROM Production.Suppliers AS S
OUTER APPLY (SELECT TOP (2) productid, productname, unitprice
FROM Production.Products AS P
WHERE P.supplierid = S.supplierid
ORDER BY unitprice, productid) AS A
WHERE S.country = N'Japan';