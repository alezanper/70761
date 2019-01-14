USE master;

IF DB_ID(N'TEST') IS NOT NULL DROP DATABASE TEST;

CREATE DATABASE TEST;
GO

USE TEST;
GO

CREATE SCHEMA DB;
GO

CREATE TABLE DB.PEOPLE
(
	boid		INT NOT NULL,
	ti			NVARCHAR(5) NOT NULL,
	id			INT NOT NULL,
	name		NVARCHAR(40) NOT NULL,
	lastname	NVARCHAR(40) NOT NULL,
	birthdate	DATE NOT NULL,
	CONSTRAINT PK_PEOPLE PRIMARY KEY(boid)
);

--Multiple inserts
INSERT INTO DB.PEOPLE(boid, ti, id, name, lastname, birthdate) VALUES
(10000, 'C', 7975001, 'Alexander', 'Benavides', '19870620'),
(10001, 'C', 2004501, 'Andrea', 'Torres', '19931112'),
(10002, 'C', 7000203,'Mary', 'Martinez', '19860725'),
(10003, 'R', 1040031,'Peter', 'Gutierrez', '19931112'),
(10004, 'C', 2009004,'Juan', 'Ocampo', '19970923'),
(10005, 'C', 3003001,'Angie', 'Gomez', '19760211'),
(10006, 'T', 1301001,'Silvana', 'Marx', '19731022'),
(10007, 'C', 3000021,'Bruno', 'Rico', '19820430'),
(10008, 'C', 1050101,'Andrea', 'Roca', '19901031'),
(10009, 'P', 6070021,'Ronald', 'Morales', '19790115'),
(10010, 'C', 8007013,'John', 'Smith', '19751031'),
(10011, 'C', 9208032,'Peter', 'Smith', '19830620'),
(10012, 'C', 8902066,'Alice', 'Martinez', '19890808'),
(10013, 'C', 2004089,'Jean', 'Martinez', '19920925'),
(10014, 'C', 1009190,'Carlos', 'Olivera', '19961105'),
(10015, 'C', 3003021,'Lili', 'Bernal', '19661204');


CREATE TABLE DB.CLIENTS
(
	clientid	INT NOT NULL,
	boid		INT NOT NULL,
	segment		NVARCHAR(5) NOT NULL,
	score		INT,
	income		MONEY,
	location    NVARCHAR(20),
	CONSTRAINT PK_Client PRIMARY KEY(clientid),
	CONSTRAINT FK_Person FOREIGN KEY(boid) REFERENCES DB.PEOPLE(boid)
);

--Multiple inserts
INSERT INTO DB.CLIENTS(clientid, boid, segment, score, income, location) VALUES
(100, 10005, 'Low', 900, 6500, 'Bogotá'),
(101, 10008, 'High', 100, 9500, 'Medellín'),
(102, 10009, 'Low', 300, 5550, 'Bogotá'),
(103, 10010, 'High', 200, 14500, 'Medellín'),
(104, 10011, 'Low', 900, 4500, 'Cali'),
(105, 10013, 'Med', 800, NULL, NULL);

CREATE TABLE DB.EMPLOYEES
(
	boid		INT NOT NULL,
	jobtitle	NVARCHAR(40) NOT NULL,
	hiredate	DATE NOT NULL,
	salary		MONEY,
	location	NVARCHAR(20),
	CONSTRAINT PK_EMPLOYEE PRIMARY KEY(boid),
	CONSTRAINT FK_PEOPLE_EMPLOYEE FOREIGN KEY(boid) REFERENCES DB.PEOPLE(boid)
);

--Multiple inserts
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

CREATE TABLE DB.CONTACT
(
	contactid	INT NOT NULL,
	boid		INT NOT NULL,
	contact		NVARCHAR(40) NOT NULL,
	contacttype	NVARCHAR(2) NOT NULL,
	CONSTRAINT PK_CONTACT PRIMARY KEY(contactid),
	CONSTRAINT FK_CONTACT_PEOPLE FOREIGN KEY(boid) REFERENCES DB.PEOPLE(boid)
);


--Inserting into contact table
INSERT INTO DB.Contact(contactid, boid, contact, contacttype) VALUES
(1, 10001, 'Calle 45 # 34 - 23', 'A'),
(2, 10001, '3179998899', 'C'),
(3, 10002, 'Calle 25 # 22 - 11', 'A'),
(4, 10002, '3218889999', 'C'),
(5, 10003, 'carrera 2 # 4 - 19', 'A'),
(6, 10003, '3109991234', 'C'),
(7, 10004, 'Diagonal 12 # 34 - 23', 'A'),
(8, 10004, '3009999999', 'C'),
(9, 10005, 'Calle 93 sur # 92 - 12', 'A'),
(10, 10005, '3111234567', 'C'),
(11, 10006, 'carrera 24 este # 80 - 16', 'A'),
(12, 10006, '3108888888', 'C'),
(13, 10007, 'Transversal 22 # 90 - 23', 'A'),
(14, 10007, '3007777777', 'C'),
(15, 10008, 'Calle 55 # 87 - 33', 'A'),
(16, 10008, '3006666666', 'C'),
(17, 10009, 'Calle 45 # 42 - 49', 'A'),
(18, 10009, '3003333333', 'C'),
(19, 10010, 'Calle 95 # 7 - 66', 'A'),
(20, 10010, '3001111111', 'C'),
(21, 10011, '3100008898', 'C'),
(22, 10011, 'Transversal 22 # 90 - 23', 'A'),
(23, 10012, '3111111111', 'C'),
(24, 10012, 'Calle 55 # 87 - 33', 'A'),
(25, 10013, '3122222222', 'C'),
(26, 10013, 'Calle 45 # 42 - 49', 'A'),
(27, 10014, '3133344334', 'C'),
(28, 10015, 'Calle 95 # 7 - 66', 'A');

SELECT * FROM DB.PEOPLE;
SELECT * FROM DB.CLIENTS;
select * from DB.EMPLOYEES;
SELECT * FROM DB.contact;