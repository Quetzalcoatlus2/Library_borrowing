-- CREARE TABELE ȘI CONSTRÂNGERI

-- 1. Autori
CREATE TABLE autori
    (pk_autor                       NUMBER NOT NULL,
    nume_autor                     VARCHAR2(50) NOT NULL
    );
ALTER TABLE autori ADD CONSTRAINT pk_autor PRIMARY KEY (pk_autor);
ALTER TABLE autori ADD CONSTRAINT uk_nume_autor UNIQUE (nume_autor);

--2. Cititori
CREATE TABLE cititori
    (pk_cititor                     NUMBER NOT NULL,
    nume_cititor                   VARCHAR2(50),
    varsta                         NUMBER(2,0),
    sex                            VARCHAR2(1),
    calificativ                    VARCHAR2(50));  
ALTER TABLE cititori ADD CONSTRAINT pk_cititor PRIMARY KEY (pk_cititor);

-- 3. Carti
CREATE TABLE carti
    (pk_carte                       NUMBER NOT NULL,
    domeniu                        VARCHAR2(50),
    titlu_carte                    VARCHAR2(100) NOT NULL,
    pk_autor1                      NUMBER,
    pk_autor2                      NUMBER,
    pk_autor3                      NUMBER);
    ALTER TABLE carti ADD CONSTRAINT pk_carte PRIMARY KEY (pk_carte);
    ALTER TABLE carti ADD CONSTRAINT ck_carti_domeniu CHECK (domeniu in ('Beletristica','Stiinte','Divertisment'));
    ALTER TABLE carti ADD CONSTRAINT uk_nume_carte UNIQUE (titlu_carte);
    ALTER TABLE carti ADD CONSTRAINT fk_carti_autori FOREIGN KEY (pk_autor1) REFERENCES autori (pk_autor);

--4. Imprumuturi
    CREATE TABLE imprumuturi
    (pk_imprumut                    NUMBER NOT NULL,
    pk_carte                       NUMBER NOT NULL,
    pk_cititor                     NUMBER NOT NULL,
    data_start                     DATE NOT NULL,
    data_end                       DATE NOT NULL,
    data_return                    DATE,
    observatii                     VARCHAR2(50));
    ALTER TABLE imprumuturi ADD CONSTRAINT pk_imprumut PRIMARY KEY (pk_imprumut);
    ALTER TABLE imprumuturi ADD CONSTRAINT fk_imprumuturi_carti FOREIGN KEY (pk_carte) REFERENCES carti (pk_carte);
    ALTER TABLE imprumuturi ADD CONSTRAINT fk_imprumuturi_cititori FOREIGN KEY (pk_cititor) REFERENCES cititori (pk_cititor);




--INTRODUCEREA DATELOR DE LUCRU

--1. Autori
    insert into autori values(1, 'Neil Gaiman');
    insert into autori values(2, 'Terry Pratchett');
    insert into autori values(3, 'Stephen Hawking');
    insert into autori values(4, 'Leonard Mlodinow');
    insert into autori values(5, 'Siddhartha Mukherjee');
    insert into autori values(6, 'Michio Kaku');
    insert into autori values(7, 'David Trottier');
    insert into autori values(8, 'Douglas Adams');
    insert into autori values(9, 'Tina Fey');
    
--2. Cititori
    insert into cititori values(1, 'Dăscălescu Mihai', 22,'M','FB');
    insert into cititori values(2, 'Vornicu Irina-Maria', 36,'F','S');
    insert into cititori values(3, 'Dinescu Călin', 70,'M','NS');
    insert into cititori values(4, 'Popescu Lia-Ioana', 21,'F','B');
    insert into cititori values(5, 'Mihăiescu Cezarina', 25,'F','S');
    
--3. Carti
    insert into carti values(1,'Beletristica','Good Omens',1,2,null);
    insert into carti values(2,'Beletristica','The Ocean at the End of the Lane',1,null,null);
    insert into carti values(3,'Beletristica','American Gods',1,null,null);
    insert into carti values(4,'Beletristica','The Colour of Magic',2,null,null);
    insert into carti values(5,'Stiinte','The Grand Design',3,4,null);
    insert into carti values(6,'Stiinte','A Briefer History of Time',3,4,null);
    insert into carti values(7,'Stiinte','The Gene: An Intimate History',5,null,null);
    insert into carti values(8,'Stiinte','Physics of the Impossible',6,null,null);
    insert into carti values(9,'Divertisment','Two Screenplays',7,null,null);
    insert into carti values(10,'Divertisment','Last Chance to See',8,null,null);
    insert into carti values(11,'Divertisment','The Meaning of Liff',8,null,null);
    insert into carti values(12,'Divertisment','Bossypants',9,null,null);
    
--4. Imprumuturi
    insert into imprumuturi values(1, 1, 1, sysdate-4,sysdate+6, sysdate-2,null);
    insert into imprumuturi values(2, 2, 3, sysdate-10,sysdate, sysdate-5,'coperta murdara');
    insert into imprumuturi values(3, 2, 4, sysdate-2,sysdate+8, sysdate,null);
    insert into imprumuturi values(4, 4, 5, sysdate,sysdate+10, null,null);
    insert into imprumuturi values(5, 6, 2, sysdate-20,sysdate-10, sysdate-15,'semne cu pixul');
    insert into imprumuturi values(6, 10, 3, sysdate-25,sysdate-15, sysdate-10,'pagina rupta, a intarziat 5 zile');
    insert into imprumuturi values(7, 11, 1, sysdate-15,sysdate-5, sysdate-2,'a intarziat 3 zile');
    insert into imprumuturi values(8, 12, 2, sysdate-4,sysdate+6, null,null);
    insert into imprumuturi values(9, 9, 4, sysdate-30,sysdate-20, sysdate-16,'a intarziat 4 zile');
    insert into imprumuturi values(10, 8, 5, sysdate,sysdate+10, null,null);
    insert into imprumuturi values(11, 6, 3, sysdate-20,sysdate-10, sysdate-2,'a intarziat 8 zile');