USE TEST;

--First name starting with A or B
SELECT *
FROM DB.PEOPLE P
WHERE p.name LIKE '[AB]%';

--Filter by date
SELECT *
FROM DB.PEOPLE P
WHERE P.birthdate BETWEEN '19830101' and '19861231';

--Order (default is descending)
SELECT *
FROM DB.PEOPLE P
ORDER BY p.lastname;

--Using Top(3)
SELECT TOP (3) p.boid, p.name, p.lastname, p.birthdate
FROM DB.PEOPLE P
ORDER BY p.birthdate DESC;

--Using with ties (For returning all values)
SELECT TOP (3) WITH TIES p.boid, p.name, p.lastname, p.birthdate
FROM DB.PEOPLE P
ORDER BY p.birthdate DESC;

--Using Percent
SELECT TOP (10) PERCENT p.boid, p.name, p.lastname, p.birthdate
FROM DB.PEOPLE P
ORDER BY p.birthdate DESC;

--Using OFFSET-FETCH (Offset first 5 and return the next 10)
SELECT p.boid, p.name, p.lastname, p.birthdate
FROM DB.people P
ORDER BY p.birthdate DESC, p.boid DESC
OFFSET 5 ROWS FETCH NEXT 10 ROWS ONLY;

-------------------------
---UNION and UNION ALL---
-------------------------

--16 ROWS (Implicit distinct)
SELECT p.boid, p.name, p.lastname
FROM DB.PEOPLE p
UNION 
SELECT p.boid, p.name, p.lastname
FROM DB.PEOPLE p

--32 ROWS (Full rows)
SELECT p.boid, p.name, p.lastname
FROM DB.PEOPLE p
UNION ALL
SELECT p.boid, p.name, p.lastname
FROM DB.PEOPLE p

--INTERSECT (Implicit distinct, it includes NULLS)
SELECT boid
FROM db.people
INTERSECT
SELECT boid
FROM db.employees;

--EXCEPT (Implicit distinct, returns people who is not employees)
SELECT boid
FROM db.people
EXCEPT
SELECT boid
FROM db.employees;