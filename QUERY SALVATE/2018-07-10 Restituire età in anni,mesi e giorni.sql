/* INPUT PARAMETERS */
DECLARE @DateofBirth DATETIME
		,@Months INT
/*********************/

/* INSERT INPUT PARAMETERS */

SET @DateofBirth = '19921116'
SET @Months = 3

/*******************************/

/* INTERMEDIATE VARIABLES */

DECLARE @ExPostDate DATETIME
		,@CurrentAgeTotal DOUBLE PRECISION
		,@ExPostAgeTotal DOUBLE PRECISION
		,@CurrentMonth int
		,@CurrentAgeYears INT
		,@CurrentAgeMonths INT
		,@CurrentAgeDays INT
		,@ExpostMonth INT
		,@ExPostAgeYears INT
		,@ExPostAgeMonths INT
		,@ExPostAgeDays INT

SET @CurrentMonth = MONTH(GETDATE())
SET @ExPostDate = DATEADD(MONTH,@Months,GETDATE())
SET @ExpostMonth = MONTH(@ExPostDate)

SET @CurrentAgeTotal = DATEDIFF(DAY,@DateofBirth,GETDATE())

SET @ExPostAgeTotal = DATEDIFF(DAY,@DateofBirth,@ExPostDate)

SET @CurrentAgeYears = @CurrentAgeTotal/365

SET @CurrentAgeMonths =  ((@CurrentAgeTotal/365) - @CurrentAgeYears)*12


SET @CurrentAgeDays = (((@CurrentAgeTotal/365) - @CurrentAgeYears)*12 - @CurrentAgeMonths) * 30 
																								- (IIF(@CurrentMonth >= 1 AND @CurrentMonth < 3, 1
																									,IIF(@CurrentMonth >= 3 AND @CurrentMonth < 5, 2
																									 ,IIF(@CurrentMonth >= 5 AND @CurrentMonth < 7, 3
																									  ,IIF(@CurrentMonth >=7 AND @CurrentMonth < 8, 4
																									   ,IIF(@CurrentMonth >=8 AND @CurrentMonth < 10, 5
																									    ,IIF(@CurrentMonth >=10 AND @CurrentMonth < 12, 6
																										 ,7)
																									     ))))))	- 1


SET @ExPostAgeYears = @ExPostAgeTotal/365
SET @ExPostAgeMonths = ((@ExPostAgeTotal/365) - @ExPostAgeYears)*12

set @ExPostAgeDays = (((@ExPostAgeTotal / 365) - @ExPostAgeYears) * 12 - @ExPostAgeMonths) * 30 
																								- (IIF(@ExPostMonth >= 1 AND @ExPostMonth < 3, 1
																									, IIF(@ExPostMonth >= 3 AND @ExPostMonth < 5, 3
																									, IIF(@ExPostMonth >= 5 AND @ExPostMonth < 7, 4
																									, IIF(@ExPostMonth >= 7 AND @ExPostMonth < 8, 5
																									, IIF(@ExPostMonth >= 8 AND @ExPostMonth < 10, 6
																									, IIF(@ExPostMonth >= 10 AND @ExPostMonth < 12, 7
																									, 8)
																									)))))) -- - 1


--sELECT @CurrentAgeYears, @CurrentAgeMonths ,@CurrentAgeDays

--SELECT @ExPostAgeYears, @ExPostAgeMonths, @ExPostAgeDays

/* OUTPUT PARAMETERS */
DECLARE @PrintCurrentAge VARCHAR(100)
		,@PrintExPostAge VARCHAR(100)


SET @PrintCurrentAge = CAST(@CurrentAgeYears as VARCHAR(4)) + ' years, ' + CAST(@CurrentAgeMonths AS VARCHAR(2)) + ' months, ' + CAST(@CurrentAgeDays AS VARCHAR(2)) + ' days.'

SET @PrintExPostAge = CAST(@ExPostAgeYears AS VARCHAR(4)) + ' years, ' + CAST(@ExPostAgeMonths AS VARCHAR(2)) + ' months, ' + CAST(@ExPostAgeDays AS VARCHAR(2)) + ' days.'

/******************************/

--Result
SELECT @PrintCurrentAge
UNION ALL
SELECT @PrintExPostAge



 
 
 
 
 
 








