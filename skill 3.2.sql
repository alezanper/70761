USE TSQLV4;

SET XACT_ABORT, NOCOUNT ON;
-- start a new transaction
BEGIN TRAN;
-- declare a variable
DECLARE @neworderid AS INT;
-- insert a new order into the Sales.Orders table
INSERT INTO Sales.Orders
(custid, empid, orderdate, requireddate, shippeddate,
shipperid, freight, shipname, shipaddress, shipcity,
shippostalcode, shipcountry)
VALUES
(1, 1, '20170212', '20170301', '20170216',
1, 10.00, N'Shipper 1', N'Address AAA', N'City AAA',
N'11111', N'Country AAA');
-- save the new order id in the variable @neworderid
SET @neworderid = SCOPE_IDENTITY();
PRINT 'Added new order header with order ID ' + CAST(@neworderid AS VARCHAR(10))
+ '. @@TRANCOUNT is ' + CAST(@@TRANCOUNT AS VARCHAR(10)) + '.';
-- insert order lines for new order into Sales.OrderDetails
INSERT INTO Sales.OrderDetails(orderid, productid, unitprice, qty, discount)
VALUES(@neworderid, 1, 10.00, 1, 0.000),
(@neworderid, 2, 10.00, 1, 0.000),
(@neworderid, 3, 10.00, 1, 0.000);
PRINT 'Added order lines to new order. @@TRANCOUNT is '
+ CAST(@@TRANCOUNT AS VARCHAR(10)) + '.';
-- commit the transaction
COMMIT TRAN;

--NESTED TRANSACTIONS--
--@TRANCOUNT depends of transactions
SET NOCOUNT ON;
DROP TABLE IF EXISTS dbo.T1;
GO
CREATE TABLE dbo.T1(col1 INT);
PRINT '@@TRANCOUNT before first BEGIN TRAN is '
+ CAST(@@TRANCOUNT AS VARCHAR(10)) + '.';
BEGIN TRAN;
PRINT '@@TRANCOUNT after first BEGIN TRAN is '
+ CAST(@@TRANCOUNT AS VARCHAR(10)) + '.';
BEGIN TRAN;
PRINT '@@TRANCOUNT after second BEGIN TRAN is '
+ CAST(@@TRANCOUNT AS VARCHAR(10)) + '.';
BEGIN TRAN;
PRINT '@@TRANCOUNT after third BEGIN TRAN is '
+ CAST(@@TRANCOUNT AS VARCHAR(10)) + '.';
INSERT INTO dbo.T1 VALUES(1),(2),(3);
COMMIT TRAN; -- this doesn't really commit
PRINT '@@TRANCOUNT after first COMMIT TRAN is '
+ CAST(@@TRANCOUNT AS VARCHAR(10)) + '.';
ROLLBACK TRAN; -- this does roll the transaction back
PRINT '@@TRANCOUNT after ROLLBACK TRAN is '
+ CAST(@@TRANCOUNT AS VARCHAR(10)) + '.';
SELECT col1 FROM dbo.T1;

--Working with named transactions, savepoints, and markers

SET XACT_ABORT OFF;
BEGIN TRAN OutermostTran;
BEGIN TRAN InnerTran1;
BEGIN TRAN InnerTran2;
ROLLBACK TRAN OutermostTran;
PRINT '@@TRANCOUNT is ' + CAST(@@TRANCOUNT AS VARCHAR(10)) + '.';

--Save Points--
SET XACT_ABORT, NOCOUNT ON;
DROP TABLE IF EXISTS dbo.T1;
GO
CREATE TABLE dbo.T1(col1 VARCHAR(10));
GO
BEGIN TRAN;
SAVE TRAN S1;
INSERT INTO dbo.T1(col1) VALUES('S1');
SAVE TRAN S2;
INSERT INTO dbo.T1(col1) VALUES('S2');
SAVE TRAN S3;
INSERT INTO dbo.T1(col1) VALUES('S3');
ROLLBACK TRAN S3;
ROLLBACK TRAN S2;
SAVE TRAN S4;
INSERT INTO dbo.T1(col1) VALUES('S4');
COMMIT TRAN;
SELECT col1 FROM dbo.T1;
GO
DROP TABLE IF EXISTS dbo.T1;

--Error handling with TRY-CATCH--
SET NOCOUNT ON;
USE TSQLV4;
DROP TABLE IF EXISTS dbo.T1;
GO
CREATE TABLE dbo.T1
(
keycol INT NOT NULL
CONSTRAINT PK_T1 PRIMARY KEY,
col1 INT NOT NULL
CONSTRAINT CHK_T1_col1_gtzero CHECK(col1 > 0),
col2 VARCHAR(10) NOT NULL
);

--Without error
BEGIN TRY
INSERT INTO dbo.T1(keycol, col1, col2)
VALUES(1, 10, 'AAA');
INSERT INTO dbo.T1(keycol, col1, col2)
VALUES(2, 20, 'BBB');
PRINT 'Got to end of TRY block.';
END TRY
BEGIN CATCH
PRINT 'Error occurred. Entering CATCH block. Error message: ' + ERROR_MESSAGE();
END CATCH;
GO

--With Error
BEGIN TRY
INSERT INTO dbo.T1(keycol, col1, col2)
VALUES(1, 10, 'AAA');
INSERT INTO dbo.T1(keycol, col1, col2)
VALUES(2, -20, 'BBB');
PRINT 'Got to the end of the TRY block.';
END TRY
BEGIN CATCH
PRINT 'Error occurred. Entering CATCH block. Error message: ' + ERROR_MESSAGE();
END CATCH;
GO

--Error functions--
CREATE OR ALTER PROC dbo.PrintErrorInfo
AS
PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
PRINT 'Error Message : ' + ERROR_MESSAGE();
PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
PRINT 'Error State : ' + CAST(ERROR_STATE() AS VARCHAR(10));
PRINT 'Error Line : ' + CAST(ERROR_LINE() AS VARCHAR(10));
PRINT 'Error Proc : ' + COALESCE(ERROR_PROCEDURE(), 'Not within proc');
GO

--For testing
CREATE OR ALTER PROC dbo.AddRowToT1 -- proc name
@keycol INT,
@col1 INT,
@col2 VARCHAR(10)
AS
SET NOCOUNT ON;
BEGIN TRY
INSERT INTO dbo.T1(keycol, col1, col2) -- line 11
VALUES(@keycol, @col1, @col2);
END TRY
BEGIN CATCH
EXEC dbo.PrintErrorInfo;
END CATCH;
GO

--For execution
EXEC dbo.AddRowToT1
@keycol = 1,
@col1 = -10,
@col2 = 'AAA';

--The THROW and RAISERROR commands--







