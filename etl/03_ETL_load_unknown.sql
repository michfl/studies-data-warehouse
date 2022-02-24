USE DW_IMP;

SET IDENTITY_INSERT Dim_Date ON;

INSERT INTO Dim_Date (ID_Date, date, year, month, monthNo, dayNo)
VALUES (-1, NULL, 0, NULL, 1, 1);

SET IDENTITY_INSERT Dim_Date OFF;



SET IDENTITY_INSERT Dim_Real_estate ON;

INSERT INTO Dim_Real_estate (ID_Estate, level, size, value)
VALUES (-1, NULL, NULL, NULL);

SET IDENTITY_INSERT Dim_Real_estate OFF;



SET IDENTITY_INSERT Dim_Junk ON;

INSERT INTO Dim_Junk (ID_Junk, transaction_type, people_present, successful)
VALUES (-1, NULL, NULL, NULL);

SET IDENTITY_INSERT Dim_Junk OFF;



SET IDENTITY_INSERT Dim_Agent ON;

INSERT INTO Dim_Agent (ID_Agent, BK_Agent, ID_Branch, first_name, last_name, salary, insertionDate, deactivationDate)
VALUES (-1, -1, NULL, 'UNKNOWN', 'UNKNOWN', NULL, NULL, NULL);

SET IDENTITY_INSERT Dim_Agent OFF;



SET IDENTITY_INSERT Dim_Branch ON;

INSERT INTO Dim_Branch (ID_Branch, country, city)
VALUES (-1, 'UNKNOWN', 'UNKNOWN');

SET IDENTITY_INSERT Dim_Branch OFF;
