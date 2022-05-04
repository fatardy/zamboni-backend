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
