use DW_IMP;

INSERT INTO [dbo].[Dim_Junk] 
SELECT t, p, q
FROM 
	  (
		VALUES 
			  ('sprzeda¿')
			, ('wynajem')
	  ) 
	AS transaction_type(t)
	, (
		VALUES 
			  ('Jedna')
			, ('Dwie')
			, ('Trzy lub wiêcej')
	  ) 
	AS people_present(p)
	, (
		VALUES 
			  ('tak')
			, ('nie')
	  ) 
	AS successful(q);