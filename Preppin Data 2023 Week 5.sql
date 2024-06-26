-- Techniques:
-- 1. Date functions
-- 2. Rank functions
-- 3. Common Table Expressions (CTEs)

-- Preppin'
-- Create the bank code by splitting out off the letters from the Transaction code, call this field 'Bank'

SELECT 
SPLIT_PART(TRANSACTION_CODE, '-',1) as bank,
*
FROM pd2023_wk01


-- Change transaction date to the just be the month of the transaction

SELECT 
SPLIT_PART(transaction_code , '-',1) as bank,
MONTHNAME(DATE(transaction_date,'dd/MM/yyyy hh24:mi:ss')) as date,
transaction_date,
*
FROM pd2023_wk01

-- Total up the transaction values so you have one row for each bank and month combination

SELECT 
SPLIT_PART(transaction_code,'-',1) as bank,
MONTHNAME(DATE(transaction_date,'dd/MM/yyyy hh24:mi:ss')) as month,
SUM(value) as total_transactions_valueS
FROM pd2023_wk01
GROUP BY SPLIT_PART(transaction_code, '-',1), 
MONTHNAME(DATE(transaction_date,'dd/MM/yyyy hh24:mi:ss'))

-- Rank each bank for their value of transactions each month against the other banks. 1st is the highest value of transactions, 3rd the lowest.
SELECT 
SPLIT_PART(transaction_code,'-',1) as bank,
MONTHNAME(DATE(transaction_date,'dd/MM/yyyy hh24:mi:ss')) as month,
SUM(value) as total_transactions_values,
RANK()OVER (PARTITION BY MONTHNAME(DATE(transaction_date,'dd/MM/yyyy hh24:mi:ss')) ORDER BY SUM(value) DESC) 
as rnk
FROM pd2023_wk01
GROUP BY SPLIT_PART(transaction_code, '-',1), 
MONTHNAME(DATE(transaction_date,'dd/MM/yyyy hh24:mi:ss'))
ORDER BY month

-- Without losing all of the other data fields, find:
--The average rank a bank has across all of the months, call this field 'Avg Rank per Bank'
WITH CTE AS (
SELECT 
SPLIT_PART(transaction_code,'-',1) as bank,
MONTHNAME(DATE(transaction_date,'dd/MM/yyyy hh24:mi:ss')) as month,
SUM(value) as total_transactions_values,
RANK()OVER (PARTITION BY MONTHNAME(DATE(transaction_date,'dd/MM/yyyy hh24:mi:ss')) ORDER BY SUM(value) DESC) 
as rnk
FROM pd2023_wk01
GROUP BY SPLIT_PART(transaction_code, '-',1), 
MONTHNAME(DATE(transaction_date,'dd/MM/yyyy hh24:mi:ss'))
ORDER BY month
)
SELECT 
bank,
AVG(rnk) as average_rank_across_all_months
FROM CTE
GROUP BY bank

--Output
--BANK	AVERAGE_RANK_ACROSS_ALL_MONTHS
--DSB	2.333333
--DS	1.916667
--DTB	1.750000


--The average transaction value per rank, call this field 'Avg Transaction Value per Rank'

WITH CTE AS (
SELECT 
SPLIT_PART(transaction_code,'-',1) as bank,
DATENAME('month',DATE(transaction_date,'dd/MM/yyyy hh24:mi:ss')) as month,
SUM(value) as total_transaction_values,
RANK() OVER(PARTITION BY MONTHNAME(DATE(transaction_date,'dd/MM/yyyy hh24:mi:ss')) ORDER BY SUM(value) DESC) as rnk
FROM pd2023_wk01
GROUP BY SPLIT_PART(transaction_code,'-',1),
MONTHNAME(DATE(transaction_date,'dd/MM/yyyy hh24:mi:ss'))
)
,AVG_RANK AS (
SELECT 
bank,
AVG(rnk) as average_rank_across_all_months
FROM CTE
GROUP BY bank
)
,AVG_RNK_VALUE AS (
SELECT 
rnk,
AVG(total_transaction_values) as avg_transaction_per_rank
FROM CTE
GROUP BY rnk
)
SELECT 
CTE.*,
average_rank_across_all_months as avg_rank_per_bank,
avg_transaction_per_rank as avg_transaction_value_per_rank
FROM CTE
INNER JOIN AVG_RANK as AR ON AR.bank = CTE.bank
INNER JOIN AVG_RNK_VALUE as AV ON AV.rnk = CTE.rnk
