USE TEST;

------------------------------------
--System-versioned temporal tables--
------------------------------------

--Run if you want to drop tables
ALTER TABLE DB.PETS SET (SYSTEM_VERSIONING = OFF);
DROP TABLE db.PetsHistory;
DROP TABLE DB.PETS;

--Creating table with history control
CREATE TABLE DB.PETS
(
	petid INT NOT NULL CONSTRAINT PK_pets PRIMARY KEY(petid),
	petname NVARCHAR(30) NOT NULL,
	petprice MONEY NOT NULL,
	-- below are additions related to temporal table
	validfrom DATETIME2(3) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	validto DATETIME2(3)
	GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	PERIOD FOR SYSTEM_TIME (validfrom, validto)
)
WITH ( SYSTEM_VERSIONING = ON ( HISTORY_TABLE = db.PetsHistory ) );

--Adding information
INSERT INTO DB.PETS(petid, petname, petprice) VALUES
(80000, 'Spike', 1000),
(80001, 'Kylie', 800),
(80002, 'kaiser', 1100),
(80003, 'Kenay', 1200),
(80004, 'Alexa', 900),
(80005, 'Madara', 1500);

--Checking Information
SELECT * FROM DB.PETS;


--Modifying data for checking 
BEGIN TRAN;
UPDATE DB.PETS
SET petprice *= 1.1
WHERE petid = 80004;
--WAITFOR DELAY '00:00:05.000';
UPDATE DB.PETS
SET petprice *= 0.97
WHERE petid = 80003;
--WAITFOR DELAY '00:00:05.000';
UPDATE DB.PETS
SET petname = 'Manchas'
WHERE petid = 80001;
COMMIT TRAN;

--Checking for changes
SELECT * FROM DB.PETSHISTORY;

--Producing and using XML in queries
SELECT Customer.custid, Customer.companyname,
[Order].orderid, [Order].orderdate
FROM Sales.Customers AS Customer
INNER JOIN Sales.Orders AS [Order]
ON Customer.custid = [Order].custid
WHERE Customer.custid <= 2
AND [Order].orderid %2 = 0
ORDER BY Customer.custid, [Order].orderid
FOR XML RAW;

--Using AUTO 
WITH XMLNAMESPACES('ER70761-CustomersOrders' AS co)
SELECT [co:Customer].custid AS [co:custid],
[co:Customer].companyname AS [co:companyname],
[co:Order].orderid AS [co:orderid],
[co:Order].orderdate AS [co:orderdate]
FROM Sales.Customers AS [co:Customer]
INNER JOIN Sales.Orders AS [co:Order]
ON [co:Customer].custid = [co:Order].custid
WHERE [co:Customer].custid <= 2
AND [co:Order].orderid %2 = 0
ORDER BY [co:Customer].custid, [co:Order].orderid
FOR XML AUTO, ELEMENTS, ROOT('CustomersOrders');

--Querying XML data with XQuery
DECLARE @x AS XML = N'
<CustomersOrders>
	<Customer custid="1">
		<!-- Comment 111 -->
		<companyname>Customer NRZBB</companyname>
		<Order orderid="10692">
			<orderdate>2015-10-03T00:00:00</orderdate>
		</Order>
		<Order orderid="10702">
			<orderdate>2015-10-13T00:00:00</orderdate>
		</Order>
		<Order orderid="10952">
			<orderdate>2016-03-16T00:00:00</orderdate>
		</Order>
	</Customer>
	<Customer custid="2">
		<!-- Comment 222 -->
		<companyname>Customer MLTDN</companyname>
		<Order orderid="10308">
			<orderdate>2014-09-18T00:00:00</orderdate>
		</Order>
		<Order orderid="10952">
			<orderdate>2016-03-04T00:00:00</orderdate>
		</Order>
	</Customer>
</CustomersOrders>';
SELECT @x.query('for $i in CustomersOrders/Customer/Order
let $j := $i/orderdate
where $i/@orderid < 10900
order by ($j)[1]
return
<Order-orderid-element>
<orderid>{data($i/@orderid)}</orderid>
{$j}
</Order-orderid-element>')
AS [Filtered, sorted and reformatted orders with let clause];

--Query and output JSON data
SELECT Customer.custid, Customer.companyname,
[Order].orderid, [Order].orderdate
FROM Sales.Customers AS Customer
INNER JOIN Sales.Orders AS [Order]
ON Customer.custid = [Order].custid
WHERE Customer.custid <= 2
AND [Order].orderid %2 = 0
ORDER BY Customer.custid, [Order].orderid
FOR JSON AUTO;

--Using PATH clause
SELECT custid AS [CustomerId],
companyname AS [Company],
contactname AS [Contact.Name]
FROM Sales.Customers
WHERE custid = 1
FOR JSON PATH;

--Convert JSON data to tabular format
DECLARE @json AS NVARCHAR(MAX) = N'
{
"Customer":{
"Id":1,
"Name":"Customer NRZBB",
"Order":{
"Id":10692,
"Date":"2015-10-03",
"Delivery":null
}
}
}';
SELECT *
FROM OPENJSON(@json);

--Adding properties
DECLARE @json AS NVARCHAR(MAX) = N'
{
"Customer":{
"Id":1,
"Name":"Customer NRZBB",
"Order":{
"Id":10692,
"Date":"2015-10-03",
"Delivery":null
}
}
}';
SELECT *
FROM OPENJSON(@json)
WITH
(
CustomerId INT '$.Customer.Id',
CustomerName NVARCHAR(20) '$.Customer.Name',
Orders NVARCHAR(MAX) '$.Customer.Order' AS JSON
);

