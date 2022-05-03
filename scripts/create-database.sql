DROP DATABASE zamboni;

CREATE DATABASE zamboni;
USE zamboni;

CREATE TABLE users (
    userId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    -- id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(300),
    last_name VARCHAR(300),
    PRIMARY KEY (userId),
);

CREATE TABLE otps (
    id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    otp VARCHAR(6),
    PRIMARY KEY (id)
    FOREIGN KEY (userId) REFERENCES users(userId),
);

-- INSERT INTO users 
-- (first_name, last_name) VALUES
-- ('bob', 'brush');
-- INSERT INTO users 
-- (first_name, last_name) VALUES
-- ('brut', 'classic');