USE master;

IF DB_ID(N'TEST') IS NOT NULL DROP DATABASE TEST;

CREATE DATABASE TEST;
GO

USE TEST;
GO

CREATE SCHEMA DB;
GO

CREATE TABLE DB.people
(
	id			INT NOT NULL,
	name		NVARCHAR(40) NOT NULL,
	lastname	NVARCHAR(40) NOT NULL,
	address		NVARCHAR(40) NOT NULL,
	phone		NVARCHAR(24) NOT NULL,
	birthday	DATE NOT NULL,
	salary		MONEY NOT NULL,
	CONSTRAINT PK_People PRIMARY KEY(id)
);

--Multiple inserts
INSERT INTO DB.people(id, name, lastname, address, phone, birthday, salary) VALUES
(1, 'Alexander', 'Benavides', 'Calle 45 # 34 - 23', '3179998899', '19870620', 4500.00),
(2, 'Mary', 'Martinez', 'Calle 25 # 22 - 11', '3218889999', '19860725', 6700.00),
(3, 'Peter', 'Gutierrez', 'carrera 2 # 4 - 19', '3109991234', '19931112', 6000.00),
(4, 'Juan', 'Ocampo', 'Diagonal 12 # 34 - 23', '3009999999', '19970923', 5500.00),
(5, 'Angie', 'Gomez', 'Calle 93 sur # 92 - 12', '3111234567', '19760211', 6700.00),
(6, 'Silvana', 'Marx', 'carrera 24 este # 80 - 16', '3108888888', '19731022', 8000.00),
(7, 'Bruno', 'Rico', 'Transversal 22 # 90 - 23', '3007777777', '19820430', 5900.00),
(8, 'Andrea', 'Roca', 'Calle 55 # 87 - 33', '3006666666', '19901031', 6300.00),
(9, 'Ronald', 'Morales', 'Calle 45 # 42 - 49', '3003333333', '19790115', 7000.00);

select * from db.people
