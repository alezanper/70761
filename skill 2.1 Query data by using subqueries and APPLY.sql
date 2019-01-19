USE TEST;

-------------------------------------
---Using subqueries (single value)---
-------------------------------------
SELECT P.boid, P.name, P.lastname, P.birthdate
FROM DB.PEOPLE P
WHERE P.birthdate =
(SELECT MIN(P.birthdate)
FROM DB.PEOPLE P);

----------------------------------------
---Using subqueries (multiple values)---
----------------------------------------
SELECT C.clientid, C.boid, C.location 
FROM DB.CLIENTS C
WHERE C.clientid IN
(SELECT C.clientid 
FROM DB.CLIENTS C
WHERE C.location = N'Bogotá')

------------------------
---Using ALL operator---
------------------------
SELECT E.boid, E.jobtitle, E.salary
FROM db.EMPLOYEES E
WHERE E.salary < ALL 
(SELECT F.salary 
FROM db.EMPLOYEES F 
WHERE F.jobtitle = 'Software Engineer')

------------------------
---Using ANY operator---
------------------------
SELECT E.boid, E.jobtitle, E.salary
FROM db.EMPLOYEES E
WHERE E.salary < ANY 
(SELECT F.salary 
FROM db.EMPLOYEES F 
WHERE F.jobtitle = 'Software Engineer')
----------------------
---Correlated Query---
----------------------
SELECT E.boid, E.jobtitle, E.salary
FROM DB.EMPLOYEES E
WHERE E.salary =
(SELECT MIN(F.salary)
FROM DB.EMPLOYEES F
WHERE E.jobtitle = F.jobtitle)

-------------------------------
---Using Exist and Not Exist---
-------------------------------
SELECT P.boid, P.name, P.lastname
FROM DB.PEOPLE P
WHERE EXISTS
(SELECT *
FROM DB.CLIENTS C
WHERE C.boid = P.boid)

--Must Include CROSS APPLY and OUTER APPLY