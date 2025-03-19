use class12;
go
DECLARE @temp table(
	DatabaseName nvarchar(255),
	SchemaName nvarchar(255),
	ColumnName nvarchar(255),
	DataType nvarchar(255)
);


DECLARE @Databases TABLE (
    database_id INT IDENTITY(1,1),
    name NVARCHAR(255)
);


INSERT INTO @Databases (name)
SELECT [name]
FROM sys.databases
WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')
ORDER BY database_id;


DECLARE @i INT = 1;
DECLARE @NumberOFDatabases INT;
DECLARE @DatabaseName NVARCHAR(255);

SELECT @NumberOFDatabases = COUNT(*) FROM @Databases;


WHILE @i <= @NumberOFDatabases
BEGIN
    SELECT @DatabaseName = name FROM @Databases WHERE database_id = @i;

	DECLARE @sql_query nvarchar(max) = '
	SELECT 
		TABLE_CATALOG AS [DatabaseName],
		TABLE_SCHEMA AS [Schema],
		COLUMN_NAME AS [ColumnName],
		CONCAT(DATA_TYPE, 
			   ''('' + 
			   IIF(CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) = ''-1'', ''max'', CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR))  
			   + '')'') AS DataType
	FROM ' + QUOTENAME(@DatabaseName) + '.INFORMATION_SCHEMA.COLUMNS;';

	INSERT INTO @temp
		EXEC sp_executesql @sql_query;

    SET @i = @i + 1;
END;

SELECT * FROM @temp