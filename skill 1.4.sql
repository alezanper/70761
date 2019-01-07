-------------------
----INSERT DATA----
-------------------

--Single alues
INSERT INTO Sales.MyOrders(custid, empid, orderdate, shipcountry, freight)
VALUES(2, 19, '20170620', N'USA', 30.00);

--Multiple inserts
INSERT INTO Sales.MyOrders(custid, empid, orderdate, shipcountry, freight) VALUES
(2, 11, '20170620', N'USA', 50.00),
(5, 13, '20170620', N'USA', 40.00),
(7, 17, '20170620', N'USA', 45.00);

--Inserting using select
INSERT INTO Sales.MyOrders(orderid, custid, empid, orderdate, shipcountry, freight)
SELECT orderid, custid, empid, orderdate, shipcountry, freight
FROM Sales.Orders
WHERE shipcountry = N'Norway';

--Insert using INTO
--It creates the target table
SELECT orderid, custid, orderdate, shipcountry, freight
INTO Sales.MyOrders
FROM Sales.Orders
WHERE shipcountry = N'Norway';

---------------------
----UPDATING DATA----
---------------------

UPDATE <target table>
SET <col 1> = <expression 1>,
	...,
	<col n> = <expression n>
WHERE <predicate>;

UPDATE Sales.MyOrderDetails
SET discount += 0.05
WHERE orderid = 10251;






