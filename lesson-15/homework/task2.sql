DROP TABLE IF EXISTS items;
CREATE TABLE items
(
	ID VARCHAR(10),
	CurrentQuantity INT,
	QuantityChange INT,
	ChangeType VARCHAR(10),
	Change_datetime DATETIME
);

INSERT INTO items
VALUES 
	('A0013', 278,  99 ,  'out', '2020-05-25 00:25'), 
	('A0012', 377,  31 ,  'in',  '2020-05-24 22:00'),
	('A0011', 346,  1  ,  'out', '2020-05-24 15:01'),
	('A0010', 347,  1  ,  'out', '2020-05-23 05:00'),
	('A009',  348,  102,  'in',  '2020-04-25 18:00'),
	('A008',  246,  43 ,  'in',  '2020-04-25 02:00'),
	('A007',  203,  2  ,  'out', '2020-02-25 09:00'),
	('A006',  205,  129,  'out', '2020-02-18 07:00'),
	('A005',  334,  1  ,  'out', '2020-02-18 06:00'),
	('A004',  335,  27 ,  'out', '2020-01-29 05:00'),
	('A003',  362,  120,  'in',  '2019-12-31 02:00'),
	('A002',  242,  8  ,  'out', '2019-05-22 00:50'),
	('A001',  250,  250,  'in',  '2019-05-20 00:45');


DROP TABLE IF EXISTS #ResultTable;
CREATE TABLE #ResultTable
(
	QuantityChange INT,
	Days INT
);

DROP TABLE IF EXISTS #out_transactions;
CREATE TABLE #out_transactions 
(
	Num INT IDENTITY(1,1),
	ID VARCHAR(10),
	CurrentQuantity INT,
	QuantityChange INT,
	ChangeType VARCHAR(10),
	Change_datetime DATETIME
);

INSERT INTO #out_transactions (ID, CurrentQuantity, QuantityChange, ChangeType, Change_datetime)
SELECT * FROM items WHERE ChangeType = 'out' ORDER BY Change_datetime ASC;

DROP TABLE IF EXISTS #in_transactions;
CREATE TABLE #in_transactions 
(
	Num INT IDENTITY(1,1),
	ID VARCHAR(10),
	CurrentQuantity INT,
	QuantityChange INT,
	ChangeType VARCHAR(10),
	Change_datetime DATETIME
);

INSERT INTO #in_transactions (ID, CurrentQuantity, QuantityChange, ChangeType, Change_datetime)
SELECT * FROM items WHERE ChangeType = 'in' ORDER BY Change_datetime ASC;

DECLARE @IncomingQuantity INT
DECLARE @OutgoingQuantity INT
DECLARE @InIndex INT
DECLARE @OutIndex INT;

SET @InIndex = 1
SET @OutIndex = 1;
DECLARE @OutCount INT = (SELECT COUNT(*) FROM #out_transactions);
DECLARE @InCount INT = (SELECT COUNT(*) FROM #in_transactions);

SET @OutgoingQuantity = (SELECT QuantityChange FROM #out_transactions WHERE Num = 1);

WHILE @InIndex <= @InCount
BEGIN
	SET @IncomingQuantity = (SELECT QuantityChange FROM #in_transactions WHERE Num = @InIndex);

	WHILE @OutgoingQuantity < @IncomingQuantity
	BEGIN 
		INSERT INTO #ResultTable
		VALUES
			(@OutgoingQuantity, DATEDIFF(DAY, (SELECT Change_datetime FROM #in_transactions WHERE Num = @InIndex), 
				(SELECT Change_datetime FROM #out_transactions WHERE Num = @OutIndex)));

		SET @IncomingQuantity = @IncomingQuantity - @OutgoingQuantity;
		SET @OutIndex = @OutIndex + 1;

		IF @OutIndex > @OutCount
			BREAK;

		SET @OutgoingQuantity = (SELECT QuantityChange FROM #out_transactions WHERE Num = @OutIndex);
	END

	IF @OutIndex > @OutCount
		BREAK;
	  
	INSERT INTO #ResultTable
	VALUES
		(@IncomingQuantity, DATEDIFF(DAY, (SELECT Change_datetime FROM #in_transactions WHERE Num = @InIndex), 
			(SELECT Change_datetime FROM #out_transactions WHERE Num = @OutIndex)));

	SET @OutgoingQuantity = @OutgoingQuantity - @IncomingQuantity;
	SET @InIndex = @InIndex + 1;
END

INSERT INTO #ResultTable 
VALUES
	(@IncomingQuantity, DATEDIFF(DAY, (SELECT Change_datetime FROM #in_transactions WHERE Num = @InIndex), 
		(SELECT MAX(Change_datetime) FROM items)));

WHILE @InIndex < @InCount
BEGIN
	SET @InIndex = @InIndex + 1;
	INSERT INTO #ResultTable
	VALUES
		((SELECT QuantityChange FROM #in_transactions WHERE Num = @InIndex), 
			DATEDIFF(DAY, (SELECT Change_datetime FROM #in_transactions WHERE Num = @InIndex), 
				(SELECT MAX(Change_datetime) FROM items)));
END;

DECLARE @MaxDays INT;
DECLARE @StartInterval INT = 1;
DECLARE @IntervalSize INT = 90;
DECLARE @SQL NVARCHAR(MAX) = '';
DECLARE @Columns NVARCHAR(MAX) = '';

SELECT @MaxDays = MAX(Days) FROM #ResultTable;

DROP TABLE IF EXISTS #temp_result;
CREATE TABLE #temp_result
(
	IntervalLabel VARCHAR(50),
	TotalQuantity INT
);

WHILE @StartInterval <= @MaxDays
BEGIN
    DECLARE @EndInterval INT = @StartInterval + @IntervalSize - 1;
    DECLARE @IntervalLabel VARCHAR(50) = CAST(@StartInterval AS VARCHAR) + '-' + CAST(@EndInterval AS VARCHAR) + ' days old';

    INSERT INTO #temp_result
    SELECT @IntervalLabel, 
        SUM(QuantityChange)
    FROM #ResultTable
    WHERE Days BETWEEN @StartInterval AND @EndInterval;

    SET @Columns = @Columns + '[' + @IntervalLabel + '],';

    SET @StartInterval = @EndInterval + 1;
END;

SET @Columns = LEFT(@Columns, LEN(@Columns) - 1);

SET @SQL = '
    SELECT * 
    FROM (SELECT IntervalLabel, TotalQuantity FROM #temp_result) AS SourceTable
    PIVOT (SUM(TotalQuantity) FOR IntervalLabel IN (' + @Columns + ')) AS PivotTable;
';

EXEC sp_executesql @SQL;
