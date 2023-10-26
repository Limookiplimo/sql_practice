/*
Difficulty - Hard
source: https://platform.stratascratch.com/coding/10319-monthly-percentage-difference?code_type=1
*/

-- Thought Process --
-- create year-month col
-- get sum of value grouped by the year-month col
-- using window function(LAG) get percentage change over year_month


with revenue as(
    select
        year_month,
        sum(value) as monthly_sum
    from
        (select
            value,
            purchase_id,
            to_char(created_at,'YYYY-MM') as year_month
        from sf_transactions) e
    group by year_month
    )
    select
        year_month,
        round((monthly_sum - lag(monthly_sum) over (order by year_month)) / lag(monthly_sum) over (order by year_month) * 100, 2) as revenue_diff_pct
    from revenue
    order by year_month