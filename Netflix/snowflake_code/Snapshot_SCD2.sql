--Let's demonstrate snapshots, SCD type 2. Here initially we query the snap_tags.
--Since src_tags is a view it throws an error. so make sure we conver it to table using
--{{config(materialized='table')}} in DBT src_tags. once we run this check for a user with movie id 
--after that let's update the tag and then run dbt snapshot in the terminal. after that 
--again check the same query to see if SCD type 2 is implemented or not
select *from snapshots.snap_tags
order by user_id,dbt_valid_from desc;

update src_tags
set tag = 'Mark Waters 3', tag_timestamp = CAST(current_timestamp() as TIMESTAMP_NTZ)
where user_id = 18;

select *from src_tags
where user_id=18;