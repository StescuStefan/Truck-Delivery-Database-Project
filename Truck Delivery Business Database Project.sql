DROP TABLE IF EXISTS clienti CASCADE;
DROP TABLE IF EXISTS localizari CASCADE;
DROP TABLE IF EXISTS facturi CASCADE;
DROP TABLE IF EXISTS linii_factura CASCADE;
DROP TABLE IF EXISTS produse CASCADE;
DROP TABLE IF EXISTS incasari CASCADE;
DROP TABLE IF EXISTS avize CASCADE;
DROP TABLE IF EXISTS linii_avize CASCADE;
DROP TABLE IF EXISTS camioane CASCADE;
DROP TABLE IF EXISTS remorci CASCADE;
DROP TABLE IF EXISTS camioane_remorci CASCADE;
DROP TABLE IF EXISTS transportatori CASCADE;
DROP TABLE IF EXISTS alimentari CASCADE;
DROP TABLE IF EXISTS revizii CASCADE;
DROP TABLE IF EXISTS asigurari CASCADE;
DROP TABLE IF EXISTS reparatii CASCADE;
DROP TABLE IF EXISTS schimburi CASCADE;
DROP TABLE IF EXISTS piese CASCADE;
DROP TABLE IF EXISTS incarcari CASCADE;
DROP TABLE IF EXISTS descarcari CASCADE;
DROP TABLE IF EXISTS produse_incarcari CASCADE;
DROP TABLE IF EXISTS trasee CASCADE;
DROP TABLE IF EXISTS statii_traseu CASCADE;
---1 run #2
CREATE TABLE clienti (
	idClient SMALLINT NOT NULL,
	dencl VARCHAR(30) NOT NULL,
	nr_orc VARCHAR(10) NOT NULL,
	iban VARCHAR(15),
	idLocalizare SMALLINT,
	CONSTRAINT pk_clienti PRIMARY KEY (idClient),
	CONSTRAINT fk_clienti_idLocalizare FOREIGN KEY (idLocalizare) REFERENCES localizari(idLocalizare)
);
---2 run #1
CREATE TABLE localizari (
	idLocalizare SMALLINT NOT NULL CONSTRAINT pk_localizare PRIMARY KEY,
		judet VARCHAR(2) NOT NULL,
		tara VARCHAR(2) DEFAULT 'RO',
		strada VARCHAR(20),
		nr SMALLINT,
		CONSTRAINT ck_nr CHECK (nr >= 1),
		localitate VARCHAR(15) NOT NULL
);
---3 run #3
CREATE TABLE facturi (
	idFactura SMALLINT NOT NULL CONSTRAINT pk_facturi PRIMARY KEY,
		scadenta DATE DEFAULT CURRENT_DATE,
		data_intocmire DATE DEFAULT CURRENT_DATE,
		nr SMALLINT ,
		CONSTRAINT ck_nr CHECK (nr >= 1),
		idClient SMALLINT,
		CONSTRAINT fk_facturi_idClient FOREIGN KEY (idClient) REFERENCES clienti(idClient)
);
---4 run #5
CREATE TABLE linii_factura (
    idFactura SMALLINT NOT NULL,
    linii_factura SMALLINT NOT NULL,
    val_incasare INTEGER,
    descriere VARCHAR(40),
    pret_unitar INTEGER,
    cantitate INTEGER,
    idProdus SMALLINT,
    CONSTRAINT pk_linii_factura PRIMARY KEY (idFactura, linii_factura),
    CONSTRAINT ck_val_incasare CHECK (val_incasare >= 0),
    CONSTRAINT ck_pret_unitar CHECK (pret_unitar >= 1),
    CONSTRAINT ck_cantitate CHECK (cantitate >= 1),
    CONSTRAINT fk_linii_factura_idProdus FOREIGN KEY (idProdus) REFERENCES produse(idProdus)
);
---5 run #4
CREATE TABLE produse (
	idProdus SMALLINT NOT NULL
	CONSTRAINT pk_produse PRIMARY KEY,
	CONSTRAINT ck_produse CHECK (idProdus >= 1),
	denumire VARCHAR(30),
	descriere VARCHAR(30),
	procTVA NUMERIC (4,2) DEFAULT 19 NOT NULL,
	unitate_masura VARCHAR(7) NOT NULL,
	CONSTRAINT ck_unitate_masura CHECK (unitate_masura IN ('M', 'M PATRATI', 'M CUB', 'TO', 'L', 'BUC'))
);
---6 run #6
CREATE TABLE incasari (
	idFactura SMALLINT NOT NULL,
	nr_incasare SMALLINT NOT NULL,
	valoare INTEGER,
	data_incasare DATE,
	PRIMARY KEY (idFactura, nr_incasare)
);
---7 run #22
CREATE TABLE avize (
    idAviz INTEGER NOT NULL,
    data_aviz DATE,
    idClient SMALLINT,
    idTransport VARCHAR(2),
    idIncarcare VARCHAR(2),
    idDescarcare VARCHAR(2),
    idTransportatori VARCHAR(4),
    CONSTRAINT pk_avize PRIMARY KEY (idAviz),
    CONSTRAINT ck_avize CHECK (idAviz >= 1),
    CONSTRAINT fk_avize_idClient FOREIGN KEY (idClient) REFERENCES clienti(idClient),
    CONSTRAINT fk_avize_idTransport FOREIGN KEY (idTransport) REFERENCES camioane_remorci(idTransport),
    CONSTRAINT fk_avize_idIncarcare FOREIGN KEY (idIncarcare) REFERENCES incarcari(idIncarcare),
    CONSTRAINT fk_avize_idDescarcare FOREIGN KEY (idDescarcare) REFERENCES descarcari(idDescarcare),
    CONSTRAINT fk_avize_idTransportatori FOREIGN KEY (idTransportatori) REFERENCES transportatori(idTransportatori)
);
---8	run #10
CREATE TABLE linii_avize (
	idAviz INTEGER NOT NULL,
	nr_linie SMALLINT NOT NULL,
	PRIMARY KEY (idAviz, nr_linie),
	cantitate INTEGER,
	idProdus SMALLINT,
	CONSTRAINT fk_linii_avize_idProdus FOREIGN KEY (idProdus) REFERENCES produse(idProdus)
);
---9 run #8
CREATE TABLE camioane (
	idCamion VARCHAR(3) NOT NULL,
	CONSTRAINT pk_camioane PRIMARY KEY (idCamion),
	marca VARCHAR(20),
	an_fabricatie INTEGER,
	nr_inmatriculare VARCHAR(10),
	greutate INTEGER,
	consum_mediu SMALLINT NOT NULL,
	axe SMALLINT
);
---10 run #7
CREATE TABLE remorci (
	idRemorca VARCHAR(2) NOT NULL,
	CONSTRAINT pk_remorci PRIMARY KEY (idRemorca),
	tip VARCHAR(25),
	denumire VARCHAR(20),
	nr_inmatriculare VARCHAR(10),
	greutate INTEGER,
	capacitate INTEGER,
	axe SMALLINT
);
---11 run #9
CREATE TABLE camioane_remorci (
	idTransport VARCHAR(2) NOT NULL,
	CONSTRAINT pk_camioane_remorci PRIMARY KEY (idTransport),
	data_start DATE DEFAULT CURRENT_DATE,
	idCamion VARCHAR(4),
	idRemorca VARCHAR(4),
	CONSTRAINT fk_camioane_remorci_idCamion FOREIGN KEY (idCamion) REFERENCES camioane(idCamion),
	CONSTRAINT fk_camioane_remorci_idRemorca FOREIGN KEY (idRemorca) REFERENCES remorci(idRemorca)
);
---12 run #11
CREATE TABLE transportatori (
	idTransportator VARCHAR(4) NOT NULL,
	CONSTRAINT pk_transportator PRIMARY KEY (idTransportator),
	nume VARCHAR(15),
	prenume VARCHAR(15),
	cnp BIGINT
);
---13 run #12
CREATE TABLE alimentari (
	idTransportator VARCHAR(4) NOT NULL,
	idCamion VARCHAR(3) NOT NULL,
	nr_alimentare SMALLINT,
	data_alimentare DATE,
	PRIMARY KEY (idTransportator, idCamion, nr_alimentare, data_alimentare),
	litri INTEGER,
	CONSTRAINT ck_litri CHECK (litri >= 1),
	pret_litru NUMERIC(4,2) NOT NULL
);
---14 run #13
CREATE TABLE revizii (
	idCamion VARCHAR(3) NOT NULL,
	nr_revizie SMALLINT NOT NULL,
	PRIMARY KEY (idCamion, nr_revizie),
	data_efectuarii DATE DEFAULT CURRENT_DATE,
	locatie VARCHAR(15)
);
---15 run #14
CREATE TABLE asigurari (
    idAsigurare VARCHAR(7) NOT NULL,
    CONSTRAINT pk_asigurari PRIMARY KEY (idAsigurare),
    idCamion VARCHAR(3),
    CONSTRAINT fk_asigurari_idCamion FOREIGN KEY (idCamion) REFERENCES camioane(idCamion),
    tip VARCHAR(5),
    data_asigurare DATE DEFAULT CURRENT_DATE,
    data_scadenta DATE,
    pret_asigurare INTEGER
);

---ALTER TABLE asigurari
---ALTER COLUMN data_scadenta SET DEFAULT (data_asigurare + INTERVAL '1 year');

---trigger function
	CREATE OR REPLACE FUNCTION set_data_scadenta_default() RETURNS TRIGGER AS $$
BEGIN
    NEW.data_scadenta := NEW.data_asigurare + INTERVAL '1 year';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

---triger before insert 
CREATE TRIGGER set_data_scadenta_default_trigger
BEFORE INSERT ON asigurari
FOR EACH ROW
EXECUTE FUNCTION set_data_scadenta_default();

---16 run #17 merge
CREATE TABLE reparatii (
    idCamion VARCHAR(3) NOT NULL,
    nr_reparatie SMALLINT NOT NULL,
    data_reparatie DATE,
    motiv VARCHAR(50),
    idSchimb VARCHAR(7),
    CONSTRAINT pk_reparatii PRIMARY KEY (idSchimb),
	CONSTRAINT fk_reparatii_idCamion FOREIGN KEY (idCamion) REFERENCES camioane(idCamion)	
);

---17 run #16
CREATE TABLE schimburi (
    idSchimb VARCHAR(7) NOT NULL,
    nr_piesa SMALLINT NOT NULL,
    cantitate SMALLINT,
    idPiesa VARCHAR(3),
    CONSTRAINT pk_schimburi PRIMARY KEY (idSchimb, nr_piesa),
    CONSTRAINT fk_schimburi_idPiesa FOREIGN KEY (idPiesa) REFERENCES piese(idPiesa),
	CONSTRAINT uk_schimburi UNIQUE (idSchimb, nr_piesa)
);
---18 run #15
CREATE TABLE piese (
	idPiesa VARCHAR(3) NOT NULL,
	CONSTRAINT pk_piese PRIMARY KEY (idPiesa),
	denumire_piesa VARCHAR(15),
	pret_piesa INTEGER,
	unitate_masura VARCHAR(3) DEFAULT 'BUC'
);
---19 run #18
CREATE TABLE incarcari (
	idIncarcare VARCHAR(2) NOT NULL,
	CONSTRAINT pk_incarcari PRIMARY KEY (idIncarcare),
	denumire_incarcator VARCHAR(20) NOT NULL
);
---20 run #19
CREATE TABLE descarcari (
	idDescarcare VARCHAR(2) NOT NULL,
	CONSTRAINT pk_descarcari PRIMARY KEY (idDescarcare),
	denumire_descarcator VARCHAR(20) NOT NULL
);
---21 run #20
CREATE TABLE produse_incarcari (
	idIncarcare VARCHAR(2) NOT NULL,
	nr_produs SMALLINT NOT NULL,
	idProdus SMALLINT,
	CONSTRAINT pk_produse_incarcari PRIMARY KEY (idIncarcare, nr_produs),
	CONSTRAINT fk_produse_incasari_idProdus FOREIGN KEY(idProdus) REFERENCES produse(idProdus)
);
---22 run #23
CREATE TABLE trasee (
	idIncarcare VARCHAR(2) NOT NULL,
	idDescarcare VARCHAR(2) NOT NULL,
	idTraseu VARCHAR(3),
	km INTEGER NOT NULL,
	CONSTRAINT pk_trasee PRIMARY KEY (idTraseu),
	CONSTRAINT fk_trasee_idIncarcare FOREIGN KEY(idIncarcare) REFERENCES incarcari(idIncarcare),
	CONSTRAINT fk_trasee_idDescarcare FOREIGN KEY(idDescarcare) REFERENCES descarcari(idDescarcare)
);
---23 run #21
CREATE TABLE statii_traseu (
	idTraseu VARCHAR(3) NOT NULL,
	nr_statie SMALLINT NOT NULL,
	CONSTRAINT pk_statii_traseu PRIMARY KEY (idTraseu, nr_statie),
	denumire_statie_traseu VARCHAR(10)
);

--- INSERT_URI
	
DELETE FROM clienti;
DELETE FROM localizari;
DELETE FROM facturi;
DELETE FROM linii_factura;
DELETE FROM produse;
DELETE FROM incasari;
DELETE FROM avize;
DELETE FROM linii_avize;
DELETE FROM camioane;
DELETE FROM remorci;
DELETE FROM camioane_remorci;
DELETE FROM transportatori;
DELETE FROM alimentari;
DELETE FROM revizii;
DELETE FROM asigurari;
DELETE FROM reparatii;
DELETE FROM schimburi;
DELETE FROM piese;
DELETE FROM incarcari;
DELETE FROM descarcari;
DELETE FROM produse_incarcari;
DELETE FROM trasee;
DELETE FROM statii_traseu;
	
--- INSERT tabel 1 clienti merge run #2
INSERT INTO clienti (idClient, dencl, nr_orc, iban, idLocalizare) VALUES (1, 'TREVIZO SRL', 'RO43005343', 'BTRLRONCRT849', 1);
INSERT INTO clienti (idClient, dencl, nr_orc, iban, idLocalizare) VALUES (2, 'MAXIMA SRL', 'RO45000333', 'BTRLRONCRT762', 2);
INSERT INTO clienti (idClient, dencl, nr_orc, iban, idLocalizare) VALUES (3, 'TNMT SRL', 'RO32006758', 'BTRLRONCRT593', 3);
INSERT INTO clienti (idClient, dencl, nr_orc, iban, idLocalizare) VALUES (4, 'GEOKE SRL', 'RO78565656', 'BTRLRONCRT216', 4);
INSERT INTO clienti (idClient, dencl, nr_orc, iban, idLocalizare) VALUES (5, 'YVANA SRL', 'RO12345678', 'BTRLRONCRT428', 5);
INSERT INTO clienti (idClient, dencl, nr_orc, iban, idLocalizare) VALUES (6, 'EYEFUL SRL', 'RO34652817', 'BTRLRONCRT935', 6);
INSERT INTO clienti (idClient, dencl, nr_orc, iban, idLocalizare) VALUES (7, 'JOLLY SRL', 'RO82563490', 'BTRLRONCRT107', 7);
INSERT INTO clienti (idClient, dencl, nr_orc, iban, idLocalizare) VALUES (8, 'MAKE SRL', 'RO16398572', 'BTRLRONCRT671', 8);
INSERT INTO clienti (idClient, dencl, nr_orc, iban, idLocalizare) VALUES (9, 'RAPID SRL', 'RO59784623', 'BTRLRONCRT524', 9);
INSERT INTO clienti (idClient, dencl, nr_orc, iban, idLocalizare) VALUES (10, 'FRESH SRL', 'RO43218659', 'BTRLRONCRT963', 10);

--- INSERT tabel 2 localizari merge run #1
INSERT INTO localizari (idLocalizare, judet, tara, strada, nr, localitate) VALUES (1, 'TL', 'RO', 'FERICIRIII', 23, 'MACIN');
INSERT INTO localizari (idLocalizare, judet, tara, strada, nr, localitate) VALUES (2, 'GL', 'RO', 'TRISTETII', 55, 'VANATORI');
INSERT INTO localizari (idLocalizare, judet, tara, strada, nr, localitate) VALUES (3, 'BR', 'RO', 'INIMII', 65, 'IANCA');
INSERT INTO localizari (idLocalizare, judet, tara, strada, nr, localitate) VALUES (4, 'IS', 'RO', 'PODISULUI', 8, 'MIROSLAVA');
INSERT INTO localizari (idLocalizare, judet, tara, strada, nr, localitate) VALUES (5, 'VS', 'RO', 'BOBOCULUI', 4, 'HUSI');
INSERT INTO localizari (idLocalizare, judet, tara, strada, nr, localitate) VALUES (6, 'CJ', 'RO', 'PIETRISULUI', 48, 'TURDA');
INSERT INTO localizari (idLocalizare, judet, tara, strada, nr, localitate) VALUES (7, 'BV', 'RO', 'VESELIEI', 62, 'RASNOV');
INSERT INTO localizari (idLocalizare, judet, tara, strada, nr, localitate) VALUES (8, 'SB', 'RO', 'CURCUBEULUI', 39, 'MEDIAS');
INSERT INTO localizari (idLocalizare, judet, tara, strada, nr, localitate) VALUES (9, 'BH', 'RO', 'HOTILOR', 86, 'ORADEA');
INSERT INTO localizari (idLocalizare, judet, tara, strada, nr, localitate) VALUES (10, 'MM', 'RO', 'PAUNULUI', 11, 'BORSA');

--- INSERT tabel 3 facturi merge run #3
INSERT INTO facturi (idFactura, scadenta, data_intocmire, nr, idClient) VALUES (10, '2022-06-12', '2022-05-12', 132, 1);
INSERT INTO facturi (idFactura, scadenta, data_intocmire, nr, idClient) VALUES (11, '2021-04-17', '2021-03-17', 234, 2);
INSERT INTO facturi (idFactura, scadenta, data_intocmire, nr, idClient) VALUES (12, '2022-02-02', '2022-01-02', 352, 3);
INSERT INTO facturi (idFactura, scadenta, data_intocmire, nr, idClient) VALUES (13, '2012-05-23', '2012-04-23', 75, 4);
INSERT INTO facturi (idFactura, scadenta, data_intocmire, nr, idClient) VALUES (14, '2020-12-22', '2020-11-22', 2, 5);
INSERT INTO facturi (idFactura, scadenta, data_intocmire, nr, idClient) VALUES (15, '2018-02-18', '2018-01-18', 412, 6);
INSERT INTO facturi (idFactura, scadenta, data_intocmire, nr, idClient) VALUES (16, '2015-12-25', '2015-11-25', 687, 7);
INSERT INTO facturi (idFactura, scadenta, data_intocmire, nr, idClient) VALUES (17, '2016-08-30', '2016-07-30', 548, 8);
INSERT INTO facturi (idFactura, scadenta, data_intocmire, nr, idClient) VALUES (18, '2019-03-15', '2019-02-15', 711, 9);
INSERT INTO facturi (idFactura, scadenta, data_intocmire, nr, idClient) VALUES (19, '2014-09-07', '2014-08-07', 808, 10);

--- INSERT tabel 4 linii_facturi merge run#5
INSERT INTO linii_factura (idFactura, linii_factura, val_incasare, descriere, pret_unitar, cantitate, idProdus) VALUES (10, 1, 2100, 'TRANSPORT NISIP', 53, 25, 1);
INSERT INTO linii_factura (idFactura, linii_factura, val_incasare, descriere, pret_unitar, cantitate, idProdus) VALUES (10, 2, 3000, 'TRANSPORT BALASTRU', 25, 100, 2);
INSERT INTO linii_factura (idFactura, linii_factura, val_incasare, descriere, pret_unitar, cantitate, idProdus) VALUES (12, 1, 1425, 'TRANSPORT MOTORINA', 5, 100, 3);
INSERT INTO linii_factura (idFactura, linii_factura, val_incasare, descriere, pret_unitar, cantitate, idProdus) VALUES (14, 1, 328, 'TRANSPORT LEMNE', 22, 120, 4);
INSERT INTO linii_factura (idFactura, linii_factura, val_incasare, descriere, pret_unitar, cantitate, idProdus) VALUES (11, 1, 4267, 'TRANSPORT PIATRA 0.63', 56, 25, 5);
INSERT INTO linii_factura (idFactura, linii_factura, val_incasare, descriere, pret_unitar, cantitate, idProdus) VALUES (11, 2, 5100, 'TRANSPORT PIATRA 0.90', 70, 10, 6);
INSERT INTO linii_factura (idFactura, linii_factura, val_incasare, descriere, pret_unitar, cantitate, idProdus) VALUES (15, 1, 1800, 'TRANSPORT FIER BETON', 41, 80, 7);
INSERT INTO linii_factura (idFactura, linii_factura, val_incasare, descriere, pret_unitar, cantitate, idProdus) VALUES (19, 1, 2490, 'TRANSPORT TIGLA', 50, 125, 8);
INSERT INTO linii_factura (idFactura, linii_factura, val_incasare, descriere, pret_unitar, cantitate, idProdus) VALUES (17, 1, 3854, 'TRANSPORT OSB', 30, 46, 9);
INSERT INTO linii_factura (idFactura, linii_factura, val_incasare, descriere, pret_unitar, cantitate, idProdus) VALUES (17, 2, 4761, 'TRANSPORT CARAMIDA', 75, 12, 10);

--- INSERT tabel 5 produse merge run #4
INSERT INTO produse (idProdus, denumire, descriere, procTVA, unitate_masura) VALUES (1, 'NISIP', 'NISIP FIN', 19, 'TO');
INSERT INTO produse (idProdus, denumire, descriere, procTVA, unitate_masura) VALUES (2, 'LEMNE', 'CHERESTEA', 19, 'M CUB');
INSERT INTO produse (idProdus, denumire, descriere, procTVA, unitate_masura) VALUES (3, 'MOTORINA 98', '98', 19, 'L');
INSERT INTO produse (idProdus, denumire, descriere, procTVA, unitate_masura) VALUES (4, 'BALASTRU', 'PIETRE MICI', 19, 'TO');
INSERT INTO produse (idProdus, denumire, descriere, procTVA, unitate_masura) VALUES (5, 'PIATRA 0.63', 'PIATRA CU DURITATE MEDIE', 19, 'TO');
INSERT INTO produse (idProdus, denumire, descriere, procTVA, unitate_masura) VALUES (6, 'PIATRA 0.90', 'PIATRA DURA', 19, 'TO');
INSERT INTO produse (idProdus, denumire, descriere, procTVA, unitate_masura) VALUES (7, 'FIER BETON', 'BARA SAU FASONAT', 19, 'M CUB');
INSERT INTO produse (idProdus, denumire, descriere, procTVA, unitate_masura) VALUES (8, 'TIGLA', 'TIGLA ACOPERIS', 19, 'BUC');
INSERT INTO produse (idProdus, denumire, descriere, procTVA, unitate_masura) VALUES (9, 'OSB', '2 METRI PE 40 CM', 19, 'M');
INSERT INTO produse (idProdus, denumire, descriere, procTVA, unitate_masura) VALUES (10, 'CARAMIDA', 'CU GOLURI', 19, 'M CUB');

--- INSERT tabel 6 incasari merge run #6
INSERT INTO incasari (idFactura, nr_incasare, valoare, data_incasare) VALUES (10, 1, 1325, '2022-06-01');
INSERT INTO incasari (idFactura, nr_incasare, valoare, data_incasare) VALUES (10, 2, 2500, '2022-06-12');
INSERT INTO incasari (idFactura, nr_incasare, valoare, data_incasare) VALUES (11, 1, 1400, '2021-04-17');
INSERT INTO incasari (idFactura, nr_incasare, valoare, data_incasare) VALUES (12, 1, 500, '2022-02-02');
INSERT INTO incasari (idFactura, nr_incasare, valoare, data_incasare) VALUES (14, 1, 2640, '2012-05-23');
INSERT INTO incasari (idFactura, nr_incasare, valoare, data_incasare) VALUES (16, 1, 4300, '2015-11-27');
INSERT INTO incasari (idFactura, nr_incasare, valoare, data_incasare) VALUES (17, 1, 3215, '2016-08-21');
INSERT INTO incasari (idFactura, nr_incasare, valoare, data_incasare) VALUES (19, 1, 1100, '2014-08-15');
INSERT INTO incasari (idFactura, nr_incasare, valoare, data_incasare) VALUES (12, 2, 700, '2022-01-11');
INSERT INTO incasari (idFactura, nr_incasare, valoare, data_incasare) VALUES (18, 1, 2785, '2019-02-27');
	
--- INSERT tabel 7 avize merge run #22
INSERT INTO avize (idAviz, data_aviz, idClient, idTransport, idIncarcare, idDescarcare, idTransportatori) VALUES (3334049, '2022-05-12', 1, 'T1', 'L1', 'D1', 'TR01');
INSERT INTO avize (idAviz, data_aviz, idClient, idTransport, idIncarcare, idDescarcare, idTransportatori) VALUES (3487987, '2021-03-17', 2, 'T2', 'L2', 'D2', 'TR02');
INSERT INTO avize (idAviz, data_aviz, idClient, idTransport, idIncarcare, idDescarcare, idTransportatori) VALUES (3438921, '2022-01-02', 3, 'T3', 'L3', 'D3', 'TR03');
INSERT INTO avize (idAviz, data_aviz, idClient, idTransport, idIncarcare, idDescarcare, idTransportatori) VALUES (3573465, '2012-04-23', 4, 'T4', 'L4', 'D4', 'TR04');
INSERT INTO avize (idAviz, data_aviz, idClient, idTransport, idIncarcare, idDescarcare, idTransportatori) VALUES (4647803, '2020-11-22', 5, 'T5', 'L5', 'D5', 'TR05');
INSERT INTO avize (idAviz, data_aviz, idClient, idTransport, idIncarcare, idDescarcare, idTransportatori) VALUES (5127823, '2018-01-18', 6, 'T1', 'L2', 'D2', 'TR06');
INSERT INTO avize (idAviz, data_aviz, idClient, idTransport, idIncarcare, idDescarcare, idTransportatori) VALUES (9125021, '2015-11-25', 7, 'T2', 'L4', 'D4', 'TR07');
INSERT INTO avize (idAviz, data_aviz, idClient, idTransport, idIncarcare, idDescarcare, idTransportatori) VALUES (8404953, '2016-07-30', 8, 'T3', 'L1', 'D1', 'TR08');
INSERT INTO avize (idAviz, data_aviz, idClient, idTransport, idIncarcare, idDescarcare, idTransportatori) VALUES (6423490, '2019-02-15', 9, 'T4', 'L5', 'D5', 'TR09');
INSERT INTO avize (idAviz, data_aviz, idClient, idTransport, idIncarcare, idDescarcare, idTransportatori) VALUES (7980321, '2014-08-07', 10, 'T5', 'L3', 'D3', 'TR10');

--- INSERT tabel 8 linii_avize merge run #10
INSERT INTO linii_avize (idAviz, nr_linie, cantitate, idProdus) VALUES (3334049, 1, 25, 1);
INSERT INTO linii_avize (idAviz, nr_linie, cantitate, idProdus) VALUES (3334049, 2, 100, 2);
INSERT INTO linii_avize (idAviz, nr_linie, cantitate, idProdus) VALUES (3334049, 3, 14, 3);
INSERT INTO linii_avize (idAviz, nr_linie, cantitate, idProdus) VALUES (3487987, 1, 30, 4);
INSERT INTO linii_avize (idAviz, nr_linie, cantitate, idProdus) VALUES (4647803, 1, 55, 5);
INSERT INTO linii_avize (idAviz, nr_linie, cantitate, idProdus) VALUES (4647803, 2, 10, 6);
INSERT INTO linii_avize (idAviz, nr_linie, cantitate, idProdus) VALUES (5127823, 1, 82, 7);
INSERT INTO linii_avize (idAviz, nr_linie, cantitate, idProdus) VALUES (8404953, 1, 47, 8);
INSERT INTO linii_avize (idAviz, nr_linie, cantitate, idProdus) VALUES (6423490, 1, 82, 9);
INSERT INTO linii_avize (idAviz, nr_linie, cantitate, idProdus) VALUES (6423490, 2, 18, 10);
	
--- INSERT tabel 9 camioane run #8
INSERT INTO camioane (idCamion, marca, an_fabricatie, nr_inmatriculare, greutate, consum_mediu, axe) VALUES ('C10', 'MAN', 2004, 'IS15NSA', 7653, 55, 2);
INSERT INTO camioane (idCamion, marca, an_fabricatie, nr_inmatriculare, greutate, consum_mediu, axe) VALUES ('C11', 'IVECO', 2021, 'IS06MXM', 7800, 54, 2);
INSERT INTO camioane (idCamion, marca, an_fabricatie, nr_inmatriculare, greutate, consum_mediu, axe) VALUES ('C12', 'MAN', 2007, 'IS42VIC', 7230, 55, 2);
INSERT INTO camioane (idCamion, marca, an_fabricatie, nr_inmatriculare, greutate, consum_mediu, axe) VALUES ('C13', 'MERCEDES', 2013, 'IS42RZV', 7500, 60, 3);
INSERT INTO camioane (idCamion, marca, an_fabricatie, nr_inmatriculare, greutate, consum_mediu, axe) VALUES ('C14', 'DAF', 2015, 'IS12YVN', 7200, 65, 3);
INSERT INTO camioane (idCamion, marca, an_fabricatie, nr_inmatriculare, greutate, consum_mediu, axe) VALUES ('C15', 'VOLVO', 2012, 'IS25VOL', 7399, 56, 3);
INSERT INTO camioane (idCamion, marca, an_fabricatie, nr_inmatriculare, greutate, consum_mediu, axe) VALUES ('C16', 'AUDI', 2018, 'IS01AUD', 7124, 50, 2);
INSERT INTO camioane (idCamion, marca, an_fabricatie, nr_inmatriculare, greutate, consum_mediu, axe) VALUES ('C17', 'VW', 2019, 'IS44VWW', 7543, 55, 2);
INSERT INTO camioane (idCamion, marca, an_fabricatie, nr_inmatriculare, greutate, consum_mediu, axe) VALUES ('C18', 'HYUNDAI', 2022, 'IS45DAI', 7311, 64, 3);
INSERT INTO camioane (idCamion, marca, an_fabricatie, nr_inmatriculare, greutate, consum_mediu, axe) VALUES ('C19', 'SABB', 2011, 'IS99BBS', 7765, 60, 3);

--- INSERT tabel 10 remorci merge run #7
INSERT INTO remorci (idRemorca, tip, denumire, nr_inmatriculare, greutate, capacitate, axe) VALUES ('R1', 'PLATFORMA', 'TAALER', 'IS01GLA', 1500, 200, 3);
INSERT INTO remorci (idRemorca, tip, denumire, nr_inmatriculare, greutate, capacitate, axe) VALUES ('R2', 'SEMIREMORCA ', 'IRVAN', 'IS02GLA', 7300, 300, 3);
INSERT INTO remorci (idRemorca, tip, denumire, nr_inmatriculare, greutate, capacitate, axe) VALUES ('R3', 'COMBUSTIBIL', 'HMK', 'IS03GLA', 4000, 200, 3);
INSERT INTO remorci (idRemorca, tip, denumire, nr_inmatriculare, greutate, capacitate, axe) VALUES ('R4', 'SEMIREMORCA PIATRA', 'HAAS', 'IS04GLA', 7000, 500, 3);
INSERT INTO remorci (idRemorca, tip, denumire, nr_inmatriculare, greutate, capacitate, axe) VALUES ('R5', 'FRIGORIFICA', 'A.KO COOL', 'IS05GLA', 5500, 400, 3);

--- INSERT tabel 11 camioane_remorci merge run #9
INSERT INTO camioane_remorci (idTransport, data_start, idCamion, idRemorca) VALUES ('T1', '2022-05-12', 'C10', 'R1');
INSERT INTO camioane_remorci (idTransport, data_start, idCamion, idRemorca) VALUES ('T2', '2021-03-17', 'C11', 'R2');
INSERT INTO camioane_remorci (idTransport, data_start, idCamion, idRemorca) VALUES ('T3', '2022-01-02', 'C12', 'R3');
INSERT INTO camioane_remorci (idTransport, data_start, idCamion, idRemorca) VALUES ('T4', '2012-04-23', 'C13', 'R4');
INSERT INTO camioane_remorci (idTransport, data_start, idCamion, idRemorca) VALUES ('T5', '2020-12-07', 'C14', 'R5');
	
--- INSERT tabel 12 transportatori merge run #11
INSERT INTO transportatori (idTransportator, nume, prenume, cnp) VALUES ('TR01', 'VANEA', 'COSTEL', 1820525030041);
INSERT INTO transportatori (idTransportator, nume, prenume, cnp) VALUES ('TR02', 'RADU', 'ANDREI', 1920212180056);
INSERT INTO transportatori (idTransportator, nume, prenume, cnp) VALUES ('TR03', 'DUMITRESCU', 'MIHAI', 1771128120037);
INSERT INTO transportatori (idTransportator, nume, prenume, cnp) VALUES ('TR04', 'MARINESCU', 'ADRIAN', 2850417030062);
INSERT INTO transportatori (idTransportator, nume, prenume, cnp) VALUES ('TR05', 'STANESCU', 'ALEXANDRU', 1940329080043);
INSERT INTO transportatori (idTransportator, nume, prenume, cnp) VALUES ('TR06', 'POPA', 'MIHAI', 1790615030025);
INSERT INTO transportatori (idTransportator, nume, prenume, cnp) VALUES ('TR07', 'MIHALESCU', 'COSTIN', 1880228080076);
INSERT INTO transportatori (idTransportator, nume, prenume, cnp) VALUES ('TR08', 'VASILESCU', 'ANDREI', 1950417120034);
INSERT INTO transportatori (idTransportator, nume, prenume, cnp) VALUES ('TR09', 'GHEORGHE', 'ROBERT', 1930503050061);
INSERT INTO transportatori (idTransportator, nume, prenume, cnp) VALUES ('TR10', 'IACOB', 'DOREL', 1820929030017);

--- INSERT tabel 13 alimentari merge run #12
INSERT INTO alimentari (idTransportator, idCamion, nr_alimentare, data_alimentare, litri, pret_litru) VALUES ('TR02', 'C12', 1, '2022-04-07', 200, 6);
INSERT INTO alimentari (idTransportator, idCamion, nr_alimentare, data_alimentare, litri, pret_litru) VALUES ('TR04', 'C13', 1, '2022-04-14', 435, 6.43);
INSERT INTO alimentari (idTransportator, idCamion, nr_alimentare, data_alimentare, litri, pret_litru) VALUES ('TR05', 'C10', 1, '2021-03-03', 576, 8.02);
INSERT INTO alimentari (idTransportator, idCamion, nr_alimentare, data_alimentare, litri, pret_litru) VALUES ('TR02', 'C11', 1, '2022-04-12', 240, 6.7);
INSERT INTO alimentari (idTransportator, idCamion, nr_alimentare, data_alimentare, litri, pret_litru) VALUES ('TR01', 'C12', 2, '2022-05-12', 600, 6.23);
																							
--- INSERT tabel 14 revizii merge run #13
INSERT INTO revizii (idCamion, nr_revizie, data_efectuarii, locatie) VALUES ('C14', 1, '2022-04-07', 'RELUSRL');
INSERT INTO revizii (idCamion, nr_revizie, data_efectuarii, locatie) VALUES ('C14', 2, '2022-04-14', 'RELUSRL');
INSERT INTO revizii (idCamion, nr_revizie, data_efectuarii, locatie) VALUES ('C10', 3, '2021-03-03', 'AMIDASRL');
INSERT INTO revizii (idCamion, nr_revizie, data_efectuarii, locatie) VALUES ('C12', 2, '2022-04-12', 'AMIDASRL');
INSERT INTO revizii (idCamion, nr_revizie, data_efectuarii, locatie) VALUES ('C13', 2, '2022-05-12', 'COSTELSRL');
	
--- INSERT tabel 15 asigurari merge run #14
INSERT INTO asigurari (idAsigurare, idCamion, tip, pret_asigurare, data_asigurare, data_scadenta) VALUES ('ASIG1', 'C10', 'RCA', 2300, '2023-05-27', '2024-05-27');
INSERT INTO asigurari (idAsigurare, idCamion, tip, pret_asigurare, data_asigurare, data_scadenta) VALUES ('ASIG2', 'C11', 'RCA', 2500, '2023-05-27', '2024-05-27');
INSERT INTO asigurari (idAsigurare, idCamion, tip, pret_asigurare, data_asigurare, data_scadenta) VALUES ('ASIG3', 'C12', 'RCA', 2340, '2023-05-27', '2024-05-27');
INSERT INTO asigurari (idAsigurare, idCamion, tip, pret_asigurare, data_asigurare, data_scadenta) VALUES ('ASIG4', 'C13', 'RCA', 2200, '2023-05-27', '2024-05-27');
INSERT INTO asigurari (idAsigurare, idCamion, tip, pret_asigurare, data_asigurare, data_scadenta) VALUES ('ASIG5', 'C14', 'RCA', 3000, '2023-05-27', '2024-05-27');
INSERT INTO asigurari (idAsigurare, idCamion, tip, pret_asigurare, data_asigurare, data_scadenta) VALUES ('ASIG6', 'C15', 'CASCO', 3500, '2023-05-27', '2024-05-27');
INSERT INTO asigurari (idAsigurare, idCamion, tip, pret_asigurare, data_asigurare, data_scadenta) VALUES ('ASIG7', 'C16', 'CASCO', 3700, '2023-05-27', '2024-05-27');
INSERT INTO asigurari (idAsigurare, idCamion, tip, pret_asigurare, data_asigurare, data_scadenta) VALUES ('ASIG8', 'C17', 'CASCO', 3050, '2023-05-27', '2024-05-27');
INSERT INTO asigurari (idAsigurare, idCamion, tip, pret_asigurare, data_asigurare, data_scadenta) VALUES ('ASIG9', 'C18', 'CASCO', 2900, '2023-05-27', '2024-05-27');
INSERT INTO asigurari (idAsigurare, idCamion, tip, pret_asigurare, data_asigurare, data_scadenta) VALUES ('ASIG10', 'C19', 'CASCO', 2970, '2023-05-27', '2024-05-27');
	
--- INSERT tabel 16 reparatii merge run #17
INSERT INTO reparatii (idSchimb, idCamion, nr_reparatie, data_reparatie, motiv) VALUES ('SC01', 'C10', 1, '2021-04-12', 'SCURGERE ULEI');
INSERT INTO reparatii (idSchimb, idCamion, nr_reparatie, data_reparatie, motiv) VALUES ('SC02', 'C10', 2, '2021-04-12', 'ROATA DEFECTA');
INSERT INTO reparatii (idSchimb, idCamion, nr_reparatie, data_reparatie, motiv) VALUES ('SC06', 'C10', 3, '2022-05-23', 'PLANETARA DEFECTA');
INSERT INTO reparatii (idSchimb, idCamion, nr_reparatie, data_reparatie, motiv) VALUES ('SC03', 'C11', 1, '2022-02-13', 'MOTOR DEFECT');
INSERT INTO reparatii (idSchimb, idCamion, nr_reparatie, data_reparatie, motiv) VALUES ('SC07', 'C11', 2, '2022-07-08', 'SCHIMBARE FILTRE');
INSERT INTO reparatii (idSchimb, idCamion, nr_reparatie, data_reparatie, motiv) VALUES ('SC04', 'C12', 1, '2022-04-01', 'SCURGERE ULEI');
INSERT INTO reparatii (idSchimb, idCamion, nr_reparatie, data_reparatie, motiv) VALUES ('SC08', 'C13', 1, '2022-11-14', 'FAR DEFECT');
INSERT INTO reparatii (idSchimb, idCamion, nr_reparatie, data_reparatie, motiv) VALUES ('SC09', 'C13', 2, '2022-12-10', 'DISCURI FRANA');
INSERT INTO reparatii (idSchimb, idCamion, nr_reparatie, data_reparatie, motiv) VALUES ('SC05', 'C14', 1, '2021-08-02', 'ROATA DEFECTA');
INSERT INTO reparatii (idSchimb, idCamion, nr_reparatie, data_reparatie, motiv) VALUES ('SC010', 'C14', 2, '2022-05-17', 'SCURGERE ULEI');
	
--- INSERT tabel 17 schimburi merge run #16
INSERT INTO schimburi (idSchimb, nr_piesa, cantitate, idPiesa) VALUES ('SC01', 1, 1, 'PS1');
INSERT INTO schimburi (idSchimb, nr_piesa, cantitate, idPiesa) VALUES ('SC02', 1, 1, 'PS2');
INSERT INTO schimburi (idSchimb, nr_piesa, cantitate, idPiesa) VALUES ('SC03', 1, 4, 'PS8');
INSERT INTO schimburi (idSchimb, nr_piesa, cantitate, idPiesa) VALUES ('SC04', 1, 2, 'PS1');
INSERT INTO schimburi (idSchimb, nr_piesa, cantitate, idPiesa) VALUES ('SC05', 1, 2, 'PS2');
INSERT INTO schimburi (idSchimb, nr_piesa, cantitate, idPiesa) VALUES ('SC06', 1, 1, 'PS6');
INSERT INTO schimburi (idSchimb, nr_piesa, cantitate, idPiesa) VALUES ('SC07', 1, 1, 'PS8');
INSERT INTO schimburi (idSchimb, nr_piesa, cantitate, idPiesa) VALUES ('SC08', 1, 1, 'PS4');
INSERT INTO schimburi (idSchimb, nr_piesa, cantitate, idPiesa) VALUES ('SC09', 1, 1, 'PS7');
INSERT INTO schimburi (idSchimb, nr_piesa, cantitate, idPiesa) VALUES ('SC010', 1, 3, 'PS1');
	
--- INSERT tabel 18 piese merge run #15
INSERT INTO piese (idPiesa, denumire_piesa, pret_piesa, unitate_masura) VALUES ('PS1', 'TUB', 24, 'BUC');
INSERT INTO piese (idPiesa, denumire_piesa, pret_piesa, unitate_masura) VALUES ('PS2', 'ROATA', 3000, 'BUC');
INSERT INTO piese (idPiesa, denumire_piesa, pret_piesa, unitate_masura) VALUES ('PS3', 'PISTON', 450, 'BUC');
INSERT INTO piese (idPiesa, denumire_piesa, pret_piesa, unitate_masura) VALUES ('PS4', 'BUJIE', 10, 'BUC');
INSERT INTO piese (idPiesa, denumire_piesa, pret_piesa, unitate_masura) VALUES ('PS5', 'CUREA', 80, 'BUC');
INSERT INTO piese (idPiesa, denumire_piesa, pret_piesa, unitate_masura) VALUES ('PS6', 'PLANETARA', 400, 'BUC');
INSERT INTO piese (idPiesa, denumire_piesa, pret_piesa, unitate_masura) VALUES ('PS7', 'DISC', 500, 'BUC');
INSERT INTO piese (idPiesa, denumire_piesa, pret_piesa, unitate_masura) VALUES ('PS8', 'FILTRU', 50, 'BUC');
	
--- INSERT tabel 19 incarcari merge run #18
INSERT INTO incarcari (idIncarcare, denumire_incarcator) VALUES ('L1', 'SOVAT SRL');
INSERT INTO incarcari (idIncarcare, denumire_incarcator) VALUES ('L2', 'COMPAKT SRL');
INSERT INTO incarcari (idIncarcare, denumire_incarcator) VALUES ('L3', 'ALTO SRL');
INSERT INTO incarcari (idIncarcare, denumire_incarcator) VALUES ('L4', 'LEROY SRL');
INSERT INTO incarcari (idIncarcare, denumire_incarcator) VALUES ('L5', 'CONCAS SRL');
	
--- INSERT tabel 20 descarcari merge run #19
INSERT INTO descarcari (idDescarcare, denumire_descarcator) VALUES ('D1', 'MAGA SRL');
INSERT INTO descarcari (idDescarcare, denumire_descarcator) VALUES ('D2', 'ENTRAP SRL');
INSERT INTO descarcari (idDescarcare, denumire_descarcator) VALUES ('D3', 'CONSAP SRL');
INSERT INTO descarcari (idDescarcare, denumire_descarcator) VALUES ('D4', 'EVO SRL');
INSERT INTO descarcari (idDescarcare, denumire_descarcator) VALUES ('D5', 'DREP SRL');
	
--- INSERT tabel 21 produse_incarcari merge run #20
INSERT INTO produse_incarcari (idIncarcare, nr_produs, idProdus) VALUES ('L1', 1, 1);
INSERT INTO produse_incarcari (idIncarcare, nr_produs, idProdus) VALUES ('L1', 2, 4);
INSERT INTO produse_incarcari (idIncarcare, nr_produs, idProdus) VALUES ('L3', 1, 3);
INSERT INTO produse_incarcari (idIncarcare, nr_produs, idProdus) VALUES ('L4', 1, 4);
INSERT INTO produse_incarcari (idIncarcare, nr_produs, idProdus) VALUES ('L4', 2, 5);


--- INSERT tabel 22 trasee merge run #23
INSERT INTO trasee (idIncarcare, idDescarcare, idTraseu, km) VALUES ('L1', 'D2', 'TR1', 200);
INSERT INTO trasee (idIncarcare, idDescarcare, idTraseu, km) VALUES ('L1', 'D4', 'TR2', 234);
INSERT INTO trasee (idIncarcare, idDescarcare, idTraseu, km) VALUES ('L2', 'D5', 'TR3', 235);
INSERT INTO trasee (idIncarcare, idDescarcare, idTraseu, km) VALUES ('L3', 'D4', 'TR4', 156);
INSERT INTO trasee (idIncarcare, idDescarcare, idTraseu, km) VALUES ('L3', 'D5', 'TR5', 287);

--- INSERT tabel 23 statii_traseu merge run #21
INSERT INTO statii_traseu (idTraseu, nr_statie, denumire_statie_traseu) VALUES ('TR1', 1, 'CONSAL');
INSERT INTO statii_traseu (idTraseu, nr_statie, denumire_statie_traseu) VALUES ('TR1', 2, 'TRADESL');
INSERT INTO statii_traseu (idTraseu, nr_statie, denumire_statie_traseu) VALUES ('TR3', 1, 'MARFAT');
INSERT INTO statii_traseu (idTraseu, nr_statie, denumire_statie_traseu) VALUES ('TR4', 1, 'TRADECOMP');
INSERT INTO statii_traseu (idTraseu, nr_statie, denumire_statie_traseu) VALUES ('TR5', 1, 'CONSAL');
	
--- SELECT grupare si filtrare
SELECT * FROM clienti;
SELECT * FROM localizari;
SELECT * FROM facturi; 
SELECT * FROM linii_factura;
SELECT * FROM produse;
SELECT * FROM incasari;
SELECT * FROM avize;
SELECT * FROM linii_avize;
SELECT * FROM camioane;
SELECT * FROM remorci;
SELECT * FROM camioane_remorci;
SELECT * FROM transportatori;
SELECT * FROM alimentari;
SELECT * FROM revizii;
SELECT * FROM asigurari;
SELECT * FROM reparatii;
SELECT * FROM schimburi; 
SELECT * FROM piese; 
SELECT * FROM incarcari;
SELECT * FROM descarcari;
SELECT * FROM produse_incarcari;
SELECT * FROM trasee;
SELECT * FROM statii_traseu;

--- grupare si filtre SELECTARE NR TOTAL avize ale unui client
SELECT dencl, COUNT(idAviz) FROM clienti
NATURAL JOIN avize WHERE data_aviz BETWEEN '2022-01-02' AND '2022-12-30'
GROUP BY dencl
ORDER BY dencl;

--- SELECTARE SUBCONSULTARI IN FROM SAU HAVING Care este clientul caruia i s-au transportat cele mai multe produse?
SELECT dencl, COUNT(DISTINCT nr_produs) AS NrProd
FROM clienti
NATURAL JOIN produse_incarcari
NATURAL JOIN incasari
NATURAL JOIN facturi
NATURAL JOIN linii_factura
GROUP by dencl
HAVING COUNT (DISTINCT nr_produs) >= ALL
(SELECT COUNT (DISTINCT nr_produs) FROM produse_incarcari
NATURAL JOIN linii_factura lf
GROUP BY dencl)

--- expresii tabela si pivot table cu sau fara jonctiuni externe  Cate incasari au fost realizate la fiecare client?
SELECT COALESCE(cl.dencl, 'TOTAL') AS Client, COALESCE(mt.an2018, 0), COALESCE(mt.an2019, 0)
FROM clienti cl
NATURAL JOIN incasari
NATURAL JOIN facturi f
LEFT OUTER JOIN
(
    SELECT ic.idFactura,
    SUM(CASE WHEN EXTRACT(year FROM ic.data_incasare) = 2018 THEN ic.valoare ELSE 0 END) AS an2018,
    SUM(CASE WHEN EXTRACT(year FROM ic.data_incasare) = 2019 THEN ic.valoare ELSE 0 END) AS an2019
    FROM incasari ic
    WHERE EXTRACT(year FROM ic.data_incasare) IN (2018, 2019)
    GROUP BY ROLLUP(ic.idFactura)
) mt ON mt.idFactura = f.idFactura
ORDER BY CASE COALESCE(cl.dencl, 'TOTAL') WHEN 'TOTAL' THEN 1 ELSE 0 END ASC, Client ASC;