USE TEST;

------------------
---Transactions---
------------------
SET XACT_ABORT, NOCOUNT ON;
-- start a new transaction
BEGIN TRAN;
-- declare a variables
DECLARE @newboid AS INT, @scopeid AS INT;

SELECT @newboid = max(boid) + 1 from db.people;

-- insert a new person into the db.people table
INSERT INTO db.PEOPLE
(boid, ti, id, name, lastname, birthdate)
VALUES
(@newboid, 'C', 1000000, 'Inuyasha', ' ', '1900-01-01');

--Checking insertion
PRINT 'Added new person with boid: ' + CAST(@newboid AS VARCHAR(10))
+ '. @@TRANCOUNT is ' + CAST(@@TRANCOUNT AS VARCHAR(10)) + '.';

--New boid
SELECT @newboid = max(boid) + 1 from db.people;

-- insert a new person into the db.people table
INSERT INTO db.PEOPLE
(boid, ti, id, name, lastname, birthdate)
VALUES
(@newboid, 'C', 2000000, 'Kagome', ' ', '1900-01-01');

-- Checking insertion
PRINT 'Added new person with boid: ' + CAST(@newboid AS VARCHAR(10))
+ '. @@TRANCOUNT is ' + CAST(@@TRANCOUNT AS VARCHAR(10)) + '.';
COMMIT TRAN;

SELECT * FROM DB.PEOPLE;

--For cleaning transactions
BEGIN TRAN;
DELETE FROM DB.PEOPLE 
WHERE name='Inuyasha' or name = 'Kagome';
COMMIT TRAN;

-------------------------
---NESTED TRANSACTIONS---
-------------------------
--@TRANCOUNT depends of transactions
SET NOCOUNT ON;
DROP TABLE IF EXISTS db.Testtable;
GO
CREATE TABLE db.Testtable(col1 INT);
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
INSERT INTO db.Testtable VALUES(1),(2),(3);
COMMIT TRAN; -- this doesn't really commit
PRINT '@@TRANCOUNT after first COMMIT TRAN is '
+ CAST(@@TRANCOUNT AS VARCHAR(10)) + '.';
ROLLBACK TRAN; -- this does roll the transaction back
PRINT '@@TRANCOUNT after ROLLBACK TRAN is '
+ CAST(@@TRANCOUNT AS VARCHAR(10)) + '.';
SELECT col1 FROM db.Testtable;

--------------------------------------------------------------
---Working with named transactions, savepoints, and markers---
--------------------------------------------------------------
---Named Transactions---
SET XACT_ABORT OFF;
BEGIN TRAN O1;
BEGIN TRAN I1;
BEGIN TRAN I2;
ROLLBACK TRAN O1;
PRINT '@@TRANCOUNT is ' + CAST(@@TRANCOUNT AS VARCHAR(10));

-----------------
---Save Points---
-----------------
SET XACT_ABORT, NOCOUNT ON;
DROP TABLE IF EXISTS db.Testtable;
GO
CREATE TABLE db.Testtable(col1 VARCHAR(10));
GO
BEGIN TRAN;
SAVE TRAN S1;
INSERT INTO db.Testtable(col1) VALUES('S1');
SAVE TRAN S2;
INSERT INTO db.Testtable(col1) VALUES('S2');
SAVE TRAN S3;
INSERT INTO db.Testtable(col1) VALUES('S3');
ROLLBACK TRAN S3;
ROLLBACK TRAN S2;
SAVE TRAN S4;
INSERT INTO db.Testtable(col1) VALUES('S4');
COMMIT TRAN;
SELECT col1 FROM db.Testtable;
GO
DROP TABLE IF EXISTS db.Testtable;

-----------------------------------
---Error handling with TRY-CATCH---
-----------------------------------
SET NOCOUNT ON;

DROP TABLE IF EXISTS db.Testtable;
GO
CREATE TABLE db.Testtable
(
id INT NOT NULL CONSTRAINT PK_id PRIMARY KEY,
salary MONEY NOT NULL
CONSTRAINT CHK_money CHECK(salary > 0)
);

--Without error
BEGIN TRY
INSERT INTO db.Testtable(id, salary)
VALUES(1, 1800);
INSERT INTO db.Testtable(id, salary)
VALUES(2, 2200);
END TRY
BEGIN CATCH
PRINT 'Check your inserts ' + ERROR_MESSAGE();
END CATCH;
GO

TRUNCATE TABLE db.Testtable;

--With Error
BEGIN TRY
INSERT INTO db.Testtable(id, salary)
VALUES(1, 1800);
INSERT INTO db.Testtable(id, salary)
VALUES(2, -2200);
END TRY
BEGIN CATCH
PRINT 'Check your inserts ' + ERROR_MESSAGE();
END CATCH;
GO

---------------------
---Error functions---
---------------------
CREATE OR ALTER PROC db.PrintErrorInfo
AS
PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
PRINT 'Error Message : ' + ERROR_MESSAGE();
PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
PRINT 'Error State : ' + CAST(ERROR_STATE() AS VARCHAR(10));
PRINT 'Error Line : ' + CAST(ERROR_LINE() AS VARCHAR(10));
PRINT 'Error Proc : ' + COALESCE(ERROR_PROCEDURE(), 'Not within proc');
GO

TRUNCATE TABLE db.Testtable;

--For testing
CREATE OR ALTER PROC db.checkerrorFunction -- proc name
@id AS INT,
@salary AS MONEY
AS
SET NOCOUNT ON;
BEGIN TRY
INSERT INTO db.Testtable(id, salary)
VALUES(@id, @salary);
END TRY
BEGIN CATCH
EXEC db.PrintErrorInfo;
END CATCH;
GO

--For execution
EXEC db.checkerrorFunction
@id = 10,
@salary = -2000;

--The THROW and RAISERROR commands--