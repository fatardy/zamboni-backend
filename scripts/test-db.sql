DROP DATABASE IF EXISTS zamboni;

CREATE DATABASE zamboni;
USE zamboni;

-- company in old design
CREATE TABLE firms (
    firmId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(50),
    regNo VARCHAR(10) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

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
    userType CHAR(1) DEFAULT 'C',  -- discriminator 'A', 'C', 'B'

    -- do you need this everywhere else?
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (userId)
);

-- 'A'
CREATE TABLE admins (
    userId INT(10) UNSIGNED NOT NULL,
    isAdmin BOOLEAN NOT NULL DEFAULT true,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES users(userId)
);

-- 'C'
CREATE TABLE customers (
    userId INT(10) UNSIGNED NOT NULL,
    driverLicense VARCHAR(10) NOT NULL UNIQUE, -- why unique;
    insurancePolicy VARCHAR(10) NOT NULL,
    insuranceCompany VARCHAR(30) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES users(userId)
);

-- 'B'
CREATE TABLE bizCustomers (
    userId INT(10) UNSIGNED NOT NULL,
    empNo INT(10) NOT NULL UNIQUE, -- why unique;
    firmId INT(10) UNSIGNED NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES users(userId),
    FOREIGN KEY (firmId) REFERENCES firms(firmId)
);

CREATE TABLE otps (
    id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    otp INT(6) NOT NULL,
    userId INT(10) UNSIGNED NOT NULL UNIQUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    FOREIGN KEY (userId) REFERENCES users(userId)
);

CREATE TABLE vehicleTypes (
    vtId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    rate DECIMAL(9, 2) NOT NULL,
    overFee DECIMAL(9, 2) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

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

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
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
    avatar VARCHAR(300),
    odo DECIMAL(10, 2) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (vehId),
    FOREIGN KEY (locId) REFERENCES locations(locId),
    FOREIGN KEY (vtId) REFERENCES vehicleTypes(vtId)
);

CREATE TABLE coupons (
    coupId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(60) NOT NULL,
    percent DECIMAL(5, 2),
    flatRate DECIMAL(5, 2),
    startDate DATETIME NOT NULL,
    endDate DATETIME NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (coupId)
);

CREATE TABLE users_coupons (
    userId INT(10) UNSIGNED NOT NULL,
    coupId INT(10) UNSIGNED NOT NULL,
    coupType VARCHAR(30), -- what is this??

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

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

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

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

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (invId),
    FOREIGN KEY (tripId) REFERENCES trips(tripId)
);

CREATE TABLE payments (
    payId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    payDate DATETIME NOT NULL,
    amount DECIMAL(10, 2),
    method ENUM('VISA', 'MASTERCARD', 'RUPAY', 'OTHER'), -- CHANGE THIS!
    cardNo VARCHAR(16),
    invId INT(10) UNSIGNED NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

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
    "Fulton St",
    1231231234,
    "fulton@zamboni.com",
    "1364 Fulton St",
    "Brooklyn",
    "New York",
    "123113",
    "USA"
);

INSERT INTO locations (name, phoneNumber, email, street1, city, stateName, zipCode, country)
VALUES (
    "Borough Hall",
    1231231267,
    "borough@check.com",
    "9 Brooklyn Commons",
    "Brooklyn",
    "New York",
    "11213",
    "USA"
);

INSERT INTO locations (name, phoneNumber, email, street1, city, stateName, zipCode, country)
VALUES (
    "Bakers St",
    1231231294,
    "bakers@zamboni.com",
    "331 Bakers St",
    "Boston",
    "Massachusetts",
    "10004",
    "USA"
);

INSERT INTO locations (name, phoneNumber, email, street1, city, stateName, zipCode, country)
VALUES (
    "Another St",
    1231231294,
    "bakers@zamboni.com",
    "331 Bakers St",
    "Boston",
    "Massachusetts",
    "10004",
    "USA"
);

INSERT INTO locations (name, phoneNumber, email, street1, city, stateName, zipCode, country)
VALUES (
    "Third St",
    1231231294,
    "bakers@zamboni.com",
    "331 Bakers St",
    "Boston",
    "Massachusetts",
    "10004",
    "USA"
);

INSERT INTO locations (name, phoneNumber, email, street1, city, stateName, zipCode, country)
VALUES (
    "Fourth St",
    1231231294,
    "bakers@zamboni.com",
    "331 Bakers St",
    "Boston",
    "Massachusetts",
    "10004",
    "USA"
);
INSERT INTO coupons (name, percent, startDate, endDate)
VALUES (
    "30% Off",
    10,
    "2022-05-04 19-57-10",
    "2022-05-06 19-57-10"
);

INSERT INTO coupons (name, percent, startDate, endDate)
VALUES (
    "40% Off",
    40,
    "2022-05-04 19-57-10",
    "2022-05-06 19-57-10"
);

INSERT INTO coupons (name, percent, startDate, endDate)
VALUES (
    "50% Off",
    50,
    "2022-05-04 19-57-10",
    "2022-05-06 19-57-10"
);

INSERT INTO coupons (name, percent, startDate, endDate)
VALUES (
    "10% Off",
    10,
    "2022-05-04 19-57-10",
    "2022-05-06 19-57-10"
);

INSERT INTO coupons (name, percent, startDate, endDate)
VALUES (
    "5% Off",
    5,
    "2022-05-04 19-57-10",
    "2022-05-06 19-57-10"
);

INSERT INTO coupons (name, flatRate, startDate, endDate)
VALUES (
    "5$ Off",
    5,
    "2022-05-04 19-57-10",
    "2022-05-06 19-57-10"
);

INSERT INTO coupons (name, flatRate, startDate, endDate)
VALUES (
    "50$ Off",
    50,
    "2022-05-04 19-57-10",
    "2022-05-06 19-57-10"
);

INSERT INTO coupons (name, flatRate, startDate, endDate)
VALUES (
    "100$ Off",
    100,
    "2022-05-04 19-57-10",
    "2022-05-06 19-57-10"
);

INSERT INTO coupons (name, flatRate, startDate, endDate)
VALUES (
    "3$ Off",
    3,
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
    "Sedan",
    30.5,
    42
);
INSERT INTO vehicleTypes (name, rate, overFee)
VALUES (
    "Luxury Sedan",
    70,
    94
);
INSERT INTO vehicleTypes (name, rate, overFee)
VALUES (
    "Compact",
    14,
    19
);
INSERT INTO vehicleTypes (name, rate, overFee)
VALUES (
    "Supercar",
    125,
    170
);

INSERT INTO vehicleTypes (name, rate, overFee)
VALUES (
    "Small",
    30.5,
    42
);
INSERT INTO vehicleTypes (name, rate, overFee)
VALUES (
    "Tiny",
    70,
    94
);
INSERT INTO vehicleTypes (name, rate, overFee)
VALUES (
    "MUV",
    14,
    19
);
INSERT INTO vehicleTypes (name, rate, overFee)
VALUES (
    "All Terrain",
    125,
    170
);

INSERT INTO locations_vehicleTypes (vehId, make, model, licensePlate, locId, vtId, avatar, odo)
VALUES (
    "asdf1234qwer1234k",
    "BMW",
    "3 Series",
    "ASDF1234QW",
    "1",
    "1",
    "https://images.unsplash.com/photo-1547038577-da80abbc4f19?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1655&q=80",
    0
);

INSERT INTO locations_vehicleTypes (vehId, make, model, licensePlate, locId, vtId, avatar, odo)
VALUES (
    "qwer1234asdf1234i",
    "Mercedes",
    "5 Series",
    "ZSDF1234QW",
    "1",
    "2",
    "https://images.unsplash.com/photo-1503736334956-4c8f8e92946d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1674&q=80",
    994
);

INSERT INTO locations_vehicleTypes (vehId, make, model, licensePlate, locId, vtId, avatar, odo)
VALUES (
    "poiu1234asdf0987b",
    "Mazda",
    "MXR",
    "QWER1234IO",
    "2",
    "3",
    "https://images.unsplash.com/photo-1547038577-da80abbc4f19?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1655&q=80",
    23456
);

INSERT INTO locations_vehicleTypes (vehId, make, model, licensePlate, locId, vtId, avatar, odo)
VALUES (
    "zxcvasdf12345678b",
    "McLaren",
    "P1",
    "QWEROIUY23",
    "2",
    "4",
    "https://images.unsplash.com/photo-1494905998402-395d579af36f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80",
    123450
);

drop procedure if exists zamboni.getAllTripsOfUser;

delimiter //
create procedure getAllTripsOfUser(in userId int(10))
begin
    select a.tripId, a.pickDate, a.dropDate, a.odoStart, a.odoEnd, a.inProgress,
        b.invId, b.invDate, b.amount,
        c.locId as "pickLocId", c.name as "pickLocName",
        d.locId as "dropLocId", d.name as "dropLocName",
        e.payId, e.payDate, e.amount as 'paidAmount', e.method, e.cardNo,
        f.vehId, f.make, f.model
    from trips as a
    left join invoices as b
        on a.tripId = b.tripId
    join locations as c
        on a.pickLocId = c.locId
    join locations as d
        on a.pickLocId = d.locId
    left join payments as e
        on b.invId = e.invId
    join locations_vehicleTypes f
        on a.vehId = f.vehId
    where a.userId = userId
    order by a.inProgress desc;
end //
delimiter ;

drop procedure if exists zamboni.adminGetAllTrips;

delimiter //
create procedure adminGetAllTrips()
begin
    select a.tripId, a.pickDate, a.dropDate, a.pickLocId, 
        a.dropLocId, a.odoStart, a.odoEnd, a.odoLimit,
        b.userId, b.firstName, b.lastName,
        c.vehId, c.make, c.model,
        e.invId, e.invDate, e.amount,
        f.payId, f.amount as 'paidAmount', f.method, f.cardNo
    from trips a
    join users b
        on a.userId = b.userId
    join locations_vehicleTypes c
        on a.vehId = c.vehId
    join vehicleTypes d
        on c.vtId = d.vtId
    left join invoices e
        on a.tripId = e.tripId
    left join payments f
        on e.invId = f.invId;
end //
delimiter ;

drop procedure if exists zamboni.getAvailableVehiclesBy;

delimiter //
create procedure getAvailableVehiclesBy(in locId int(10))
begin
    select b.locId, b.name as 'locName', 
        c.vtId as 'vtId', c.name as 'vehName', c.rate, c.overFee, 
        a.vehId, a.make, a.model, a.licensePlate, a.avatar
    from locations_vehicleTypes as a
    join locations as b
        on a.locId = b.locId
    join vehicleTypes as c
        on a.vtId = c.vtId
    where a.vehId not in (
        select vehId
        from trips a
        where a.inProgress = true    
    ) AND a.locId = locId;
end //
delimiter ;
