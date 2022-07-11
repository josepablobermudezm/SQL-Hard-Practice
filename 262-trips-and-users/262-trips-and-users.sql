# Write your MySQL query statement below

/*

## first long approach
with a as (
select count(*) as total, t.request_at
from Trips as t
left join Users as u
on u.users_id = t.client_id
left join Users as u2
on u2.users_id = t.driver_id
where u2.banned <> 'Yes' 
and u.banned <> 'Yes'
and (t.status = 'cancelled_by_driver' or t.status = 'cancelled_by_client')
and t.request_at between '2013-10-01' and '2013-10-03'
group by request_at
), b as (

select count(*) as total, request_at
from Trips as t
left join Users as u
on u.users_id = t.client_id
left join Users as u2
on u2.users_id = t.driver_id
where u2.banned <> 'Yes' 
and u.banned <> 'Yes'
and t.request_at between '2013-10-01' and '2013-10-03'
group by request_at
),

c as (
select 
    0 as total, 
    t.request_at
from Trips as t
left join Users as u
on u.users_id = t.client_id
left join Users as u2
on u2.users_id = t.driver_id
where u2.banned <> 'Yes' 
and u.banned <> 'Yes'
and t.request_at between '2013-10-01' and '2013-10-03'
and t.request_at not in (select request_at from a)
group by request_at
),

d as (
select 
    a.request_at as Day, 
    round((a.total / b.total), 2) as `Cancellation Rate`
from a
left join b
on a.request_at = b.request_at
union 
select 
    c.request_at, 
    total
from c
)

select * from d
order by Day
    
    */
    
select 
    t.Request_at Day,
    ROUND((count(IF(t.status!='completed',TRUE,null))/count(*)),2) as 'Cancellation Rate'
from Trips t 
where t.Client_Id in (Select Users_Id from Users where Banned='No') 
and t.Driver_Id in (Select Users_Id from Users where Banned='No')
and t.Request_at between '2013-10-01' and '2013-10-03'
group by t.Request_at;


