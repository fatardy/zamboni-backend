DROP DATABASE IF EXISTS zamboni;

CREATE DATABASE zamboni;
USE zamboni;

-- company in old design
CREATE TABLE aa_firms (
    firmId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(50),
    regNo VARCHAR(10) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (firmId)
);

CREATE TABLE aa_users (
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
CREATE TABLE aa_admins (
    userId INT(10) UNSIGNED NOT NULL,
    isAdmin BOOLEAN NOT NULL DEFAULT true,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES aa_users(userId)
);

-- 'C'
CREATE TABLE aa_customers (
    userId INT(10) UNSIGNED NOT NULL,
    driverLicense VARCHAR(10), -- why unique;
    insurancePolicy VARCHAR(10),
    insuranceCompany VARCHAR(30),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES aa_users(userId)
);

-- 'B'
CREATE TABLE aa_bizCustomers (
    userId INT(10) UNSIGNED NOT NULL,
    empNo INT(10) NOT NULL, -- why unique;
    firmId INT(10) UNSIGNED NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES aa_users(userId),
    FOREIGN KEY (firmId) REFERENCES aa_firms(firmId)
);

CREATE TABLE aa_otps (
    id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    otp INT(6) NOT NULL,
    userId INT(10) UNSIGNED NOT NULL UNIQUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    FOREIGN KEY (userId) REFERENCES aa_users(userId)
);

CREATE TABLE aa_vehicleTypes (
    vtId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    rate DECIMAL(9, 2) NOT NULL,
    overFee DECIMAL(9, 2) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (vtId)
);


CREATE TABLE aa_locations (
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

CREATE TABLE aa_locations_vehicleTypes (
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
    FOREIGN KEY (locId) REFERENCES aa_locations(locId),
    FOREIGN KEY (vtId) REFERENCES aa_vehicleTypes(vtId)
);

CREATE TABLE aa_coupons (
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

CREATE TABLE aa_users_coupons (
    userId INT(10) UNSIGNED NOT NULL,
    coupId INT(10) UNSIGNED NOT NULL,
    coupType VARCHAR(30), -- what is this??

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (userId, coupId)
);

CREATE TABLE aa_trips (
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
    FOREIGN KEY (userId) REFERENCES aa_users(userId),
    FOREIGN KEY (pickLocId) REFERENCES aa_locations(locId),
    FOREIGN KEY (dropLocId) REFERENCES aa_locations(locId),
    FOREIGN KEY (vehId) REFERENCES aa_locations_vehicleTypes(vehId),
    FOREIGN KEY (coupId) REFERENCES aa_coupons(coupId)
);

CREATE TABLE aa_invoices (
    invId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    invDate DATETIME NOT NULL,
    amount DECIMAL(10, 2),
    tripId INT(10) UNSIGNED NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (invId),
    FOREIGN KEY (tripId) REFERENCES aa_trips(tripId)
);

CREATE TABLE aa_payments (
    payId INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    payDate DATETIME NOT NULL,
    amount DECIMAL(10, 2),
    method ENUM('VISA', 'MASTERCARD', 'RUPAY', 'OTHER'), -- CHANGE THIS!
    cardNo VARCHAR(16),
    invId INT(10) UNSIGNED NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (payId),
    FOREIGN KEY (invId) REFERENCES aa_invoices(invId)
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
    from aa_trips as a
    left join aa_invoices as b
        on a.tripId = b.tripId
    join aa_locations as c
        on a.pickLocId = c.locId
    join aa_locations as d
        on a.pickLocId = d.locId
    left join aa_payments as e
        on b.invId = e.invId
    join aa_locations_vehicleTypes f
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
    from aa_trips a
    join aa_users b
        on a.userId = b.userId
    join aa_locations_vehicleTypes c
        on a.vehId = c.vehId
    join aa_vehicleTypes d
        on c.vtId = d.vtId
    left join aa_invoices e
        on a.tripId = e.tripId
    left join aa_payments f
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
    from aa_locations_vehicleTypes as a
    join aa_locations as b
        on a.locId = b.locId
    join aa_vehicleTypes as c
        on a.vtId = c.vtId
    where a.vehId not in (
        select vehId
        from aa_trips a
        where a.inProgress = true    
    ) AND a.locId = locId;
end //
delimiter ;
