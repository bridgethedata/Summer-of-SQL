-- Input the data
SELECT *
FROM pd2023_wk07_transaction_path
LIMIT 100

-- For the Account Information table: Make sure there are no null values in the Account Holder ID- excl;due nulls
SELECT *
FROM pd2023_wk07_account_information
WHERE account_holder_id IS NOT NULL
LIMIT 100 

-- For the Account Information table: Ensure there is one row per Account Holder ID
-- Joint accounts will have 2 Account Holders, we want a row for each of them
SELECT 
ACCOUNT_NUMBER,ACCOUNT_TYPE,BALANCE_DATE,BALANCE
FROM pd2023_wk07_account_information, LATERAL SPLIT_TO_TABLE (ACCOUNT_HOLDER_ID,',')
WHERE account_holder_id IS NOT NULL
LIMIT 100

--For the Account Holders table: Make sure the phone numbers start with 07
SELECT 
'0' || contact_number::varchar(20) as phone, 
*
FROM pd2023_wk07_account_holders
LIMIT 100

-- Bring the tables together
FROM pd2023_wk07_transaction_detail as D
INNER JOIN pd2023_wk07_transaction_path as P ON D.transaction_id = P.transaction_id
INNER JOIN ACC on ACC.account_number = P.account_from
INNER JOIN pd2023_wk07_account_holders as H ON H.account_holder_id = ACC.account_holder_id

-- ADD FILTERS
INNER JOIN pd2023_wk07_transaction_path as P ON D.transaction_id = P.transaction_id
INNER JOIN ACC on ACC.account_number = P.account_from
INNER JOIN pd2023_wk07_account_holders as H ON H.account_holder_id = ACC.account_holder_id
WHERE cancelled_ = 'N'
AND value > 1000
AND account_type <> 'Platinum'
