USE DW_IMP;

IF (object_id('vETLDimRealEstateData') is not null) DROP VIEW vETLDimRealEstateData;
GO
CREATE VIEW vETLDimRealEstateData
AS
SELECT DISTINCT
	CASE
		WHEN [level] = 0 THEN 'Parter'
		WHEN [level] BETWEEN 1 AND 2 THEN '1-2'
		WHEN [level] BETWEEN 3 AND 4 THEN '3-4'
		WHEN [level] BETWEEN 5 AND 6 THEN '5-6'
		WHEN [level] BETWEEN 7 AND 8 THEN '7-8'
		ELSE '8+'
	END AS [level],
	CASE
		WHEN [living_size] < 40 THEN 'Bardzo ma³e'
		WHEN [living_size] BETWEEN 40 AND 59 THEN 'Ma³e'
		WHEN [living_size] BETWEEN 60 AND 89 THEN 'Œrednie'
		WHEN [living_size] BETWEEN 90 AND 149 THEN 'Du¿e'
		ELSE 'Bardzo du¿e'
	END AS [size],
	CASE
		WHEN [value] < 100000 THEN '<100k'
		WHEN [value] BETWEEN 100000 AND 299999.99 THEN '100k-300k'
		WHEN [value] BETWEEN 300000 AND 499999.99 THEN '300k-500k'
		WHEN [value] BETWEEN 500000 AND 799999.99 THEN '500k-800k'
		ELSE '>milion'
	END AS [value]
FROM [DW_LAB].dbo.[real_estates]
JOIN [DW_LAB].dbo.[real_estate_locations]
	ON [DW_LAB].dbo.[real_estates].[estate_id] = [DW_LAB].dbo.[real_estate_locations].[estate_id]
JOIN (SELECT [DW_LAB].dbo.[market_values].estate_id, [DW_LAB].dbo.[market_values].value
	FROM [DW_LAB].dbo.[market_values]
	INNER JOIN (
		SELECT MAX([DW_LAB].dbo.[market_values].entry_date) AS LatestDate, [DW_LAB].dbo.[market_values].estate_id
		FROM [DW_LAB].dbo.[market_values]
		GROUP BY [DW_LAB].dbo.[market_values].estate_id) LatestValue
	ON [DW_LAB].dbo.[market_values].estate_id = LatestValue.estate_id
	AND [DW_LAB].dbo.[market_values].entry_date = LatestValue.LatestDate) values_table
ON [DW_LAB].dbo.[real_estates].[estate_id] = values_table.estate_id;
GO

MERGE INTO Dim_Real_estate as TargetTable
	USING vETLDimRealEstateData as SourceTable
		ON TargetTable.level = SourceTable.level
		AND TargetTable.size = SourceTable.size
		AND TargetTable.value = SourceTable.value
			WHEN Not Matched
				THEN
					INSERT
					Values (
					SourceTable.level,
					SourceTable.size,
					SourceTable.value)
			;

DROP VIEW vETLDimRealEstateData;
