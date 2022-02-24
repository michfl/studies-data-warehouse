USE DW_IMP;

IF (object_id('vDimAgentWithBranchInfoWithoutSalaries') is not null) DROP VIEW vDimAgentWithBranchInfoWithoutSalaries;
GO
CREATE VIEW vDimAgentWithBranchInfoWithoutSalaries
AS
SELECT DISTINCT
	[agent_id],
	[country],
	[city],
	[first_name],
	[last_name]
FROM [DW_LAB].dbo.[agents]
JOIN [DW_LAB].dbo.[company_branches] ON [DW_LAB].dbo.[agents].[branch_id]
	= [DW_LAB].dbo.[company_branches].[branch_id];
GO

IF (object_id('vDimAgentWithoutSalaries') is not null) DROP VIEW vDimAgentWithoutSalaries;
GO
CREATE VIEW vDimAgentWithoutSalaries
AS
SELECT DISTINCT
	[agent_id],
	[ID_Branch],
	[first_name],
	[last_name]
FROM vDimAgentWithBranchInfoWithoutSalaries
JOIN Dim_Branch ON (vDimAgentWithBranchInfoWithoutSalaries.city = Dim_Branch.city
AND vDimAgentWithBranchInfoWithoutSalaries.country = Dim_Branch.country);
GO

IF (object_id('vDimAgentSalaries') is not null) DROP VIEW vDimAgentSalaries;
GO
CREATE VIEW vDimAgentSalaries
AS
SELECT [DW_LAB].dbo.[salaries].[agent_id], [DW_LAB].dbo.[salaries].[value]
FROM [DW_LAB].dbo.[salaries]
INNER JOIN (
	SELECT MAX([DW_LAB].dbo.[salaries].[payment_date]) AS latestDate, [DW_LAB].dbo.[salaries].[agent_id] AS agent_id
	FROM [DW_LAB].dbo.[salaries]
	GROUP BY [DW_LAB].dbo.[salaries].[agent_id]) LatestSalary
ON [DW_LAB].dbo.[salaries].[agent_id] = LatestSalary.agent_id
AND [DW_LAB].dbo.[salaries].[payment_date] = LatestSalary.latestDate;
GO

IF (object_id('vETLDimAgentData') is not null) DROP VIEW vETLDimAgentData;
GO
CREATE VIEW vETLDimAgentData
AS
SELECT DISTINCT
	vDimAgentWithoutSalaries.agent_id AS [BK_Agent],
	[ID_Branch],
	[first_name],
	[last_name],
	CASE
		WHEN [value] < 4000 THEN '<4k'
		WHEN [value] BETWEEN 4000 AND 5000 THEN '4k-5k'
		ELSE '>5k'
	END AS [salary]
FROM vDimAgentWithoutSalaries
JOIN vDimAgentSalaries ON (vDimAgentWithoutSalaries.agent_id = vDimAgentSalaries.agent_id);
GO



DECLARE @EntryDate datetime2; 
SELECT @EntryDate = '1980-01-01 00:00:01';



MERGE INTO Dim_Agent as TargetTable
	USING vETLDimAgentData as SourceTable
		ON TargetTable.BK_Agent = SourceTable.BK_Agent
			WHEN Not Matched
				THEN
					INSERT Values (
					SourceTable.BK_Agent,
					SourceTable.ID_Branch,
					SourceTable.first_name,
					SourceTable.last_name,
					SourceTable.salary,
					@EntryDate,
					NULL,
					1
					)
			WHEN Matched
				AND (SourceTable.ID_Branch <> TargetTable.ID_Branch
				OR SourceTable.first_name <> TargetTable.first_name
				OR SourceTable.last_name <> TargetTable.last_name
				OR SourceTable.salary <> TargetTable.salary)
				AND TargetTable.deactivationDate IS NULL
			THEN
				UPDATE
				SET TargetTable.isCurrent = 0,
				TargetTable.deactivationDate = GETDATE()
			WHEN Not Matched By Source
			AND TargetTable.BK_Agent != -1
			THEN
				UPDATE
				SET TargetTable.isCurrent = 0,
				TargetTable.deactivationDate = GETDATE()
			;

INSERT INTO Dim_Agent(
	BK_Agent,
	ID_Branch,
	first_name,
	last_name,
	salary,
	insertionDate,
	deactivationDate,
	isCurrent
	)
	SELECT
		BK_Agent,
		ID_Branch,
		first_name,
		last_name,
		salary,
		GETDATE(),
		NULL,
		1
	FROM vETLDimAgentData
	EXCEPT
	SELECT
		BK_Agent,
		ID_Branch,
		first_name,
		last_name,
		salary,
		GETDATE(),
		NULL,
		1
	FROM Dim_Agent;




IF (object_id('vDimReactivated') is not null) DROP VIEW vDimReactivated;
GO
CREATE VIEW vDimReactivated
AS
SELECT
	BK_Agent,
	ID_Branch,
	first_name,
	last_name,
	salary,
	GETDATE() AS insertionDate,
	NULL AS deactivationDate,
	1 AS isCurrent
FROM vETLDimAgentData
EXCEPT
SELECT
	BK_Agent,
	ID_Branch,
	first_name,
	last_name,
	salary,
	GETDATE(),
	NULL,
	isCurrent
FROM Dim_Agent
GO

UPDATE Dim_Agent
SET
	Dim_Agent.ID_Branch = vDimReactivated.ID_Branch,
	Dim_Agent.first_name = vDimReactivated.first_name,
	Dim_Agent.last_name = vDimReactivated.last_name,
	Dim_Agent.salary = vDimReactivated.salary,
	Dim_Agent.insertionDate = vDimReactivated.insertionDate,
	Dim_Agent.deactivationDate = NULL,
	Dim_Agent.isCurrent = 1
FROM Dim_Agent INNER JOIN vDimReactivated
ON (Dim_Agent.BK_Agent = vDimReactivated.BK_Agent
AND Dim_Agent.ID_Branch = vDimReactivated.ID_Branch
AND Dim_Agent.first_name = vDimReactivated.first_name
AND Dim_Agent.last_name = vDimReactivated.last_name
AND Dim_Agent.salary = vDimReactivated.salary);




DROP VIEW vDimAgentWithBranchInfoWithoutSalaries;
DROP VIEW vDimAgentWithoutSalaries;
DROP VIEW vDimAgentSalaries;
DROP VIEW vETLDimAgentData;
DROP VIEW vDimReactivated;
