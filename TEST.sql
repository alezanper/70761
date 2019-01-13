USE master;

IF DB_ID(N'TEST') IS NOT NULL DROP DATABASE TEST;

CREATE DATABASE TEST;
GO

USE TEST;
GO

CREATE SCHEMA DB;
GO

CREATE TABLE DB.EMPLOYEES
(
	personid	INT NOT NULL,
	name		NVARCHAR(40) NOT NULL,
	lastname	NVARCHAR(40) NOT NULL,
	birthdate	DATE NOT NULL,
	salary		MONEY NOT NULL,
	CONSTRAINT PK_Person PRIMARY KEY(personid)
);

CREATE TABLE DB.contact
(
	contactid	INT NOT NULL,
	personid	INT NOT NULL,
	contact		NVARCHAR(40) NOT NULL,
	contacttype	NVARCHAR(2) NOT NULL,
	CONSTRAINT PK_Contact PRIMARY KEY(contactid),
	CONSTRAINT FK_Person FOREIGN KEY(personid) REFERENCES DB.EMPLOYEES(personid)
);

--Multiple inserts
INSERT INTO DB.EMPLOYEES(personid, name, lastname, birthdate, salary) VALUES
(1, 'Alexander', 'Benavides', '19870620', 4500.00),
(2, 'Mary', 'Martinez', '19860725', 6700.00),
(3, 'Peter', 'Gutierrez', '19931112', 6000.00),
(4, 'Juan', 'Ocampo', '19970923', 5500.00),
(5, 'Angie', 'Gomez', '19760211', 6700.00),
(6, 'Silvana', 'Marx', '19731022', 8000.00),
(7, 'Bruno', 'Rico', '19820430', 5900.00),
(8, 'Andrea', 'Roca', '19901031', 6300.00),
(9, 'Ronald', 'Morales', '19790115', 7000.00),
(10, 'John', 'Smith', '19901031', 8300.00);

--Inserting into contact table
INSERT INTO DB.Contact(contactid, personid, contact, contacttype) VALUES
(1, 1, 'Calle 45 # 34 - 23', 'A'),
(2, 1, '3179998899', 'C'),
(3, 2, 'Calle 25 # 22 - 11', 'A'),
(4, 2, '3218889999', 'C'),
(5, 3, 'carrera 2 # 4 - 19', 'A'),
(6, 3, '3109991234', 'C'),
(7, 4, 'Diagonal 12 # 34 - 23', 'A'),
(8, 4, '3009999999', 'C'),
(9, 5, 'Calle 93 sur # 92 - 12', 'A'),
(10, 5, '3111234567', 'C'),
(11, 6, 'carrera 24 este # 80 - 16', 'A'),
(12, 6, '3108888888', 'C'),
(13, 7, 'Transversal 22 # 90 - 23', 'A'),
(14, 7, '3007777777', 'C'),
(15, 8, 'Calle 55 # 87 - 33', 'A'),
(16, 8, '3006666666', 'C'),
(17, 9, 'Calle 45 # 42 - 49', 'A'),
(18, 9, '3003333333', 'C'),
(19, 10, 'Calle 95 # 7 - 66', 'A'),
(20, 10, '3001111111', 'C');

select * from DB.EMPLOYEES
