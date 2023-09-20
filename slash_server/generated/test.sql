CREATE TABLE kamer (
    kamer_nr CHAR(6) CONSTRAINT pk_kamer PRIMARY KEY,
    kamer_omschrijving VARCHAR(25),
    lst_bijwerkdat DATE
);
-- Tabel bed_type
CREATE TABLE bed_type (
    bed_type_nr CHAR(2) CONSTRAINT pk_bed_type PRIMARY KEY,
    bed_type_omschrijving VARCHAR(50),
    lst_bijwerkdat DATE
);
-- Tabel bed
CREATE TABLE bed (
    bed_nr INTEGER CONSTRAINT pk_bed PRIMARY KEY,
    bed_kamer_nr CHAR(6) CONSTRAINT fk_bed_kamer_nr REFERENCES kamer(kamer_nr),
    bed_type_nr CHAR(2) CONSTRAINT nn_bed_type_nr NOT NULL CONSTRAINT fk_bed_type_nr REFERENCES bed_type(bed_type_nr),
    bed_beschikbaarheid CHAR(1),
    lst_bijwerkdat DATE
);
-- Tabel patient
CREATE TABLE patient (
    patient_nr CHAR(6) CONSTRAINT pk_patient PRIMARY KEY,
    patient_sofi_nr CHAR(9) CONSTRAINT nn_patient_sofi_nr NOT NULL,
    patient_achternaam VARCHAR(50) CONSTRAINT nn_patient_achternaam NOT NULL,
    patient_voornaam VARCHAR(50) CONSTRAINT nn_patient_voornaam NOT NULL,
    patient_tussenvoegsel VARCHAR(50),
    patient_adres VARCHAR(50),
    patient_plaats VARCHAR(50),
    patient_provincie CHAR(2),
    patient_postcode VARCHAR(7),
    patient_geboortedatum DATE,
    patient_tel_nr CHAR(10),
    patient_bed_nr INTEGER CONSTRAINT fk_bed_nr REFERENCES bed(bed_nr),
    lst_bijwerkdat DATE
);
-- Tabel patient_notitie
CREATE TABLE patient_notitie (
    pn_patient_nr CHAR(6),
    pn_notitie_datum DATE,
    pn_notitie_commentaar VARCHAR(4000),
    lst_bijwerkdat DATE,
    CONSTRAINT fk_pn_patient_nr FOREIGN KEY (pn_patient_nr) REFERENCES patient ON DELETE CASCADE,
    CONSTRAINT pk_patient_notitie PRIMARY KEY (pn_patient_nr, pn_notitie_datum)
);
-- Tabel afdeling
CREATE TABLE zh_afdeling (
    afdeling_nr CHAR(5) CONSTRAINT pk_zh_afdeling PRIMARY KEY,
    afdeling_naam VARCHAR(50) CONSTRAINT nn_zh_afdeling_naam NOT NULL,
    afdeling_kantoor_locatie VARCHAR(25) CONSTRAINT nn_afdeling_kantoor_locatie NOT NULL,
    afdeling_tel_nr CHAR(10),
    lst_bijwerkdat DATE
);
-- Tabel personeel
CREATE TABLE personeel (
    pers_nr CHAR(5) CONSTRAINT pk_personeel PRIMARY KEY,
    pers_sofi_nr CHAR(9) CONSTRAINT nn_pers_sofi_nr NOT NULL,
    pers_achternaam VARCHAR(50) CONSTRAINT nn_pers_achternaam NOT NULL,
    pers_voornaam VARCHAR(50) CONSTRAINT nn_pers_voornaam NOT NULL,
    pers_tussenvoegsel VARCHAR(50),
    pers_afd_toegewezen CHAR(5) CONSTRAINT fk_pers_afd_toegewezen REFERENCES zh_afdeling(afdeling_nr),
    pers_kantoor_locatie VARCHAR(10),
    pers_datum_in_dienst DATE DEFAULT NULL,
    pers_ziekenhuis_titel VARCHAR(50) CONSTRAINT nn_pers_ziekenhuis_titel NOT NULL,
    pers_tel_werk CHAR(10),
    pers_tel_doorkies VARCHAR(4),
    pers_reg_nr VARCHAR(20),
    pers_salaris INTEGER,
    pers_tarief NUMERIC(5, 2),
    lst_bijwerkdat DATE
);
-- Tabel medisch_specialisme
CREATE TABLE medisch_specialisme (
    medspec_cd CHAR(4) CONSTRAINT pk_medisch_specialisme PRIMARY KEY,
    medspec_titel VARCHAR(50) CONSTRAINT nn_medspec_titel NOT NULL,
    /* gaat dit goed met medisch_spec zoals in het EngelsLR */
    medspec_hoe_behaald VARCHAR(100),
    lst_bijwerkdat DATE
);
-- Tabel personeel_medspec
CREATE TABLE personeel_medspec (
    pm_pers_nr CHAR(5),
    pm_medspec_cd CHAR(4),
    pm_datum_behaald DATE DEFAULT now(),
    lst_bijwerkdat DATE,
    CONSTRAINT fk_pm_pers_nr FOREIGN KEY (pm_pers_nr) REFERENCES personeel,
    CONSTRAINT fk_pm_medspec_cd FOREIGN KEY (pm_medspec_cd) REFERENCES medisch_specialisme,
    CONSTRAINT pk_personeel_medspec PRIMARY KEY (pm_pers_nr, pm_medspec_cd)
);
-- Tabel verrichting_cat
CREATE TABLE verrichting_cat (
    verrichting_cat_nr CHAR(3) CONSTRAINT pk_verrichting_cat PRIMARY KEY,
    verrichting_cat_omschrijving VARCHAR(50) CONSTRAINT nn_verrichting_cat_oms NOT NULL,
    lst_bijwerkdat DATE
);
-- Tabel verrichting
CREATE TABLE verrichting (
    verrichting_nr CHAR(5) CONSTRAINT pk_verrichting PRIMARY KEY,
    verrichting_omschrijving VARCHAR(50) CONSTRAINT nn_verrichting_omschrijving NOT NULL,
    verrichting_rek_totaal NUMERIC(9, 2) CONSTRAINT ck_verrichting_rek_totaal CHECK (verrichting_rek_totaal >= 0),
    verrichting_opmerking VARCHAR(2000),
    verrichting_cat_nr CHAR(3) CONSTRAINT fk_verrichting_cat_nr REFERENCES verrichting_cat(verrichting_cat_nr),
    lst_bijwerkdat DATE
);
-- Tabel behandeling
CREATE TABLE behandeling (
    behandeling_nr INTEGER,
    behandeling_datum DATE,
    behandeling_patient_nr CHAR(6) CONSTRAINT nn_behandeling_patient_nr NOT NULL,
    behandeling_pers_nr CHAR(5) CONSTRAINT nn_behandeling_personeel_nr NOT NULL,
    behandeling_verrichting_nr CHAR(5) CONSTRAINT nn_behandeling_verrichting_nr NOT NULL,
    behandeling_huidige_rek_totaal NUMERIC(9, 2) CONSTRAINT ck_beh_huidige_rek_totaal CHECK (behandeling_huidige_rek_totaal >= 0),
    behandeling_opmerking VARCHAR(2000),
    lst_bijwerkdat DATE,
    CONSTRAINT fk_behandeling_patient FOREIGN KEY (behandeling_patient_nr) REFERENCES patient,
    CONSTRAINT fk_behandeling_personeel FOREIGN KEY (behandeling_pers_nr) REFERENCES personeel,
    CONSTRAINT fk_behandeling_verrichting FOREIGN KEY (behandeling_verrichting_nr) REFERENCES verrichting,
    CONSTRAINT pk_behandeling PRIMARY KEY (behandeling_nr, behandeling_datum)
);
-- Tabel medicijn
CREATE TABLE medicijn (
    medicijn_cd CHAR(7) CONSTRAINT pk_medicijn PRIMARY KEY,
    medicijn_wetensch_naam VARCHAR(50) CONSTRAINT nn_medicijn_wetensch_naam NOT NULL,
    medicijn_handelsnaam VARCHAR(50) CONSTRAINT nn_medicijn_handelsnaam NOT NULL,
    medicijn_normale_dos VARCHAR(300) CONSTRAINT nn_medicijn_dosering NOT NULL,
    medicijn_opmerking VARCHAR(500),
    medicijn_voorraad_hoev INTEGER CONSTRAINT ck_medicijn_hoev_in_voorraad CHECK (medicijn_voorraad_hoev >= 0),
    medicijn_eenheid VARCHAR(20),
    lst_bijwerkdat DATE
);
-- Tabel recept
CREATE TABLE recept (
    recept_nr INTEGER CONSTRAINT pk_recept PRIMARY KEY,
    recept_datum DATE,
    recept_medicijn_cd CHAR(7) CONSTRAINT nn_recept_med_cd NOT NULL,
    recept_patient_nr CHAR(6) CONSTRAINT nn_recept_patient_nr NOT NULL,
    recept_pers_nr CHAR(5) CONSTRAINT nn_recept_pers_nr NOT NULL,
    recept_voorgeschr_dos VARCHAR(50) CONSTRAINT nn_recept_voorgeschr_dos NOT NULL,
    recept_dos_voorschr VARCHAR(500),
    lst_bijwerkdat DATE,
    CONSTRAINT fk_recept_med_cd FOREIGN KEY (recept_medicijn_cd) REFERENCES medicijn,
    CONSTRAINT fk_recept_patient_nr FOREIGN KEY (recept_patient_nr) REFERENCES patient,
    CONSTRAINT fk_recept_pers_nr FOREIGN KEY (recept_pers_nr) REFERENCES personeel
);
-- DE TABELLEN VULLEN MET GEGEVENS
-- Vullen van de tabel bed_type - 10 rijen 
INSERT INTO bed_type
VALUES ('N1', 'Normale afdeling-Vast', now());
INSERT INTO bed_type
VALUES ('N2', 'Normale afdeling-Verstelbaar', now());
INSERT INTO bed_type
VALUES ('EH', 'Eerste Hulp-Verrijdbaar', now());
INSERT INTO bed_type
VALUES ('E2', 'Eerste Hulp-Vast', '27-OCT-01');
INSERT INTO bed_type
VALUES ('RA', 'Radiologie', now());
--COMMIT;
INSERT INTO bed_type
VALUES ('N3', 'Normale afdeling-Verhoogd', '29-DEC-01');
INSERT INTO bed_type
VALUES ('E3', 'Eerste Hulp-Draagbaar', '05-JAN-02');
INSERT INTO bed_type
VALUES ('CH', 'Chirurgie-Verrijdbaar', now());
INSERT INTO bed_type
VALUES ('K1', 'Kinderbed tot 5 jaar', now());
INSERT INTO bed_type
VALUES ('K2', 'Kinderbed tot 15 jaar', now());
--COMMIT;
-- Vullen van de tabel kamer - 61 rijen 
INSERT INTO kamer
VALUES ('ZW1001', 'Heelkunde, enkel', '03-JAN-01');
INSERT INTO kamer
VALUES ('ZW1002', 'Heelkunde, enkel', '03-JAN-01');
INSERT INTO kamer
VALUES ('ZW1003', 'Heelkunde, enkel', '03-JAN-01');
INSERT INTO kamer
VALUES ('ZW1004', 'Heelkunde, enkel', '03-JAN-01');
INSERT INTO kamer
VALUES ('ZW1005', 'Heelkunde, enkel', '03-JAN-01');
--COMMIT;
INSERT INTO kamer
VALUES ('ZW1006', 'Heelkunde, enkel', '03-JAN-01');
INSERT INTO kamer
VALUES ('ZW1010', 'Heelkunde, dubbel', '03-JAN-01');
INSERT INTO kamer
VALUES ('ZW1011', 'Heelkunde, dubbel', '03-JAN-01');
INSERT INTO kamer
VALUES ('ZW1012', 'Heelkunde, dubbel', '03-JAN-01');
INSERT INTO kamer
VALUES ('ZW1013', 'Heelkunde, dubbel', '03-JAN-01');
--COMMIT;
INSERT INTO kamer
VALUES ('ZW1014', 'Heelkunde, dubbel', '03-JAN-01');
INSERT INTO kamer
VALUES ('ZW1015', 'Heelkunde, dubbel', '03-JAN-01');
INSERT INTO kamer
VALUES ('NW1001', 'Heelkunde, enkel', '03-JAN-01');
INSERT INTO kamer
VALUES ('NW1002', 'Heelkunde, enkel', '03-JAN-01');
INSERT INTO kamer
VALUES ('NW1003', 'Heelkunde, enkel', '03-JAN-01');
--COMMIT;
INSERT INTO kamer
VALUES ('NW1004', 'Heelkunde, enkel', '03-JAN-01');
INSERT INTO kamer
VALUES ('NW1005', 'Heelkunde, enkel', '03-JAN-01');
INSERT INTO kamer
VALUES ('NW1010', 'Heelkunde, dubbel', '03-JAN-01');
INSERT INTO kamer
VALUES ('NW1011', 'Heelkunde, dubbel', '03-JAN-01');
INSERT INTO kamer
VALUES ('NW1012', 'Heelkunde, dubbel', '03-JAN-01');
--COMMIT;
INSERT INTO kamer
VALUES ('NW1013', 'Heelkunde, dubbel', '03-JAN-01');
INSERT INTO kamer
VALUES ('NW1014', 'Heelkunde, dubbel', '03-JAN-01');
INSERT INTO kamer
VALUES ('RA0075', 'Radiologie', now());
INSERT INTO kamer
VALUES ('RA0076', 'Radiologie', now());
INSERT INTO kamer
VALUES ('RA0077', 'Radiologie', now());
--COMMIT;
INSERT INTO kamer
VALUES ('RA0078', 'Radiologie', now());
INSERT INTO kamer
VALUES ('EH0001', 'Eerste Hulp 1', now());
INSERT INTO kamer
VALUES ('EH0002', 'Eerste Hulp 2', now());
INSERT INTO kamer
VALUES ('VK0001', 'Verkoever 1', now());
INSERT INTO kamer
VALUES ('VK0023', 'Verkoever 2', now());
COMMIT;
INSERT INTO kamer
VALUES ('VK0024', 'Verkoever 3', now());
INSERT INTO kamer
VALUES ('VK0031', 'Verkoever 4', now());
INSERT INTO kamer
VALUES ('VK0032', 'Verkoever 5', now());
INSERT INTO kamer
VALUES ('OP0001', 'Operatiekamer 1', '03-JAN-01');
INSERT INTO kamer
VALUES ('OP0002', 'Operatiekamer 2', '03-JAN-01');
COMMIT;
INSERT INTO kamer
VALUES ('OP0003', 'Operatiekamer 3', '03-DEC-01');
INSERT INTO kamer
VALUES ('OP0004', 'Operatiekamer 4', '3-DEC-01');
INSERT INTO kamer
VALUES ('ZW3001', 'Oncologie, enkel', now());
INSERT INTO kamer
VALUES ('ZW3002', 'Oncologie, enkel', now());
INSERT INTO kamer
VALUES ('ZW3003', 'Oncologie, enkel', now());
COMMIT;
INSERT INTO kamer
VALUES ('ZW3004', 'Oncologie, enkel', now());
INSERT INTO kamer
VALUES ('ZW3005', 'Oncologie, dubbel', now());
INSERT INTO kamer
VALUES ('ZW3006', 'Oncologie, dubbel', now());
INSERT INTO kamer
VALUES ('ZW3007', 'Oncologie, dubbel', now());
INSERT INTO kamer
VALUES ('ZW3008', 'Oncologie, dubbel', now());
COMMIT;
INSERT INTO kamer
VALUES ('NW3001', 'Intensive Care, enkel', now());
INSERT INTO kamer
VALUES ('NW3011', 'Intensive Care, enkel', now());
INSERT INTO kamer
VALUES ('NW3021', 'Intensive Care, enkel', now());
INSERT INTO kamer
VALUES ('NW3031', 'Intensive Care, enkel', now());
INSERT INTO kamer
VALUES ('NW3041', 'Intensive Care, enkel', now());
COMMIT;
INSERT INTO kamer
VALUES ('NW3051', 'Intensive Care, enkel', now());
INSERT INTO kamer
VALUES ('NW3061', 'Intensive Care, enkel', now());
INSERT INTO kamer
VALUES ('ZW2101', 'Pediatrie, enkel', now());
INSERT INTO kamer
VALUES ('ZW2102', 'Pediatrie, enkel', now());
INSERT INTO kamer
VALUES ('ZW2103', 'Pediatrie, enkel', now());
COMMIT;
INSERT INTO kamer
VALUES ('ZW2104', 'Pediatrie, enkel', now());
INSERT INTO kamer
VALUES ('ZW2105', 'Pediatrie, enkel', now());
INSERT INTO kamer
VALUES ('ZW2111', 'Pediatrie, dubbel', now());
INSERT INTO kamer
VALUES ('ZW2112', 'Pediatrie, dubbel', now());
INSERT INTO kamer
VALUES ('ZW2113', 'Pediatrie, dubbel', now());
INSERT INTO kamer
VALUES ('ZW2114', 'Pediatrie, dubbel', now());
COMMIT;
-- Vullen van de tabel bed - 98 rijen 
-- Heelkunde, locatie ZuidWest
INSERT INTO bed
VALUES (1, 'ZW1001', 'N1', 'J', '03-JAN-01');
INSERT INTO bed
VALUES (2, 'ZW1002', 'N1', 'J', '03-JAN-01');
INSERT INTO bed
VALUES (3, 'ZW1003', 'N2', 'J', '03-JAN-01');
INSERT INTO bed
VALUES (4, 'ZW1004', 'N1', 'J', '03-JAN-01');
INSERT INTO bed
VALUES (5, 'ZW1005', 'N2', 'J', '03-JAN-01');
COMMIT;
INSERT INTO bed
VALUES (6, 'ZW1006', 'N1', 'J', '03-JAN-01');
INSERT INTO bed
VALUES (7, 'ZW1010', 'N1', 'J', '03-JAN-01');
INSERT INTO bed
VALUES (8, 'ZW1010', 'N2', 'J', '03-JAN-01');
INSERT INTO bed
VALUES (9, 'ZW1011', 'N2', 'J', '03-JAN-01');
INSERT INTO bed
VALUES (10, 'ZW1011', 'N2', 'N', '03-JAN-01');
COMMIT;
INSERT INTO bed
VALUES (11, 'ZW1012', 'N1', 'J', '03-JAN-01');
INSERT INTO bed
VALUES (12, 'ZW1012', 'N3', 'N', '01-JAN-01');
INSERT INTO bed
VALUES (13, 'ZW1013', 'N3', 'N', '01-JAN-01');
INSERT INTO bed
VALUES (14, 'ZW1013', 'N1', 'J', '03-JAN-01');
INSERT INTO bed
VALUES (15, 'ZW1014', 'N1', 'J', '03-JAN-01');
COMMIT;
INSERT INTO bed
VALUES (16, 'ZW1014', 'N1', 'J', '03-JAN-01');
INSERT INTO bed
VALUES (17, 'ZW1015', 'N3', 'N', '01-JAN-01');
INSERT INTO bed
VALUES (18, 'ZW1015', 'N3', 'J', '01-JAN-01');
-- Heelkunde, locatie NoordWest
INSERT INTO bed
VALUES (19, 'ZW1001', 'N3', 'N', '03-JAN-01');
INSERT INTO bed
VALUES (20, 'ZW1002', 'N1', 'J', '03-JAN-01');
COMMIT;
INSERT INTO bed
VALUES (21, 'ZW1003', 'N3', 'N', '03-JAN-01');
INSERT INTO bed
VALUES (22, 'ZW1004', 'N2', 'N', '03-JAN-01');
INSERT INTO bed
VALUES (23, 'ZW1005', 'N2', 'J', '03-JAN-01');
INSERT INTO bed
VALUES (24, 'ZW1006', 'N2', 'J', '03-JAN-01');
INSERT INTO bed
VALUES (25, 'ZW1010', 'N1', 'N', '03-JAN-01');
COMMIT;
INSERT INTO bed
VALUES (26, 'ZW1010', 'N3', 'J', '01-JAN-01');
INSERT INTO bed
VALUES (27, 'ZW1011', 'N2', 'N', '03-JAN-01');
INSERT INTO bed
VALUES (28, 'ZW1011', 'N2', 'J', '03-JAN-01');
INSERT INTO bed
VALUES (29, 'ZW1012', 'N1', 'N', '03-JAN-01');
INSERT INTO bed
VALUES (30, 'ZW1012', 'N3', 'J', '01-JAN-01');
COMMIT;
INSERT INTO bed
VALUES (31, 'ZW1013', 'N2', 'J', '03-JAN-01');
INSERT INTO bed
VALUES (32, 'ZW1013', 'N1', 'N', '03-JAN-01');
INSERT INTO bed
VALUES (33, 'ZW1014', 'N1', 'N', '03-JAN-01');
INSERT INTO bed
VALUES (34, 'ZW1014', 'N1', 'J', '03-JAN-01');
INSERT INTO bed
VALUES (35, 'ZW1015', 'N3', 'N', '01-JAN-01');
COMMIT;
INSERT INTO bed
VALUES (36, 'ZW1015', 'N1', 'J', '03-JAN-01');
-- Radiologie
INSERT INTO bed
VALUES (100, 'RA0075', 'RA', 'J', now());
INSERT INTO bed
VALUES (101, 'RA0075', 'RA', 'N', now());
INSERT INTO bed
VALUES (102, 'RA0076', 'RA', 'J', now());
INSERT INTO bed
VALUES (103, 'RA0077', 'RA', 'J', now());
COMMIT;
INSERT INTO bed
VALUES (104, 'RA0077', 'RA', 'N', now());
INSERT INTO bed
VALUES (105, 'RA0077', 'RA', 'J', now());
INSERT INTO bed
VALUES (106, 'RA0078', 'RA', 'N', now());
INSERT INTO bed
VALUES (107, 'RA0078', 'RA', 'N', now());
-- Eerste Hulp
INSERT INTO bed
VALUES (50, 'EH0001', 'EH', 'J', now());
COMMIT;
INSERT INTO bed
VALUES (51, 'EH0001', 'EH', 'N', now());
INSERT INTO bed
VALUES (52, 'EH0001', 'E2', 'J', now());
INSERT INTO bed
VALUES (53, 'EH0001', 'E2', 'J', now());
INSERT INTO bed
VALUES (59, 'EH0001', 'E3', 'J', now());
INSERT INTO bed
VALUES (54, 'EH0002', 'EH', 'N', now());
COMMIT;
INSERT INTO bed
VALUES (55, 'EH0002', 'EH', 'J', now());
INSERT INTO bed
VALUES (56, 'EH0002', 'E2', 'J', now());
INSERT INTO bed
VALUES (57, 'EH0002', 'E2', 'N', now());
INSERT INTO bed
VALUES (58, 'EH0002', 'E3', 'J', now());
-- Verkoever
INSERT INTO bed
VALUES (70, 'VK0001', 'N2', 'J', now());
COMMIT;
INSERT INTO bed
VALUES (71, 'VK0023', 'N2', 'N', now());
INSERT INTO bed
VALUES (72, 'VK0023', 'N2', 'J', now());
INSERT INTO bed
VALUES (73, 'VK0024', 'N2', 'N', now());
INSERT INTO bed
VALUES (74, 'VK0031', 'N3', 'J', now());
INSERT INTO bed
VALUES (75, 'VK0032', 'N2', 'J', now());
COMMIT;
INSERT INTO bed
VALUES (76, 'VK0032', 'N2', 'J', now());
INSERT INTO bed
VALUES (77, 'VK0032', 'N1', 'J', now());
-- Chirurgie
INSERT INTO bed
VALUES (1001, 'OP0001', 'CH', NULL, '06-JAN-01');
INSERT INTO bed
VALUES (1002, 'OP0002', 'CH', NULL, '06-JAN-01');
INSERT INTO bed
VALUES (1003, 'OP0003', 'CH', NULL, '06-JAN-01');
COMMIT;
INSERT INTO bed
VALUES (1004, 'OP0004', 'CH', NULL, '06-JAN-01');
-- Oncologie
INSERT INTO bed
VALUES (2001, 'ZW3001', 'N1', 'J', now());
INSERT INTO bed
VALUES (2002, 'ZW3002', 'N2', 'N', now());
INSERT INTO bed
VALUES (2003, 'ZW3003', 'N2', 'J', now());
INSERT INTO bed
VALUES (2004, 'ZW3004', 'N3', 'N', now());
COMMIT;
INSERT INTO bed
VALUES (2005, 'ZW3005', 'N1', 'J', now());
INSERT INTO bed
VALUES (2006, 'ZW3005', 'N1', 'N', now());
INSERT INTO bed
VALUES (2007, 'ZW3006', 'N2', 'J', now());
INSERT INTO bed
VALUES (2008, 'ZW3006', 'N2', 'J', now());
INSERT INTO bed
VALUES (2009, 'ZW3007', 'N1', 'N', now());
COMMIT;
INSERT INTO bed
VALUES (2010, 'ZW3007', 'N1', 'J', now());
INSERT INTO bed
VALUES (2011, 'ZW3008', 'N3', 'J', now());
INSERT INTO bed
VALUES (2012, 'ZW3008', 'N3', 'J', now());
-- Intensive Care
INSERT INTO bed
VALUES (2100, 'NW3001', 'N2', 'J', now());
INSERT INTO bed
VALUES (2101, 'NW3011', 'N2', 'J', now());
COMMIT;
INSERT INTO bed
VALUES (2102, 'NW3021', 'N2', 'N', now());
INSERT INTO bed
VALUES (2103, 'NW3031', 'N2', 'J', now());
INSERT INTO bed
VALUES (2104, 'NW3031', 'N2', 'J', now());
INSERT INTO bed
VALUES (2105, 'NW3051', 'N2', 'J', now());
INSERT INTO bed
VALUES (2106, 'NW3061', 'N2', 'N', now());
COMMIT;
-- Kindergeneeskunde
INSERT INTO bed
VALUES (5001, 'ZW2101', 'K1', 'N', now());
INSERT INTO bed
VALUES (5002, 'ZW2102', 'K1', 'J', now());
INSERT INTO bed
VALUES (5003, 'ZW2103', 'K1', 'N', now());
INSERT INTO bed
VALUES (5004, 'ZW2104', 'K2', 'J', now());
INSERT INTO bed
VALUES (5005, 'ZW2105', 'K2', 'J', now());
COMMIT;
INSERT INTO bed
VALUES (5006, 'ZW2111', 'K2', 'N', now());
INSERT INTO bed
VALUES (5007, 'ZW2111', 'K2', 'N', now());
INSERT INTO bed
VALUES (5008, 'ZW2112', 'K1', 'J', now());
INSERT INTO bed
VALUES (5009, 'ZW2112', 'K1', 'J', now());
INSERT INTO bed
VALUES (5010, 'ZW2113', 'K1', 'N', now());
COMMIT;
INSERT INTO bed
VALUES (5011, 'ZW2113', 'K2', 'J', now());
INSERT INTO bed
VALUES (5012, 'ZW2114', 'K2', 'N', now());
INSERT INTO bed
VALUES (5013, 'ZW2114', 'K2', 'N', now());
COMMIT;
-- Vullen van de tabel patient - 60 rijen -
-- Patiënten op afdeling Heelkunde, locatie ZuidWest
INSERT INTO patient
VALUES (
        '100001',
        '111111111',
        'Abrahams',
        'Andrew',
        NULL,
        'Eisenhowerlaan 100',
        'Aardenburg',
        'GR',
        '6202 BB',
        '02-JAN-1991',
        '1005551212',
        5001,
        now()
    );
INSERT INTO patient
VALUES (
        '100002',
        '222222222',
        'Bennink',
        'Barbara',
        NULL,
        'Rozenlaan 5',
        'Aardenburg',
        'GR',
        '6202 RC',
        '02-JAN-1961',
        '1005551000',
        1,
        now()
    );
INSERT INTO patient
VALUES (
        '100003',
        '333333333',
        'Chevalier',
        'Ruud',
        NULL,
        'Starkenborgstraat 27',
        'Groningen',
        'GR',
        '6202 JH',
        '14-FEB-1973',
        '1005552000',
        4,
        now()
    );
INSERT INTO patient
VALUES (
        '100024',
        '444444444',
        'Davids',
        'Donald',
        NULL,
        'Zagerij 1',
        'Groningen',
        'GR',
        '6202 BC',
        '14-MAR-1983',
        '1005552002',
        6,
        now()
    );
INSERT INTO patient
VALUES (
        '100025',
        '555555555',
        'Everaert',
        'Ernst',
        NULL,
        'PC Hooftstraat 45',
        'Eindhoven',
        'NB',
        '6202 FG',
        '05-DEC-1975',
        '1005552001',
        7,
        now()
    );
COMMIT;
INSERT INTO patient
VALUES (
        '100026',
        '666666666',
        'Francken',
        'Ferdinand',
        NULL,
        'Markt 4',
        'Eindhoven',
        'NB',
        '6202 GH',
        '16-DEC-1976',
        '1005552004',
        11,
        now()
    );
INSERT INTO patient
VALUES (
        '100027',
        '777777777',
        'Groothuis',
        'Gerard',
        NULL,
        'Garensteeg 245',
        'Aardenburg',
        'ZE',
        '6202 HJ',
        '05-DEC-1951',
        '1005551001',
        14,
        now()
    );
INSERT INTO patient
VALUES (
        '100028',
        '888888888',
        'Harmsen',
        'Harold',
        NULL,
        'Nijverheidsweg 42',
        'Aardenburg',
        'ZE',
        '6202 JK',
        '03-NOV-1948',
        '1005551002',
        15,
        now()
    );
INSERT INTO patient
VALUES (
        '100029',
        '999999999',
        'Ingels',
        'Ingrid',
        NULL,
        'Noordstraat 12',
        'Aardenburg',
        'ZE',
        '6202 JK',
        '13-OCT-1973',
        '1005551004',
        16,
        now()
    );
INSERT INTO patient
VALUES (
        '100030',
        '111000000',
        'Jungerius',
        'Juliette',
        NULL,
        'Nieuwendijk 14',
        'Aardenburg',
        'ZE',
        '6202 KL',
        '15-OCT-1975',
        '1005551005',
        18,
        now()
    );
COMMIT;
-- Patiënten op afdeling Heelkunde, locatie NoordWest
INSERT INTO patient
VALUES (
        '100031',
        '111000031',
        'Kramer',
        'Karel',
        NULL,
        'Overijssellaan 405',
        'Aardenburg',
        'ZE',
        '6202 LM',
        '11-OCT-1979',
        '1005551006',
        20,
        now()
    );
INSERT INTO patient
VALUES (
        '100050',
        '111000050',
        'Lamers',
        'Linda',
        NULL,
        'Overijssellaan 406',
        'Aardenburg',
        'ZE',
        '6202 MN',
        '21-MAY-1979',
        '1005551007',
        23,
        now()
    );
INSERT INTO patient
VALUES (
        '100051',
        '111000051',
        'Monasch',
        'Moniek',
        NULL,
        'Moleneinde 5',
        'Eindhoven',
        'NB',
        '6202 NO',
        '21-MAY-1952',
        '1005551007',
        24,
        now()
    );
INSERT INTO patient
VALUES (
        '100301',
        '222333301',
        'Nonneman',
        'Nancy',
        NULL,
        'Abdijstraat 35',
        'Eindhoven',
        'NB',
        '6202 OP',
        '21-JUN-1963',
        '1005551034',
        26,
        now()
    );
INSERT INTO patient
VALUES (
        '100302',
        '222333302',
        'Ongena',
        'Odette',
        NULL,
        'Kloosterstraat 20',
        'Eindhoven',
        'NB',
        '6202 PQ',
        '04-JUN-1972',
        '1005551035',
        28,
        now()
    );
COMMIT;
INSERT INTO patient
VALUES (
        '100303',
        '222333303',
        'Pauwels',
        'Peter',
        NULL,
        'Markweg 22',
        'Eindhoven',
        'NB',
        '6202 QS',
        '04-JUN-1983',
        '1005551036',
        30,
        now()
    );
INSERT INTO patient
VALUES (
        '100304',
        '222333304',
        'Quaak',
        'Rinus',
        'van der',
        'Stevenshof 76',
        'Eindhoven',
        'NB',
        '6202 RS',
        '07-JUN-1984',
        '1005551037',
        31,
        now()
    );
INSERT INTO patient
VALUES (
        '100305',
        '222333305',
        'Ridderhof',
        'Ricardo',
        NULL,
        'Mersenstraat 105',
        'Eindhoven',
        'NB',
        '6202 ST',
        '07-JUN-1984',
        '1005551038',
        34,
        now()
    );
INSERT INTO patient
VALUES (
        '100306',
        '222333306',
        'Schiedam',
        'Sam',
        'van',
        'Scheveningenallee 22',
        'Eindhoven',
        'NB',
        '6202 TU',
        '07-JUN-1984',
        '1005551039',
        36,
        now()
    );
-- Patiënten op afdeling Radiologie 
INSERT INTO patient
VALUES (
        '100422',
        '222422001',
        'Terberg',
        'Tessa',
        NULL,
        'Noordkaap 2',
        'Franeker',
        'FR',
        '6233 UV',
        '30-JUL-1978',
        '1005551111',
        100,
        now()
    );
COMMIT;
INSERT INTO patient
VALUES (
        '100423',
        '222422003',
        'Uyttenhage',
        'Theo',
        NULL,
        'Eenhoorn 16',
        'Franeker',
        'FR',
        '6233 VU',
        '28-JUL-1983',
        '1005551112',
        102,
        now()
    );
INSERT INTO patient
VALUES (
        '100424',
        '222422004',
        'Victorius',
        'Vincent',
        NULL,
        'Namenstraat 16',
        'Eindhoven',
        'NB',
        '6202 WX',
        '04-JUL-1976',
        '1005551114',
        103,
        now()
    );
INSERT INTO patient
VALUES (
        '100425',
        '222422005',
        'Willemsen',
        'Ward',
        NULL,
        'Eglantier 168',
        'Eindhoven',
        'NB',
        '6202 XD',
        '05-JUL-1967',
        '1005551115',
        105,
        now()
    );
-- Patiënten bij Eerste Hulp 
INSERT INTO patient
VALUES (
        '100500',
        '222500001',
        'Younis',
        'Yoko',
        NULL,
        'Hoofdstraat 505',
        'Eindhoven',
        'NB',
        '6202 ZA',
        '15-MAR-1983',
        '1005555001',
        50,
        now()
    );
INSERT INTO patient
VALUES (
        '100501',
        '222500002',
        'Zeven',
        'Zeus',
        'van',
        'Zandstraat 51',
        'Eindhoven',
        'NB',
        '6202 AB',
        '1-MAY-1969',
        '1005555001',
        52,
        now()
    );
COMMIT;
INSERT INTO patient
VALUES (
        '100502',
        '222500000',
        'Assendelft',
        'Arthur',
        'van',
        'Aardster 1',
        'Franeker',
        'FR',
        '6233 VB',
        '12-MAY-1968',
        '1005555002',
        53,
        now()
    );
INSERT INTO patient
VALUES (
        '100503',
        '222500003',
        'Boudewijn',
        'Bas',
        NULL,
        'Wagensveld 5',
        'Franeker',
        'FR',
        '6233 SE',
        '03-SEP-1943',
        '1005555003',
        59,
        now()
    );
INSERT INTO patient
VALUES (
        '100504',
        '222500004',
        'Chardon',
        'Chris',
        NULL,
        'Woelwater 14',
        'Franeker',
        'FR',
        '6233 LM',
        '20-APR-1963',
        '1005555004',
        55,
        now()
    );
INSERT INTO patient
VALUES (
        '100505',
        '222500005',
        'Driel',
        'Denise',
        'van',
        'Middelburglaan 114',
        'Eindhoven',
        'NB',
        '6202 NE',
        '02-JAN-1979',
        '1005555050',
        56,
        now()
    );
INSERT INTO patient
VALUES (
        '100506',
        '222500006',
        'Eibergen',
        'Erna',
        'van',
        'Noordstraat 45c',
        'Eindhoven',
        'NB',
        '6202 YA',
        '5-JAN-1978',
        '1005555051',
        58,
        now()
    );
COMMIT;
-- Patiënten op de Verkoeverafdeling
INSERT INTO patient
VALUES (
        '222001',
        '222252003',
        'Fagel',
        'Frans',
        NULL,
        'Waterlelie 77',
        'Eindhoven',
        'NB',
        '6202 HA',
        '07-JUN-1966',
        '1005556101',
        70,
        now()
    );
INSERT INTO patient
VALUES (
        '222002',
        '222252002',
        'Grimbergen',
        'Georgette',
        NULL,
        'Welvaartstraat 79',
        'Eindhoven',
        'NB',
        '6202 BJ',
        '07-JUN-1982',
        '1005556102',
        72,
        now()
    );
INSERT INTO patient
VALUES (
        '555003',
        '222555003',
        'Hiel',
        'Hanna',
        NULL,
        'Stuiverstraat 8',
        'Aardenburg',
        'ZE',
        '6202 MR',
        '07-JUN-1982',
        '1005556103',
        74,
        now()
    );
INSERT INTO patient
VALUES (
        '555004',
        '222555004',
        'Itterson',
        'Ilonka',
        'van',
        'Narwal 22',
        'Aardenburg',
        'ZE',
        '6202 TT',
        '2-JUL-1978',
        '1005556104',
        75,
        now()
    );
INSERT INTO patient
VALUES (
        '555005',
        '222555005',
        'Jonkers',
        'Jochem',
        NULL,
        'Handelskade 2',
        'Franeker',
        'FR',
        '6233 JK',
        '30-JUL-1978',
        '1005556105',
        76,
        now()
    );
COMMIT;
INSERT INTO patient
VALUES (
        '222006',
        '222555006',
        'Keessen',
        'Kas',
        NULL,
        'Neerkanne 4',
        'Franeker',
        'FR',
        '6233 EK',
        '1-JAN-1964',
        '1005556110',
        77,
        now()
    );
-- Patiënten op afdeling Chirurgie
-- Op de afdeling Chirurgie worden patiënten niet aan bedden gekoppeld
-- Patiënten op afdeling Oncologie
INSERT INTO patient
VALUES (
        '333110',
        '333333110',
        'Mourik',
        'Maarten',
        'van',
        'Veeteeltstraat 53',
        'Franeker',
        'FR',
        '6233 RO',
        '12-JAN-1974',
        '1005556110',
        2001,
        now()
    );
INSERT INTO patient
VALUES (
        '333111',
        '333333111',
        'Leekkant',
        'Lilian',
        NULL,
        'Lekstraat 54',
        'Eindhoven',
        'NB',
        '6202 LM',
        '24-JAN-1975',
        '1005556111',
        2003,
        now()
    );
INSERT INTO patient
VALUES (
        '333112',
        '333333112',
        'Overdijk',
        'Otto',
        NULL,
        'Rooseveltlaan 73',
        'Eindhoven',
        'NB',
        '6202 EP',
        '16-FEB-1948',
        '1005556112',
        2005,
        now()
    );
INSERT INTO patient
VALUES (
        '333113',
        '333333113',
        'Noorman',
        'Nol',
        NULL,
        'Millinxstraat 25',
        'Aardenburg',
        'ZE',
        '6202 JH',
        '14-NOV-1949',
        '1005556113',
        2007,
        now()
    );
COMMIT;
INSERT INTO patient
VALUES (
        '333114',
        '333333114',
        'Persijn',
        'Ronnie',
        NULL,
        'Nicodemusstraat 105',
        'Aardenburg',
        'ZE',
        '6202 BM',
        '01-APR-1992',
        '1005556114',
        2008,
        now()
    );
INSERT INTO patient
VALUES (
        '333115',
        '333333115',
        'Roelofs',
        'Reece',
        NULL,
        'Romeinenweg 101',
        'Aardenburg',
        'ZE',
        '6202 AM',
        '11-APR-1939',
        '1005556115',
        2010,
        now()
    );
INSERT INTO patient
VALUES (
        '333116',
        '333333116',
        'Quanjel',
        'Regina',
        NULL,
        'van Eeghenstraat 23',
        'Franeker',
        'FR',
        '6233 HD',
        '21-AUG-1941',
        '1005556116',
        2011,
        now()
    );
INSERT INTO patient
VALUES (
        '333117',
        '333333117',
        'Steenhuis',
        'Sandra',
        NULL,
        'Aagje Dekenstraat 6',
        'Franeker',
        'FR',
        '6233 EC',
        '22-SEP-1946',
        '1005556117',
        2012,
        now()
    );
-- Patiënten op afdeling Intensive Care
INSERT INTO patient
VALUES (
        '666117',
        '333666117',
        'Tennema',
        'Thomas',
        NULL,
        'Kortekaasplantsoen 77',
        'Franeker',
        'FR',
        '6233 CE',
        '02-SEP-1966',
        '1005557001',
        2100,
        now()
    );
COMMIT;
INSERT INTO patient
VALUES (
        '666118',
        '333666118',
        'Vanders',
        'Viviënne',
        NULL,
        'IJsselmeerweg 17',
        'Eindhoven',
        'NB',
        '6202 RH',
        '3-OCT-1946',
        '1005557002',
        2101,
        now()
    );
INSERT INTO patient
VALUES (
        '666119',
        '333666119',
        'Ulst',
        'Umberto',
        'van der',
        'Oostrandpark 36',
        'Eindhoven',
        'NB',
        '6202 MB',
        '13-AUG-1935',
        '1005557003',
        2103,
        now()
    );
INSERT INTO patient
VALUES (
        '666120',
        '333666120',
        'Ysebaart',
        'Yenneke',
        NULL,
        'Hulststraat 42',
        'Eindhoven',
        'NB',
        '6202 LY',
        '3-OCT-1946',
        '1005557003',
        2104,
        now()
    );
INSERT INTO patient
VALUES (
        '666121',
        '333666121',
        'Zonneberg',
        'Zita',
        NULL,
        'Piet Heinstraat 12',
        'Aardenburg',
        'ZE',
        '6202 TZ',
        '31-OCT-1942',
        '1005557003',
        2105,
        now()
    );
-- op de afdeling Kindergeneeskunde
INSERT INTO patient
VALUES (
        '421221',
        '777343221',
        'Algera',
        'Albert',
        'A',
        'Julianastraat 9',
        'Aardenburg',
        'ZE',
        '6202 IK',
        '31-OCT-2000',
        '1005558021',
        5002,
        now()
    );
COMMIT;
INSERT INTO patient
VALUES (
        '421222',
        '777343222',
        'Bogerd',
        'Bert',
        'van den',
        'Schoener 8',
        'Aardenburg',
        'ZE',
        '6202 EE',
        '30-NOV-1992',
        '1005558022',
        5004,
        now()
    );
INSERT INTO patient
VALUES (
        '421223',
        '777343223',
        'Coenders',
        'Cees',
        NULL,
        'Baudeloo 100',
        'Eindhoven',
        'NB',
        '6202 TT',
        '03-SEP-1993',
        '1005558023',
        5005,
        now()
    );
INSERT INTO patient
VALUES (
        '421224',
        '777343224',
        'Donders',
        'Dirk',
        NULL,
        'Madeleineweg 42',
        'Aardenburg',
        'ZE',
        '6202 BO',
        '13-JAN-2002',
        '1005558024',
        5008,
        now()
    );
INSERT INTO patient
VALUES (
        '421225',
        '777343225',
        'Eilers',
        'Erika',
        NULL,
        'Trapezestraat 105',
        'Eindhoven',
        'NB',
        '6202 DB',
        '15-MAR-2002',
        '1005558025',
        5009,
        now()
    );
INSERT INTO patient
VALUES (
        '421226',
        '777343226',
        'Fultinga',
        'Frank',
        NULL,
        'Amelandstraat 8',
        'Franeker',
        'FR',
        '6233 LH',
        '16-JAN-1995',
        '1005558026',
        5011,
        now()
    );
COMMIT;
INSERT INTO patient
VALUES (
        '421227',
        '777343227',
        'Grosveld',
        'Greetje',
        NULL,
        'Nepveulaan 3',
        'Aardenburg',
        'ZE',
        '6202 NG',
        '31-OCT-1994',
        '1005558027',
        5013,
        now()
    );
-- Patiënten die op dit moment niet in het ziekenhuis liggen en niet gekoppeld zijn aan een bed
INSERT INTO patient
VALUES (
        '421228',
        '777343228',
        'Holtkamp',
        'Ronald',
        NULL,
        'Nobelstraat 15',
        'Aardenburg',
        'ZE',
        '6202 MK',
        '31-OCT-1985',
        '1005558028',
        NULL,
        now()
    );
INSERT INTO patient
VALUES (
        '421229',
        '777343229',
        'Mul',
        'Marian',
        NULL,
        'Ampsen 16',
        'Eindhoven',
        'NB',
        '6202 MM',
        '05-JAN-1966',
        '1005558029',
        5001,
        now()
    );
INSERT INTO patient
VALUES (
        '181230',
        '888343230',
        'Noordman',
        'Norbert',
        NULL,
        'Bergstraat 205',
        'Franeker',
        'FR',
        '6233 HM',
        '05-JAN-1956',
        '1005558030',
        5001,
        now()
    );
INSERT INTO patient
VALUES (
        '191449',
        '222343529',
        'Overdijk',
        'Onno',
        NULL,
        'Abeel 167',
        'Franeker',
        'FR',
        '6233 PR',
        '22-FEB-1978',
        '1005558031',
        NULL,
        now()
    );
COMMIT;
-- Vullen van de tabel patient_notitie - 174 rijen 
INSERT INTO patient_notitie
VALUES (
        '100001',
        date 'now()' + integer '1',
        'Patiënt opgenomen via Chirurgie om 1715 uur',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '100001',
        date 'now()' + integer '2',
        'Verband op buik droog en intact na leveroperatie.  Galblaasdrain met normale hoeveelheid (50 cc) donkergroene vloeistof tijdens deze dienst.',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '100002',
        now(),
        'Patiënt opgenomen via Chirurgie om 0810 uur',
        now()
    );
INSERT INTO patient_notitie
VALUES (
        '100002',
        date 'now()' + integer '1',
        'Patiënt leek cyanotisch met circumorale cyanose (respiratoir).',
        date 'now()' + integer '0'
    );
INSERT INTO patient_notitie
VALUES (
        '100002',
        date 'now()' + integer '2',
        'Ademhaling 24 met moeite.  O2 toegediend met 3 liter per minuut.',
        date 'now()' + integer '05'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100003',
        now(),
        'Patiënt opgenomen via EH om 2145 uur',
        now()
    );
INSERT INTO patient_notitie
VALUES (
        '100003',
        date 'now()' + integer '1',
        'Patiënt klaagde over buikpijn x2.  Buikholte gecontroleerd met positieve geluiden in alle vier de kwadranten.',
        date 'now()' + integer '0'
    );
INSERT INTO patient_notitie
VALUES (
        '100024',
        date 'now()' + integer '2',
        'Patiënt opgenomen via EH om 2200 uur',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '100024',
        date 'now()' + integer '3',
        'Verband om linkerteen verschoond x1 (diabeet).',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '100024',
        date 'now()' + integer '4',
        'Sereus-bloederig exsudaat op oud verband.  Geen etterige afscheiding aanwezig.',
        date 'now()' + integer '2'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100025',
        now(),
        'Patiënt opgenomen via Administratie om 0730 uur',
        now()
    );
INSERT INTO patient_notitie
VALUES (
        '100025',
        date 'now()' + integer '1',
        'Tractie voor linkerbeen van patiënt is intact.  Goede kleur, gevoel en beweging van tenen die warm en roze zijn.',
        date 'now()' + integer '0'
    );
INSERT INTO patient_notitie
VALUES (
        '100025',
        date 'now()' + integer '2',
        'Patiënt klaagde over pijn in linkerdij.  3x 75 mg Demerol en 25 mg Fenegran voorgeschreven met goed effect op de pijn.',
        date 'now()' + integer '0'
    );
INSERT INTO patient_notitie
VALUES (
        '100025',
        date 'now()' + integer '3',
        'Patiënt klaagde over pijn in linkerdij.  5x 75 mg Demerol en 25 mg Fenegran voorgeschreven met goed effect op de pijn.',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '100026',
        date 'now()' + integer '10',
        'Patiënt opgenomen via Chirurgie om 1456 uur',
        date 'now()' + integer '10'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100026',
        date 'now()' + integer '11',
        'Patiënt klaagde over scherpe stekende pijn in rechter elleboog. Gipsverband intact.',
        date 'now()' + integer '10'
    );
INSERT INTO patient_notitie
VALUES (
        '100026',
        date 'now()' + integer '12',
        '10 mg Morfine x2 voor elke klacht voorgeschreven.',
        date 'now()' + integer '10'
    );
INSERT INTO patient_notitie
VALUES (
        '100026',
        date 'now()' + integer '13',
        'Patiënt klaagde over doof gevoel in rechter elleboog. Gipsverband intact.',
        date 'now()' + integer '11'
    );
INSERT INTO patient_notitie
VALUES (
        '100026',
        date 'now()' + integer '14',
        '10 mg Morfine x2 voor elke klacht voorgeschreven.',
        date 'now()' + integer '11'
    );
INSERT INTO patient_notitie
VALUES (
        '100027',
        date 'now()' + integer '5',
        'Patiënt opgenomen via EH om 0245 uur',
        date 'now()' + integer '5'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100027',
        date 'now()' + integer '6',
        'Linker dijbeen vertoond samengestelde breuk juist onder de knie. Operatie gepland voor middag.',
        date 'now()' + integer '5'
    );
INSERT INTO patient_notitie
VALUES (
        '100027',
        date 'now()' + integer '7',
        '10 mg morfine, eenmaal per uur, voorgeschreven tegen pijn.',
        date 'now()' + integer '5'
    );
INSERT INTO patient_notitie
VALUES (
        '100028',
        date 'now()' + integer '6',
        'Patiënt opgenomen via Chirurgie om 1755 uur',
        date 'now()' + integer '6'
    );
INSERT INTO patient_notitie
VALUES (
        '100028',
        date 'now()' + integer '7',
        'Linker heupverband droog en intact.',
        date 'now()' + integer '6'
    );
INSERT INTO patient_notitie
VALUES (
        '100028',
        date 'now()' + integer '8',
        'Patiënt klaagde over pijn in heup (dij). 3x 75 mg Demerol en 25 mg Fenegran voorgeschreven met met goed effect op de pijn.',
        date 'now()' + integer '6'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100029',
        date 'now()' + integer '2',
        'Patiënt volgens afspraak opgenomen om 0710 uur. Gereedmaken voor operatie om 1400 uur.',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '100030',
        date 'now()' + integer '3',
        'Patiënt opgenomen via EH om 0400 uur',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '100030',
        date 'now()' + integer '4',
        'Patiënt wordt nog steeds geïsoleerd verpleegd.',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '100030',
        date 'now()' + integer '5',
        'Telling witte bloedlichaampjes blijft laag 2000 (oncologie). Geen pijnklachten, maar patiënt is lethargisch.',
        date 'now()' + integer '4'
    );
INSERT INTO patient_notitie
VALUES (
        '100031',
        date 'now()' + integer '4',
        'Patiënt opgenomen via EH om 1645 uur',
        date 'now()' + integer '4'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100031',
        date 'now()' + integer '5',
        'Oude verband bevat normale hoeveelheid sereus-bloederig drainvocht.',
        date 'now()' + integer '4'
    );
INSERT INTO patient_notitie
VALUES (
        '100031',
        date 'now()' + integer '6',
        'Hechtingen van incisie zijn intact. Geen etterige afscheiding aanwezig.',
        date 'now()' + integer '4'
    );
INSERT INTO patient_notitie
VALUES (
        '100051',
        date 'now()' + integer '4',
        'Patiënt opgenomen via EH om 0400 uur',
        date 'now()' + integer '4'
    );
INSERT INTO patient_notitie
VALUES (
        '100051',
        date 'now()' + integer '5',
        'Rechterzijde van patiënt blijft slap. Babinski linkervoet negatief (beroerte).',
        date 'now()' + integer '4'
    );
INSERT INTO patient_notitie
VALUES (
        '100051',
        date 'now()' + integer '6',
        'Rechterpupil blijft troebel. Geen respons op verbale stimuli.',
        date 'now()' + integer '45'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100301',
        now(),
        'Patiënt opgenomen via EH om 0400 hours',
        now()
    );
INSERT INTO patient_notitie
VALUES (
        '100301',
        date 'now()' + integer '1',
        'Scheurwond dig. III links tussen eerste en tweede falanx. Wondgebied gereinigd en gehecht met 14 hechtingen.',
        date 'now()' + integer '0'
    );
INSERT INTO patient_notitie
VALUES (
        '100301',
        date 'now()' + integer '2',
        'Patiënt klaagde over pijn in linkerhand. 3x 50 mg Demerol en 25 mg Fenegran voorgeschreven met nauwelijks verlichting van de pijn.',
        date 'now()' + integer '05'
    );
INSERT INTO patient_notitie
VALUES (
        '100302',
        date 'now()' + integer '1',
        'Patiënt opgenomen via EH om 0400 uur',
        date 'now()' + integer '14'
    );
INSERT INTO patient_notitie
VALUES (
        '100302',
        date 'now()' + integer '14',
        'Weëen geklokt op interval van 8 minuten. Patiënt getoucheerd, ontsluiting 4cm.',
        date 'now()' + integer '14'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100302',
        date 'now()' + integer '15',
        'Weëen geklokt op interval van 6 minuten. Patiënt getoucheerd, ontsluiting 4 cm.',
        date 'now()' + integer '14'
    );
INSERT INTO patient_notitie
VALUES (
        '100302',
        date 'now()' + integer '16',
        'Weëen geklokt op interval van 4 minuten. Patiënt getoucheerd, ontsluiting 4 cm.',
        date 'now()' + integer '14'
    );
INSERT INTO patient_notitie
VALUES (
        '100303',
        date 'now()' + integer '12',
        'Patiënt opgenomen via EH om 0400 uur',
        date 'now()' + integer '12'
    );
INSERT INTO patient_notitie
VALUES (
        '100303',
        date 'now()' + integer '13',
        'Penplaatsen (2x) voor de tractie gereinigd met peroxide. Penplaatsen produceren niet. Halotractie intact.',
        date 'now()' + integer '12'
    );
INSERT INTO patient_notitie
VALUES (
        '100303',
        date 'now()' + integer '14',
        'Verband om hoofdwond vertoont linksonder kleine wondvochtvlek.',
        date 'now()' + integer '12'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100303',
        date 'now()' + integer '15',
        'Patiënt klaagde over pijn in linkerhand. 3 x 75 mg Demerol en 25 mg Fenegran voorgeschreven met nauwelijks verlichting van de pijn.',
        date 'now()' + integer '125'
    );
INSERT INTO patient_notitie
VALUES (
        '100304',
        date 'now()' + integer '6',
        'Patiënt opgenomen via EH om 0400 uur',
        date 'now()' + integer '6'
    );
INSERT INTO patient_notitie
VALUES (
        '100304',
        date 'now()' + integer '7',
        'Patiënt slaapt en is ontspannen.',
        date 'now()' + integer '6'
    );
INSERT INTO patient_notitie
VALUES (
        '100304',
        date 'now()' + integer '8',
        'Tube links door arts in borst zonder complicaties ingebracht voor steekwond. Aangesloten op Pluravac op de vloer naast bed.',
        date 'now()' + integer '6'
    );
INSERT INTO patient_notitie
VALUES (
        '100304',
        date 'now()' + integer '65',
        'Pluravac voerde deze dienst 75 cc groenachtige etterige vloeistof af.',
        date 'now()' + integer '65'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100304',
        date 'now()' + integer '66',
        'IV-plek in linkerarm rood en opgezwollen. Infuus verwijderd van linkerarm en warme compres aangebracht. Linkerarm omhooggebracht met behulp van kussen.',
        date 'now()' + integer '6'
    );
INSERT INTO patient_notitie
VALUES (
        '100304',
        date 'now()' + integer '67',
        '22 g intracath intraveneuze catheter ingebracht in handrug rechts waaruit gemakkelijk bloed kan worden opgetrokken.',
        date 'now()' + integer '65'
    );
INSERT INTO patient_notitie
VALUES (
        '100305',
        date 'now()' + integer '2',
        'Patiënt opgenomen via EH om 0400 uur',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '100305',
        date 'now()' + integer '3',
        'Patiënt had tijdje snelle hartslag (1x). Hartslag 120 en stijgend.',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '100305',
        date 'now()' + integer '4',
        'Patiënt klaagde over kortademigheid.',
        date 'now()' + integer '2'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100305',
        date 'now()' + integer '5',
        '10 mg valium IV toegediend met goed resultaat. Hartslag terug naar normaal (84 binnen 10 minuten).',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '100306',
        date 'now()' + integer '2',
        'Patiënt opgenomen via Chirurgie om 0400 uur',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '100306',
        date 'now()' + integer '3',
        'NG-tube zonder weerstand aangebracht in linker neusgat. Aan laag muurvacuüm aangesloten. 125 cc heldere groene vloeistof in deze dienst afgevoerd.',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '100422',
        date 'now()' + integer '2',
        'Patiënt opgenomen via EH om 1125 uur',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '100422',
        date 'now()' + integer '3',
        'Vleeswond 30 cm met uitstekende botfragmenten. Chirurg van dienst gebeld-onmiddellijk gereed gemaakt voor operatie. Vitale signalen stabiel.',
        date 'now()' + integer '2'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100422',
        date 'now()' + integer '4',
        'Patiënt klaagde over pijn in linker opperarmbeen. 3 x 75 mg Demerol en 25 mg Fenegran voorgeschreven met nauwelijks verlichting van de pijn.',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '100423',
        now(),
        'Patiënt opgenomen via EH om 0650 uur',
        now()
    );
INSERT INTO patient_notitie
VALUES (
        '100423',
        date 'now()' + integer '1',
        'Patiënt heeft enkel verstuikt-Röntgenfoto voor mogelijke fractuur.',
        date 'now()' + integer '0'
    );
INSERT INTO patient_notitie
VALUES (
        '100424',
        date 'now()' + integer '2',
        'Patiënt opgenomen via Chirurgie om 0115 uur',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '100424',
        date 'now()' + integer '3',
        'Pupillen even groot en bilateraal reactief op licht. Georiënteerd in tijd. plaats en persoon 3x.',
        date 'now()' + integer '1'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100424',
        date 'now()' + integer '4',
        'Hoofdwond onder beharing, gehecht met 12 hechtingen.',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '100424',
        date 'now()' + integer '15',
        'MRI om schedelbasisfractuur uit te kunnen sluiten.',
        date 'now()' + integer '15'
    );
INSERT INTO patient_notitie
VALUES (
        '100425',
        date 'now()' + integer '3',
        'Patiënt opgenomen via EH om 0100 uur',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '100425',
        date 'now()' + integer '4',
        'Patiënt heeft vanochtend een voedingssonde ingebracht gekregen. Verband rondom tube droog en intact. Plaatsingsverificatieonderzoek via Radiologie.',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '100500',
        now(),
        'Patiënt opgenomen via EH om 1440 uur',
        now()
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100500',
        date 'now()' + integer '1',
        'Ademhaling verminderd hoorbaar in kwab linksonder. Ademhaling 24 en oppervlakkig.',
        date 'now()' + integer '0'
    );
INSERT INTO patient_notitie
VALUES (
        '100500',
        date 'now()' + integer '2',
        'Patiënt blijft aan IV Aminophylline drip met 250mg/uur.',
        date 'now()' + integer '0'
    );
INSERT INTO patient_notitie
VALUES (
        '100500',
        date 'now()' + integer '3',
        'Tube links door arts in borst zonder complicaties ingebracht. Aangesloten op Pluravac op de vloer naast bed.',
        date 'now()' + integer '0'
    );
INSERT INTO patient_notitie
VALUES (
        '100500',
        date 'now()' + integer '5',
        'Pluravac voerde deze dienst 75 cc groenachtige etterige vloeistof af.',
        date 'now()' + integer '05'
    );
INSERT INTO patient_notitie
VALUES (
        '100501',
        date 'now()' + integer '1',
        'Patient opgenomen op EH om 0145 uur',
        date 'now()' + integer '1'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100501',
        date 'now()' + integer '2',
        'Patiënt klaagt over kortademigheid. Ademhaling 28 en moeizaam. O2 opgevoerd van van 2 l/min naar 4 l/min. Arts gewaarschuwd.',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '100501',
        date 'now()' + integer '3',
        '2 mg valium IV toegediend om 0215 uur.',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '100502',
        date 'now()' + integer '3',
        'Patient opgenomen op EH om 0815 uur',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '100502',
        date 'now()' + integer '4',
        'Patiënt licht gedesoriënteerd. Huid klam. Acucheck resultaat 42 (diabeet).',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '100502',
        date 'now()' + integer '5',
        '15 eenheden insuline met suiker en sinaasappelsap toegediend.',
        date 'now()' + integer '3'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100502',
        date 'now()' + integer '35',
        'Patiënt nogmaals gecontroleerd na 30 minuten. Huid droog. Acucheck resultaat 102.',
        date 'now()' + integer '35'
    );
INSERT INTO patient_notitie
VALUES (
        '100503',
        date 'now()' + integer '2',
        'Patient opgenomen op EH om 0930 uur',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '100503',
        date 'now()' + integer '3',
        'EKG heeft verhoogde ST-golven. Patiënt krijgt Procardia en wordt 3 dagen na ECG bewaakt.',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '100504',
        date 'now()' + integer '5',
        'Patient opgenomen op EH om 1123 uur',
        date 'now()' + integer '5'
    );
INSERT INTO patient_notitie
VALUES (
        '100504',
        date 'now()' + integer '6',
        'Patiënt klaagt over kortademigheid. Ademhaling 28 en moeizaam.',
        date 'now()' + integer '5'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100504',
        date 'now()' + integer '7',
        'O2 opgevoerd van 2 l/min naar 4 l/min. Arts gewaarschuwd.',
        date 'now()' + integer '5'
    );
INSERT INTO patient_notitie
VALUES (
        '100504',
        date 'now()' + integer '8',
        'Patiënt had tijdje snelle hartslag. Hartslag 120 en stijgend.',
        date 'now()' + integer '5'
    );
INSERT INTO patient_notitie
VALUES (
        '100504',
        date 'now()' + integer '55',
        'Patiënt klaagde over kortademigheid.',
        date 'now()' + integer '55'
    );
INSERT INTO patient_notitie
VALUES (
        '100504',
        date 'now()' + integer '56',
        '10 mg valium IV toegediend met goed resultaat. Hartslag terug naar 84 binnen 10 minuten.',
        date 'now()' + integer '5'
    );
INSERT INTO patient_notitie
VALUES (
        '100505',
        date 'now()' + integer '7',
        'Patient opgenomen op EH om 1540 uur',
        date 'now()' + integer '7'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '100505',
        date 'now()' + integer '8',
        'Patiënt klaagde over pijn in rechterarm. 3 x 50 mg Demerol en 25 mg Fenegran voorgeschreven met matige verlichting van de pijn.',
        date 'now()' + integer '7'
    );
INSERT INTO patient_notitie
VALUES (
        '100505',
        date 'now()' + integer '9',
        'Vreemd object (splinter) onder vierde digit. Gebied geïnjecteerd met Lidocaine en splinter verwijderd. Wond ontsmet met betadine en verbonden.',
        date 'now()' + integer '7'
    );
INSERT INTO patient_notitie
VALUES (
        '100506',
        date 'now()' + integer '2',
        'Patiënt opgenomen op EH om 0530 uur',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '100506',
        date 'now()' + integer '3',
        'Patiënt klaagde over pijn in linkerhand. 3 x 50 mg Demerol en 25 mg Fenegran voorgeschreven met nauwelijks verlichting van de pijn.',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '222001',
        now(),
        'Patiënt opgenomen via EH om 0730 uur',
        now()
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '222001',
        date 'now()' + integer '4',
        'Builverband droog en intact na leveroperatie. Galdrain met normale hoeveelheid donkergroene afscheiding.',
        date 'now()' + integer '0'
    );
INSERT INTO patient_notitie
VALUES (
        '222002',
        date 'now()' + integer '1',
        'Patiënt opgenomen via EH om 0830 uur',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '222002',
        date 'now()' + integer '2',
        'Verband en kapje linkeroog droog en intact. Geen pijnklachten.',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '555003',
        date 'now()' + integer '3',
        'Patiënt opgenomen via EH om 0920 uur',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '555003',
        date 'now()' + integer '4',
        'Tractie van linkerbeen intact. Kleur, gevoel en bewegingen van tenen (warm en rose) goed.',
        date 'now()' + integer '3'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '555004',
        date 'now()' + integer '5',
        'Patiënt opgenomen via EH om 1200 uur',
        date 'now()' + integer '5'
    );
INSERT INTO patient_notitie
VALUES (
        '555004',
        date 'now()' + integer '6',
        'Tube links in borst produceert (3x).',
        date 'now()' + integer '5'
    );
INSERT INTO patient_notitie
VALUES (
        '555005',
        date 'now()' + integer '1',
        'Patiënt opgenomen via EH om 1445 uur',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '555005',
        date 'now()' + integer '2',
        'Foleycatheter voert goed af.',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '222006',
        now(),
        'Patiënt opgenomen via EH om 0530 uur',
        now()
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '222006',
        date 'now()' + integer '1',
        'NG-tube voerde 300 cc heldergroene vloeistof af. Ingewanden lijken absent.',
        date 'now()' + integer '0'
    );
INSERT INTO patient_notitie
VALUES (
        '333110',
        date 'now()' + integer '2',
        'Patiënt opgenomen via EH om 1530 uur',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '333110',
        date 'now()' + integer '3',
        'Transfusie met 4 eenheden verpakte cellen en 10 eenheden van plaatjes. Geen reactie. Verdroeg procedure goed.',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '333111',
        now(),
        'Patiënt opgenomen via EH om 1235 uur',
        now()
    );
INSERT INTO patient_notitie
VALUES (
        '333111',
        date 'now()' + integer '1',
        'Patiënt klaagt nog steeds over zere mond. Mondspoeling met 1,5% waterstofperoxide voorgeschreven.',
        date 'now()' + integer '0'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '333111',
        date 'now()' + integer '2',
        'Visceuze Xylocainegel aangebracht op mondslijmvlies om ongemak enigszins te verlichten.',
        date 'now()' + integer '0'
    );
INSERT INTO patient_notitie
VALUES (
        '333111',
        date 'now()' + integer '3',
        'Familie en arts hadden vandaag overleg over stamceltransplantatie van volgende week. Patiënt blijft geisoleerd vanwege lage hoeveelheid witte bloedlichamen (vandaag 3500).',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '333112',
        date 'now()' + integer '1',
        'Patiënt opgenomen via Poli om 0725 uur',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '333112',
        date 'now()' + integer '2',
        'Hypervoeding en lipiden nog steeds via infuus onder sleutelbeen met 125 cc/uur',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '333112',
        date 'now()' + integer '3',
        'Geen roodheid of zwelling op insertieplek tijdens verschonen van verband. Nieuw verband op operatiewond aangebracht zonder complicaties.',
        date 'now()' + integer '2'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '333113',
        date 'now()' + integer '2',
        'Patiënt opgenomen via Chirurgie om 1005 uur',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '333113',
        date 'now()' + integer '3',
        'Patiënt blijft last houden van overgeven en buikloop. IV gestart-22g angiocath in linker handrug met D5NS met 200 cc/uur.',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '333113',
        date 'now()' + integer '4',
        'Patiënt probeerde over railing van bed te klimmen. Is gedesoriënteerd in tijd en plaats. Poseyvest aangetrokken en railing van bed omhooggebracht.',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '333113',
        date 'now()' + integer '5',
        'Patiënt 3 x ambulant in gang deze dienst. Zegt vandaag meer kracht te hebben dan anders na operatie 3 dagen geleden.',
        date 'now()' + integer '5'
    );
INSERT INTO patient_notitie
VALUES (
        '333114',
        date 'now()' + integer '1',
        'Patiënt opgenomen via EH om 1450 uur',
        date 'now()' + integer '1'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '333114',
        date 'now()' + integer '2',
        'Patiënt blijft last houden van overgeven en buikloop. IV gestart-22g angiocath in linker handrug met D5NS met 90 cc/uur.',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '333114',
        date 'now()' + integer '3',
        'Patiënt had een neusbloeding die 10 minuten aanhield. Gestopt door lichte druk en achteroverliggen. Plaatjestelling vanochtend is 150.000.',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '333115',
        date 'now()' + integer '2',
        'Patiënt opgenomen via EH om 1500 uur',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '333115',
        date 'now()' + integer '3',
        'Patiënt klaagt over slechtzittend kunstgebit vanwege gewichtsverlies als gevolg van kanker en chemotherapie. Heeft ook last van ontsteking van het mondslijmvlies; daarvoor viscueze lidocaine mondspoeling toegediend.',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '333115',
        date 'now()' + integer '4',
        'Dieet van patiënt omgezet van standaard naar zacht voedsel. Verdroeg avondmaaltijd met zachte voeding goed.',
        date 'now()' + integer '2'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '333116',
        date 'now()' + integer '1',
        'Patiënt opgenomen via Poli om 0725 uur',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '333116',
        date 'now()' + integer '2',
        'Patiënt verdroeg IV-behandeling met Oncovin goed. (Leukemie) Witte bloedlichamen voor behandeling 9800.',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '333116',
        date 'now()' + integer '3',
        'Geen klachten over misselijkheid, maar wel last van koude rillingen tijdens behandeling (die ophielden binnen 30 minuten na aanvang van de behandeling.',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '333117',
        date 'now()' + integer '3',
        'Patiënt opgenomen via Poli om 0725 uur',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '333117',
        date 'now()' + integer '4',
        'Hypervoeding en lipiden nog steeds via infuus onder sleutelbeen met 125 cc/uur',
        date 'now()' + integer '3'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '333117',
        date 'now()' + integer '5',
        'Geen roodheid of zwelling op insertieplek tijdens verschonen van verband. Nieuw verband op operatiewond aangebracht zonder complicaties.',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '666117',
        date 'now()' + integer '6',
        'Patiënt opgenomen via EH om 0725 uur',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '666117',
        date 'now()' + integer '7',
        'Hypervoeding en lipiden nog steeds via infuus onder sleutelbeen met 125 cc/uur',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '666117',
        date 'now()' + integer '8',
        'Geen roodheid of zwelling op insertieplek tijdens verschonen van verband. Nieuw verband op operatiewond aangebracht zonder complicaties.',
        date 'now()' + integer '4'
    );
INSERT INTO patient_notitie
VALUES (
        '666118',
        now(),
        'Patiënt opgenomen via EH om 0725 hours',
        now()
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '666118',
        date 'now()' + integer '1',
        'IV-plek in linker handrug rood en opgezwollen. Infuus verwijderd uit linkerarm en warme compres aangebracht.  Linkerarm omhooggebracht met behulp van kussen.',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '666118',
        date 'now()' + integer '2',
        '22g intracath intraveneuze catheter ingebracht in handrug rechts waaruit gemakkelijk bloed kan worden opgetrokken.',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '666118',
        date 'now()' + integer '3',
        'NG-tube ingebracht in linker neusgat zonder weerstand. Aan laag muurvacuüm aangesloten. 125 cc heldere groene vloeistof in deze dienst afgevoerd.',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '666119',
        date 'now()' + integer '2',
        'Patiënt opgenomen via EH om 0725 uur',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '666119',
        date 'now()' + integer '3',
        'Huidzwelling onrustig. Lippen droog en gebarsten. Huid en ogen gelig.',
        date 'now()' + integer '3'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '666119',
        date 'now()' + integer '4',
        'Foleycatheter voert bruine urine af - 30 cc in afgelopen acht uur. Patiënt lethargisch, reageert alleen op naam.',
        date 'now()' + integer '4'
    );
INSERT INTO patient_notitie
VALUES (
        '666119',
        date 'now()' + integer '5',
        'Patiënt gestorven om 2018 uur in aanwezigheid van de familie.  Lichaam overgebracht naar mortuarium om 2230 uur.',
        date 'now()' + integer '4'
    );
INSERT INTO patient_notitie
VALUES (
        '666120',
        now(),
        'Patiënt opgenomen via EH om 0725 uur',
        now()
    );
INSERT INTO patient_notitie
VALUES (
        '666120',
        date 'now()' + integer '1',
        'Patiënt had even versnelde hartslag x1  Hartslag 120 en versnellend.',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '666120',
        date 'now()' + integer '2',
        'Patiënt klaagde over kortademigheid.',
        date 'now()' + integer '1'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '666120',
        date 'now()' + integer '12',
        '10 mg valium IV toegediend met goede resultaten.  Hartslag gedaald tot 84 binnen 10 minuten.',
        date 'now()' + integer '12'
    );
INSERT INTO patient_notitie
VALUES (
        '666121',
        date 'now()' + integer '1',
        'Patiënt opgenomen via Chirurgie om 2225 uur',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '666121',
        date 'now()' + integer '2',
        'Buikverband verschoond. Oude verband bevat normale hoeveelheid sereus-bloederig drainvocht.',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '666121',
        date 'now()' + integer '3',
        'Hechtingen van incisie zijn intact. Geen etterige afscheiding aanwezig.',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '666121',
        date 'now()' + integer '4',
        'Patiënt klaagde over buikpijn.  3 x 75 mg Demerol en 25 mg Fenegran voorgeschreven met redelijk effect op de pijn.',
        date 'now()' + integer '3'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '421221',
        now(),
        'Patiënt opgenomen via EH om 0725 uur',
        now()
    );
INSERT INTO patient_notitie
VALUES (
        '421221',
        date 'now()' + integer '1',
        'Ruggenmergpunctie door arts uitgevoerd. Afgenomen spinaalvloeistof bleek helder en kleurloos. Naar lab vooronderzoek. Patiënt verdraagt behandeling goed.',
        date 'now()' + integer '0'
    );
INSERT INTO patient_notitie
VALUES (
        '421222',
        now(),
        'Patiënt opgenomen via Poli om 0725 uur',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '421222',
        date 'now()' + integer '3',
        'Rechterarm blijft in gipsverband. Rechtervingers warm, paars en droog maar goed beweegbaarheid van alle digits.',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '421222',
        date 'now()' + integer '4',
        'Patiënt klaagde over pijn in arm.  10 mg Demerol en 10 mg Fenegran voorgeschreven met goed effect op de pijn.',
        date 'now()' + integer '4'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '421223',
        date 'now()' + integer '3',
        'Patiënt opgenomen via Poli om 0725 uur',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '421223',
        date 'now()' + integer '4',
        'Factor VIII-infuus in rechterarm zonder complicaties. Geen tekenen van bloeding of andere afwijkingen zichtbaar.',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '421223',
        date 'now()' + integer '5',
        'Patiënt deze dienst 3 maal ambulant over gang.',
        date 'now()' + integer '4'
    );
INSERT INTO patient_notitie
VALUES (
        '421224',
        date 'now()' + integer '3',
        'Patiënt opgenomen via EH om 0725 uur',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '421224',
        date 'now()' + integer '4',
        'Huidzwelling rustig, slijmvliesmembramen vochtig, huilt. 3x luier verschoond, gemeten 75 cc, 55 cc en 60 cc.',
        date 'now()' + integer '3'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '421225',
        date 'now()' + integer '3',
        'Patiënt opgenomen via EH om 0725 uur',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '421225',
        date 'now()' + integer '4',
        'Patiënt heeft deze dienst totaal 80 cc Pedilyte gekregen. Goede zuigreflex, maar blijft lethargisch en zachtjes huilen.',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '421225',
        date 'now()' + integer '5',
        'angiocath intraveneus catheter nr. 26 ingebracht in scalpvene zonder complicaties. IV-infuus: D5NS met 25 cc/uur.',
        date 'now()' + integer '4'
    );
INSERT INTO patient_notitie
VALUES (
        '421226',
        now(),
        'Patiënt opgenomen via Poli om 1005 uur',
        now()
    );
INSERT INTO patient_notitie
VALUES (
        '421226',
        date 'now()' + integer '1',
        'Inspiratoire en expiratoire ruis nog steeds hoorbaar. Reutels opgemerkt in linker long. Saturatie laag maar zonder assistentie op 28.',
        date 'now()' + integer '0'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '421226',
        date 'now()' + integer '2',
        'Temperatuur deze middag maximaal 38°C. Elke 4 uur vloeibaar Tylenol toegediend.',
        date 'now()' + integer '0'
    );
INSERT INTO patient_notitie
VALUES (
        '421226',
        date 'now()' + integer '10',
        'IV-infuur in linkerarm gehandhaafd (D5NS met 125 cc/uur.',
        date 'now()' + integer '1'
    );
INSERT INTO patient_notitie
VALUES (
        '421227',
        date 'now()' + integer '2',
        'Patiënt opgenomen via Poli om 0022 uur',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '421227',
        date 'now()' + integer '3',
        '2x Heparine in rechterhand zonder complicaties. Bloed kan gemakkelijk worden opgetrokken. Geen zwelling of roodheid.',
        date 'now()' + integer '2'
    );
INSERT INTO patient_notitie
VALUES (
        '421227',
        date 'now()' + integer '4',
        'Patiënt had slechte nacht als gevolg van het feit haar rechter arm gefixeerd was om infuusplek te beschermen.',
        date 'now()' + integer '3'
    );
COMMIT;
INSERT INTO patient_notitie
VALUES (
        '421227',
        date 'now()' + integer '5',
        'Patiënt klaagt over maagkrampen en diarree 3x.  Licht vloeibaar dieet werd goed verdragen. maar patiënt geeft te kennen trek te hebben in meer vast voedsel.',
        date 'now()' + integer '3'
    );
INSERT INTO patient_notitie
VALUES (
        '421228',
        date 'now()' + integer '28',
        'Patiënt opgenomen via EH om 0022 uur',
        date 'now()' + integer '28'
    );
INSERT INTO patient_notitie
VALUES (
        '421228',
        date 'now()' + integer '29',
        'Rechterarm blijft in gipsverband. Rechtervingers warm, paars en droog maar goed beweegbaarheid van alle digits.',
        date 'now()' - integer '29'
    );
INSERT INTO patient_notitie
VALUES (
        '421228',
        date 'now()' + integer '30',
        'Patiënt ontslagen om 0815 uur',
        date 'now()' + integer '30'
    );
COMMIT;
-- Vullen van de tabel afdeling - 18 rijen 
INSERT INTO zh_afdeling
VALUES (
        'HEEL1',
        'Heelkunde 1',
        'ZW1020',
        '1005559201',
        now()
    );
INSERT INTO zh_afdeling
VALUES (
        'HEEL2',
        'Heelkunde 2',
        'NW1018',
        '1005559202',
        now()
    );
INSERT INTO zh_afdeling
VALUES (
        'RADI1',
        'Radiologie',
        'RA0070',
        '1005559203',
        now()
    );
INSERT INTO zh_afdeling
VALUES (
        'EH1',
        'Eerste Hulp',
        'RA0070',
        '1005559204',
        now()
    );
INSERT INTO zh_afdeling
VALUES (
        'CHI1',
        'Chirurgie',
        'CHI010',
        '1005559205',
        now()
    );
COMMIT;
INSERT INTO zh_afdeling
VALUES (
        'ONCOL',
        'Oncologie',
        'ZW3010',
        '1005559206',
        now()
    );
INSERT INTO zh_afdeling
VALUES (
        'IC',
        'Intensive Care',
        'NW3005',
        '1005559207',
        now()
    );
INSERT INTO zh_afdeling
VALUES (
        'PEDI1',
        'Pediatrie',
        'ZW2010',
        '1005559208',
        now()
    );
INSERT INTO zh_afdeling
VALUES (
        'GYN1',
        'Gynaecologie',
        'ZW2655',
        '1005559216',
        now()
    );
INSERT INTO zh_afdeling
VALUES ('APO', 'Apotheek', 'NW0085', '1005559207', now());
COMMIT;
INSERT INTO zh_afdeling
VALUES (
        'LAB1',
        'Laboratorium 1',
        'NW0090',
        '1005559208',
        now()
    );
INSERT INTO zh_afdeling
VALUES (
        'LAB2',
        'Laboratorium 2',
        'NW0093',
        '1005559209',
        now()
    );
INSERT INTO zh_afdeling
VALUES (
        'CARD1',
        'Cardiologie',
        'ZW1288',
        '1005559210',
        now()
    );
INSERT INTO zh_afdeling
VALUES (
        'UITS1',
        'Uitschrijvingen',
        'ZW1400',
        '1005559211',
        now()
    );
INSERT INTO zh_afdeling
VALUES (
        'ADMIN',
        'Administratie',
        'ZW1500',
        '1005559212',
        now()
    );
COMMIT;
INSERT INTO zh_afdeling
VALUES ('INTK', 'Intake', 'ZW15010', '1005559213', now());
INSERT INTO zh_afdeling
VALUES (
        'CHIVK',
        'Chirurgie, verkoever',
        'VK0005',
        '1005559214',
        now()
    );
INSERT INTO zh_afdeling
VALUES (
        'NEON1',
        'Neonatologie',
        'ZW2700',
        '1005559215',
        now()
    );
COMMIT;
-- Vullen van de tabel personeel - 24 rijen 
INSERT INTO personeel
VALUES (
        '23232',
        '310223232',
        'Ebbink',
        'Max',
        'van',
        'HEEL1',
        'ZW4208',
        '06-JAN-98',
        'dr',
        '1005559268',
        '0001',
        '54386',
        150000,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '23244',
        '316223244',
        'Weber',
        'Eugene',
        NULL,
        'RADI1',
        'ZW4392',
        '16-FEB-95',
        'dr',
        '1005559270',
        '4410',
        '383815',
        175000,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '10044',
        '216223308',
        'Suurbier',
        'Elizabeth',
        NULL,
        'EH1',
        'ZW4393',
        '16-FEB-01',
        'dr',
        '1005559271',
        '3201',
        '419057',
        165000,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '23100',
        '261223803',
        'Bordoloi',
        'Bijoy',
        NULL,
        'RADI1',
        'ZW4392',
        '23-AUG-99',
        'dr',
        '1005559270',
        '4411',
        '8398663',
        178500,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '01885',
        '215243964',
        'Bock',
        'Douglas',
        NULL,
        'HEEL1',
        'ZW4209',
        '11-AUG-87',
        'dr',
        '1005559268',
        '0011',
        '234576',
        162500,
        NULL,
        now()
    );
COMMIT;
INSERT INTO personeel
VALUES (
        '66425',
        '261803223',
        'Quattromani',
        'Antonio',
        NULL,
        'CARD1',
        'ZW4410',
        '10-NOV-89',
        'dr',
        '1005559280',
        '0222',
        '4398777',
        225325,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '66427',
        '348789991',
        'Schulte',
        'Roberto',
        'van',
        'UITS1',
        'ZW4408',
        '14-DEC-79',
        'dr',
        '1005559284',
        '0333',
        '45982245',
        175425,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '66432',
        '980789632',
        'Kleingeld',
        'Robert',
        NULL,
        'ONCOL',
        'ZW4422',
        '01-FEB-84',
        'dr',
        '1005559268',
        '0201',
        '55662398',
        150655,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '66532',
        '980789632',
        'Brokken',
        'Mary',
        NULL,
        'GYN1',
        'ZW4800',
        '23-FEB-96',
        'VPK1',
        '1005559401',
        '0030',
        '435576',
        68000,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '67555',
        '981789642',
        'Simonelli',
        'Luigi',
        NULL,
        'CHIVK',
        'ZW4801',
        '03-MAR-98',
        'VPK1',
        '1005559401',
        '0031',
        '763345',
        62000,
        NULL,
        now()
    );
COMMIT;
INSERT INTO personeel
VALUES (
        '67585',
        '445667323',
        'Simonelli',
        'Leander',
        NULL,
        'NEON1',
        'ZW4802',
        '30-MAR-98',
        'VPK2',
        '1005559401',
        '0032',
        '478892',
        42000,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '67666',
        '732971001',
        'Younis',
        'Yvonne',
        NULL,
        'NEON1',
        'ZW4803',
        '26-FEB-00',
        'VPK2',
        '1005559401',
        '0033',
        '478892',
        42000,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '66444',
        '980789632',
        'Zuijdewijn',
        'Mary',
        'van',
        'ONCOL',
        'ZW4804',
        '03-JAN-96',
        'VPK1',
        '1005559401',
        '0033',
        '872589',
        69500,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '33344',
        '890563287',
        'Adamus',
        'Anton',
        NULL,
        'ADMIN',
        'NW0105',
        '29-JAN-85',
        'Administratief medewerker',
        '1005558287',
        '1212',
        NULL,
        35500,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '33355',
        '890536222',
        'Boudewijn',
        'Bertine',
        NULL,
        'ADMIN',
        'NW0105',
        '15-OCT-01',
        'Administratief medewerker',
        '1005558287',
        '1213',
        NULL,
        37520,
        NULL,
        now()
    );
COMMIT;
INSERT INTO personeel
VALUES (
        '33356',
        '790543232',
        'Boudreaux',
        'Betty',
        NULL,
        'ADMIN',
        'NW0106',
        '05-NOV-00',
        'Medewerker Intake',
        '1005558287',
        '1214',
        NULL,
        32895,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '33358',
        '834576129',
        'Thorn',
        'Wim',
        'van',
        'ADMIN',
        'NW0220',
        '14-APR-00',
        'Facilitair medewerker',
        1005558287,
        '1213',
        NULL,
        NULL,
        8.28,
        now()
    );
INSERT INTO personeel
VALUES (
        '33359',
        '457890233',
        'Cleef',
        'Leo',
        'van',
        'ADMIN',
        'NW0220',
        '05-JAN-01',
        'Facilitair medewerker',
        1005558287,
        '1213',
        NULL,
        NULL,
        7.35,
        now()
    );
INSERT INTO personeel
VALUES (
        '88101',
        '347889991',
        'Beets',
        'Robert',
        NULL,
        'CHI1',
        'ZW4408',
        '14-DEC-82',
        'dr',
        '1005559284',
        '0355',
        '2398457',
        235450,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '88202',
        '232888647',
        'Beets',
        'Roberta',
        NULL,
        'CHI1',
        'ZW4408',
        '14-DEC-82',
        'dr',
        '1005559284',
        '0355',
        '4455872',
        230000,
        NULL,
        now()
    );
COMMIT;
INSERT INTO personeel
VALUES (
        '88303',
        '654339993',
        'Jansen',
        'Andre',
        NULL,
        'CHI1',
        'ZW4408',
        '01-JAN-90',
        'dr',
        '1005559284',
        '0355',
        '8935781',
        305250,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '88404',
        '787249002',
        'Barbiero',
        'Leo',
        'di',
        'CHI1',
        'ZW4408',
        '16-MAY-01',
        'dr',
        '1005559284',
        '0355',
        '9873346',
        275000,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '88505',
        '548865540',
        'Smit',
        'Suzan',
        'de',
        'CHI1',
        'ZW4408',
        '19-JUN-00',
        'dr',
        '1005559284',
        '0355',
        '4590225',
        325500,
        NULL,
        now()
    );
INSERT INTO personeel
VALUES (
        '88777',
        '664865650',
        'Smit',
        'Alyssa',
        'de',
        'RADI1',
        'ZW4414',
        '10-JUN-99',
        'Radiologisch technicus',
        '1005559267',
        '3444',
        '98993455',
        45500,
        NULL,
        now()
    );
COMMIT;
-- Vullen van de tabel medisch_specialisme - 15 rijen 
INSERT INTO medisch_specialisme
VALUES (
        'OPT',
        'Optometrist',
        'Volledig bevoegd optometrist.',
        now()
    );
INSERT INTO medisch_specialisme
VALUES (
        'ONC',
        'Oncoloog',
        'Voltooide opleiding tot oncoloog.',
        now()
    );
INSERT INTO medisch_specialisme
VALUES (
        'RAD',
        'Radioloog',
        'Voltooide opleiding tot oncoloog.',
        now()
    );
INSERT INTO medisch_specialisme
VALUES (
        'CAR',
        'Cardioog',
        'Voltooide opleiding tot cardioloog.',
        now()
    );
INSERT INTO medisch_specialisme
VALUES (
        'GYN',
        'Gynaecoloog',
        'Voltooide opleiding tot gynaecoloog.',
        now()
    );
COMMIT;
INSERT INTO medisch_specialisme
VALUES (
        'AAS',
        'Arts assistent',
        'Voltooide studie medicijnen.',
        now()
    );
INSERT INTO medisch_specialisme
VALUES (
        'CH1',
        'Thoraxchirurg',
        'Voltooide opleiding tot thoraxchirurg.',
        now()
    );
INSERT INTO medisch_specialisme
VALUES (
        'CH2',
        'Chirurg',
        'Volledig bevoegd chirurg.',
        now()
    );
INSERT INTO medisch_specialisme
VALUES (
        'CH3',
        'Neuroloog',
        'Voltooide opleiding tot neuroloog.',
        now()
    );
INSERT INTO medisch_specialisme
VALUES (
        'KIN',
        'Kinderarts',
        'Voltooide opleiding tot kinderarts.',
        now()
    );
COMMIT;
INSERT INTO medisch_specialisme
VALUES (
        'CH4',
        'Buikchirurg',
        'Voltooide opleiding tot buikchirurg.',
        now()
    );
INSERT INTO medisch_specialisme
VALUES (
        'VPK1',
        'Verpleegkundige 1',
        'Voltooide opleiding tot basis verpleegkundige.',
        now()
    );
INSERT INTO medisch_specialisme
VALUES (
        'VPK2',
        'Verpleegkundige 2',
        'Voltooide opleiding tot verpleegkundige 1.',
        now()
    );
INSERT INTO medisch_specialisme
VALUES (
        'VPK3',
        'Verpleegkundige 3',
        'Voltooide opleiding tot verpleegkundige.2',
        now()
    );
INSERT INTO medisch_specialisme
VALUES (
        'RA2',
        'Radiologisch technicus',
        'Voltooide opleiding tot radiologisch technicus.',
        now()
    );
COMMIT;
-- Vullen van de tabel personeel_medspec - 21 rijen 
INSERT INTO personeel_medspec
VALUES ('23232', 'AAS', '04-DEC-97', now());
INSERT INTO personeel_medspec
VALUES ('23244', 'RAD', '04-MAY-92', now());
INSERT INTO personeel_medspec
VALUES ('10044', 'AAS', '04-DEC-94', now());
INSERT INTO personeel_medspec
VALUES ('23100', 'RAD', '11-AUG-87', now());
INSERT INTO personeel_medspec
VALUES ('01885', 'AAS', '12-FEB-87', now());
COMMIT;
INSERT INTO personeel_medspec
VALUES ('66425', 'CAR', '25-MAY-92', now());
INSERT INTO personeel_medspec
VALUES ('66427', 'AAS', '04-DEC-79', now());
INSERT INTO personeel_medspec
VALUES ('66432', 'ONC', '04-JAN-83', now());
INSERT INTO personeel_medspec
VALUES ('66532', 'VPK3', '06-DEC-95', now());
INSERT INTO personeel_medspec
VALUES ('67555', 'VPK1', '04-FEB-92', now());
COMMIT;
INSERT INTO personeel_medspec
VALUES ('67585', 'VPK2', '22-MAR-98', now());
INSERT INTO personeel_medspec
VALUES ('67666', 'VPK2', '15-DEC-95', now());
INSERT INTO personeel_medspec
VALUES ('66444', 'VPK1', '08-MAR-88', now());
INSERT INTO personeel_medspec
VALUES ('88101', 'CH1', '02-NOV-80', now());
INSERT INTO personeel_medspec
VALUES ('88202', 'CH4', '04-DEC-82', now());
COMMIT;
INSERT INTO personeel_medspec
VALUES ('88303', 'CH2', '02-DEC-89', now());
INSERT INTO personeel_medspec
VALUES ('88404', 'CH3', '12-MAY-95', now());
INSERT INTO personeel_medspec
VALUES ('88505', 'CH2', '22-AUG-96', now());
INSERT INTO personeel_medspec
VALUES ('88777', 'RA2', '04-DEC-88', now());
INSERT INTO personeel_medspec
VALUES ('23232', 'CH2', '04-DEC-99', now());
INSERT INTO personeel_medspec
VALUES ('10044', 'CH2', '15-DEC-97', now());
COMMIT;
-- Vullen van de tabel verrichting_categorie - 9 rijen 
INSERT INTO verrichting_cat
VALUES ('BU1', 'Bureaudiensten', now());
INSERT INTO verrichting_cat
VALUES ('GYN', 'Gynaecologie', now());
INSERT INTO verrichting_cat
VALUES ('CHI', 'Chirurgie', now());
INSERT INTO verrichting_cat
VALUES ('LA1', 'Laboratorium 1', now());
INSERT INTO verrichting_cat
VALUES ('LA2', 'Laboratorium 2', now());
COMMIT;
INSERT INTO verrichting_cat
VALUES ('ALG', 'Procedures-algemeen', now());
INSERT INTO verrichting_cat
VALUES ('RAD', 'Radiologie', now());
INSERT INTO verrichting_cat
VALUES ('INJ', 'Injecties', now());
INSERT INTO verrichting_cat
VALUES ('CAR', 'Cardiologie', now());
COMMIT;
-- Vullen van de tabel verrichting - 105 rijen 
INSERT INTO verrichting
VALUES (
        '36415',
        'Bloedafname',
        35.55,
        'Kantoor- of bedprocedure',
        'LA1',
        now()
    );
INSERT INTO verrichting
VALUES (
        '82947',
        'Bloedsuiker',
        20.40,
        'Kantoor- of bedprocedure',
        'LA1',
        now()
    );
INSERT INTO verrichting
VALUES (
        '85018',
        'Hemoglobine',
        25.00,
        'Kantoor- of bedprocedure',
        'LA1',
        now()
    );
INSERT INTO verrichting
VALUES (
        '82270',
        'Hemocultuur',
        15.40,
        'Kantoor- of bedprocedure',
        'LA1',
        now()
    );
INSERT INTO verrichting
VALUES (
        '87220',
        'KOH',
        15.00,
        'Kantoor- of bedprocedure',
        'LA1',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '81025',
        'Prognose, urine',
        12.00,
        'Kantoor- of bedprocedure',
        'LA1',
        now()
    );
INSERT INTO verrichting
VALUES (
        '87430',
        'Streptokokkentest',
        13.50,
        'Kantoor- of bedprocedure',
        'LA1',
        now()
    );
INSERT INTO verrichting
VALUES (
        '81002',
        'Urine/dip',
        10.75,
        'Kantoor- of bedprocedure',
        'LA1',
        now()
    );
INSERT INTO verrichting
VALUES (
        '81000',
        'Urine/microsc.',
        12.90,
        'Kantoor- of bedprocedure',
        'LA1',
        now()
    );
INSERT INTO verrichting
VALUES (
        '99000',
        'Speciale behandling',
        35.75,
        'Kantoor- of bedprocedure',
        'LA1',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '87210',
        'Uitstrijkje',
        15.00,
        'Kantoor- of bedprocedure',
        'LA1',
        now()
    );
INSERT INTO verrichting
VALUES (
        '99201',
        'Probleem, specifiek',
        55.00,
        'Kantoordiensten',
        'LA1',
        now()
    );
INSERT INTO verrichting
VALUES (
        '99202',
        'Probleem, niet-specifiek',
        75.00,
        'Kantoordiensten',
        'LA1',
        now()
    );
INSERT INTO verrichting
VALUES (
        '99203',
        'Probleem, gedetailleerd',
        95.00,
        'Kantoordiensten',
        'LA1',
        now()
    );
INSERT INTO verrichting
VALUES (
        '99204',
        'Uitgebreid, standaard',
        75.00,
        'Kantoordiensten',
        'LA1',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '99205',
        'Uitgebreid, meer',
        95.00,
        'Kantoordiensten',
        'LA1',
        now()
    );
INSERT INTO verrichting
VALUES (
        '99050',
        'Overuren',
        125.00,
        'Kantoordiensten',
        'LA1',
        now()
    );
INSERT INTO verrichting
VALUES (
        '99058',
        'Spoed',
        155.00,
        'Kantoordiensten',
        'LA1',
        now()
    );
INSERT INTO verrichting
VALUES (
        '46600',
        'Anoscopie',
        21.00,
        'Kantoor- of bedprocedure',
        'ALG',
        now()
    );
INSERT INTO verrichting
VALUES (
        '92551',
        'Gehoortest',
        45.00,
        'Kantoor- of bedprocedure',
        'ALG',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '69210',
        'Cerumen verwijderen',
        35.00,
        'Kantoor- of bedprocedure',
        'ALG',
        now()
    );
INSERT INTO verrichting
VALUES (
        'G0102',
        'DRE',
        30.00,
        'Kantoor- of bedprocedure',
        'ALG',
        now()
    );
INSERT INTO verrichting
VALUES (
        '93000',
        'ECG/Interpreteren',
        85.00,
        'Kantoor- of bedprocedure',
        'CAR',
        now()
    );
INSERT INTO verrichting
VALUES (
        '94010',
        'Spirometrie',
        55.00,
        'Kantoor- of bedprocedure',
        'ALG',
        now()
    );
INSERT INTO verrichting
VALUES (
        '92567',
        'Tympanometrie',
        40.00,
        'Kantoor- of bedprocedure',
        'ALG',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '94664',
        'Ademhalingstest',
        35.00,
        'Kantoor- of bedprocedure',
        'ALG',
        now()
    );
INSERT INTO verrichting
VALUES (
        '94760',
        'Zuurstof',
        25.00,
        'Kantoor- of bedprocedure',
        'ALG',
        now()
    );
INSERT INTO verrichting
VALUES (
        '16020',
        'Brandwondtoilet',
        35.00,
        'Kantoor- of bedprocedure',
        'ALG',
        now()
    );
INSERT INTO verrichting
VALUES (
        '85022',
        'Bloedonderzoek',
        21.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
INSERT INTO verrichting
VALUES (
        '80053',
        'Algeheel onderzoek',
        115.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '80072',
        'Artritisonderzoek (RA, ANA, UA, ESR)',
        75.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
INSERT INTO verrichting
VALUES (
        '80050',
        'Algemene kaart',
        55.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
INSERT INTO verrichting
VALUES (
        '80076',
        'Leverfunctie',
        95.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
INSERT INTO verrichting
VALUES (
        '80048',
        'Algeheel onderzoek, beperkt',
        35.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
INSERT INTO verrichting
VALUES (
        '80061',
        'Lipidekaart',
        45.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '84450',
        'SGOT',
        30.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
INSERT INTO verrichting
VALUES (
        '83036',
        'HGB A1C',
        95.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
INSERT INTO verrichting
VALUES (
        '88142',
        'Uitstrijkje',
        75.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
INSERT INTO verrichting
VALUES (
        '88304',
        'Pathologie-algemeen',
        75.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
INSERT INTO verrichting
VALUES (
        '80055',
        'Prenataalkaart',
        110.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '85610',
        'Protime/INR',
        75.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
INSERT INTO verrichting
VALUES (
        '84152',
        'PSA',
        85.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
INSERT INTO verrichting
VALUES (
        '84443',
        'TSH',
        90.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
INSERT INTO verrichting
VALUES (
        '87060',
        'Speekselkweek',
        45.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
INSERT INTO verrichting
VALUES (
        '87088',
        'Urinekweek',
        45.00,
        'Laboratoriumanalyse',
        'LA2',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '72050',
        'Rugfoto (min. 4 posities)',
        205.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
INSERT INTO verrichting
VALUES (
        '70360',
        'Zacht weefsel nek',
        275.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
INSERT INTO verrichting
VALUES (
        '71020',
        'CXR (2 posities)',
        225.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
INSERT INTO verrichting
VALUES (
        '71010',
        'CXR (1 posities)',
        170.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
INSERT INTO verrichting
VALUES (
        '74000',
        'Buik (NUB)',
        240.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '74020',
        'Buik, obstetrie',
        340.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
INSERT INTO verrichting
VALUES (
        '72110',
        'Lumbaalfoto(5 posities)',
        675.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
INSERT INTO verrichting
VALUES (
        '73000',
        'Sleutelbeen (2 posities)',
        250.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
INSERT INTO verrichting
VALUES (
        '73030',
        'Schouder (min. 2 posities)',
        250.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
INSERT INTO verrichting
VALUES (
        '73070',
        'Elleboog (2 posities)',
        225.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '73110',
        'Pols (min. 3 posities)',
        285.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
INSERT INTO verrichting
VALUES (
        '73130',
        'Hand (3 posities)',
        280.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
INSERT INTO verrichting
VALUES (
        '73140',
        'Vinger (2 posities)',
        225.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
INSERT INTO verrichting
VALUES (
        '73510',
        'Heup (min. 2 posities)',
        275.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
INSERT INTO verrichting
VALUES (
        '73562',
        'Knie (3 posities)',
        325.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '73610',
        'Enkel (3 posities)',
        325.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
INSERT INTO verrichting
VALUES (
        '73630',
        'Voet (3 posities)',
        325.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
INSERT INTO verrichting
VALUES (
        '73650',
        'Hielbeen (min. 2 posities)',
        275.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
INSERT INTO verrichting
VALUES (
        '73660',
        'Teen (min. 2 posities)',
        225.00,
        'Radiologische procedures en analyse',
        'RAD',
        now()
    );
INSERT INTO verrichting
VALUES (
        '95115',
        'Allergie 1',
        25.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '95117',
        'Allergie 2 + integer meer',
        55.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
INSERT INTO verrichting
VALUES (
        'J1055',
        'Depo Provera contraceptiemiddel',
        85.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
INSERT INTO verrichting
VALUES (
        'J1050',
        'Depo Provera hormoontest',
        95.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
INSERT INTO verrichting
VALUES (
        '90700',
        'DPT-AC VFC',
        75.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
INSERT INTO verrichting
VALUES (
        '90721',
        'DPT-AC/HIB',
        75.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '90648',
        'HIB VFC',
        65.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
INSERT INTO verrichting
VALUES (
        '90707',
        'MMR VFC',
        55.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
INSERT INTO verrichting
VALUES (
        '90713',
        'IPV VFC',
        55.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
INSERT INTO verrichting
VALUES (
        '90744',
        'Hep B 0-19 VFC',
        185.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
INSERT INTO verrichting
VALUES (
        '90746',
        'Hep B 20-volwassene',
        195.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '90718',
        'dT Volwassenen VFC',
        75.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
INSERT INTO verrichting
VALUES (
        '90716',
        'Varicellavaccinatie VFC',
        65.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
INSERT INTO verrichting
VALUES (
        '90633',
        'Hep A vaccin',
        175.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
INSERT INTO verrichting
VALUES (
        '90657',
        'Fluvax',
        55.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
INSERT INTO verrichting
VALUES (
        '90732',
        'Pneumonievaccin volwassene',
        88.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '90669',
        'Prevnar Pedi',
        92.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
INSERT INTO verrichting
VALUES (
        '90788',
        'Antibioticuminjectie',
        110.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
INSERT INTO verrichting
VALUES (
        '90782',
        'Therapeutische injectie',
        75.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
INSERT INTO verrichting
VALUES (
        '90471',
        'Vaccinatie 1',
        45.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
INSERT INTO verrichting
VALUES (
        '90472',
        'Vaccinatie 2 + integer meer',
        75.00,
        'Injecties aan het bed en tijdens spreekuur',
        'INJ',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '11730',
        'Losgekomen nagel',
        175.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
INSERT INTO verrichting
VALUES (
        '11750',
        'Nagelbedverwonding',
        185.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
INSERT INTO verrichting
VALUES (
        '10060',
        'I en D, eenvoudig',
        258.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
INSERT INTO verrichting
VALUES (
        '10061',
        'I en D. complex',
        320.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
INSERT INTO verrichting
VALUES (
        '10120',
        'Verwijderen F.B.',
        230.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '11056',
        'Hechten huidwond',
        225.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
INSERT INTO verrichting
VALUES (
        '12000',
        'Appendectomie',
        555.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
INSERT INTO verrichting
VALUES (
        '12001',
        'Algemeen thoraxonderzoek',
        6200.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
INSERT INTO verrichting
VALUES (
        '12002',
        'Thorax, longonderzoek',
        6500.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
INSERT INTO verrichting
VALUES (
        '12003',
        'Thorax, hart',
        9500.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '12004',
        'Buik, algemeen',
        6000.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
INSERT INTO verrichting
VALUES (
        '12005',
        'Pancreas',
        6500.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
INSERT INTO verrichting
VALUES (
        '12006',
        'Buik, intestinaal',
        7800.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
INSERT INTO verrichting
VALUES (
        '12007',
        'Craniaal',
        10000.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
INSERT INTO verrichting
VALUES (
        '12008',
        'Nieren',
        7500.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
COMMIT;
INSERT INTO verrichting
VALUES (
        '12009',
        'Lever',
        7800.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
INSERT INTO verrichting
VALUES (
        '12010',
        'Spinaal onderzoek',
        3500.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
INSERT INTO verrichting
VALUES (
        '12011',
        'Hernia',
        3800.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
INSERT INTO verrichting
VALUES (
        '12012',
        'Fractuur, enkelvoudig',
        1500.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
INSERT INTO verrichting
VALUES (
        '12013',
        'Fractuur, complex',
        2500.00,
        'Kleine chirurgische ingrepen',
        'CHI',
        now()
    );
COMMIT;
-- Vullen van de tabel behandeling - 124 rijen 
-- Behandelingen op now() - 29
INSERT INTO behandeling
VALUES (
        1,
        date 'now()' + integer '29',
        '421228',
        '23232',
        '99203',
        75.00,
        'Onderzoek gipsverband.',
        date 'now()' + integer '29'
    );
INSERT INTO behandeling
VALUES (
        2,
        date 'now()' + integer '29',
        '421228',
        '23232',
        '73070',
        250.00,
        'Röntgenfoto rechterarm bij elleboog.',
        date 'now()' + integer '29'
    );
-- Behandelingen op now()
INSERT INTO behandeling
VALUES (
        1,
        now(),
        '100002',
        '01885',
        '94664',
        35.00,
        'Beademingsprocedure uitgevoerd.',
        now()
    );
INSERT INTO behandeling
VALUES (
        2,
        now(),
        '100002',
        '01885',
        '94760',
        30.00,
        'O2 92%.',
        now()
    );
INSERT INTO behandeling
VALUES (
        3,
        now(),
        '100003',
        '23232',
        '99058',
        155.00,
        'Onderzocht op Eerste Hulp - doorverwezen naar Radiologie voor MRI.',
        now()
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        4,
        now(),
        '100003',
        '23100',
        '74000',
        240.00,
        'Onderzoek van de buik wijst op waarschijnlijke blindedarmontsteking.',
        now()
    );
INSERT INTO behandeling
VALUES (
        5,
        now(),
        '100003',
        '88202',
        '12000',
        555.00,
        'Appendectomie uitgevoerd zonder complicaties.',
        now()
    );
INSERT INTO behandeling
VALUES (
        6,
        now(),
        '100025',
        '10044',
        '90782',
        75.00,
        'Injectie toegediend.',
        now()
    );
INSERT INTO behandeling
VALUES (
        7,
        now(),
        '100301',
        '66427',
        '99058',
        155.00,
        'Patiënt met weefselverscheuring opgenomen voor observatie.',
        now()
    );
INSERT INTO behandeling
VALUES (
        8,
        now(),
        '100301',
        '66427',
        '90782',
        75.00,
        'Injectie toegediend.',
        now()
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        9,
        now(),
        '100423',
        '01885',
        '99058',
        155.00,
        'Arts EH bezocht voor mogelijke fractuur - doorverwezen naar Radiologie voor röntgenfoto van enkel.',
        now()
    );
INSERT INTO behandeling
VALUES (
        10,
        now(),
        '100500',
        '66427',
        '99058',
        155.00,
        'Eerste Hulp bezocht wegens ademhalingsproblemen.',
        now()
    );
INSERT INTO behandeling
VALUES (
        11,
        now(),
        '100500',
        '66427',
        '94010',
        55.00,
        'Beademingsprocedure uitgevoerd.',
        now()
    );
INSERT INTO behandeling
VALUES (
        12,
        now(),
        '100500',
        '23100',
        '71020',
        225.00,
        'Röntgenfoto borst gemaakt.',
        now()
    );
INSERT INTO behandeling
VALUES (
        13,
        now(),
        '100500',
        '88101',
        '12002',
        6500.00,
        'Longoperatie uitgevoerd.',
        now()
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        14,
        now(),
        '222001',
        '88202',
        '12009',
        7800.00,
        'Leveroperatie uitgevoerd.',
        now()
    );
INSERT INTO behandeling
VALUES (
        15,
        now(),
        '222006',
        '23232',
        '10060',
        258.00,
        'NG-tube via incisie geplaatst.',
        now()
    );
INSERT INTO behandeling
VALUES (
        16,
        now(),
        '333111',
        '66432',
        '99203',
        95.00,
        'Oncologische test wegens pijn in mond-infectie aangetroffen.',
        now()
    );
INSERT INTO behandeling
VALUES (
        17,
        now(),
        '333111',
        '66444',
        '36415',
        35.55,
        'Bloed afgenomen.',
        now()
    );
INSERT INTO behandeling
VALUES (
        18,
        now(),
        '333111',
        '66444',
        '80050',
        55.00,
        'Algemeen bloedonderzoek uitgevoerd.',
        now()
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        19,
        now(),
        '421221',
        '66532',
        '99058',
        155.00,
        'EH-diagnose spinale meningitis.',
        now()
    );
INSERT INTO behandeling
VALUES (
        20,
        now(),
        '421221',
        '23100',
        '12010',
        1480.00,
        'Rugpunctie uitgevoerd.',
        now()
    );
INSERT INTO behandeling
VALUES (
        21,
        now(),
        '421226',
        '23232',
        '80048',
        35.00,
        'Algeheel onderzoek uitgevoerd.',
        now()
    );
INSERT INTO behandeling
VALUES (
        22,
        now(),
        '421226',
        '66532',
        '36415',
        35.55,
        'Bloed afgenomen.',
        now()
    );
-- Behandelingen op date 'now()' + integer '1'
INSERT INTO behandeling
VALUES (
        1,
        date 'now()' + integer '1',
        '100001',
        '01885',
        '87220',
        15.40,
        'Procedure uitgevoerd zonder complicaties.',
        date 'now()' + integer '1'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        2,
        date 'now()' + integer '1',
        '100025',
        '10044',
        90782,
        45.00,
        'Tweede injectie toegediend.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        3,
        date 'now()' + integer '1',
        '100424',
        '88404',
        '12007',
        8500.00,
        'Craniaalchirurgie uitgevoerd.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        4,
        date 'now()' + integer '1',
        '100424',
        '23100',
        '72050',
        205.00,
        'MRI-resultaten van schedel naar chirurg.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        5,
        date 'now()' + integer '1',
        '100501',
        '66427',
        '99058',
        155.00,
        'EH bezocht wegens mogelijk myocardiaal infarct.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        6,
        date 'now()' + integer '1',
        '100501',
        '66532',
        36415,
        35.55,
        'Bloed afgenomen.',
        date 'now()' + integer '1'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        7,
        date 'now()' + integer '1',
        '100501',
        '66532',
        '85022',
        21.00,
        'Analyse bloedgassen.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        8,
        date 'now()' + integer '1',
        '100501',
        '66532',
        '94760',
        25.00,
        'O2 - 93%.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        9,
        date 'now()' + integer '1',
        '100025',
        '10044',
        90782,
        95.00,
        'Valiuminjectie toegediend.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        10,
        date 'now()' + integer '1',
        '222002',
        '23232',
        '99202',
        75.00,
        'Oogonderzoek uitgevoerd.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        11,
        date 'now()' + integer '1',
        '555005',
        '67585',
        'G0102',
        30.00,
        'DRE-controle foleycatheter.',
        date 'now()' + integer '1'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        12,
        date 'now()' + integer '1',
        '333112',
        '10044',
        '10061',
        320.00,
        'Incisie voor lipideinfuus aangebracht.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        13,
        date 'now()' + integer '1',
        '333112',
        '66444',
        '90788',
        110.00,
        'IV-insertie na chirurgie.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        14,
        date 'now()' + integer '1',
        '333114',
        '66444',
        '90788',
        110.00,
        'Nieuwe IV-insertie (verplaatsing).',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        15,
        date 'now()' + integer '1',
        '333114',
        '66444',
        36415,
        35.55,
        'Bloed afgenomen.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        16,
        date 'now()' + integer '1',
        '333114',
        '23232',
        '87220',
        45.00,
        'KOH-test uitgevoerd.',
        date 'now()' + integer '1'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        17,
        date 'now()' + integer '1',
        '333116',
        '67555',
        '90788',
        135.00,
        'Oncovin IV toegediend.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        18,
        date 'now()' + integer '1',
        '333116',
        '66432',
        '99203',
        95.00,
        'Oncologie onderzoek - behandeling leukemie voltooid.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        19,
        date 'now()' + integer '1',
        '333116',
        '67555',
        36415,
        35.55,
        'Bloed afgenomen.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        20,
        date 'now()' + integer '1',
        '333116',
        '67555',
        '87220',
        45.00,
        'Witte bloedcellen toegediend.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        21,
        date 'now()' + integer '1',
        '666118',
        '66432',
        '90788',
        110.00,
        'IV-plek opnieuw geplaatst.',
        date 'now()' + integer '1'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        22,
        date 'now()' + integer '1',
        '666118',
        '66432',
        '80053',
        115.00,
        'Compleet algemeen onderzoek uitgevoerd.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        23,
        date 'now()' + integer '1',
        '666120',
        '01885',
        '93000',
        85.00,
        'ECG gemaakt.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        24,
        date 'now()' + integer '1',
        '666120',
        '01885',
        '94760',
        25.00,
        'O2 - 94%.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        25,
        date 'now()' + integer '1',
        '100025',
        '10044',
        90782,
        75.00,
        'Valiuminjectie toegediend.',
        date 'now()' + integer '1'
    );
INSERT INTO behandeling
VALUES (
        26,
        date 'now()' + integer '1',
        '666121',
        '88202',
        '12005',
        6500.00,
        'Pancreasoperatie uitgevoerd.',
        date 'now()' + integer '1'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        27,
        date 'now()' + integer '1',
        '421226',
        '66532',
        '90788',
        140.00,
        'Tylenol IV toegediend.',
        date 'now()' + integer '1'
    );
-- Behandelingen op date 'now()' + integer '2'
INSERT INTO behandeling
VALUES (
        1,
        date 'now()' + integer '2',
        '100024',
        '66444',
        36415,
        35.55,
        'Bloed afgenomen.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        2,
        date 'now()' + integer '2',
        '100024',
        '10044',
        '82947',
        20.40,
        'Glucosespiegel normaal.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        3,
        date 'now()' + integer '2',
        '100029',
        '88101',
        '99205',
        125.00,
        'Chirurgisch consult.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        4,
        date 'now()' + integer '2',
        '100030',
        '66432',
        '99205',
        125.00,
        'Oncologisch consult.',
        date 'now()' + integer '2'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        5,
        date 'now()' + integer '2',
        '100030',
        '67555',
        '36415',
        35.55,
        'Bloedafname.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        6,
        date 'now()' + integer '2',
        '100030',
        '66432',
        '80050',
        55.00,
        'Algemeen onderzoek uitgevoerd-resultaten doorgestuurd naar eigen arts.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        7,
        date 'now()' + integer '2',
        '100305',
        '66425',
        '93000',
        85.00,
        'ECG laat periodieke afwijkingen van de sinus zien voorafgaand aan tachycardie.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        8,
        date 'now()' + integer '2',
        '100305',
        '66425',
        '90782',
        110.00,
        'Valium IV toegediend',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        9,
        date 'now()' + integer '2',
        '100306',
        '67555',
        '99201',
        55.00,
        'NG-tube geplaatst',
        date 'now()' + integer '2'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        10,
        date 'now()' + integer '2',
        '100306',
        '10044',
        '12001',
        6200.00,
        'Thoraxonderzoek uitgevoerd.  Nieuwe afspraak maken voor longoperatie.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        11,
        date 'now()' + integer '2',
        '100422',
        '66427',
        '99058',
        150.00,
        'EH-weefselverscheuring-zie röntgenfoto.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        12,
        date 'now()' + integer '2',
        '100422',
        '23100',
        '73110',
        285.00,
        'EH-weefselverscheuring-zie röntgenfoto.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        13,
        date 'now()' + integer '2',
        '100422',
        '66444',
        90782,
        110.00,
        'Pijnstillende injectie toegediend.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        14,
        date 'now()' + integer '2',
        '100506',
        '01885',
        '99203',
        95.00,
        'Buik onderzocht wegens pijnklachten - negatief.',
        date 'now()' + integer '2'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        15,
        date 'now()' + integer '2',
        '100506',
        '67555',
        '90782',
        75.00,
        'Demerol injectie toegediend.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        16,
        date 'now()' + integer '2',
        '333110',
        '66444',
        '90788',
        110.00,
        'Antibioticum IV toegediend.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        17,
        date 'now()' + integer '2',
        '333113',
        '66444',
        '90788',
        110.00,
        'Antibioticum IV toegediend.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        18,
        date 'now()' + integer '2',
        '333113',
        '23232',
        '99201',
        55.00,
        'Fysiek onderzoek uitgevoerd om oorzaak van buikloop te achterhalen.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        19,
        date 'now()' + integer '2',
        '333115',
        '66432',
        '99203',
        95.00,
        'Oncologie onderzoek- gewichtsverlies/ontsteking van het mondslijmvlies.',
        date 'now()' + integer '2'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        20,
        date 'now()' + integer '2',
        '666119',
        '23232',
        '99058',
        155.00,
        'EH - terminaal stadium van levercarcinoom.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        21,
        date 'now()' + integer '2',
        '666119',
        '66432',
        '99203',
        75.00,
        'Oncologisch onderzoek.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        22,
        date 'now()' + integer '2',
        '666119',
        '66432',
        '90782',
        125.00,
        'Morfinedrip toegediend tegen pijn.',
        date 'now()' + integer '2'
    );
INSERT INTO behandeling
VALUES (
        23,
        date 'now()' + integer '2',
        '421227',
        '66532',
        '90782',
        115.00,
        'Heparintoevoer geplaatst in rechterhand.',
        date 'now()' + integer '2'
    );
-- Behandelingen op date 'now()' + integer '3'
INSERT INTO behandeling
VALUES (
        1,
        date 'now()' + integer '3',
        '100425',
        '66427',
        '99058',
        175.00,
        'Eerste Hulp-screening.',
        date 'now()' + integer '3'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        2,
        date 'now()' + integer '3',
        '100425',
        '67555',
        90782,
        75.00,
        'Pijnstillende injectie toegediend.',
        date 'now()' + integer '3'
    );
INSERT INTO behandeling
VALUES (
        3,
        date 'now()' + integer '3',
        '100502',
        '66532',
        '99058',
        155.00,
        'EH bezocht wegens mogelijke diabetesshock.',
        date 'now()' + integer '3'
    );
INSERT INTO behandeling
VALUES (
        4,
        date 'now()' + integer '3',
        '100502',
        '66532',
        80050,
        75.00,
        'Algemeen bloedonderzoek uitgevoerd.',
        date 'now()' + integer '3'
    );
INSERT INTO behandeling
VALUES (
        5,
        date 'now()' + integer '3',
        '100502',
        '66532',
        36415,
        35.55,
        'Bloed afgenomen.',
        date 'now()' + integer '3'
    );
INSERT INTO behandeling
VALUES (
        6,
        date 'now()' + integer '3',
        '100503',
        '01885',
        '99058',
        155.00,
        'EH-screening na periode van tachycardie.',
        date 'now()' + integer '3'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        7,
        date 'now()' + integer '3',
        '100503',
        '01885',
        '93000',
        85.00,
        'ECG gemaakt.',
        date 'now()' + integer '3'
    );
INSERT INTO behandeling
VALUES (
        8,
        date 'now()' + integer '3',
        '555003',
        '01885',
        '99058',
        155.00,
        'EH-screening vanwege letsel aan linkerbeen.',
        date 'now()' + integer '3'
    );
INSERT INTO behandeling
VALUES (
        9,
        date 'now()' + integer '3',
        '555003',
        '23232',
        '73510',
        275.00,
        'Röntgenfoto heup gemaakt.',
        date 'now()' + integer '3'
    );
INSERT INTO behandeling
VALUES (
        10,
        date 'now()' + integer '3',
        '333117',
        '10044',
        '10061',
        325.00,
        'I en D voor lipide-infuus uitgevoerd.',
        date 'now()' + integer '3'
    );
INSERT INTO behandeling
VALUES (
        11,
        date 'now()' + integer '3',
        '333117',
        '66432',
        '90788',
        110.00,
        'IV-plek opnieuw geplaatst.',
        date 'now()' + integer '3'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        12,
        date 'now()' + integer '3',
        '666117',
        '10044',
        '10061',
        325.00,
        'I en D voor lipide-infuus uitgevoerd.',
        date 'now()' + integer '3'
    );
INSERT INTO behandeling
VALUES (
        13,
        date 'now()' + integer '3',
        '666117',
        '66432',
        '90788',
        110.00,
        'IV-plek opnieuw geplaatst.',
        date 'now()' + integer '3'
    );
INSERT INTO behandeling
VALUES (
        14,
        date 'now()' + integer '3',
        '666121',
        '66532',
        '90782',
        75.00,
        'Demerolinjectie tegen pijn toegediend.',
        date 'now()' + integer '3'
    );
INSERT INTO behandeling
VALUES (
        15,
        date 'now()' + integer '3',
        '421222',
        '23100',
        '73070',
        250.00,
        'Röntgenfoto rechterelleboog gemaakt.',
        date 'now()' + integer '3'
    );
INSERT INTO behandeling
VALUES (
        16,
        date 'now()' + integer '3',
        '421222',
        '67555',
        '90782',
        75.00,
        'Demerolinjectie tegen pijn toegediend.',
        date 'now()' + integer '3'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        17,
        date 'now()' + integer '3',
        '421223',
        '66532',
        '90788',
        145.00,
        'IV voor factor III gestart.',
        date 'now()' + integer '3'
    );
INSERT INTO behandeling
VALUES (
        18,
        date 'now()' + integer '3',
        '421224',
        '66427',
        36415,
        35.55,
        'Bloed afgenomen.',
        date 'now()' + integer '3'
    );
INSERT INTO behandeling
VALUES (
        19,
        date 'now()' + integer '3',
        '421224',
        '66427',
        '85018',
        25.00,
        'Hemoglobine.',
        date 'now()' + integer '3'
    );
INSERT INTO behandeling
VALUES (
        20,
        date 'now()' + integer '3',
        '421225',
        '23232',
        '99202',
        75.00,
        'Kleuter onderzocht ivm lethargie.',
        date 'now()' + integer '3'
    );
-- Behandelingen op date 'now()' + integer '4'
INSERT INTO behandeling
VALUES (
        1,
        date 'now()' + integer '4',
        '100031',
        '88202',
        '12000',
        600.00,
        'Appendectomie uitgevoerd.',
        date 'now()' + integer '4'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        2,
        date 'now()' + integer '4',
        '100051',
        '23232',
        '99202',
        75.00,
        'Onderzoek na beroerte.',
        date 'now()' + integer '4'
    );
INSERT INTO behandeling
VALUES (
        3,
        date 'now()' + integer '4',
        '421225',
        '23232',
        '90788',
        140.00,
        'IV in scalpvene voor D5NS gestart.',
        date 'now()' + integer '4'
    );
-- Behandelingen op date 'now()' + integer '5'
INSERT INTO behandeling
VALUES (
        1,
        date 'now()' + integer '5',
        '100027',
        '10044',
        '99058',
        155.00,
        'Gezien op EH. Doorverwezen naar Radiologie voor MRI linkerbeen.',
        date 'now()' + integer '5'
    );
INSERT INTO behandeling
VALUES (
        2,
        date 'now()' + integer '5',
        '100027',
        '23244',
        '73562',
        325.00,
        'Röntgenfoto enkel negatief.',
        date 'now()' + integer '5'
    );
INSERT INTO behandeling
VALUES (
        3,
        date 'now()' + integer '5',
        '100027',
        '23244',
        '73610',
        325.00,
        'Röntgenfoto toont fractuur boven linkerknie in dijbeen.',
        date 'now()' + integer '5'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        4,
        date 'now()' + integer '5',
        '100027',
        '66444',
        90782,
        75.00,
        'Injectie toegediend.',
        date 'now()' + integer '5'
    );
INSERT INTO behandeling
VALUES (
        5,
        date 'now()' + integer '5',
        '100504',
        '66532',
        '99058',
        155.00,
        'EH-onderzoek na periode van tachycardie.',
        date 'now()' + integer '5'
    );
INSERT INTO behandeling
VALUES (
        6,
        date 'now()' + integer '5',
        '100504',
        '66532',
        '94760',
        25.00,
        'Zuurstof toegediend - 93%.',
        date 'now()' + integer '5'
    );
INSERT INTO behandeling
VALUES (
        7,
        date 'now()' + integer '5',
        '100025',
        '10044',
        90782,
        95.00,
        'Valiuminjectie toegediend.',
        date 'now()' + integer '5'
    );
INSERT INTO behandeling
VALUES (
        8,
        date 'now()' + integer '5',
        '100504',
        '66532',
        '93000',
        85.00,
        'ECG gemaakt.',
        date 'now()' + integer '5'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        9,
        date 'now()' + integer '5',
        '555004',
        '01885',
        '99058',
        435.00,
        'Plaatsen tube in borst op EH.',
        date 'now()' + integer '5'
    );
-- Behandelingen op date 'now()' + integer '6'
INSERT INTO behandeling
VALUES (
        1,
        date 'now()' + integer '11',
        '100028',
        '67555',
        90782,
        75.00,
        'Injectie toegediend.',
        date 'now()' + integer '11'
    );
INSERT INTO behandeling
VALUES (
        2,
        date 'now()' + integer '6',
        '100304',
        '66427',
        '90788',
        110.00,
        'Antibiotica-injectie toegediend.',
        date 'now()' + integer '6'
    );
INSERT INTO behandeling
VALUES (
        3,
        date 'now()' + integer '6',
        '100304',
        '88101',
        '12001',
        450.00,
        'Thoraxonderzoek om steekwond te repareren en tube in borst ingebracht.',
        date 'now()' + integer '6'
    );
INSERT INTO behandeling
VALUES (
        4,
        date 'now()' + integer '6',
        '100304',
        '66427',
        '90716',
        50.00,
        'Algemeen pathologisch rapport negatief.',
        date 'now()' + integer '6'
    );
COMMIT;
-- Behandelingen op date 'now()' + integer '7'
INSERT INTO behandeling
VALUES (
        1,
        date 'now()' + integer '7',
        '100505',
        '01885',
        '99058',
        155.00,
        'EH-screening voor pijn in rechterarm en splinter onder vierde digit.',
        date 'now()' + integer '7'
    );
INSERT INTO behandeling
VALUES (
        2,
        date 'now()' + integer '7',
        '100025',
        '10044',
        90782,
        70.00,
        'Injectie Demerol toegediend.',
        date 'now()' + integer '7'
    );
INSERT INTO behandeling
VALUES (
        3,
        date 'now()' + integer '7',
        '100505',
        '01885',
        '99201',
        75.00,
        'Splinter verwijderd en wond verbonden.',
        date 'now()' + integer '7'
    );
-- Behandelingen op date 'now()' + integer '10'
INSERT INTO behandeling
VALUES (
        1,
        date 'now()' + integer '10',
        '100026',
        '67555',
        90716,
        65.00,
        'Injectie toegediend.',
        date 'now()' + integer '10'
    );
-- Behandelingen op date 'now()' + integer '11'
INSERT INTO behandeling
VALUES (
        2,
        date 'now()' + integer '10',
        '100026',
        '66444',
        90716,
        65.00,
        'Injectie toegediend.',
        date 'now()' + integer '10'
    );
COMMIT;
-- Behandelingen op date 'now()' + integer '12'
INSERT INTO behandeling
VALUES (
        1,
        date 'now()' + integer '12',
        '100303',
        '88777',
        '93000',
        85.00,
        'ECG normaal gemaakt.',
        date 'now()' + integer '12'
    );
INSERT INTO behandeling
VALUES (
        2,
        date 'now()' + integer '11',
        '100303',
        '66444',
        90716,
        65.00,
        'Injectie toegediend.',
        date 'now()' + integer '11'
    );
INSERT INTO behandeling
VALUES (
        3,
        date 'now()' + integer '12',
        '100303',
        '23100',
        '72050',
        205.00,
        'Röntgenfoto wervelkolom toont geen letselschade.',
        date 'now()' + integer '12'
    );
INSERT INTO behandeling
VALUES (
        4,
        date 'now()' + integer '12',
        '100303',
        '23100',
        '70360',
        275.00,
        'Röntgenfoto zacht weefsel toont geen letselschade.',
        date 'now()' + integer '12'
    );
-- Behandelingen op date 'now()' + integer '14'
INSERT INTO behandeling
VALUES (
        1,
        date 'now()' + integer '14',
        '100302',
        '66427',
        '99058',
        155.00,
        'Gezien op EH-opgenomen voor bevalling.',
        date 'now()' + integer '14'
    );
COMMIT;
INSERT INTO behandeling
VALUES (
        2,
        date 'now()' + integer '14',
        '100302',
        '67585',
        '99201',
        55.00,
        'Ontsluiting gecontroleerd.',
        date 'now()' + integer '14'
    );
INSERT INTO behandeling
VALUES (
        3,
        date 'now()' + integer '14',
        '100302',
        '67585',
        '94760',
        25.00,
        'Saturatie gecontroleerd-98%.',
        date 'now()' + integer '14'
    );
INSERT INTO behandeling
VALUES (
        4,
        date 'now()' + integer '14',
        '100302',
        '66444',
        '36415',
        35.55,
        'Bloedafname.',
        date 'now()' + integer '14'
    );
INSERT INTO behandeling
VALUES (
        5,
        date 'now()' + integer '14',
        '100302',
        '67585',
        '80050',
        55.00,
        'Algemeen onderzoek uitgevoerd - resultaat negatief.',
        date 'now()' + integer '14'
    );
COMMIT;
-- Vullen van de tabel medicijn - 20 rijen
INSERT INTO medicijn
VALUES (
        9999001,
        'Promethazine',
        'Fenegran',
        '25-50 mg IM of IV elke 4 uur.',
        'Voor misselijkheid/braken, toepasbaar in combinatie met verdovend middel.',
        1200,
        'milligram',
        now()
    );
INSERT INTO medicijn
VALUES (
        9999002,
        'Meperidine',
        'Demerol',
        '25-100 mg (dosering voor volwassene) IM of IV elke 4 uur.',
        'Pijnstillend - verdovend.',
        14000,
        'milligram',
        now()
    );
INSERT INTO medicijn
VALUES (
        9999003,
        'Diazepam',
        'Valium',
        '2-10 mg oraal 2 tot 4 maal daags.',
        'Kalmerend.',
        36000,
        'milligram',
        now()
    );
INSERT INTO medicijn
VALUES (
        9999004,
        'Flurazepam',
        'Dalmane',
        '15-30 mg bij het slapengaan.  oraal.',
        'Hypnotisch als slaapmiddel.',
        855,
        'milligram',
        now()
    );
INSERT INTO medicijn
VALUES (
        9999005,
        'Kaliumpenicillin V',
        'P en VK',
        '125-500 mg oraal elke 4 - 6 uur.',
        'Antibioticum.',
        34365,
        'milligram',
        now()
    );
COMMIT;
INSERT INTO medicijn
VALUES (
        9999006,
        'Ampicilline',
        'Ampicilline',
        '250-500 mg (dosering voor volwassene).  IV elke 6 uur.',
        'Antibioticum.',
        16550,
        'milligram',
        now()
    );
INSERT INTO medicijn
VALUES (
        9999007,
        'Hydroxyzine',
        'Atarax',
        '10, 25, 50, 100 mg (volwassene).  oraal elke 4 uur.  orale suspensie (oudere kinderen) - 25 mg / 5 cc. oraal.',
        'Antihistaminicum en sedativum.',
        855,
        'mg/cc',
        now()
    );
INSERT INTO medicijn
VALUES (
        9999008,
        'Cyclobenzaprine',
        'Flexeril',
        '10 mg. elke 6 uur.',
        'Spierverslappend.',
        1450,
        'milligram',
        now()
    );
INSERT INTO medicijn
VALUES (
        9999009,
        'Nitrofurantoin',
        'Macradantine',
        '100 mg oraal 4 maal daags.',
        'Urinair antisepticum.',
        5435,
        'milligram',
        now()
    );
INSERT INTO medicijn
VALUES (
        9999010,
        'Chloorpropamide',
        'Diabinese',
        '100-500 mg  oraal 1 maal daags.',
        'Oraal antidiabeticum.',
        23500,
        'milligram',
        now()
    );
COMMIT;
INSERT INTO medicijn
VALUES (
        9999011,
        'Chloorthiazide',
        'Diuril',
        '0,5-2,0 g Een of tweemaal per dag gedurende 1 dag.',
        'Diureticum (plaspil).',
        1830,
        'g',
        now()
    );
INSERT INTO medicijn
VALUES (
        9999012,
        'Digoxine',
        'Lanoxine',
        '0,5-1,5 mg (volwassene).  oraal eenmaal per dag.',
        'Verbetert de hartefficiency.',
        1525,
        'g',
        now()
    );
INSERT INTO medicijn
VALUES (
        9999013,
        'Metaproterenol',
        'Alupent',
        '20 mg (dosering voor volwassene).  oraal 3 maal daags.',
        'Voor astma-ontspant de bronchiale spier.',
        7210,
        'milligram',
        now()
    );
INSERT INTO medicijn
VALUES (
        9999014,
        'Clindamycine',
        'Cleocine',
        '150-450 mg oraal elke 6 uur (volwassene).  Tot 600 mg IM of IV elke 6 uur bij ernstige ziekteverschijnselen.',
        'IM- of IV-antibioticum.',
        8775,
        'milligram',
        now()
    );
INSERT INTO medicijn
VALUES (
        9999015,
        'Nystatine',
        'Nystatine',
        '400-600 eenheden/kg 4 maal daags oraal voor volwassene.  250-500 eenheden/kg 4 maal daags voor peuters ouder dan 3 maanden. 100 eenheden/kg 4 maal daags voor neonaten.',
        'Antifungisch voor orale infecties en intestinale problemen',
        8775,
        'Eenheid per kilo',
        now()
    );
COMMIT;
INSERT INTO medicijn
VALUES (
        9999016,
        'Cimetidine',
        'Tagamet',
        '300 mg oraal 4 maal daags tijdens maaltijd (volwassenen en kinderen)',
        'Voor gasafscheiding-opgeblazen gevoel.',
        72050,
        'milligram',
        now()
    );
INSERT INTO medicijn
VALUES (
        9999017,
        'Ceftriaxone-Na',
        'Rocefin',
        '1 - 2 g per dag IM of IV (volwassene) - 50-75 mg per 12 uur (kind).',
        'Breedspectrum antibioticum.',
        4255,
        'g',
        now()
    );
INSERT INTO medicijn
VALUES (
        9999018,
        'Mupirocine',
        'Bactroban Ung. zalf',
        '3 maal daags kleine hoeveelheid plaatselijk op aangedaan gebied aanbrengen.',
        'Plaatselijk infectieremmend middel voor kinderen tegen impetigo.',
        367,
        'tube',
        now()
    );
INSERT INTO medicijn
VALUES (
        9999019,
        'Ibuprofen',
        'Motrin',
        '200-800 mg 4 maal daags (volwassene).',
        'Ontstekingsremmend.',
        72050,
        'milligram',
        now()
    );
INSERT INTO medicijn
VALUES (
        9999020,
        'Glycerine',
        'Glycerol',
        '3 g zetpil of  5 - 15 ml klysma (volwassenen en kinderen ouder dan 6 jaar).  1 - 1,5 g zetpil of  2 - 5 ml klysma (kinderen tot 6 jaar).',
        'Bij constipatie.',
        1452,
        'g of ml',
        now()
    );
COMMIT;
-- Vullen van de tabel recept - 25 rijen 
INSERT INTO recept
VALUES (
        755444001,
        now(),
        '9999001',
        '222001',
        '88202',
        '200 mg 4 maal daags.',
        'Innemen na maaltijd of voor het slapen.',
        now()
    );
INSERT INTO recept
VALUES (
        755444011,
        now(),
        '9999002',
        '421228',
        '23232',
        '100 mg IV 4 maal daags.',
        NULL,
        now()
    );
INSERT INTO recept
VALUES (
        755444014,
        now(),
        '9999019',
        '100301',
        '66427',
        '800 mg tabletten 3 maal daags.',
        'Innemen na de maaltijden.',
        now()
    );
INSERT INTO recept
VALUES (
        755444017,
        now(),
        '9999002',
        '100500',
        '88101',
        '100 mg IV.',
        'Toedienen naar behoefte tegen de pijn.',
        now()
    );
INSERT INTO recept
VALUES (
        755444020,
        now(),
        '9999017',
        '421221',
        '10044',
        '2 g dagelijks IV.',
        NULL,
        now()
    );
COMMIT;
INSERT INTO recept
VALUES (
        755445301,
        date 'now()' + integer '1',
        '9999017',
        '100424',
        '88404',
        '2 g dagelijks IV.',
        NULL,
        now()
    );
INSERT INTO recept
VALUES (
        755445302,
        date 'now()' + integer '1',
        '9999003',
        '100501',
        '66532',
        '8 mg oraal 4 maal daags.',
        'Niet doorgaan als patiënt negatief reageert.',
        date 'now()' + integer '1'
    );
INSERT INTO recept
VALUES (
        755445305,
        date 'now()' + integer '1',
        '9999001',
        '333112',
        '10044',
        '50 mg IV elke 4 uur.',
        'Niet in combinatie met ander narcoticum.',
        date 'now()' + integer '1'
    );
INSERT INTO recept
VALUES (
        755445308,
        date 'now()' + integer '1',
        '9999006',
        '666118',
        '66432',
        '400 mg IV elke 6 uur.',
        NULL,
        date 'now()' + integer '1'
    );
INSERT INTO recept
VALUES (
        755445311,
        date 'now()' + integer '1',
        '9999003',
        '666120',
        '01885',
        '10 mg oraal 4 maal daags.',
        'Niet doorgaan als patiënt negatief reageert.',
        date 'now()' + integer '1'
    );
COMMIT;
INSERT INTO recept
VALUES (
        755445445,
        date 'now()' + integer '2',
        '9999012',
        '100305',
        '66425',
        '1.0 mg 1 maal per dag.',
        'Contra-indicatie voor Flexeril.',
        date 'now()' + integer '2'
    );
INSERT INTO recept
VALUES (
        755445446,
        date 'now()' + integer '2',
        '9999003',
        '100305',
        '66425',
        '6 mg oraal 4 maal daags.',
        'Niet doorgaan als patiënt negatief reageert.',
        date 'now()' + integer '2'
    );
INSERT INTO recept
VALUES (
        755445448,
        date 'now()' + integer '2',
        '9999002',
        '100422',
        '23100',
        '75 mg IM elke 4 uur.',
        'Niet in combinatie met ander narcoticum.',
        date 'now()' + integer '2'
    );
INSERT INTO recept
VALUES (
        755445551,
        date 'now()' + integer '2',
        '9999017',
        '333110',
        '23232',
        '2 g. IV dagelijks.',
        NULL,
        date 'now()' + integer '2'
    );
INSERT INTO recept
VALUES (
        755445553,
        date 'now()' + integer '2',
        '9999001',
        '333115',
        '66432',
        '50 mg IV elke 4 uur.',
        'Kan gebruikt worden in combinatie met ander narcoticum.',
        date 'now()' + integer '2'
    );
COMMIT;
INSERT INTO recept
VALUES (
        755445554,
        date 'now()' + integer '3',
        '9999012',
        '100503',
        '01885',
        '1.5 mg oraal 1 maal daags.',
        'Niet doorgaan na 4 dagen of bij ontslag uit ziekenhuis.',
        date 'now()' + integer '3'
    );
INSERT INTO recept
VALUES (
        755445555,
        date 'now()' + integer '3',
        '9999006',
        '333117',
        '10044',
        '300 mg IV elke 6 uur.',
        'IV gedurende 5 dagen.',
        date 'now()' + integer '3'
    );
INSERT INTO recept
VALUES (
        755445558,
        date 'now()' + integer '3',
        '9999006',
        '421225',
        '23232',
        '100 mg IV elke 6 uur.',
        'IV gedurende 3 dagen.',
        date 'now()' + integer '3'
    );
INSERT INTO recept
VALUES (
        755445652,
        date 'now()' + integer '4',
        '9999017',
        '421225',
        '23232',
        '50 mg per 12 uur.',
        'IV gedurende 3 dagen.',
        date 'now()' + integer '4'
    );
INSERT INTO recept
VALUES (
        755445655,
        date 'now()' + integer '6',
        '9999002',
        '100304',
        '66427',
        '50 mg elke 4 uur.',
        'Telkens op een andere plaats injecteren.',
        date 'now()' + integer '6'
    );
COMMIT;
INSERT INTO recept
VALUES (
        755445670,
        date 'now()' + integer '5',
        '9999012',
        '100504',
        '66425',
        '1.0 mg oraal 1 maal daags.',
        NULL,
        date 'now()' + integer '5'
    );
INSERT INTO recept
VALUES (
        755445671,
        date 'now()' + integer '5',
        '9999013',
        '100504',
        '66425',
        '20 mg oraal 3 maal daags.',
        NULL,
        date 'now()' + integer '5'
    );
INSERT INTO recept
VALUES (
        755445667,
        date 'now()' + integer '3',
        '9999012',
        '100502',
        '66532',
        '400 mg oraal 1 maal daags.',
        NULL,
        date 'now()' + integer '3'
    );
INSERT INTO recept
VALUES (
        755445672,
        date 'now()' + integer '12',
        '9999013',
        '100303',
        '66425',
        '20 mg oraal 3 maal daags.',
        'Stoppen na 2 dagen.',
        date 'now()' + integer '12'
    );
INSERT INTO recept
VALUES (
        755445666,
        date 'now()' + integer '2',
        '9999002',
        '100306',
        '10044',
        '100 mg IM elke 4 uur.',
        'Kan gebruikt worden in combinatie met pijnstillers.',
        date 'now()' + integer '2'
    );
COMMIT;
-- Controle van het aantal rijen in de verschillende tabellen.
SELECT COUNT(*) As kamer_telling_61_rijen
FROM kamer;
SELECT COUNT(*) As bed_type_telling_10_rijen
FROM bed_type;
SELECT COUNT(*) As bed_telling_98_rijen
FROM bed;
SELECT COUNT(*) As patient_telling_60_rijen
FROM patient;
SELECT COUNT(*) As patient_not_tel_174_rijen
FROM patient_notitie;
SELECT COUNT(*) As afdeling_telling_18_rijen
FROM zh_afdeling;
SELECT COUNT(*) As personeel_telling_24_rijen
FROM personeel;
SELECT COUNT(*) As medisch_spec_tel_15_rijen
FROM medisch_specialisme;
SELECT COUNT(*) As personeel_medspec_tel_21_rijen
FROM personeel_medspec;
SELECT COUNT(*) As verrichting_cat_tel_9_rijen
FROM verrichting_cat;
SELECT COUNT(*) As verrichting_telling_105_rijen
FROM verrichting;
SELECT COUNT(*) As behandeling_telling_124_rijen
FROM behandeling;
SELECT COUNT(*) As medicijn_telling_20_rijen
FROM medicijn;
SELECT COUNT(*) As recept_telling_25_rijen
FROM recept;