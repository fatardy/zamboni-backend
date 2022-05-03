DROP DATABASE zamboni;

CREATE DATABASE zamboni;
USE zamboni;

CREATE TABLE users (
    userId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    firstName VARCHAR(300),
    lastName VARCHAR(300),
    phoneNumber INT(10),
    email VARCHAR(50) NOT NULL UNIQUE,
    street1 VARCHAR(50),
    street2 VARCHAR(50),
    city VARCHAR(50),
    stateName VARCHAR(50), -- `state` seems to be a reserved keyword
    zipCode VARCHAR(8),
    country VARCHAR(50),
    deviceId VARCHAR(30),
    userType CHAR(1), -- discrimiator

    PRIMARY KEY (userId)
);

-- ALTER TABLE users ADD CONSTRAINT constCheckUserType
--     CHECK (userType IN ('C', 'I'));

CREATE TABLE otps (
    id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    otp INT(6) NOT NULL,
    userId INT(10) UNSIGNED NOT NULL UNIQUE,

    PRIMARY KEY (id),
    FOREIGN KEY (userId) REFERENCES users(userId)
);

CREATE TABLE vehicleClass (
    vcId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    rate DECIMAL(9, 2) NOT NULL,
    overFee DECIMAL(9, 2) NOT NULL,

    PRIMARY KEY (vcId)
);

CREATE TABLE locations (
    locId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(300) NOT NULL,
    phoneNumber INT(10) NOT NULL,
    email VARCHAR(50) NOT NULL,
    street1 VARCHAR(50) NOT NULL,
    street2 VARCHAR(50),
    city VARCHAR(50) NOT NULL,
    stateName VARCHAR(50) NOT NULL, -- `state` seems to be a reserved keyword
    zipCode VARCHAR(8) NOT NULL,
    country VARCHAR(50) NOT NULL,
    
    PRIMARY KEY (locId)
);

-- TODO: create intersections;

CREATE TABLE locations_vehicleClass (
    vehId VARCHAR(17) NOT NULL, -- vehicle identification
    make VARCHAR(30) NOT NULL,
    model VARCHAR(30) NOT NULL,
    licencePlate VARCHAR(10) NOT NULL,

    PRIMARY KEY (vehId),
    FOREIGN KEY (locId) REFERENCES locations(locId),
    FOREIGN KEY (vcId) REFERENCES vehicleClass(vcId)
);

CREATE TABLE trips (
    tripId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    pickDate DATETIME NOT NULL,
    dropDate DATETIME NOT NULL,
    odoStart DECIMAL(10, 2) NOT NULL,
    odoEnd DECIMAL(10, 2) NOT NULL,
    odoLimit DECIMAL(10, 2) NOT NULL,

    PRIMARY KEY (tripId),
    FOREIGN KEY (userId) REFERENCES users(userId),
    FOREIGN KEY (pickLocId) REFERENCES locations(locId),
    FOREIGN KEY (dropLocId) REFERENCES locations(locId),
    FOREIGN KEY (vehId) REFERENCES locations_vehicleClass(vehId),
    FOREIGN KEY (coupId) REFERENCES coupons(coupId)
);

CREATE TABLE coupons (
    coupId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(60) NOT NULL,
    percent DECIMAL(4, 2) NOT NULL,
    startDate DATETIME NOT NULL,
    endDate DATETIME NOT NULL,

    PRIMARY KEY (coupId)
);

CREATE TABLE users_coupons (
    coupType NOT NULL


);

CREATE TABLE na_invoice (
    invId INT(10) NOT NULL AUTO_INCREMENT,
    invDate DATETIME NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,

    PRIMARY KEY (invId),
    FOREIGN KEY (tripId) REFERENCES trips(tripId)
);


-- INSERT INTO users 
-- (first_name, last_name) VALUES
-- ('bob', 'brush');
-- INSERT INTO users 
-- (first_name, last_name) VALUES
-- ('brut', 'classic');