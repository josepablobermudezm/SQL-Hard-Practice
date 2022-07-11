# Write your MySQL query statement below

with a as (
select
    id,
    visit_date,
    people,
    lead(id, 1) over(order by id) as nextId,
    lead(id, 2) over(order by id) as nextnextId,
    lag(id, 1) over(order by id) as prevId,
    lag(id, 2) over(order by id) as prevprevId
from Stadium
where people >= 100
)

select
    id,
    visit_date,
    people
from a
where (id + 1) = nextId and (id + 2) = nextnextId
or (id - 1) = prevId and (id - 2) = prevprevId
or (id + 1) = nextId and (id - 1) = prevId
