SELECT u.userId, u.email, o.otp FROM users as u
INNER JOIN otps as o
ON u.userId = o.userId
WHERE u.userId = 1;

DELETE FROM otps WHERE userId = 1;


-- UPDATE table_name SET column_1 = value_1, column_2 = value_2 WHERE column_3 = value_3
UPDATE users SET 
    firstName = 'Ardy', 
    lastName = 'Almur'
WHERE userId = 1;


-- some interesting shit from class

-- you can do a dynamic update? how interesting!
UPDATE users SET
    salary = salary + 10
    WHERE userId = 1;

-- in oracle, to add to null:
UPDATE users SET
    SET comm = nvl(comm, 0) + 100
    WHERE userId = 1;
-- if the commission is null, it will convert to 0;

-- if you put CASCADE for delete on a parent, the children will also be deleted;



select b.locId as 'locId', b.name as 'Location', 
    c.vtId as 'vtId', c.name as 'Vehicle Class', c.rate, c.overFee, 
    a.vehId as 'vehId', a.make, a.model, a.licensePlate
from locations_vehicleTypes as a
join locations as b
    on a.locId = b.locId
join vehicleTypes as c
    on a.vtId = c.vtId
where a.vehId not in (
    select vehId
    from trips a
    where a.inProgress = true    
);

select *
from trips a
where a.inProgress = true;

select a.tripId, a.pickDate, a.dropDate, a.odoStart, a.odoEnd, a.inProgress,
    b.invId, b.invDate, b.amount,
    c.locId as "pickLocId", c.name as "pickLocName",
    d.locId as "dropLocId", d.name as "dropLocName",
    e.payId, e.payDate, e.amount, e.method, e.cardNo
from trips as a
left join invoices as b
    on a.tripId = b.tripId
join locations as c
    on a.pickLocId = c.locId
join locations as d
    on a.pickLocId = d.locId
left join payments as e
    on b.invId = e.invId
where a.userId = 2
order by a.inProgress desc;


select a.tripId, a.pickDate, a.dropDate, a.odoStart, a.odoEnd, a.inProgress,
    b.invId, b.invDate, b.amount,
    c.locId as "pickLocId", c.name as "pickLocName",
    d.locId as "dropLocId", d.name as "dropLocName",
    e.payId, e.payDate, e.amount, e.method, e.cardNo
from trips as a
left join invoices as b
    on a.tripId = b.tripId
join locations as c
    on a.pickLocId = c.locId
join locations as d
    on a.pickLocId = d.locId
left join payments as e
    on b.invId = e.invId
where a.userId = 2
group by e.invId
order by a.inProgress desc;



select *
from trips a
join locations_vehicleTypes b
    on a.vehId = b.vehId
join vehicleTypes c
    on b.vtId = c.vtId
left join coupons d
    on a.coupId = d.coupId
where a.tripId = 5;


ALTER TABLE firms
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE invoices
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE payments
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
