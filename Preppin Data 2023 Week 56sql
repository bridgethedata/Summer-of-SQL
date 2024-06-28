-- Reshape the data so we have 5 rows for each customer, with responses for the Mobile App and Online Interface being in separate fields on the same row

SELECT * 
  customer_id,
  SPLIT_PART(pivot_coloumns, '___', 1) as device,
  SPLIT_PART(pivot_coloumns, '___', 2) as Ease of Use
(
SELECT *
FROM pd2023_wk06_dsb_customer_survey
) AS customer_survey
UNPIVOT (
value for pivot_columns IN( 
MOBILE_APP___EASE_OF_USE, MOBILE_APP___EASE_OF_ACCESS, MOBILE_APP___NAVIGATION, MOBILE_APP___LIKELIHOOD_TO_RECOMMEND, MOBILE_APP___OVERALL_RATING, ONLINE_INTERFACE___EASE_OF_USE, ONLINE_INTERFACE___EASE_OF_ACCESS, ONLINE_INTERFACE___NAVIGATION, ONLINE_INTERFACE___LIKELIHOOD_TO_RECOMMEND, ONLINE_INTERFACE___OVERALL_RATING
)) as pivot

-- Clean the question categories so they don't have the platform in from of them
-- e.g. Mobile App - Ease of Use should be simply Ease of Use
WITH PRE_PIVOT AS (
SELECT 
customer_id, 
SPLIT_PART(pivot_columns, '___', 1) as device,
SPLIT_PART(pivot_columns, '___', 2) as factor,
value
FROM
(
SELECT *
FROM pd2023_wk06_dsb_customer_survey
) AS customer_survey
UNPIVOT (
value for pivot_columns IN( 
MOBILE_APP___EASE_OF_USE, MOBILE_APP___EASE_OF_ACCESS, MOBILE_APP___NAVIGATION, MOBILE_APP___LIKELIHOOD_TO_RECOMMEND, MOBILE_APP___OVERALL_RATING, ONLINE_INTERFACE___EASE_OF_USE, ONLINE_INTERFACE___EASE_OF_ACCESS, ONLINE_INTERFACE___NAVIGATION, ONLINE_INTERFACE___LIKELIHOOD_TO_RECOMMEND, ONLINE_INTERFACE___OVERALL_RATING
)) as pivot
)
-- Exclude the Overall Ratings, these were incorrectly calculated by the system
SELECT *
FROM PRE_PIVOT
PIVOT (SUM(VALUE) FOR device IN ('MOBILE_APP','ONLINE_INTERFACE')) AS p
WHERE factor <> 'OVERALL_RATING'

-- The clause WHERE factor <> 'OVERALL_RATING' means that only rows where the factor column does not contain the value 'OVERALL_RATING' will be included in the query results.
-- Exclude the Overall Ratings, these were incorrectly calculated by the system

-- Calculate the Average Ratings for each platform for each customer 
SELECT 
customer_id, 
AVG("'MOBILE_APP'") as avg_mobile,
AVG("'ONLINE_INTERFACE'") as avg_online
FROM FORMATTED_DATA
GROUP BY customer_id

-- Calculate the difference in Average Rating between Mobile App and Online Interface for each customer
SELECT 
customer_id, 
AVG("'MOBILE_APP'") as avg_mobile,
AVG("'ONLINE_INTERFACE'") as avg_online,
AVG("'MOBILE_APP'") - AVG("'ONLINE_INTERFACE'") as difference_in_ratings
FROM FORMATTED_DATA
GROUP BY customer_id

--Catergorise customers as being:
--Mobile App Superfans if the difference is greater than or equal to 2 in the Mobile App's favour
--Mobile App Fans if difference >= 1
--Online Interface Fan
--Online Interface Superfan
--Neutral if difference is between 0 and 1

SELECT 
customer_id, 
AVG("'MOBILE_APP'") as avg_mobile,
AVG("'ONLINE_INTERFACE'") as avg_online,
AVG("'MOBILE_APP'") - AVG("'ONLINE_INTERFACE'") as difference_in_ratings,
CASE
WHEN AVG("'MOBILE_APP'") - AVG("'ONLINE_INTERFACE'") >= 2 THEN 'Mobile App Superfans'
WHEN AVG("'MOBILE_APP'") - AVG("'ONLINE_INTERFACE'") >= 1 THEN 'Mobile App Fans'
WHEN AVG("'MOBILE_APP'") - AVG("'ONLINE_INTERFACE'") >= -2 THEN 'Online Interface Superfans'
WHEN AVG("'MOBILE_APP'") - AVG("'ONLINE_INTERFACE'") >= -1 THEN 'Online Interface Fans'
ELSE 'Neutral'
END as fan_category
FROM FORMATTED_DATA
GROUP BY customer_id

-- Calculate the Percent of Total customers in each category, rounded to 1 decimal place
SELECT 
fan_category as preference,
ROUND ((COUNT(customer_id)/(SELECT COUNT(CUSTOMER_id) FROM CATEGORIES))*100,1)  as total_no_customer
FROM CATEGORIES
GROUP BY fan_category


-- OUtput
--Online Interface Superfans	79.7
--Mobile App Fans	16.4
--Mobile App Superfans	2.6
--Neutral	1.3


