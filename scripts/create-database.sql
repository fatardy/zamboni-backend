CREATE DATABASE zamboni;
USE zamboni;

CREATE TABLE users (
    id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(300),
    last_name VARCHAR(300)
);

-- INSERT INTO users 
-- (first_name, last_name) VALUES
-- ('bob', 'brush');
-- INSERT INTO users 
-- (first_name, last_name) VALUES
-- ('brut', 'classic');