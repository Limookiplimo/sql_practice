/*
Difficulty - Medium
source: https://platform.stratascratch.com/coding/10304-risky-projects?code_type=1
*/

-- Thought Process --
-- determine daily salary
-- determine project duration
-- calculate prorated expense of each employee
-- determine sum of expenses for all employees in assigned to a project
-- get only the expense which is larger than the budget as prorated employee expense
-- output the project name,budget and the prorated employee expense

select
    title,
    budget,
    sum(prorated_employee_expense) as prorated_employee_expense
from (select
    project_id,
    title,
    budget,
    emp_id,
    salary / 365 as daily_salary,
    end_date - start_date as proj_days,
    (salary / 365)*(end_date - start_date) as prorated_employee_expense
from linkedin_emp_projects ep
inner join linkedin_employees e on ep.emp_id = e.id
inner join linkedin_projects p on ep.project_id = p.id) as a
where prorated_employee_expense > budget
group by title,budget
order by title;

