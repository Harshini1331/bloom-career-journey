-- Replace with actual UUIDs before running
select *
from assessment_summaries
where assessment_response_id = ''{ASSESSMENT_RESPONSE_ID}'';

select *
from notifications
order by created_at desc
limit 20;
