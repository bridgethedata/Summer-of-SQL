-- Foodie Fi - Section A 
-- Section A. Customer Journey 

SELECT customer_id,plan_name, price, start_date
FROM subscriptions as S
INNER JOIN plans as P ON S.plan_id = P.plan_id
WHERE customer_id <= 8
LIMIT 100

-- Section B. Data Anlysis
-- 1. How many customers has Foodie-Fi ever had?
Select 
COUNT(DISTINCT customer_id) as no_of_customer
FROM subscriptions
LIMIT 100
-- OUTPUT 1000 

-- 2. What is the monthly distribution of trial plan start_date values for our dataset? 
-- Use the start of the month as the group by value
SELECT 
DATE_TRUNC ('month', start_date) as month,
COUNT(DISTINCT customer_id) as trial_start_date
FROM subscriptions
WHERE plan_id = 0 
GROUP BY DATE_TRUNC ('month', start_date)
LIMIT 100

-- OUTPUT
--MONTH	TRIAL_START_DATE
--2020-08-01	88
--2020-09-01	87
--2020-01-01	88
--2020-12-01	84
--2020-02-01	68
--2020-03-01	94
--2020-07-01	89
--2020-06-01	79
--2020-04-01	81
--2020-10-01	79
--2020-11-01	75
--2020-05-01	88

-- 3. What plan start_date values occur after the year 2020 for our dataset? 
SELECT 
plan_name,
COUNT(*) AS COUNT_OF_EVENTS
FROM subscriptions as S
INNER JOIN plans as P on S.plan_id = P.plan_id
WHERE DATE_PART ('YEAR', START_DATE) > 2020
GROUP BY plan_name
LIMIT 100

--OUTPUT 
-- churn	71
-- pro monthly	60
--pro annual	63
--basic monthly	8

-- 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
SELECT 
(SELECT COUNT(DISTINCT customer_id) FROM subscriptions) as customer_count,
ROUND((COUNT(DISTINCT customer_id)/(SELECT COUNT(DISTINCT customer_id) FROM subscriptions))*100,1) as churned_customers_percent
FROM subscriptions 
WHERE plan_id = 4

--Output 
-- CUSTOMER_COUNT	CHURNED_CUSTOMERS_PERCENT
-- 1000	30.7

--5. How many customers have churched straight after their initial free trial- what pervcentage is this rounded to the nearest whole number ?
WITH CTE AS (
SELECT 
customer_id,
plan_name,
ROW_number () over (PARTITION BY customer_id ORDER BY start_date ASC) as rn
FROM subscriptions AS S
INNER JOIN PLANS AS P ON S.PLAN_ID = p.PLAN_ID
)
SELECT 
COUNT (DISTINCT customer_id) as churched_after_trial,
COUNT (DISTINCT customer_id) / (SELECT COUNT(distinct customer_id) FROM subscriptions)
from CTE 
WHERE rn = 2
AND plan_name LIKE '%churn%'

-- Output 
-- COUNT (DISTINCT CUSTOMER_ID) / (SELECT COUNT(DISTINCT CUSTOMER_ID) FROM SUBSCRIPTIONS)
-- 0.092000

-- 6. What is the number and percentage of customer plans after their initial free trial?
WITH CTE AS (
SELECT
customer_id,
plan_name,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY start_date ASC) as rn
FROM subscriptions as S
INNER JOIN plans as P on P.plan_id = S.plan_id
)
SELECT 
plan_name,
COUNT(customer_id) as no_of_customer,
ROUND((COUNT(customer_id) / (SELECT COUNT(DISTINCT customer_id) FROM CTE))*100,1) as customer_per
FROM CTE
WHERE rn = 2
GROUP BY plan_name;

--7. What is the customer count and % breakdown of all 5 pnan_name at 2020-12-31 ?
WITH CTE AS (
SELECT *
,ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY start_date DESC) as rn
FROM subscriptions
WHERE start_date <= '2020-12-31'
)
SELECT 
plan_name,
COUNT(customer_id) as total_no_of_customers,
ROUND((COUNT(customer_id)/(SELECT COUNT(DISTINCT customer_id) FROM CTE))*100,1) as perc_of_customers
FROM CTE
INNER JOIN plans as P on CTE.plan_id = P.plan_id
WHERE rn = 1
GROUP BY plan_name;

--8. How many customers have upgraded to an annual plain in 2020?
SELECT COUNT(customer_id) as annual_upgrade_customers
FROM subscriptions as S
INNER JOIN plans as P on P.plan_id = S.plan_id
WHERE DATE_PART('year', START_DATE) = 2020
AND plan_name = 'pro annual'
LIMIT 100

-- OUTPUT
-- ANNUAL_UPGRADE_CUSTOMERS
-- 195
  
-- 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
WITH TRIAL AS (
SELECT 
customer_id,start_date as trial_start
FROM subscriptions
WHERE plan_id = 0
)
, ANNUAL AS (
SELECT 
customer_id,start_date as annual_start
FROM subscriptions
WHERE plan_id = 3
)
SELECT 
ROUND(AVG(DATEDIFF('days',trial_start,annual_start)),0) as average_days_from_trial_to_annual
FROM TRIAL as T
INNER JOIN ANNUAL as A on T.customer_id = A.customer_id;

--10. Can you further breakdown this average value into 30 day periods (i.e 0-30 days, 31-60 days etc)
WITH TRIAL AS (
SELECT 
customer_id,
start_date as trial_start
FROM subscriptions
WHERE plan_id = 0
)
, ANNUAL AS (
SELECT 
customer_id,
start_date as annual_start
FROM subscriptions
WHERE plan_id = 3
)
SELECT 
CASE
WHEN DATEDIFF('days',trial_start,annual_start)<=30  THEN '0-30'
WHEN DATEDIFF('days',trial_start,annual_start)<=60  THEN '31-60'
WHEN DATEDIFF('days',trial_start,annual_start)<=90  THEN '61-90'
WHEN DATEDIFF('days',trial_start,annual_start)<=120  THEN '91-120'
WHEN DATEDIFF('days',trial_start,annual_start)<=150  THEN '121-150'
WHEN DATEDIFF('days',trial_start,annual_start)<=180  THEN '151-180'
WHEN DATEDIFF('days',trial_start,annual_start)<=210  THEN '181-210'
WHEN DATEDIFF('days',trial_start,annual_start)<=240  THEN '211-240'
WHEN DATEDIFF('days',trial_start,annual_start)<=270  THEN '241-270'
WHEN DATEDIFF('days',trial_start,annual_start)<=300  THEN '271-300'
WHEN DATEDIFF('days',trial_start,annual_start)<=330  THEN '301-330'
WHEN DATEDIFF('days',trial_start,annual_start)<=360  THEN '331-360'
END as bin,
COUNT(T.customer_id) as customer_count
FROM TRIAL as T
INNER JOIN ANNUAL as A on T.customer_id = A.customer_id
GROUP BY 1;


--11. How many customers downgraded from a pro montly to a basic montly plan in 2020?
WITH PRO_MON AS (
SELECT 
customer_id,start_date as pro_monthly_start
FROM subscriptions
WHERE plan_id = 2
)
,BASIC_MON AS (
SELECT 
customer_id,start_date as basic_monthly_start
FROM subscriptions
WHERE plan_id = 1
)
SELECT 
P.customer_id,pro_monthly_start,basic_monthly_start
FROM PRO_MON as P
INNER JOIN BASIC_MON as B on P.customer_id = B.customer_id
WHERE pro_monthly_start < basic_monthly_start
AND DATE_PART('year',basic_monthly_start) = 2020;
