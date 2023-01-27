/*
Difficulty - Medium
source: https://platform.stratascratch.com/coding/10352-users-by-avg-session-time?code_type=1
*/

-- Thought Process--
-- calculate user's avg session time
-- session = time diff btwn pg load & pg exit
-- user has a session per day
-- consider latest pg load & and earliest pg exit
-- output user_id and avg session time

select user_id, avg(exit_time-load_time) as avg_session_duration from
	(select user_id,
		max(case when action= 'page_load' then timestamp end) as load_time,
		min(case when action= 'page_exit' then timestamp end) as exit_time from
		facebook_web_log
		group by user_id, date(timestamp)) as CTE
		
	group by user_id
	having avg(exit_time-load_time) is not null;