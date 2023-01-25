/*
Difficulty - Medium
source: https://platform.stratascratch.com/coding/10351-activity-rank?code_type=1
*/

-- Thought Process--
-- find activity rank of each user
-- email activity rank = total number of emails sent
-- highest number of emails = rank 1
-- output user, total emails and activity rank
-- order records by total emails in desc
-- sort users with same number of emails on alphabetical order
-- ranks = unique value

select
    from_user,
    count(*) as total_emails,
    rank() over(order by count(*) desc, from_user asc) as activity_rank
from google_gmail_emails
group by from_user
order by total_emails desc;