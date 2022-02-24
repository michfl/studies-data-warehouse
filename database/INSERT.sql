USE DW_LAB;


BULK INSERT dbo.company_branches
FROM 'C:\absolute\path\to\data\file\samples\branches_sample.txt'
WITH 
  (
	CODEPAGE = '65001',
    FIELDTERMINATOR = '|', 
    ROWTERMINATOR = '\n' 
  )


BULK INSERT dbo.agents
FROM 'C:\absolute\path\to\data\file\samples\agents_sample.txt'
WITH 
  (
	CODEPAGE = '65001',
    FIELDTERMINATOR = '|', 
    ROWTERMINATOR = '\n' 
  )


BULK INSERT dbo.clients
FROM 'C:\absolute\path\to\data\file\samples\clients_sample.txt'
WITH 
  (
	CODEPAGE = '65001',
    FIELDTERMINATOR = '|', 
    ROWTERMINATOR = '\n' 
  )


BULK INSERT dbo.real_estates
FROM 'C:\absolute\path\to\data\file\samples\real_estates.txt'
WITH 
  (
	CODEPAGE = '65001',
    FIELDTERMINATOR = '|', 
    ROWTERMINATOR = '\n' 
  )


BULK INSERT dbo.market_values
FROM 'C:\absolute\path\to\data\file\samples\market_values_sample.txt'
WITH 
  (
	CODEPAGE = '65001',
    FIELDTERMINATOR = '|', 
    ROWTERMINATOR = '\n' 
  )


BULK INSERT dbo.real_estate_locations
FROM 'C:\absolute\path\to\data\file\samples\real_estate_locations_sample.txt'
WITH 
  (
	CODEPAGE = '65001',
    FIELDTERMINATOR = '|', 
    ROWTERMINATOR = '\n' 
  )


BULK INSERT dbo.salaries
FROM 'C:\absolute\path\to\data\file\samples\salaries_sample.txt'
WITH 
  (
	CODEPAGE = '65001',
    FIELDTERMINATOR = '|', 
    ROWTERMINATOR = '\n' 
  )


BULK INSERT dbo.presentations
FROM 'C:\absolute\path\to\data\file\samples\TIME_STAMP_1\trunked_pres_sample.txt'
WITH 
  (
	CODEPAGE = '65001',
    FIELDTERMINATOR = '|', 
    ROWTERMINATOR = '\n' 
  )