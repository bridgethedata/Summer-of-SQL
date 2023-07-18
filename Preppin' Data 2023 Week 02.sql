-- Input the data
-- In the Transactions table, there is a Sort Code field which contains dashes. We need to remove these so just have a 6 digit string (hint)
-- Use the SWIFT Bank Code lookup table to bring in additional information about the SWIFT code and Check Digits of the receiving bank account (hint)
-- Add a field for the Country Code (hint)
-- Hint: all these transactions take place in the UK so the Country Code should be GB
-- Create the IBAN as above (hint)
-- Hint: watch out for trying to combine sting fields with numeric fields - check data types
-- Remove unnecessary fields (hint)
-- Output the data

SELECT
transaction_id, 
'GB' || CHECK_DIGITS || SWIFT_CODE ||REPLACE (SORT_CODE, '-', '') || ACCOUNT_NUMBER AS IBAN
from pd2023_wk02_transactions as T 
inner join pd2023_wk02_swift_codes as S ON T.BANK = S.BANK
