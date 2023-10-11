/*
Difficulty - Medium
source: https://platform.stratascratch.com/coding/10322-finding-user-purchases?code_type=1
*/

-- Thought Process--
    -- return active users id
    -- made a second purchase within 7 days
    -- find distinct ids using self join and date difference for comparison
    -- ensure purchase ids are not the same
    -- order results by user_id 

select
    distinct t1.user_id
from amazon_transactions t1
join amazon_transactions t2
    on t1.user_id = t2.user_id
and t1.id <> t2.id
and abs(datediff(t1.created_at, t2.created_at)) <= 7
order by t1.user_id;
