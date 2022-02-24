USE DW_IMP;


IF (object_id('dbo.ReportsTemp') is not null) DROP TABLE dbo.ReportsTemp;
CREATE TABLE dbo.ReportsTemp(report_code int, present int, time int, client_rating int, agent_rating int, expenses money);
GO

BULK INSERT dbo.ReportsTemp
FROM 'G:\Studies\Semestr 5\Hurtownie danych\DW-Generator\samples\TIME_STAMP_1\trunked_rep_sample.csv'
WITH 
  (
	CODEPAGE = '65001',
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',
	FIRSTROW = 2
  )


IF (object_id('vETLFPresentationsWithNULL') is not null) DROP VIEW vETLFPresentationsWithNULL;
GO
CREATE VIEW vETLFPresentationsWithNULL
AS
SELECT
	time,
	agent_rating,
	client_rating,
	ID_Date,
	ID_Estate,
	ID_Junk,
	ID_Agent
FROM ReportsTemp
LEFT JOIN (SELECT agent_id, estate_id, presentation_date, agent_raport_code,
	CASE
		WHEN type = 'sale' THEN 'sprzeda¿'
		WHEN type = 'rent' THEN 'wynajem'
		ELSE NULL
	END AS type,
	CASE
		WHEN contract_code IS NULL THEN 'nie'
		ELSE 'tak'
	END AS successful
FROM DW_LAB.dbo.presentations) AS presentations ON ReportsTemp.report_code = presentations.agent_raport_code
LEFT JOIN DW_IMP.dbo.Dim_Date ON presentations.presentation_date = DW_IMP.dbo.Dim_Date.date
LEFT JOIN (SELECT DW_LAB.dbo.real_estates.estate_id,
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
FROM DW_LAB.dbo.real_estates
LEFT JOIN DW_LAB.dbo.real_estate_locations ON DW_LAB.dbo.real_estates.estate_id
	= DW_LAB.dbo.real_estate_locations.estate_id
LEFT JOIN (SELECT [DW_LAB].dbo.[market_values].estate_id, [DW_LAB].dbo.[market_values].value
	FROM [DW_LAB].dbo.[market_values]
	INNER JOIN (
		SELECT MAX([DW_LAB].dbo.[market_values].entry_date) AS LatestDate, [DW_LAB].dbo.[market_values].estate_id
		FROM [DW_LAB].dbo.[market_values]
		GROUP BY [DW_LAB].dbo.[market_values].estate_id) LatestValue
	ON [DW_LAB].dbo.[market_values].estate_id = LatestValue.estate_id
	AND [DW_LAB].dbo.[market_values].entry_date = LatestValue.LatestDate) values_table
ON [DW_LAB].dbo.[real_estates].[estate_id] = values_table.estate_id) AS real_estates ON presentations.estate_id = real_estates.estate_id
LEFT JOIN DW_IMP.dbo.Dim_Real_estate ON DW_IMP.dbo.Dim_Real_estate.level = real_estates.level
	AND DW_IMP.dbo.Dim_Real_estate.size = real_estates.size AND DW_IMP.dbo.Dim_Real_estate.value = real_estates.value
LEFT JOIN (SELECT report_code,
	CASE
		WHEN present = 1 THEN 'Jedna'
		WHEN present = 2 THEN 'Dwie'
		ELSE 'Trzy lub wiêcej'
	END AS present
FROM ReportsTemp) AS Presence ON Presence.report_code = ReportsTemp.report_code
LEFT JOIN DW_IMP.dbo.Dim_Junk ON DW_IMP.dbo.Dim_Junk.people_present = Presence.present
	AND DW_IMP.dbo.Dim_Junk.transaction_type = presentations.type
	AND DW_IMP.dbo.Dim_Junk.successful = presentations.successful
LEFT JOIN DW_IMP.dbo.Dim_Agent ON DW_IMP.dbo.Dim_Agent.BK_Agent = presentations.agent_id
	AND presentations.presentation_date BETWEEN DW_IMP.dbo.Dim_Agent.insertionDate AND ISNULL(DW_IMP.dbo.Dim_Agent.deactivationDate, '2022-01-01')
GO

IF (object_id('vETLFPresentations') is not null) DROP VIEW vETLFPresentations;
GO
CREATE VIEW vETLFPresentations
AS
SELECT
	ISNULL(vETLFPresentationsWithNULL.ID_Date,-1) AS ID_Date,
	ISNULL(vETLFPresentationsWithNULL.ID_Estate,-1) AS ID_Estate,
	ISNULL(vETLFPresentationsWithNULL.ID_Agent,-1) AS ID_Agent,
	ISNULL(vETLFPresentationsWithNULL.ID_Junk,-1) AS ID_Junk,
	time,
	agent_rating,
	client_rating
FROM vETLFPresentationsWithNULL
GO

MERGE INTO DW_IMP.dbo.F_Presentation AS TargetTable
	USING vETLFPresentations AS SourceTable
		ON TargetTable.ID_Date = SourceTable.ID_Date
		AND TargetTable.ID_Estate = SourceTable.ID_Estate
		AND TargetTable.ID_Junk = SourceTable.ID_Junk
		AND TargetTable.ID_Agent = SourceTable.ID_Agent
			WHEN NOT MATCHED
				THEN
					INSERT (ID_Date, ID_Estate, ID_Agent, ID_Junk, time, agent_rating, client_rating)
					VALUES (
						SourceTable.ID_Date,
						SourceTable.ID_Estate,
						SourceTable.ID_Agent,
						SourceTable.ID_Junk,
						SourceTable.time,
						SourceTable.agent_rating,
						SourceTable.client_rating)
			;


DROP TABLE dbo.ReportsTemp;
DROP VIEW vETLFPresentationsWithNULL;
DROP VIEW vETLFPresentations;