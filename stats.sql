select 'this week' as period,

# number of tickets for current week
(
select count(*)
from ost_ticket 
where 
week(created) = week(now())
and ost_ticket.dept_id = 1
) as 'opened tickets',

# number of tickets resolved
(
select count(*) 
from ost_ticket 
where weekday(closed) 
between 0 and 4 
and 
week(closed) = week(now())
and ost_ticket.status_id = 2
and ost_ticket.dept_id = 1
) as 'resolved tickets',

# carried over
(
select count(*)
from ost_ticket 
where 
week(created) = week(now())
and ost_ticket.dept_id = 1
)
-
(
select count(*) 
from ost_ticket 
where weekday(closed) 
between 0 and 4 
and 
week(closed) = week(now())
and ost_ticket.status_id = 2
and ost_ticket.dept_id = 1
) as 'carried over',

# percentage of completed this week
(
select count(*) 
from ost_ticket 
where weekday(closed) 
between 0 and 4 
and 
week(closed) = week(now())
and ost_ticket.status_id = 2
and ost_ticket.dept_id = 1
)
/ 
(
select count(*)
from ost_ticket 
where weekday(created) 
between 0 and 4 
and 
week(created) = week(now())
and ost_ticket.dept_id = 1
) 
* 100
AS 'tickets completed percentage',

# percentage increase from tickets opened since last week
((
select count(*)
from ost_ticket 
where weekday(created) 
between 0 and 4 
and 
week(created) = week(now())
and ost_ticket.dept_id = 1
)
-
(
select count(*)
from ost_ticket 
where weekday(created) 
between 0 and 4 
and 
week(created) = week(now()) - 1
and ost_ticket.dept_id = 1
))
/
(
select count(*)
from ost_ticket 
where weekday(created) 
between 0 and 4 
and 
week(created) = week(now())
and ost_ticket.dept_id = 1
)
* 100
as 'increase of tickets from previous'

union

select 'last week',

# number of tickets last week
(
select count(*)
from ost_ticket 
where weekday(created) 
between 0 and 4 
and 
week(created) = week(now()) - 1
and ost_ticket.dept_id = 1
),
# number of tickets resolved
(
select count(*) 
from ost_ticket 
where weekday(closed) 
between 0 and 4 
and 
week(closed) = week(now()) -1
and ost_ticket.status_id = 2
and ost_ticket.dept_id = 1
) as 'resolved tickets',

# carried over
(
select count(*)
from ost_ticket 
where 
week(created) = week(now()) - 1
and ost_ticket.dept_id = 1
)
-
(
select count(*) 
from ost_ticket 
where weekday(closed) 
between 0 and 4 
and 
week(closed) = week(now()) - 1
and ost_ticket.status_id = 2
and ost_ticket.dept_id = 1
) as 'carried over',

# percentage of tickets closed last week
(
select count(*) 
from ost_ticket 
where weekday(closed) 
between 0 and 4 
and 
week(closed) = week(now()) - 1
and ost_ticket.status_id = 2
and ost_ticket.dept_id = 1
)
/ 
(
select count(*)
from ost_ticket 
where weekday(created) 
between 0 and 4 
and 
week(created) = week(now()) - 1
and ost_ticket.dept_id = 1
) 
* 100,

# percentage increase from tickets opened since last week
((
select count(*)
from ost_ticket 
where weekday(created) 
between 0 and 4 
and 
week(created) = week(now())
and ost_ticket.dept_id = 1
)
-
(
select count(*)
from ost_ticket 
where weekday(created) 
between 0 and 4 
and 
week(created) = week(now()) - 2
and ost_ticket.dept_id = 1
))
/
(
select count(*)
from ost_ticket 
where weekday(created) 
between 0 and 4 
and 
week(created) = week(now())
and ost_ticket.dept_id = 1
)
* 100
as 'increase from previous'

UNION

select 'this month' as week,

(
select count(*)
from ost_ticket 
where weekday(created) 
between 0 and 4 
and 
month(created) = month(now())
and ost_ticket.dept_id = 1
) as 'opened tickets',

# number of tickets resolved
(
select count(*) 
from ost_ticket 
where weekday(closed) 
between 0 and 4 
and 
month(closed) = month(now())
and ost_ticket.status_id = 2
and ost_ticket.dept_id = 1
) as 'resolved tickets',

# carried over
(
select count(*)
from ost_ticket 
where 
month(created) = month(now())
and ost_ticket.dept_id = 1
)
-
(
select count(*) 
from ost_ticket 
where weekday(closed) 
between 0 and 4 
and 
month(closed) = month(now())
and ost_ticket.status_id = 2
and ost_ticket.dept_id = 1
) as 'carried over',

# tickets completed percentage
(
select count(*) 
from ost_ticket 
where weekday(closed) 
between 0 and 4 
and 
month(closed) = month(now())
and ost_ticket.status_id = 2
and ost_ticket.dept_id = 1
)
/ 
(
select count(*)
from ost_ticket 
where weekday(created) 
between 0 and 4 
and 
month(created) = month(now())
and ost_ticket.dept_id = 1
) 
* 100
AS 'tickets completed percentage',
((
select count(*)
from ost_ticket 
where weekday(created) 
between 0 and 4 
and 
month(created) = month(now())
and ost_ticket.dept_id = 1
)
-
(
select count(*)
from ost_ticket 
where weekday(created) 
between 0 and 4 
and 
month(created) = month(now()) - 2
and ost_ticket.dept_id = 1
))
/
(
select count(*)
from ost_ticket 
where weekday(created) 
between 0 and 4 
and 
week(created) = week(now())
and ost_ticket.dept_id = 1
)
* 100
as 'increase from previous'

UNION

select 'total' as week,
(select count(*) as 'total' 
from ost_ticket
join ost_ticket_status on ost_ticket.status_id=ost_ticket_status.id
where ost_ticket.dept_id = 1
and ost_ticket_status.state = 'open'
and ost_ticket.dept_id = 1),

# number of tickets resolved
(
select count(*) 
from ost_ticket 
where ost_ticket.status_id = 2
and ost_ticket.dept_id = 1
) as 'resolved tickets',

(select 0 as 'carried over'),
(select 0 as 'tickets completed percentage'),
(select 0 as 'increase in tickets from previous')
