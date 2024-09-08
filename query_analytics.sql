/*
Imagine the following query being issued against a distributed analytics engine, such as Google Big Query or Redshift.

SELECT 
	sale_date, 
	SUM(TotalAmount) / COUNT(DISTINCT salesperson_id) AS SalesPerPerson 
FROM sales 
GROUP BY sale_date

[sales] table has one row for each product item sale transaction.

What part of the query would cause the most data movement between the compute nodes?
How would you optimize the query or data model to answer the same question with less data movement between compute nodes without loss of precision?

The Objective:
Analyze the query in the context of a distributed analytics engine and optimize it where necessary.

Query Analysis:
- This query calculates the average sales per salesperson for each date.
- It sums up all sales amounts and divides by the count of distinct salespersons for each date.
- The GROUP BY clause organizes the data by sale_date.
- The COUNT(DISTINCT salesperson_id) operation is the main cause of data movement in distributed systems.

Thought Process:
 - Check for expensive data shuffling
 - Perform data partition to ensure related data are located on the same node
 - Pre-aggregate the data and store the result in an intermediate table
 - Query the intermediate table for results
*/

-- Solution

-- The part of the query that would cause the most data movement between compute nodes is:
    `COUNT(DISTINCT salesperson_id)`
-- This operation requires collecting all unique salesperson_id values for each sale_date across all nodes, which can lead to significant data shuffling in a distributed environment.

-- The optimized approach:

--1. First Step
-- Create a daily summary table
create table daily_sales_summary as
select 
    sale_date,
    -- Count unique salespersons per day
    count(distinct salesperson_id) as distinct_salespersons,
    -- Sum total sales amount per day
    sum(TotalAmount) as total_sales
from sales
-- Group all data by sale date
group by sale_date

-- This query creates a summary table that pre-computes daily aggregations by counting distinct salespersons and summing total sales for each date. The result is stored in the daily_sales_summary table, reducing future computation needs.

--2. Second Step
-- Query the summary table
select
  sale_date,
  -- Calculate average sales per person using pre-computed values
  total_sales / distinct_salespersons as SalesPerPerson
from daily_sales_summary

-- This query uses the pre-computed summary table to calculate the final result. It simply divides total sales by the number of distinct salespersons for each date. This approach significantly reduces data movement and computation time for repeated queries.
-- This optimization significantly reduces data movement in distributed systems by pre-computing the aggregations that caused the most shuffling.