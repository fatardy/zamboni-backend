SELECT u.userId, u.email, o.otp FROM users as u
INNER JOIN otps as o
ON u.userId = o.userId
WHERE u.userId = 1;

DELETE FROM otps WHERE userId = 1;