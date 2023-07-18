--Summer of SQL
--Preppin' Data 2023 Week 01


-- Input the data
--Split the Transaction Code to extract the letters at the start of the transaction code
    --Rename the new field with the Bank code 'Bank'
--Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values.
--Change the date to be the day of the week
--Different LOD are required in the outputs. You will need to sum up the values of the transactions in three ways:
    --1. Total Values of Transactions by each bank
    --2. Total Values by Bank, Day of the Week and Type of Transaction (Online or In-Person)
    --3. Total Values by Bank and Customer Code

SELECT 
--LEFT TRANSACTION_CODE,CHARINDEX( "-",TRANSACTION_CODE)-1),
SPLIT_PART(TRANSACTION_CODE,'-',1) AS BANK,
CASE
WHEN ONLINE_OR_IN_PERSON = 1 THEN 'Online'
WHEN ONLINE_OR_IN_PERSON = 2 THEN 'In-Person'
END as ONLINE_OR_IN_PERSON,
DAYNAME(DATE (transaction_date,'dd/mm/yyyy hh24:mi:ss')) as day_of_week,
*
from pd2023_wk01 

select
split_part (transaction_code, '_',1) as bank,
SUM(VALUE) AS TOTAL_VALUE 
FROM PD2023_WK01 
GROUP BY SPLIT_PART TRANSACTION_CODE, '_',1);

//--Different LOD are required in the outputs. You will need to sum up the values of the transactions in three ways:

SELECT
SPLIT_PART (TRANSACTION_CODE, '_',1 ) as bank,
CASE

// Total Values by Bank, Day of the Week and Type of Transaction (Online or In-Person)

WHEN ONLINE_OR_IN_PERSON = 1 THEN 'Online'
WHEN ONLINE_OR_IN_PERSON = 2 THEN 'In-Person'
END as ONLINE_OR_IN_PERSON,

// Total Values of Transactions by each bank
DAYNAME(DATE (transaction_date,'dd/mm/yyyy hh24:mi:ss')) as day_of_week,
SUM (VALUE) AS TOTAL_VALUE 
from pd2023_wk01
group by 1,2,3;

// Total Values by Bank and Customer Code
SELECT
SPLIT_PART (TRANSACTION_CODE, '_',1 ) as bank,
CUSTOMER_CODE,
SUM (VALUE) AS TOTAL_VALUE
FROM PD2023_WK01
GROUP BY SPLIT_PART (TRANSACTION_CODE, '_',1 ),
CUSTOMER_CODE;
