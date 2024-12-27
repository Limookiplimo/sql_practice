/*
Difficulty - Hard
source: https://platform.stratascratch.com/coding/10546-capitalize-first-letters?code_type=1
*/

-- Thought Process--
-- extract the first letter
-- extract letters from the second to the last
-- capitalize the extracted first letter
-- concatinate the substrings


select
    content_id,
    customer_id,
    content_type,
    content_text,
    concat(
        upper(substring(content_text from 1 for 1)),
        lower(substring(content_text from 2))
    ) as modified_content_text 
from user_content;


/* Modern solution */

-- select 
--     content_id,
--     customer_id,
--     content_type,
--     content_text,
--     initcap(content_text) as modified_content_text
-- from user_content;

