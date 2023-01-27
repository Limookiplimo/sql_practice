/*
Difficulty - Medium
source: https://platform.stratascratch.com/coding/10353-workers-with-the-highest-salaries?code_type=1
*/

-- Thought Process --
-- titles of workers earning highest salaries
-- output highest titles that share the highest salaries

select *
from
    (select case
        when salary=
            (select max(salary) from worker) then worker_title
        end as highest_paid_title
    
    from worker
    inner join title on worker.worker_id=title.worker_ref_id
    order by highest_paid_title) cte
where highest_paid_title is not null;