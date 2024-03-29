/*
Difficulty - Medium
source: https://platform.stratascratch.com/coding/10324-distances-traveled?code_type=1
*/

-- Thought Process --
-- find users(id, name)
-- distance aggregate (sum with group by clause)
-- join the two tables(inner join)
-- order by total distance
-- limit (10)

select
    user_id,
    name,
    sum(distance) as total_distance
from lyft_rides_log r
inner join 
    lyft_users u on r.user_id = u.id
group by user_id, name
order by total_distance desc
limit 10;