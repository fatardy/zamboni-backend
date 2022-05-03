

CREATE or replace TRIGGER trg_invoice_update
AFTER INSERT ON na_booking
FOR EACH ROW
DECLARE temp_invoice_amt number(10, 2);
temp_booking_id number(10);
BEGIN
   
    SELECT CASE WHEN :NEW.COUP_ID IS NOT NULL 
         THEN 
            CASE WHEN ((:NEW.ODO_END-:NEW.ODO_START) > (:NEW.ODO_LIMIT)) 
                THEN ROUND((VC.RATE*(:NEW.DROPOFF_DATE-:NEW.PICKUP_DATE))+(VC.OVER_FEE*((:NEW.ODO_END-:NEW.ODO_START))-:NEW.ODO_LIMIT)  - ((C.COUP_PERCENT * (VC.RATE*(:NEW.DROPOFF_DATE-:NEW.PICKUP_DATE))+(VC.OVER_FEE*((:NEW.ODO_END-:NEW.ODO_START))-:NEW.ODO_LIMIT))/100), 2)
            ELSE ROUND((VC.RATE*(:NEW.DROPOFF_DATE-:NEW.PICKUP_DATE))  - ((C.COUP_PERCENT * (VC.RATE*(:NEW.DROPOFF_DATE-:NEW.PICKUP_DATE)))/100), 2) END
        ELSE CASE WHEN ((:NEW.ODO_END-:NEW.ODO_START) > (:NEW.ODO_LIMIT)) 
                THEN ROUND((VC.RATE*(:NEW.DROPOFF_DATE-:NEW.PICKUP_DATE))+(VC.OVER_FEE*((:NEW.ODO_END-:NEW.ODO_START)-:NEW.ODO_LIMIT)), 2)
            ELSE ROUND((VC.RATE*(:NEW.DROPOFF_DATE-:NEW.PICKUP_DATE)), 2) end
    end
        
    into temp_invoice_amt


    FROM NA_LOC_VCLASS LVC
    JOIN NA_VCLASS VC 
    ON LVC.VCLASS_ID = VC.VCLASS_ID
    LEFT JOIN NA_COUP C
    ON C.COUP_ID = :NEW.COUP_ID
    WHERE LVC.VIN = :NEW.VIN;
    -- AND C.COUP_ID = :NEW.COUP_ID;

    INSERT INTO na_invoice
    VALUES(name_of_sequence.nextval, SYSDATE, temp_invoice_amt,:NEW.booking_id);
    
END;



INSERT INTO na_loc (loc_id, lname, lstreet1, lstreet2, lcity, lstate, lcountry, lzipcode, lphno, lemailid) VALUES ( 1, '131 Allen St', '131 Allen St', '', 'New York', 'NY', 'United States', 10002, 6466516321, 'allen_st@wowrentals.com');
INSERT INTO na_loc (loc_id, lname, lstreet1, lstreet2, lcity, lstate, lcountry, lzipcode, lphno, lemailid) VALUES ( 2, '223 E 5th St', '223 E 5th St', '', 'New York', 'NY', 'United States', 10002, 5354264784, 'east_5th@wowrentals.com');
INSERT INTO na_loc (loc_id, lname, lstreet1, lstreet2, lcity, lstate, lcountry, lzipcode, lphno, lemailid) VALUES ( 3, '4 Union St', '4 Union St', 'Floor 1', 'Brooklyn', 'NY', 'United States', 11211, 2025550128, 'union_st@wowrentals.com');
INSERT INTO na_loc (loc_id, lname, lstreet1, lstreet2, lcity, lstate, lcountry, lzipcode, lphno, lemailid) VALUES ( 4, '9 Nevins', '9 Nevins', '', 'Brooklyn', 'NY', 'United States', 11211, 2025550195, 'nevins_brook@wowrentals.com');
INSERT INTO na_loc (loc_id, lname, lstreet1, lstreet2, lcity, lstate, lcountry, lzipcode, lphno, lemailid) VALUES ( 5, '1121 Utica Av', '1121 Utica Av', 'Utica', 'Brooklyn', 'NY', 'United States', 11213, 2025550184, 'utica_brook@wowrentals.com');
INSERT INTO na_loc (loc_id, lname, lstreet1, lstreet2, lcity, lstate, lcountry, lzipcode, lphno, lemailid) VALUES ( 6, '2 Jewel Ave', '2 Jewel Ave', '', 'Queens', 'NY', 'United States', 21433, 7873627428, 'queens_jewel@wowrentals.com');
INSERT INTO na_loc (loc_id, lname, lstreet1, lstreet2, lcity, lstate, lcountry, lzipcode, lphno, lemailid) VALUES ( 7, '13 W 48th St', '13', 'W 48th St', 'Bayonne', 'New Jersey', 'United States', 35559, 7638985968, 'west_bay@wowrentals.com');
INSERT INTO na_loc (loc_id, lname, lstreet1, lstreet2, lcity, lstate, lcountry, lzipcode, lphno, lemailid) VALUES ( 8, '1 Mercer St', '1 Mercer St', '', 'Jersey City', 'New Jersey', 'United States', 34442, 7939387747, 'mercer_bay@wowrentals.com');
INSERT INTO na_loc (loc_id, lname, lstreet1, lstreet2, lcity, lstate, lcountry, lzipcode, lphno, lemailid) VALUES ( 9, 'Wonder Lofts 3', 'Wonder Lofts 3', 'G4', 'Jersey City', 'New Jersey', 'United States', 36767, 6748473737, 'lofts_jersey@wowrentals.com');
INSERT INTO na_loc (loc_id, lname, lstreet1, lstreet2, lcity, lstate, lcountry, lzipcode, lphno, lemailid) VALUES ( 10, '13 Jump st', '13 Jump st', '', 'Boston', 'Massachusetts', 'United States', 919234, 5774838742, 'jump_bost@wowrentals.com');
INSERT INTO na_loc (loc_id, lname, lstreet1, lstreet2, lcity, lstate, lcountry, lzipcode, lphno, lemailid) VALUES ( 11, '4 Utica av', '4 Utica av', '3rd', 'Boston', 'Massachusetts', 'United States', 923411, 8689548734, 'utica_boston@wowrentals.com');
INSERT INTO na_loc (loc_id, lname, lstreet1, lstreet2, lcity, lstate, lcountry, lzipcode, lphno, lemailid) VALUES ( 12, '3 Dunder Mifflin Office', '3 Dunder Mifflin Office', '', 'Roxbury', 'Pennsylvania', 'United States', 636848, 5884737384, 'dunder_mif@wowrentals.com');
INSERT INTO na_loc (loc_id, lname, lstreet1, lstreet2, lcity, lstate, lcountry, lzipcode, lphno, lemailid) VALUES ( 13, '3452 Paper comp', '3452 Paper comp', 'Garage 4', 'Scranton', 'Pennsylvania', 'United States', 845464, 5848737374, 'dunder_scrant@wowrentals.com');

INSERT INTO na_vclass (vclass_id, vclass_name, rate, over_fee) VALUES( 2, 'Mid Size', 20, 2 );
INSERT INTO na_vclass (vclass_id, vclass_name, rate, over_fee) VALUES( 3, 'Luxury', 22, 4 );
INSERT INTO na_vclass (vclass_id, vclass_name, rate, over_fee) VALUES( 4, 'SUV', 30, 4 );
INSERT INTO na_vclass (vclass_id, vclass_name, rate, over_fee) VALUES( 5, 'Premium SUV', 35, 6 );
INSERT INTO na_vclass (vclass_id, vclass_name, rate, over_fee) VALUES( 6, 'MUV', 40, 6 );
INSERT INTO na_vclass (vclass_id, vclass_name, rate, over_fee) VALUES( 7, 'Mini Van', 42, 8 );
INSERT INTO na_vclass (vclass_id, vclass_name, rate, over_fee) VALUES( 8, 'Station Wagon', 50, 8 );
INSERT INTO na_vclass (vclass_id, vclass_name, rate, over_fee) VALUES( 9, 'Hummer', 90, 10 );
INSERT INTO na_vclass (vclass_id, vclass_name, rate, over_fee) VALUES( 10, 'Limo', 95, 10 );
INSERT INTO na_vclass (vclass_id, vclass_name, rate, over_fee) VALUES( 11, 'Antique', 100, 12 );
INSERT INTO na_vclass (vclass_id, vclass_name, rate, over_fee) VALUES( 12, 'Coupe', 140, 12 );
INSERT INTO na_vclass (vclass_id, vclass_name, rate, over_fee) VALUES( 13, 'Sports', 220, 20 );

INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 1, 7, '1L2K3J4H123K4JH22', 'Ultima', 'SLX', 2009, 'ASDF234');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 1, 5, '2LK3J4H52LK3J4H52', 'Const ', 'GLS', 2013, 'QWER345');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 2, 4, '23K4J5H23KL4J5H44', 'Let Var', 'GZ', 2003, '987IUY');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 2, 3, '34K5JH6332356SDBA', 'S Class', '3', 2008, '098OIUY');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 3, 5, '456LKJ3H456LKJ3H4', 'Sumone', 'C', 2005, '3456QWER');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 4, 5, '2L3K4J5H23KL4J5H2', '3 Series', '13', 2009, 'FDS543');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 4, 6, 'L23KJ45H23LK4J5H2', 'Busy', 'M', 2009, '456GDF');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 5, 4, '23L4KJ5H23L4KJ5H2', 'Wrk', 'QZ', 2009, 'GDFJHFG3');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 5, 3, '23L4KJ5H2M34N5B23', 'Until 3', 'SFX', 2021, '4567usxc');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 6, 2, '23U4T5IU23Y45HFJY', 'LngSun', 'ISO', 2003, 'POI234');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 6, 10, 'I2U3TR5U2YT35R676', 'SteelyDan', '99', 2008, 'POIU234');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 6, 12, '23KJ45H23JG5F3QWE', 'Spice Rogue', 'TOTO', 2009, 'UIK542');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 6, 11, '2O34UI5Y234OIU5Y2', 'Silver Horse', 'Spyder', 2013, 'BUO5768');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 7, 4, 'OIUY345IUY34ZXCV4', 'Random Life', 'Tiger Gorden', 2003, 'VKGLJ567');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 7, 5, 'IU3Y45IUY345ZXCVV', 'OyoSweep', 'Chass 1', 2008, '2384ULS');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 7, 3, 'IU3Y45IU3Y45O34IS', 'Cervasity', 'Prime Ed', 2009, '2O3SNFLS');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 8, 4, 'I356P3OI4O5U6IUY3', 'Constad', 'GLX', 2000, '2039RUAL');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 8, 3, '3IU45Y6Y3OIU4Y234', 'Fermun', 'RX3', 2019, 'ASODFU');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 8, 2, 'IU2Y4IU2Y34O234XC', 'BirdySto', 'MXr', 2022, 'O2INDLVO2');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 9, 2, 'AS90D8F7XKVJHASDF', 'Accura', 'v6', 2003, 'S987FXK');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 10, 2, 'IA7SDFHLAKSJDFHBV', 'Creeper', 'LXXi', 2009, 'A98AKVH');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 10, 3, '10928347KUHQSDFIY', 'Barracuda', 'v8', 2013, '9ASFKJHV');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 11, 3, 'AKSJHVCAISUDY2345', 'Smokemachine', 'GX', 2003, 'A9YIAUK');
INSERT INTO na_loc_vclass (loc_id, vclass_id, vin, make, model, year, lic_plate) VALUES( 11, 2, 'ALKSDJHFOWIUEYR93', 'Silver Fang', 'GXL', 2008, 'S9DY8CH');

INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'wowDisc11', 'wowDisc11', 5, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'wowDisc12', 'wowDisc12', 5, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('04/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'wowDisc13', 'wowDisc13', 5, TO_DATE('02/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('07/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'wowDisc14', 'wowDisc14', 5, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'wowDisc15', 'wowDisc15', 10, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'wowDisc16', 'wowDisc16', 10, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'wowDisc17', 'wowDisc17', 10, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'wowDisc18', 'wowDisc18', 10, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'wowDisc19', 'wowDisc19', 15, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'wowDisc21', 'wowDisc21', 15, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'wowDisc22', 'wowDisc22', 15, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'wowDisc23', 'wowDisc23', 15, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'corpDisc25', 'corpDisc25', 12, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'corpDisc26', 'corpDisc26', 12, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'corpDisc27', 'corpDisc27', 12, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'corpDisc28', 'corpDisc28', 12, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'corpDisc29', 'corpDisc29', 20, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'corpDisc30', 'corpDisc30', 20, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
INSERT INTO na_coup (coup_id, coup_name, coup_percent, coup_startdate, coup_enddate) VALUES( 'corpDisc31', 'corpDisc31', 20, TO_DATE('01/01/2021 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 1, 'Viology', '345425673');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 2, 'Dancertone', '2354236432');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 3, 'Musicly', '25364252');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 4, 'Dancerr', '676545678');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 5, 'Jazzient', '6765456787');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 6, 'Jazzcene', '7898765');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 7, 'Arttoney', '5434543');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 8, 'Grapsody', '456754345');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 9, 'Sologic', '5456543456');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 10, 'Rapsody', '545654567');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 11, 'Dramic', '456765435');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 12, 'Busic', '456543456');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 13, 'Songchic', '5765434543');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 14, 'Musicinest', '454234');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 15, 'Musicket', '2345');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 16, 'Concertera', '23456');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 17, 'MusicModa', '34565432');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 18, 'Enter.ly', '456765432');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 19, 'Daily Symp', '5678654');
INSERT INTO na_company (comp_id, comp_name, comp_regno) VALUES( 20, 'White Noise', '676543');

INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 1, 'Blair', 'Tata', 3454567345, 'blairtata@gmail.com', '234 Market St', '', 'New York', 'New York', 'United States', 10002, 'I');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 2, 'Sadia', 'Valeri', 4563453453, 'sadiavaleri@gmail.com', 'Hudson Yards 4', '34 Floor', 'New York', 'New York', 'United States', 10002, 'I');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 3, 'Colmán', 'Luke', 4657456345, 'colmánluke@gmail.com', 'Empire States', 'Apt 3', 'New York', 'New York', 'United States', 11211, 'I');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 4, 'Philippe', 'Yehuda', 5674563234, 'philippeyehuda@gmail.com', '345 Reger st', 'Floor 3', 'New York', 'New York', 'United States', 11211, 'I');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 5, 'Gualtiero', 'Beniamin', 3452564564, 'gualtierobeniamin@gmail.com', '1 Cairo', '', 'New York', 'New York', 'United States', 11213, 'I');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 6, 'Ambrozije', 'Justin', 3423423434, 'ambrozijejustin@gmail.com', '45 Brozo', '', 'Boston', 'Massachusetts', 'United States', 21433, 'I');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 7, 'Deepa', 'Caetlin', 4567567453, 'deepacaetlin@gmail.com', '56 Sixes', '', 'Boston', 'Massachusetts', 'United States', 35559, 'I');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 8, 'Chetan', 'Ivet', 5676784565, 'chetanivet@hotmail.com', '35 Enchilada av', '34', 'Boston', 'Massachusetts', 'United States', 34442, 'I');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 9, 'Teona', 'Jostein', 6796787545, 'teonajostein@hotmail.com', 'Main rd', '', 'Boston', 'Massachusetts', 'United States', 36767, 'I');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 10, 'Nolan', 'Jeni', 7567345345, 'nolanjeni@hotmail.com', 'Gully rd', '13', 'Jersey City', 'New Jersey', 'United States', 919234, 'I');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 11, 'Leopold', 'Aaron', 5674534646, 'leopoldaaron@hotmail.com', '456 Man man', '', 'Jersey City', 'New Jersey', 'United States', 923411, 'I');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 12, 'Sujay', 'Sandile', 3453452354, 'sujaysandile@hotmail.com', '24 Mercer', '', 'Jersey City', 'New Jersey', 'United States', 636848, 'C');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 13, 'Isamu', 'Doris', 3245354745, 'isamudoris@hotmail.com', '24 Creepy', '55', 'Queens', 'New York', 'United States', 10002, 'C');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 14, 'Vishnu', 'Sofiya', 4564564564, 'vishnusofiya@yahoo.com', '13245 Malvolio', '', 'Queens', 'New York', 'United States', 10002, 'C');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 15, 'El', 'Gorg', 5686798676, 'elgorg@yahoo.com', '34 Harry', '', 'Queens', 'New York', 'United States', 11211, 'C');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 16, 'Volya', 'Wafi', 5467365785, 'volyawafi@yahoo.com', '56 potter', '33 Floor', 'New York', 'New York', 'United States', 11211, 'C');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 17, 'Kayleah', 'Mutamid', 5675824564, 'kayleahmutamid@yahoo.com', '345', '14 St London', 'New York', 'New York', 'United States', 11213, 'C');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 18, 'Ritik', 'Lnu', 3453243242, 'ruthiklnu@gmail.com', '7032 4th Ave', 'Brooklyn', 'New York', 'New York', 'United States', 11209, 'C');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 19, 'Sowmith', 'Saridena', 4535553452, 'sowmgoy@gmail.com', '7032 4th Ave', 'Brooklyn', 'New York', 'New York', 'United States', 11209, 'C');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 20, 'Samson', 'Sanju', 5627254312, 'Samson@gmail.com', '7031 4th Ave', 'Sunsetpark', 'New York', 'New York', 'United States', 345245, 'C');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 21, 'Mohith', 'verma', 4325648676, 'mohithverma@gmail.com', '7034 4th Ave', '', 'New York', 'New York', 'United States', 43543, 'C');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 22, 'Lohith', 'sherma', 3456554343, 'Llohithsherma@gmail.com', '4032 5th Ave', '', 'New York', 'New York', 'United States', 345245, 'C');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 23, 'Giri', 'bellam', 8765423456, 'giribellam@gmail.com', '7132 6th Ave', '', 'Boston', 'Massachusetts', 'United States', 11207, 'C');
INSERT INTO na_cust (cust_id, fname, lname,  cphno, cemailid, cstreet1, cstreet2, ccity, cstate, ccountry, czipcode, ctype) VALUES( 24, 'Jack', 'Sparrow', 3456543234, 'jacksparrow123@gmail.com', '7032 8th Ave', '', 'Jersey City', 'New Jersey', 'United States', 11232, 'I');

INSERT INTO na_indiv (cust_id, driver_licno, ins_plcyno,  ins_compname) VALUES( 1, '345234123', '3542341243', 'Jerry');
INSERT INTO na_indiv (cust_id, driver_licno, ins_plcyno,  ins_compname) VALUES( 2, '457687564', '5365234346', 'Libery Mutual');
INSERT INTO na_indiv (cust_id, driver_licno, ins_plcyno,  ins_compname) VALUES( 3, '345346556', '5767645352', 'Smart Financial Insurance');
INSERT INTO na_indiv (cust_id, driver_licno, ins_plcyno,  ins_compname) VALUES( 4, '467678456', '4567566354', 'Dancers Choice');
INSERT INTO na_indiv (cust_id, driver_licno, ins_plcyno,  ins_compname) VALUES( 5, '678678745', '6787654345', 'Sweet Comuppance');
INSERT INTO na_indiv (cust_id, driver_licno, ins_plcyno,  ins_compname) VALUES( 6, '456345213', '6543456765', 'First Time Safety');
INSERT INTO na_indiv (cust_id, driver_licno, ins_plcyno,  ins_compname) VALUES( 7, '674563545', '5676545678', 'Nocome Insurance');
INSERT INTO na_indiv (cust_id, driver_licno, ins_plcyno,  ins_compname) VALUES( 8, '578678345', '8765678765', 'Jerry');
INSERT INTO na_indiv (cust_id, driver_licno, ins_plcyno,  ins_compname) VALUES( 9, '123948719', '8789765674', 'Libery Mutual');
INSERT INTO na_indiv (cust_id, driver_licno, ins_plcyno,  ins_compname) VALUES( 10, '356858259', '8767898765', 'Smart Financial Insurance');
INSERT INTO na_indiv (cust_id, driver_licno, ins_plcyno,  ins_compname) VALUES( 11, '923874534', '8765678765', 'Dancers Choice');

INSERT INTO na_corp (cust_id, emp_no, comp_id) VALUES( 12, '345324',1);
INSERT INTO na_corp (cust_id, emp_no, comp_id) VALUES( 13, '67',2);
INSERT INTO na_corp (cust_id, emp_no, comp_id) VALUES( 14, '5476',3);
INSERT INTO na_corp (cust_id, emp_no, comp_id) VALUES( 15, '576',4);
INSERT INTO na_corp (cust_id, emp_no, comp_id) VALUES( 16, '54',5);
INSERT INTO na_corp (cust_id, emp_no, comp_id) VALUES( 17, '2323',6);
INSERT INTO na_corp (cust_id, emp_no, comp_id) VALUES( 18, '345',7);
INSERT INTO na_corp (cust_id, emp_no, comp_id) VALUES( 19, '234',8);
INSERT INTO na_corp (cust_id, emp_no, comp_id) VALUES( 20, '122',9);
INSERT INTO na_corp (cust_id, emp_no, comp_id) VALUES( 21, '64657',10);
INSERT INTO na_corp (cust_id, emp_no, comp_id) VALUES( 22, '534',6);
INSERT INTO na_corp (cust_id, emp_no, comp_id) VALUES( 23, '5345',7);
INSERT INTO na_corp (cust_id, emp_no, comp_id) VALUES( 24, '524523',8);

INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 1, 'wowDisc11','Individual');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 2, 'wowDisc12','Individual');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 3, 'wowDisc13','Individual');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 4, 'wowDisc14','Individual');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 5, 'wowDisc15','Individual');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 6, 'wowDisc16','Individual');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 7, 'wowDisc17','Individual');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 8, 'wowDisc18','Individual');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 9, 'wowDisc19','Individual');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 10, 'wowDisc21','Individual');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 11, 'wowDisc22','Individual');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 12, 'corpDisc25','Corporate');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 13, 'corpDisc26','Corporate');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 14, 'corpDisc27','Corporate');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 15, 'corpDisc28','Corporate');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 16, 'corpDisc29','Corporate');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 17, 'corpDisc30','Corporate');
INSERT INTO na_cust_coup (cust_id, coup_id, coup_type) VALUES( 18, 'corpDisc31','Corporate');


INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 1, 1, TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),1, TO_DATE('01/05/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),3540, 3582, 100, '1L2K3J4H123K4JH22', 2, NULL);
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 1, 1, TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),1, TO_DATE('01/05/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),3540, 3582, 100, '1L2K3J4H123K4JH22', 2, 'wowDisc11');
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 2, 2, TO_DATE('01/06/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),2, TO_DATE('01/07/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),1234, 1260, 50, '2LK3J4H52LK3J4H52', 4, 'wowDisc12');
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 3, 3, TO_DATE('01/08/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),3, TO_DATE('01/11/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),34567, 34647, 20, '23K4J5H23KL4J5H44', 5, 'wowDisc13');
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 4, 4, TO_DATE('01/13/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),4, TO_DATE('01/20/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),22344, 22427, 30, '34K5JH6332356SDBA', 6, 'wowDisc14');
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 5, 6, TO_DATE('01/21/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),6, TO_DATE('01/28/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),74635, 74648, 10, '456LKJ3H456LKJ3H4', 7, 'wowDisc15');
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 6, 4, TO_DATE('02/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),4, TO_DATE('02/10/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),57674, 57996, 60, '2L3K4J5H23KL4J5H2', 8, NULL);
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 7, 7, TO_DATE('02/11/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),7, TO_DATE('02/14/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),85684, 85765, 100, 'L23KJ45H23LK4J5H2', 9, NULL);
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 8, 6, TO_DATE('02/15/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),6, TO_DATE('02/18/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),68584, 68644, 200, '23L4KJ5H23L4KJ5H2', 10, 'wowDisc18');
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 9, 7, TO_DATE('02/19/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),7, TO_DATE('02/21/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),6869, 6952, 30, '23L4KJ5H2M34N5B23', 3, NULL);
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 10, 8, TO_DATE('02/22/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),8, TO_DATE('02/27/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),7993, 8103, 80, '23U4T5IU23Y45HFJY', 11, NULL);
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 11, 9, TO_DATE('03/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),9, TO_DATE('03/05/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),87474, 87568, 30, 'I2U3TR5U2YT35R676', 12, NULL);
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 12, 10, TO_DATE('03/06/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),10, TO_DATE('03/07/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),868, 895, 100, '23KJ45H23JG5F3QWE', 13, 'corpDisc25');
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 13, 11, TO_DATE('03/09/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),11, TO_DATE('03/12/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),49837, 49935, 200, '2O34UI5Y234OIU5Y2', 14, 'corpDisc26');
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 14, 12, TO_DATE('03/13/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),12, TO_DATE('03/15/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),6968, 6997, 90, 'OIUY345IUY34ZXCV4', 15, NULL);
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 15, 1, TO_DATE('03/15/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),3, TO_DATE('03/25/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),4847, 4939, 20, 'IU3Y45IUY345ZXCVV', 16, NULL);
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 16, 3, TO_DATE('03/17/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),2, TO_DATE('03/19/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),69869, 69998, 30, 'IU3Y45IU3Y45O34IS', 17, 'corpDisc29');
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 17, 2, TO_DATE('03/22/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),1, TO_DATE('03/22/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),699, 763, 15, 'I356P3OI4O5U6IUY3', 2, 'wowDisc18');
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 18, 11, TO_DATE('04/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),2, TO_DATE('04/03/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),4356, 4562, 30, '3IU45Y6Y3OIU4Y234', 4, NULL);
INSERT INTO na_booking (booking_id, pickup_locid, pickup_date, dropoff_locid, dropoff_date, odo_start, odo_end, odo_limit, vin, cust_id, coup_id) VALUES( 19, 2, TO_DATE('44655 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),11, TO_DATE('04/07/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),3222, 33333, 40, 'ALKSDJHFOWIUEYR93', 5, NULL);

INSERT INTO na_payment (pay_id, pay_date, pay_amt, pay_method, card_no, inv_id) VALUES( 1, TO_DATE('01/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),320, 'Credit Card',4235422380495723, 1);
INSERT INTO na_payment (pay_id, pay_date, pay_amt, pay_method, card_no, inv_id) VALUES( 2, TO_DATE('01/02/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),345, 'Debit Card',2938457023984753, 2);
INSERT INTO na_payment (pay_id, pay_date, pay_amt, pay_method, card_no, inv_id) VALUES( 3, TO_DATE('01/03/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),24, 'Credit Card',2983475028347534, 3);
INSERT INTO na_payment (pay_id, pay_date, pay_amt, pay_method, card_no, inv_id) VALUES( 4, TO_DATE('01/04/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),767, 'Debit Card',6359872645928763, 4);
INSERT INTO na_payment (pay_id, pay_date, pay_amt, pay_method, card_no, inv_id) VALUES( 5, TO_DATE('02/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),34, 'Gift Card',9283645972346534, 5);
INSERT INTO na_payment (pay_id, pay_date, pay_amt, pay_method, card_no, inv_id) VALUES( 6, TO_DATE('02/02/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),100, 'Credit Card',9273465928736453, 6);
INSERT INTO na_payment (pay_id, pay_date, pay_amt, pay_method, card_no, inv_id) VALUES( 7, TO_DATE('02/03/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),150, 'Credit Card',8372456913478652, 7);
INSERT INTO na_payment (pay_id, pay_date, pay_amt, pay_method, card_no, inv_id) VALUES( 8, TO_DATE('02/04/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),34, 'Debit Card',2394875623408573, 8);
INSERT INTO na_payment (pay_id, pay_date, pay_amt, pay_method, card_no, inv_id) VALUES( 9, TO_DATE('03/01/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),66, 'Credit Card',2983745023894753, 9);
INSERT INTO na_payment (pay_id, pay_date, pay_amt, pay_method, card_no, inv_id) VALUES( 10, TO_DATE('03/02/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),787, 'Debit Card',2893878456981764, 10);
INSERT INTO na_payment (pay_id, pay_date, pay_amt, pay_method, card_no, inv_id) VALUES( 11, TO_DATE('03/02/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),47, 'Credit Card',2789347502983745, 11);
INSERT INTO na_payment (pay_id, pay_date, pay_amt, pay_method, card_no, inv_id) VALUES( 12, TO_DATE('03/03/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),69, 'Credit Card',2930874652986734, 12);
INSERT INTO na_payment (pay_id, pay_date, pay_amt, pay_method, card_no, inv_id) VALUES( 13, TO_DATE('03/04/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),994, 'Debit Card',3984567398734534, 13);
INSERT INTO na_payment (pay_id, pay_date, pay_amt, pay_method, card_no, inv_id) VALUES( 14, TO_DATE('03/10/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),2000, 'Credit Card',3948567394857639, 14);
INSERT INTO na_payment (pay_id, pay_date, pay_amt, pay_method, card_no, inv_id) VALUES( 15, TO_DATE('03/20/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),2500, 'Debit Card',3945876298572345, 15);
INSERT INTO na_payment (pay_id, pay_date, pay_amt, pay_method, card_no, inv_id) VALUES( 16, TO_DATE('03/22/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),499, 'Gift Card',9873459687329487, 16);
