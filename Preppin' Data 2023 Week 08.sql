--Input each of the 12 monthly files
--Create a 'file date' using the month found in the file name
--The Null value should be replaced as 1

WITH CTE AS (

SELECT 1 as file, * FROM pd2023_wk08_01
UNION ALL 
SELECT 2 as file, * FROM pd2023_wk08_01
UNION ALL 
SELECT 3 as file, * FROM pd2023_wk08_01
UNION ALL 
SELECT 4 as file, * FROM pd2023_wk08_01
UNION ALL 
SELECT 5 as file, * FROM pd2023_wk08_01
UNION ALL 
SELECT 6 as file, * FROM pd2023_wk08_01
UNION ALL 
SELECT 7 as file, * FROM pd2023_wk08_01
UNION ALL 
SELECT 8 as file, * FROM pd2023_wk08_01
UNION ALL 
SELECT 9 as file, * FROM pd2023_wk08_01
UNION ALL 
SELECT 10 as file, * FROM pd2023_wk08_01
UNION ALL 
SELECT 11 as file, * FROM pd2023_wk08_01
UNION ALL 
SELECT 12 as file, * FROM pd2023_wk08_01
)

SELECT
DATE_FROM_PARTS(2023,file,1) as file_date,
*
FROM CTE

--Clean the Market Cap value to ensure it is the true value as 'Market Capitalisation'
--Remove any rows with 'n/a'
--Categorise the Purchase Price into groupings
--0 to 24,999.99 as 'Low'
--25,000 to 49,999.99 as 'Medium'
--50,000 to 74,999.99 as 'High'
--h75,000 to 100,000 as 'Very High'

SELECT
DATE_FROM_PARTS(2023,file,1) as file_date,
market_cap,
(SUBSTR(market_cap,2,LENGTH(market_cap)-2)):: float *
(CASE
WHEN RIGHT (market_cap,1)='B' THEN 1000000000 
WHEN RIGHT (market_cap,1)='M' THEN 1000000
END) as market_cap_true,
*
FROM CTE
WHERE market_cap <> 'n/a'

--Categorise the Market Cap into groupings
--Below $100M as 'Small'
--Between $100M and below $1B as 'Medium'
--Between $1B and below $100B as 'Large' 
--$100B and above as 'Huge'
