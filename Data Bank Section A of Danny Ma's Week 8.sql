-- Common Table Expressions
-- Window functions - ROW_NUMBER()
-- Calculating stats: median and percentiles 

-- The following case study questions include some general data exploration analysis for the nodes and transactions before diving right into the core business questions and finishes with a challenging final request!

-- A. Customer Nodes Exploration
-- 1. How many unique nodes are there on the Data Bank system?
SELECT 
COUNT(DISTINCT node_id) as unique_no_of_nodes
FROM customer_nodes

-- output
-- 5

-- 2.What is the number of nodes per region?
SELECT 
region_name,
COUNT(DISTINCT node_id) as nodes
FROM customer_nodes as CN
INNER JOIN regions as R ON CN.region_id = r.REGION_ID
GROUP BY region_name
LIMIT 100;

-- OUTPUT
--Africa	5
--Europe	5
--Australia	5
--America	5
-- Asia	5

-- 3. How many customers are allocated to each region?
SELECT 
region_name,
COUNT(distinct CUSTOMER_ID) AS unique_customers
FROM customer_nodes as C 
INNER JOIN regions as R on C.region_id = R.region_id
GROUP BY region_name
LIMIT 100

--Region_name count_customers unique_customers
--Africa	714	102
--Europe	616	88
--Australia	770	110
--Asia	665	95
--America	735	105

-- 4. How many days on average are customers reallocated to a different node?

WITH DAYS_IN_NODE AS (
SELECT 
customer_id,
node_id, 
SUM(DATEDIFF('days',start_date,end_date)) as days_in_node
FROM customer_nodes
WHERE end_date <> '9999-12-31'
GROUP BY customer_id, 
node_id
)
SELECT 
ROUND(AVG(days_in_node),0) as average_days_in_node
FROM DAYS_IN_NODE

--Output
-- AVERAGE_DAYS_IN_NODE
-- 24

--5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
WITH DAYS_IN_NODE AS (
SELECT 
region_name,
customer_id,
node_id, 
SUM(DATEDIFF('days',start_date,end_date)) as days_in_node
FROM customer_nodes as c
INNER JOIN regions as R on R.REGION_ID = C.region_id
WHERE end_date <> '9999-12-31'
GROUP BY region_name, 
customer_id,
node_id
)
SELECT 
region_name,
ROUND(AVG(days_in_node),0) as average_days_in_node,
MEDIAN(days_in_node) as median_days_in_node,
PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY days_in_node)as pc_80_days_in_node,
PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY days_in_node)as pc_95_days_in_node
FROM DAYS_IN_NODE
GROUP BY region_name;

