use DW_IMP;
go

-- Fill Dim_Date Lookup Table
-- Step a: Declare variables use in processing
Declare @StartDate date; 
Declare @EndDate date;

-- Step b:  Fill the variable with values for the range of years needed
SELECT @StartDate = '2015-01-01', @EndDate = '2021-12-31';

-- Step c:  Use a while loop to add dates to the table
Declare @DateInProcess datetime = @StartDate;

While @DateInProcess <= @EndDate
	Begin
	--Add a row into the date dimension table for this date
		Insert Into [dbo].[Dim_Date] 
		( [date]
		, [year]
		, [month]
		, [monthNo]
		, [dayNo]
		)
		Values ( 
		  @DateInProcess -- [Date]
		  , Cast( Year(@DateInProcess) as int) -- [Year]
		  , CASE
				WHEN Month(@DateInProcess) = 1 THEN 'Styczeñ'
				WHEN Month(@DateInProcess) = 2 THEN 'Luty'
				WHEN Month(@DateInProcess) = 3 THEN 'Marzec'
				WHEN Month(@DateInProcess) = 4 THEN 'Kwiecieñ'
				WHEN Month(@DateInProcess) = 5 THEN 'Maj'
				WHEN Month(@DateInProcess) = 6 THEN 'Czerwiec'
				WHEN Month(@DateInProcess) = 7 THEN 'Lipiec'
				WHEN Month(@DateInProcess) = 8 THEN 'Sierpieñ'
				WHEN Month(@DateInProcess) = 9 THEN 'Wrzesieñ'
				WHEN Month(@DateInProcess) = 10 THEN 'PaŸdziernik'
				WHEN Month(@DateInProcess) = 11 THEN 'Listopad'
				WHEN Month(@DateInProcess) = 12 THEN 'Grudzieñ'
			END
		  , Cast( Month(@DateInProcess) as tinyint) -- [MonthNo]
		  , Cast( Day(@DateInProcess) as tinyint) -- [DayOfWeekNo]
		);  
		-- Add a day and loop again
		Set @DateInProcess = DateAdd(d, 1, @DateInProcess);
	End
go