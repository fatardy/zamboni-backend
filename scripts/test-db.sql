DROP DATABASE IF EXISTS zamboni;

CREATE DATABASE zamboni;
USE zamboni;

-- company in old design
CREATE TABLE firms (
    firmId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(50),
    regNo VARCHAR(10) NOT NULL,

    PRIMARY KEY (firmId)
);

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
    avatar VARCHAR(300),
    userType CHAR(1),  -- discriminator 'A', 'C', 'B'

    PRIMARY KEY (userId)
);

-- 'A'
CREATE TABLE admins (
    userId INT(10) UNSIGNED NOT NULL,
    isAdmin BOOLEAN NOT NULL DEFAULT true,

    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES users(userId)
);

-- 'C'
CREATE TABLE customers (
    userId INT(10) UNSIGNED NOT NULL,
    driverLicense VARCHAR(10) NOT NULL UNIQUE, -- why unique;
    insurancePolicy VARCHAR(10) NOT NULL,
    insuranceCompany VARCHAR(30) NOT NULL,

    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES users(userId)
);

-- 'B'
CREATE TABLE bizCustomers (
    userId INT(10) UNSIGNED NOT NULL,
    empNo INT(10) NOT NULL UNIQUE, -- why unique;
    firmId INT(10) UNSIGNED NOT NULL,

    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES users(userId),
    FOREIGN KEY (firmId) REFERENCES firms(firmId)
);

CREATE TABLE otps (
    id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    otp INT(6) NOT NULL,
    userId INT(10) UNSIGNED NOT NULL UNIQUE,

    PRIMARY KEY (id),
    FOREIGN KEY (userId) REFERENCES users(userId)
);

CREATE TABLE vehicleTypes (
    vtId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    rate DECIMAL(9, 2) NOT NULL,
    overFee DECIMAL(9, 2) NOT NULL,

    PRIMARY KEY (vtId)
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

CREATE TABLE locations_vehicleTypes (
    vehId VARCHAR(17) NOT NULL, -- vehicle identification
    make VARCHAR(30) NOT NULL,
    model VARCHAR(30) NOT NULL,
    licensePlate VARCHAR(10) NOT NULL,
    locId INT(10) UNSIGNED NOT NULL,
    vtId INT(10) UNSIGNED NOT NULL,

    PRIMARY KEY (vehId),
    FOREIGN KEY (locId) REFERENCES locations(locId),
    FOREIGN KEY (vtId) REFERENCES vehicleTypes(vtId)
);

CREATE TABLE coupons (
    coupId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(60) NOT NULL,
    percent DECIMAL(5, 2) NOT NULL,
    flatRate DECIMAL(5, 2) NOT NULL,
    startDate DATETIME NOT NULL,
    endDate DATETIME NOT NULL,

    PRIMARY KEY (coupId)
);

CREATE TABLE users_coupons (
    userId INT(10) UNSIGNED NOT NULL,
    coupId INT(10) UNSIGNED NOT NULL,
    coupType VARCHAR(30), -- what is this??

    PRIMARY KEY (userId, coupId)
);

CREATE TABLE trips (
    tripId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    pickDate DATETIME NOT NULL,
    dropDate DATETIME NOT NULL,
    finalDropDate DATETIME,
    odoStart DECIMAL(10, 2) NOT NULL,
    odoEnd DECIMAL(10, 2),
    odoLimit DECIMAL(10, 2) NOT NULL,
    userId INT(10) UNSIGNED NOT NULL,
    pickLocId INT(10) UNSIGNED NOT NULL,
    dropLocId INT(10) UNSIGNED NOT NULL,
    coupId INT(10) UNSIGNED,
    vehId VARCHAR(17) NOT NULL,
    inProgress BOOLEAN,

    PRIMARY KEY (tripId),
    FOREIGN KEY (userId) REFERENCES users(userId),
    FOREIGN KEY (pickLocId) REFERENCES locations(locId),
    FOREIGN KEY (dropLocId) REFERENCES locations(locId),
    FOREIGN KEY (vehId) REFERENCES locations_vehicleTypes(vehId),
    FOREIGN KEY (coupId) REFERENCES coupons(coupId)
);

CREATE TABLE invoices (
    invId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    invDate DATETIME NOT NULL,
    amount DECIMAL(10, 2),
    tripId INT(10) UNSIGNED NOT NULL,

    PRIMARY KEY (invId),
    FOREIGN KEY (tripId) REFERENCES trips(tripId)
);

CREATE TABLE payments (
    payId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    payDate DATETIME NOT NULL,
    amount DECIMAL(10, 2),
    method ENUM('VISA', 'MASTERCARD', 'RUPAY', 'OTHER'), -- CHANGE THIS!
    cardNo DECIMAL(10),
    invId INT(10) UNSIGNED NOT NULL,

    PRIMARY KEY (payId),
    FOREIGN KEY (invId) REFERENCES invoices(invId)
);

-- create the default admin;
-- INSERT INTO admins (email, isAdmin) VALUES ('a@cronlogy.com', true);

-- ALTER TABLE users ADD CONSTRAINT constCheckUserType
--     CHECK (userType IN ('C', 'I'));

INSERT INTO users (userType, email, firstName, lastName) VALUES ('A', 'admin@zamboni.com', 'ADMIN', 'ARDY');
INSERT INTO admins (userId, isAdmin) VALUES (1, true);

INSERT INTO locations (name, phoneNumber, email, street1, city, stateName, zipCode, country)
VALUES (
    "Fulton St2",
    1231231234,
    "fulton@sex.com",
    "asdf",
    "Hyd",
    "Mehdipatnam",
    "123112",
    "USA"
);

INSERT INTO coupons (name, percent, startDate, endDate)
VALUES (
    "30% Off",
    10,
    "2022-05-04 19-57-10",
    "2022-05-06 19-57-10"
);

INSERT INTO firms (name, regNo)
VALUES (
    "Intel Corp",
    "asdf1234as"
);

INSERT INTO vehicleTypes (name, rate, overFee)
VALUES (
    "SUV",
    30.5,
    4
);

INSERT INTO locations_vehicleTypes (vehId, make, model, licensePlate, locId, vtId)
VALUES (
    "asdfqwerasdfqwert",
    "BMW",
    "3 Series",
    "ASDF1234QW",
    "1",
    "1"
);

INSERT INTO locations_vehicleTypes (vehId, make, model, licensePlate, locId, vtId)
VALUES (
    "asdfqwerasdfasdf",
    "BMW",
    "5 Series",
    "ZSDF1234QW",
    "1",
    "1"
);


tripId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    pickDate DATETIME NOT NULL,
    dropDate DATETIME NOT NULL,
    odoStart DECIMAL(10, 2) NOT NULL,
    odoEnd DECIMAL(10, 2) NOT NULL,
    odoLimit DECIMAL(10, 2) NOT NULL,
    userId INT(10) UNSIGNED NOT NULL,
    pickLocId INT(10) UNSIGNED NOT NULL,
    dropLocId INT(10) UNSIGNED NOT NULL,
    coupId INT(10) UNSIGNED NOT NULL,
    vehId VARCHAR(17) NOT NULL,
    inProgress BOOLEAN,
