USE DW_LAB;


-- INSERT

BULK INSERT dbo.presentations
FROM 'C:\absolute\path\to\data\file\trunked_pres_sample.txt'
WITH 
  (
	CODEPAGE = '65001',
    FIELDTERMINATOR = '|', 
    ROWTERMINATOR = '\n' 
  )

INSERT INTO dbo.presentations
VALUES (
	357,
	2563,
	16530,
	'2021-12-31',
	NULL,
	1111111,
	'sale'
);

INSERT INTO dbo.presentations
VALUES (
	357,
	2563,
	16530,
	'2021-12-12',
	NULL,
	2314822,
	NULL
);



-- UPDATE

UPDATE agents
SET last_name = 'Nowakowski'
WHERE agent_id = 357;

INSERT INTO [DW_LAB].dbo.salaries (agent_id, value, payment_date)
VALUES (3557, 3899, GETDATE());

UPDATE agents
SET branch_id = 7
WHERE agent_id = 488;



-- SELECT


SELECT *
FROM
(SELECT COUNT(*) AS Agent
FROM [DW_IMP].dbo.Dim_Agent) Dim_Agent,
(SELECT COUNT(*) AS Branch
FROM [DW_IMP].dbo.Dim_Branch) Dim_Branch,
(SELECT COUNT(*) AS [Real estate]
FROM [DW_IMP].dbo.Dim_Real_estate) Dim_Real_estate,
(SELECT COUNT(*) AS Date
FROM [DW_IMP].dbo.Dim_Date) Dim_Date,
(SELECT COUNT(*) AS Junk
FROM [DW_IMP].dbo.Dim_Junk) Dim_Junk,
(SELECT COUNT(*) AS Presentation
FROM [DW_IMP].dbo.F_Presentation) F_Presentation;

SELECT *
FROM [DW_IMP].dbo.Dim_Agent
WHERE BK_Agent = 357;

SELECT *
FROM [DW_IMP].dbo.Dim_Agent
WHERE BK_Agent = 3557;

SELECT *
FROM [DW_IMP].dbo.Dim_Agent
WHERE BK_Agent = 488;



SELECT *
FROM [DW_IMP].dbo.F_Presentation
WHERE ID_Agent = 9082 OR ID_Agent = 10003;

SELECT *
FROM [DW_IMP].dbo.F_Presentation
WHERE ID_Agent = 1730;

SELECT *
FROM [DW_IMP].dbo.F_Presentation
WHERE ID_Agent = 92;





SELECT *
FROM [DW_IMP].dbo.Dim_Agent;

SELECT *
FROM [DW_IMP].dbo.Dim_Branch;

SELECT *
FROM [DW_IMP].dbo.Dim_Real_estate;

SELECT *
FROM [DW_IMP].dbo.Dim_Date;

SELECT *
FROM [DW_IMP].dbo.Dim_Junk;



SELECT *
FROM presentations
WHERE agent_id = 357
ORDER BY presentation_date;