----------------------
----Inserting Data----
----------------------

--Single values
INSERT INTO DB.PEOPLE(boid, ti, id, name, lastname, birthdate) VALUES
(10016, 'C', 9013082,'Juana', 'La Cubana', '19341201');

--Multiple inserts
INSERT INTO DB.PEOPLE(boid, ti, id, name, lastname, birthdate) VALUES
(10017, 'P', 6223092,'John', 'Parsons', '19741011'),
(10018, 'C', 7526034,'Mark', 'Duarte', '19941224');

--Inserting using select
INSERT INTO DB.PEOPLE(boid, ti, id, name, lastname, birthdate)
SELECT P.boid+1, P.ti, P.id, P.name, P.lastname, P.birthdate
FROM DB.PEOPLE P
WHERE P.BOID = (SELECT MAX(Q.boid) FROM DB.PEOPLE Q);

--Insert using INTO
--It creates the target table
SELECT boid, ti, id, name, lastname, birthdate
INTO DB.PEOPLE_COPY
FROM DB.PEOPLE
WHERE boid = 10015;

---------------------
----UPDATING DATA----
---------------------
UPDATE DB.EMPLOYEES
SET salary += 200
WHERE boid = 10014;

---------------------
----DELETING DATA----
---------------------
DELETE FROM DB.PEOPLE
WHERE BOID = (SELECT MAX(Q.boid) FROM DB.PEOPLE Q);

--Deleting by steps
WHILE 1 = 1
BEGIN
DELETE TOP (10) FROM DB.EMPLOYEES;
IF @@rowcount < 10 BREAK;
END

SELECT * FROM DB.EMPLOYEES;

INSERT INTO DB.EMPLOYEES(boid, jobtitle, hiredate, salary, location) VALUES
(10000, 'Software Engineer', '20070325', 9000, 'Bogotá'),
(10001, 'Software Engineer', '20040510', 8200, 'Medellín'),
(10002, 'Sales Representative', '20060825', 5700, 'Bogotá'),
(10003, 'Sales Representative', '20060725', 5500, 'Medellín'),
(10004, 'Sales Manager', '20000315', 9500, 'Cali'),
(10006, 'Tester', '20090111', 6500, 'Bogotá'),
(10007, 'Software Engineer', '20111022', 6700, NULL),
(10009, 'Tester', '20120521', 5550, 'Bogotá'),
(10010, 'CEO', '19980203', 14500, 'Medellín'),
(10012, 'Sales Representative', '20050315', 4700, 'Bogotá'),
(10013, 'Architect TI', '20010921', NULL, NULL),
(10014, 'Software Engineer', '20091202', 8900, 'Bogotá'),
(10015, 'Sales Representative', '20000812', 4900, 'Medellín');

--Truncating
TRUNCATE TABLE DB.CLIENTS;

INSERT INTO DB.CLIENTS(clientid, boid, segment, score, income, location) VALUES
(100, 10005, 'Low', 900, 6500, 'Bogotá'),
(101, 10008, 'High', 100, 9500, 'Medellín'),
(102, 10009, 'Low', 300, 5550, 'Bogotá'),
(103, 10010, 'High', 200, 14500, 'Medellín'),
(104, 10011, 'Low', 900, 4500, 'Cali'),
(105, 10013, 'Med', 800, NULL, NULL);

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

--------------------------
----structural changes----
--------------------------
----ADD----
ALTER TABLE <table_name> ADD <column_definition> [<column_constraint>] [WITH VALUES];

ALTER TABLE DB.CLIENTS
ADD creationdate DATE NOT NULL
CONSTRAINT DT_creationdate DEFAULT ('20190115') WITH VALUES;

SELECT * FROM DB.CLIENTS;

------------
----DROP----
------------
DROP TABLE DB.PEOPLE_COPY;

ALTER TABLE <table_name> DROP COLUMN <column_name>;

ALTER TABLE DB.CLIENTS DROP CONSTRAINT DT_creationdate;
ALTER TABLE DB.CLIENTS DROP COLUMN creationdate;

----ALTERING----
ALTER TABLE <table_name> ALTER COLUMN <column_definition> WITH ( ONLINE = ON | OFF );
