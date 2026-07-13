SELECT TOP 10 *
FROM dbo.master_dataset;

SELECT COUNT(*) AS TotalListings
FROM dbo.master_dataset;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'master_dataset';