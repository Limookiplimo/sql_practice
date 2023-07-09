/*
Difficulty - Medium
source: https://platform.stratascratch.com/coding/10318-new-products?code_type=1
*/

-- Thought Process --
-- product count for each year
-- group by company
-- get the net difference of product count
-- output company name and net difference



with ln_2019 as(
    select company_name ,
            count(product_name) as lnchd_2019
    from car_launches
    where year = 2019
    group by company_name
),
ln_2020 as(
    select company_name,
            count(product_name) as lnchd_2020
    from car_launches
    where year = 2020
    group by company_name
)
select
    ln_2019.company_name,
    (lnchd_2020 - lnchd_2019) as net_difference
from ln_2019 
inner join ln_2020 on ln_2019.company_name = ln_2020.company_name;