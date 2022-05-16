select * 
from payments
where amount = (
    select max(amount)
    from payments
);


select *
from payments
where amount > (
    select avg(amount)
    from payments
);


select *
from locations_vehicleTypes
where locId = 1
union
select *
from locations_vehicleTypes
where vtId in (1, 2);



with
    a as (select * from vehicleTypes),
    b as (select * from locations_vehicleTypes)
select *
from a
join b
    where a.vtId = b.vtId;



select *
from firms
limit 3;

