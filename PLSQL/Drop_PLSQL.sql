-- foreign keys
ALTER TABLE Adres
    DROP CONSTRAINT Adres_Miasto;

ALTER TABLE Podroz
    DROP CONSTRAINT Podroz_Osoba;

ALTER TABLE Przystanek
    DROP CONSTRAINT Przystanek_Adres;

ALTER TABLE Rozklad
    DROP CONSTRAINT Rozklad_Przystanek;

ALTER TABLE Rozklad
    DROP CONSTRAINT Rozklad_Transport;

ALTER TABLE Transport
    DROP CONSTRAINT Transport_Typ_transportu;

ALTER TABLE Podroz
    DROP CONSTRAINT Trasa_Adres;

ALTER TABLE Podroz
    DROP CONSTRAINT Trasa_Adres1;

ALTER TABLE Trasa_Czesc_trasy
    DROP CONSTRAINT Trasa_Czesc_trasy_Podroz;

ALTER TABLE Trasa_Czesc_trasy
    DROP CONSTRAINT Trasa_Czesc_trasy_Rozklad;

-- tables
DROP TABLE Adres;

DROP TABLE Miasto;

DROP TABLE Osoba;

DROP TABLE Podroz;

DROP TABLE Przystanek;

DROP TABLE Rozklad;

DROP TABLE Transport;

DROP TABLE Trasa_Czesc_trasy;

DROP TABLE Typ_transportu;

-- End of file.