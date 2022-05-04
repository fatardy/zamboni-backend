CREATE TABLE na_booking (
    booking_id    NUMBER(10) NOT NULL,
    pickup_locid  NUMBER(10) NOT NULL,
    pickup_date   DATE NOT NULL,
    dropoff_date  DATE NOT NULL,
    dropoff_locid NUMBER(10) NOT NULL,
    odo_start     NUMBER(10, 2) NOT NULL,
    odo_end       NUMBER(10, 2) NOT NULL,
    odo_limit     NUMBER(10, 2) NOT NULL,
    vin           VARCHAR2(17) NOT NULL,
    cust_id       NUMBER(10) NOT NULL,
    coup_id       VARCHAR2(10)
);

ALTER TABLE na_booking ADD CONSTRAINT na_booking_pk PRIMARY KEY ( booking_id );

CREATE TABLE na_company (
    comp_id    NUMBER(10) NOT NULL,
    comp_name  VARCHAR2(30) NOT NULL,
    comp_regno VARCHAR2(10) NOT NULL
);

ALTER TABLE na_company ADD CONSTRAINT na_company_pk PRIMARY KEY ( comp_id );

CREATE TABLE na_corp (
    cust_id NUMBER(10) NOT NULL,
    emp_no  NUMBER(10) NOT NULL,
    comp_id NUMBER(10) NOT NULL
);

ALTER TABLE na_corp ADD CONSTRAINT na_corp_pk PRIMARY KEY ( cust_id );

ALTER TABLE na_corp ADD CONSTRAINT na_corp_pkv1 UNIQUE ( emp_no );

CREATE TABLE na_coup (
    coup_id        VARCHAR2(10) NOT NULL,
    coup_name      VARCHAR2(30) NOT NULL,
    coup_percent   NUMBER(4, 2) NOT NULL,
    coup_startdate DATE NOT NULL,
    coup_enddate   DATE NOT NULL
);

ALTER TABLE na_coup ADD CONSTRAINT na_coup_pk PRIMARY KEY ( coup_id );

CREATE TABLE na_cust (
    cust_id  NUMBER(10) NOT NULL,
    fname    VARCHAR2(30) NOT NULL,
    lname    VARCHAR2(30) NOT NULL,
    cphno    NUMBER(10) NOT NULL,
    cemailid VARCHAR2(30) NOT NULL,
    cstreet1 VARCHAR2(30) NOT NULL,
    cstreet2 VARCHAR2(30),
    ccity    VARCHAR2(30) NOT NULL,
    cstate   VARCHAR2(30) NOT NULL,
    czipcode VARCHAR2(6) NOT NULL,
    ccountry VARCHAR2(30) NOT NULL,
    ctype    CHAR(1) NOT NULL
);

ALTER TABLE na_cust
    ADD CONSTRAINT ch_inh_na_cust CHECK ( ctype IN ( 'C', 'I' ) );

ALTER TABLE na_cust ADD CONSTRAINT na_cust_pk PRIMARY KEY ( cust_id );

CREATE TABLE na_cust_coup (
    cust_id   NUMBER(10) NOT NULL,
    coup_id   VARCHAR2(10) NOT NULL,
    coup_type VARCHAR2(30) NOT NULL
);

ALTER TABLE na_cust_coup ADD CONSTRAINT na_cust_coup_pk PRIMARY KEY ( coup_id,
                                                                      cust_id );

CREATE TABLE na_indiv (
    cust_id      NUMBER(10) NOT NULL,
    driver_licno VARCHAR2(10) NOT NULL,
    ins_plcyno   VARCHAR2(10) NOT NULL,
    ins_compname VARCHAR2(30) NOT NULL
);

ALTER TABLE na_indiv ADD CONSTRAINT na_indiv_pk PRIMARY KEY ( cust_id );

ALTER TABLE na_indiv ADD CONSTRAINT na_indiv_pkv1 UNIQUE ( driver_licno );

CREATE TABLE na_invoice (
    inv_id     NUMBER(10) NOT NULL,
    inv_date   DATE NOT NULL,
    inv_amt    NUMBER(10, 2) NOT NULL,
    booking_id NUMBER(10) NOT NULL
);

CREATE UNIQUE INDEX na_invoice__idx ON
    na_invoice (
        booking_id
    ASC );

ALTER TABLE na_invoice ADD CONSTRAINT na_invoice_pk PRIMARY KEY ( inv_id );

ALTER TABLE na_invoice ADD CONSTRAINT na_invoice_pk PRIMARY KEY ( inv_id );
CREATE SEQUENCE name_of_sequence
 START WITH 1
 INCREMENT BY 1
 NOCACHE
 NOCYCLE;

CREATE TABLE na_loc (
    loc_id   NUMBER(10) NOT NULL,
    lname    VARCHAR2(30) NOT NULL,
    lemailid VARCHAR2(30) NOT NULL,
    lphno    NUMBER(10) NOT NULL,
    lstreet1 VARCHAR2(30) NOT NULL,
    lstreet2 VARCHAR2(30),
    lcity    VARCHAR2(30) NOT NULL,
    lstate   VARCHAR2(30) NOT NULL,
    lzipcode VARCHAR2(6) NOT NULL,
    lcountry VARCHAR2(30) NOT NULL
);

ALTER TABLE na_loc ADD CONSTRAINT na_loc_pk PRIMARY KEY ( loc_id );

CREATE TABLE na_loc_vclass (
    vin       VARCHAR2(17) NOT NULL,
    make      VARCHAR2(30) NOT NULL,
    model     VARCHAR2(30) NOT NULL,
    year      NUMBER(4) NOT NULL,
    lic_plate VARCHAR2(10) NOT NULL,
    loc_id    NUMBER(10) NOT NULL,
    vclass_id NUMBER(10) NOT NULL
);


ALTER TABLE na_loc_vclass ADD CONSTRAINT na_loc_vclass_pk PRIMARY KEY ( vin );

CREATE TABLE na_payment (
    pay_id     NUMBER(10) NOT NULL,
    pay_date   DATE NOT NULL,
    pay_amt    NUMBER(10, 2) NOT NULL,
    pay_method VARCHAR2(30) NOT NULL,
    card_no    NUMBER(16) NOT NULL,
    inv_id     NUMBER(10) NOT NULL
);

ALTER TABLE na_payment ADD CONSTRAINT na_payment_pk PRIMARY KEY ( pay_id );

CREATE TABLE na_vclass (
    vclass_id   NUMBER(10) NOT NULL,
    vclass_name VARCHAR2(30) NOT NULL,
    rate        NUMBER(9, 2) NOT NULL,
    over_fee    NUMBER(9, 2) NOT NULL
);

ALTER TABLE na_vclass ADD CONSTRAINT na_vclass_pk PRIMARY KEY ( vclass_id );

ALTER TABLE na_booking
    ADD CONSTRAINT na_booking_na_coup_fk FOREIGN KEY ( coup_id )
        REFERENCES na_coup ( coup_id );

ALTER TABLE na_booking
    ADD CONSTRAINT na_booking_na_cust_fk FOREIGN KEY ( cust_id )
        REFERENCES na_cust ( cust_id );

ALTER TABLE na_booking
    ADD CONSTRAINT na_booking_na_loc_fk FOREIGN KEY ( dropoff_locid )
        REFERENCES na_loc ( loc_id );

ALTER TABLE na_booking
    ADD CONSTRAINT na_booking_na_loc_fkv2 FOREIGN KEY ( pickup_locid )
        REFERENCES na_loc ( loc_id );

ALTER TABLE na_booking
    ADD CONSTRAINT na_booking_na_loc_vclass_fk FOREIGN KEY ( vin )
        REFERENCES na_loc_vclass ( vin );

ALTER TABLE na_corp
    ADD CONSTRAINT na_corp_na_company_fk FOREIGN KEY ( comp_id )
        REFERENCES na_company ( comp_id );

ALTER TABLE na_corp
    ADD CONSTRAINT na_corp_na_cust_fk FOREIGN KEY ( cust_id )
        REFERENCES na_cust ( cust_id );

ALTER TABLE na_cust_coup
    ADD CONSTRAINT na_cust_coup_na_coup_fk FOREIGN KEY ( coup_id )
        REFERENCES na_coup ( coup_id );

ALTER TABLE na_cust_coup
    ADD CONSTRAINT na_cust_coup_na_cust_fk FOREIGN KEY ( cust_id )
        REFERENCES na_cust ( cust_id );

ALTER TABLE na_indiv
    ADD CONSTRAINT na_indiv_na_cust_fk FOREIGN KEY ( cust_id )
        REFERENCES na_cust ( cust_id );

ALTER TABLE na_invoice
    ADD CONSTRAINT na_invoice_na_booking_fk FOREIGN KEY ( booking_id )
        REFERENCES na_booking ( booking_id );

ALTER TABLE na_loc_vclass
    ADD CONSTRAINT na_loc_vclass_na_loc_fk FOREIGN KEY ( loc_id )
        REFERENCES na_loc ( loc_id );

ALTER TABLE na_loc_vclass
    ADD CONSTRAINT na_loc_vclass_na_vclass_fk FOREIGN KEY ( vclass_id )
        REFERENCES na_vclass ( vclass_id );

ALTER TABLE na_payment
    ADD CONSTRAINT na_payment_na_invoice_fk FOREIGN KEY ( inv_id )
        REFERENCES na_invoice ( inv_id );

CREATE OR REPLACE TRIGGER arc_fkarc_2_na_indiv BEFORE
    INSERT OR UPDATE OF cust_id ON na_indiv
    FOR EACH ROW
DECLARE
    d CHAR(1);
BEGIN
    SELECT
        a.ctype
    INTO d
    FROM
        na_cust a
    WHERE
        a.cust_id = :new.cust_id;

    IF ( d IS NULL OR d <> 'I' ) THEN
        raise_application_error(
                               -20223,
                               'FK NA_INDIV_NA_CUST_FK in Table NA_INDIV violates Arc constraint on Table NA_CUST - discriminator column CTYPE doesn''t have value ''I'''
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/

CREATE OR REPLACE TRIGGER arc_fkarc_2_na_corp BEFORE
    INSERT OR UPDATE OF cust_id ON na_corp
    FOR EACH ROW
DECLARE
    d CHAR(1);
BEGIN
    SELECT
        a.ctype
    INTO d
    FROM
        na_cust a
    WHERE
        a.cust_id = :new.cust_id;

    IF ( d IS NULL OR d <> 'C' ) THEN
        raise_application_error(
                               -20223,
                               'FK NA_CORP_NA_CUST_FK in Table NA_CORP violates Arc constraint on Table NA_CUST - discriminator column CTYPE doesn''t have value ''C'''
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/
