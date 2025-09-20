
CREATE TABLE Adres (
    Id NUMBER NOT NULL,
    Ulica VARCHAR2(50 CHAR) NOT NULL,
    Numer NUMBER NOT NULL,
    Geolokalizacja NUMBER NOT NULL,
    Miasto_Id NUMBER NOT NULL,
    CONSTRAINT Adres_pk PRIMARY KEY (Id)
);


CREATE TABLE Miasto (
    Id NUMBER NOT NULL,
    Nazwa VARCHAR2(50 CHAR) NOT NULL,
    CONSTRAINT Miasto_pk PRIMARY KEY (Id)
);


CREATE TABLE Osoba (
    Id NUMBER NOT NULL,
    Gmail VARCHAR2(50 CHAR) NOT NULL,
    Haslo VARCHAR2(30 CHAR) NOT NULL,
    CONSTRAINT Osoba_pk PRIMARY KEY (Id)
);


CREATE TABLE Podroz (
    Id NUMBER NOT NULL,
    DataWyjazdu DATE NOT NULL,
    Punkt_koncowy NUMBER NOT NULL,
    Punkt_poczatkowy NUMBER NOT NULL,
    Osoba_Id NUMBER NOT NULL,
    CONSTRAINT Podroz_pk PRIMARY KEY (Id)
);


CREATE TABLE Przystanek (
    Id NUMBER NOT NULL,
    Nazwa VARCHAR2(50 CHAR) NOT NULL,
    Numer NUMBER NOT NULL,
    Adres_Id NUMBER NOT NULL,
    CONSTRAINT Przystanek_pk PRIMARY KEY (Id)
);


CREATE TABLE Rozklad (
    Id NUMBER NOT NULL,
    Czas_przyjazdu TIMESTAMP NOT NULL,
    Czas_odjazdu TIMESTAMP NOT NULL,
    Przystanek_Id NUMBER NOT NULL,
    Transport_Id NUMBER NOT NULL,
    CONSTRAINT Rozklad_pk PRIMARY KEY (Id)
);


CREATE TABLE Transport (
    Id NUMBER NOT NULL,
    Typ_transportu_Id NUMBER NOT NULL,
    Linia VARCHAR2(20 CHAR) NOT NULL,
    CONSTRAINT Transport_pk PRIMARY KEY (Id)
);


CREATE TABLE Trasa_Czesc_trasy (
    Podroz_Id NUMBER NOT NULL,
    Rozklad_Id NUMBER NOT NULL,
    CONSTRAINT Trasa_Czesc_trasy_pk PRIMARY KEY (Podroz_Id, Rozklad_Id)
);


CREATE TABLE Typ_transportu (
    Id NUMBER NOT NULL,
    Typ_transportu VARCHAR2(20 CHAR) NOT NULL,
    Opis VARCHAR2(50 CHAR) NOT NULL,
    CONSTRAINT Typ_transportu_pk PRIMARY KEY (Id)
);


ALTER TABLE Adres ADD CONSTRAINT Adres_Miasto
    FOREIGN KEY (Miasto_Id)
    REFERENCES Miasto (Id);


ALTER TABLE Podroz ADD CONSTRAINT Podroz_Osoba
    FOREIGN KEY (Osoba_Id)
    REFERENCES Osoba (Id);


ALTER TABLE Przystanek ADD CONSTRAINT Przystanek_Adres
    FOREIGN KEY (Adres_Id)
    REFERENCES Adres (Id);


ALTER TABLE Rozklad ADD CONSTRAINT Rozklad_Przystanek
    FOREIGN KEY (Przystanek_Id)
    REFERENCES Przystanek (Id);


ALTER TABLE Rozklad ADD CONSTRAINT Rozklad_Transport
    FOREIGN KEY (Transport_Id)
    REFERENCES Transport (Id);


ALTER TABLE Transport ADD CONSTRAINT Transport_Typ_transportu
    FOREIGN KEY (Typ_transportu_Id)
    REFERENCES Typ_transportu (Id);


ALTER TABLE Podroz ADD CONSTRAINT Trasa_Adres
    FOREIGN KEY (Punkt_poczatkowy)
    REFERENCES Adres (Id);


ALTER TABLE Podroz ADD CONSTRAINT Trasa_Adres1
    FOREIGN KEY (Punkt_koncowy)
    REFERENCES Adres (Id);


ALTER TABLE Trasa_Czesc_trasy ADD CONSTRAINT Trasa_Czesc_trasy_Podroz
    FOREIGN KEY (Podroz_Id)
    REFERENCES Podroz (Id);


ALTER TABLE Trasa_Czesc_trasy ADD CONSTRAINT Trasa_Czesc_trasy_Rozklad
    FOREIGN KEY (Rozklad_Id)
    REFERENCES Rozklad (Id);
