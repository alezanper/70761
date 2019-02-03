USE TEST;

--Some values cannot be represented precisely
DECLARE @f AS FLOAT = 29545428.022495;
SELECT CAST(@f AS NUMERIC(28, 14)) AS numericvalue;

--Cast
SELECT CAST('Alex' AS INT);			--Generates an error
SELECT TRY_CAST('Alex' AS INT);		--Returns NULL instead of an error

