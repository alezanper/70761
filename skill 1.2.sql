--Join
SELECT E.empid,
E.firstname + N' ' + E.lastname AS emp,
M.firstname + N' ' + M.lastname AS mgr
FROM HR.Employees AS E
INNER JOIN HR.Employees AS M
ON E.mgrid = M.empid;

--Left Join (Full employees E including not match)
SELECT E.empid,
E.firstname + N' ' + E.lastname AS emp,
M.firstname + N' ' + M.lastname AS mgr
FROM HR.Employees AS E
LEFT OUTER JOIN HR.Employees AS M
ON E.mgrid = M.empid;

--Using And on Join to add keys

-- Including null handling (low performance)
SELECT EL.country, EL.region, EL.city, EL.numemps, CL.numcusts
FROM dbo.EmpLocations AS EL
INNER JOIN dbo.CustLocations AS CL
ON EL.country = CL.country
AND ISNULL(EL.region, N'<N/A>') = ISNULL(CL.region, N'<N/A>')
AND EL.city = CL.city;

-- (high performance)
SELECT EL.country, EL.region, EL.city, EL.numemps, CL.numcusts
FROM dbo.EmpLocations AS EL
INNER MERGE JOIN dbo.CustLocations AS CL
ON EL.country = CL.country
AND (EL.region = CL.region OR (EL.region IS NULL AND CL.region IS NULL))
AND EL.city = CL.city;

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