-- Inputs
-- We have one excel file, with 12 different tabs, one for each month:

-- Requirements
-- Input the data
-- We want to stack the tables on top of one another, since they have the same fields in each sheet. We can do this one of 2 ways (help):
-- Drag each table into the canvas and use a union step to stack them on top of one another
-- Use a wildcard union in the input step of one of the tables
-- Some of the fields aren't matching up as we'd expect, due to differences in spelling. Merge these fields together
-- Make a Joining Date field based on the Joining Day, Table Names and the year 2023
-- Now we want to reshape our data so we have a field for each demographic, for each new customer (help)
-- Make sure all the data types are correct for each field
-- Remove duplicates (help)
-- If a customer appears multiple times take their earliest joining date
-- Output the data
-- Output
WITH OTE AS (
SELECT *, 'PD2023_WK04_JANUARY'as tablename FROM PD2023_WK04_JANUARY
UNION ALL
SELECT *, 'PD2023_WK04_FEBRUARY'as tablename FROM PD2023_WK04_FEBRUARY
UNION ALL
SELECT *, 'PD2023_WK04_MARCH'as tablename FROM PD2023_WK04_MARCH
UNION ALL
SELECT*, 'PD2023_WK04_APRIL'as tablename FROM PD2023_WK04_APRIL
UNION ALL
SELECT*,'PD2023_WK04_MAY'as tablename FROM PD2023_WK04_MAY
UNION ALL 
SELECT*, 'PD2023_WK04_JUNE'as tablename FROM PD2023_WK04_JUNE
UNION ALL
SELECT *, 'PD2023_WK04_JULY'as tablename FROM PD2023_WK04_JULY
UNION 
SELECT *, 'PD2023_WK04_AUGUST'as tablename FROM PD2023_WK04_AUGUST
UNION ALL
SELECT *, 'PD2023_WK04_SEPTEMBET'as tablename FROM PD2023_WK04_SEPTEMBER
UNION ALL
SELECT * , 'PD2023_WK04_OCTOBER'as tablename FROM PD2023_WK04_OCTOBER
UNION ALL
SELECT *, 'PD2023_WK04_NOVEMBER'as tablename FROM PD2023_WK04_NOVEMBER
UNION ALL 
SELECT *, 'PD2023_WK04_DECEMBER'as tablename FROM PD2023_WK04_DECEMBER
)
, PRE_PIVOT AS (
SELECT
id, 
date_from_parts(2023,DATE_PART('month',DATE(SPLIT_PART(tablename,'_',3),'MMMM')), joining_day) as joining_date,
demographic,
value
FROM CTE 
)
,POST_PIVOT AS (

SELECT 
id,
joining_date,
ethnicity,
account_type,
date_of_birth :: date as date_of_birth,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY joining_date ASC) as rn
FROM PRE_PIVOT
PIVOT(MAX (value) FOR demographic IN ('Ethnicity', 'Account Type', 'Date of Birth')) AS P
(id,
joining_date,
ethnicity,
account_type,
date_of_birth)
)
SELECT
id,
joining_date,
account_type,
date_of_birth,
ethnicity
FROM post_pivot
WHERE rn = 1
