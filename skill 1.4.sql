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

---------------------
----DELETING DATA----
---------------------

DELETE FROM <table>
WHERE <predicate>;

DELETE FROM Sales.MyOrderDetails
WHERE productid = 11;

--Deleting by steps
WHILE 1 = 1
BEGIN
DELETE TOP (1000) FROM Sales.MyOrderDetails
WHERE productid = 12;
IF @@rowcount < 1000 BREAK;
END

--Truncating
TRUNCATE TABLE Sales.MyOrderDetails;
TRUNCATE TABLE MyTable WITH ( PARTITIONS(1, 2, 11 TO 20) );

------------------
----MERGE DATA----
------------------

MERGE INTO <target table> AS TGT
USING <SOURCE TABLE> AS SRC
ON <merge predicate>
	WHEN MATCHED [AND <predicate>] -- two clauses allowed:
		THEN <action> -- one with UPDATE one with DELETE
	WHEN NOT MATCHED [BY TARGET] [AND <predicate>] -- one clause allowed:
		THEN INSERT... –- if indicated, action must be INSERT
	WHEN NOT MATCHED BY SOURCE [AND <predicate>] -- two clauses allowed:
		THEN <action>; -- one with UPDATE one with DELETE

--Example
DECLARE
	@orderid AS INT = 1, @custid AS INT = 1,
	@empid AS INT = 2, @orderdate AS DATE = '20170212';
MERGE INTO Sales.MyOrders WITH (SERIALIZABLE) AS TGT
USING (VALUES(@orderid, @custid, @empid, @orderdate))
	AS SRC( orderid, custid, empid, orderdate)
ON SRC.orderid = TGT.orderid
WHEN MATCHED THEN
UPDATE
	SET TGT.custid = SRC.custid,
	TGT.empid = SRC.empid,
	TGT.orderdate = SRC.orderdate
WHEN NOT MATCHED THEN
	INSERT VALUES(SRC.orderid, SRC.custid, SRC.empid, SRC.orderdate);

--------------------------
----structural changes----
--------------------------

----ADD----
ALTER TABLE <table_name> ADD <column_definition> [<column_constraint>] [WITH VALUES];

ALTER TABLE Sales.MyOrders
ADD requireddate DATE NOT NULL
CONSTRAINT DFT_MyOrders_requireddate DEFAULT ('19000101') WITH VALUES;

----DROP----
ALTER TABLE <table_name> DROP COLUMN <column_name>;

ALTER TABLE Sales.MyOrders DROP COLUMN requireddate;

----ALTERING----
ALTER TABLE <table_name> ALTER COLUMN <column_definition> WITH ( ONLINE = ON | OFF );

ALTER TABLE Sales.MyOrders ALTER COLUMN requireddate DATETIME NOT NULL;






















