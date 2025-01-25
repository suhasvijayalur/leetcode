
-- https://leetcode.com/problems/countries-you-can-safely-invest-in/?envType=study-plan-v2&envId=premium-sql-50


with global_avg as (
    select avg(duration) as avg_duration
  from (
select to_person_country.to_country_name as country,
       calls.duration as duration
  from calls
  left join (
    select person.id as id,
       country.name as to_country_name
  from person as person
  left join country as country
    on left(person.phone_number, 3) = country.country_code
  ) as to_person_country
  on calls.caller_id = to_person_country.id
  union all 
  select from_person_country.from_country_name as country,
       calls.duration as duration
  from calls
  left join (
    select person.id as id,
       country.name as from_country_name
  from person as person
  left join country as country
    on left(person.phone_number, 3) = country.country_code
  ) as from_person_country
  on calls.callee_id = from_person_country.id
  ) as final_table
)

select final_table.country as country
  from (
select country,
       avg(duration) as avg_duration
  from (
select to_person_country.to_country_name as country,
       calls.duration as duration
  from calls
  left join (
    select person.id as id,
       country.name as to_country_name
  from person as person
  left join country as country
    on left(person.phone_number, 3) = country.country_code
  ) as to_person_country
  on calls.caller_id = to_person_country.id
  union all 
  select from_person_country.from_country_name as country,
       calls.duration as duration
  from calls
  left join (
    select person.id as id,
       country.name as from_country_name
  from person as person
  left join country as country
    on left(person.phone_number, 3) = country.country_code
  ) as from_person_country
  on calls.callee_id = from_person_country.id
  ) as final_table
 group by country
  ) as final_table cross join global_avg as global_avg
 where final_table.avg_duration > global_avg.avg_duration;
