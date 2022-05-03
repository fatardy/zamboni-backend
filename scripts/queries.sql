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