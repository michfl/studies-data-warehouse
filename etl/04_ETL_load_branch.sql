USE DW_IMP;

IF (object_id('vETLDimBranchData') is not null) DROP VIEW vETLDimBranchData;
GO
CREATE VIEW vETLDimBranchData
AS
SELECT DISTINCT
	[country],
	[city]
FROM [DW_LAB].dbo.[company_branches];
GO

MERGE INTO Dim_Branch as TargetTable
	USING vETLDimBranchData as SourceTable
		ON TargetTable.country = SourceTable.country
		AND TargetTable.city = SourceTable.city
			WHEN Not Matched
				THEN
					INSERT
					Values (
					SourceTable.country,
					SourceTable.city
					)
			;

DROP VIEW vETLDimBranchData;
