USE TEST;

--Some values cannot be represented precisely
DECLARE @f AS FLOAT = 29545428.022495;
SELECT CAST(@f AS NUMERIC(28, 14)) AS numericvalue;

--Cast
SELECT CAST('Alex' AS INT);			--Generates an error
SELECT TRY_CAST('Alex' AS INT);		--Returns NULL instead of an error

--Null handling
SELECT ISNULL(10, NULL);			--10
SELECT ISNULL(NULL, 10);			--10
SELECT ISNULL(NULL, NULL);			--NULL

SELECT COALESCE(NULL, 10, 12);		--10
SELECT COALESCE(NULL, NULL, 12);	--12
SELECT COALESCE(10, 12, NULL);		--10
