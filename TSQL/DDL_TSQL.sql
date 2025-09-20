
CREATE TABLE Adres (
    Id INT NOT NULL PRIMARY KEY,
    Ulica NVARCHAR(50) NOT NULL,
    Numer INT NOT NULL,
    Geolokalizacja INT NOT NULL,
    Miasto_Id INT NOT NULL
);


CREATE TABLE Miasto (
    Id INT NOT NULL PRIMARY KEY,
    Nazwa NVARCHAR(50) NOT NULL
);


CREATE TABLE Osoba (
    Id INT NOT NULL PRIMARY KEY,
    Gmail NVARCHAR(50) NOT NULL,
    Haslo NVARCHAR(30) NOT NULL
);



CREATE TABLE Podroz (
    Id INT NOT NULL PRIMARY KEY,
    DataWyjazdu DATE NOT NULL,
    Punkt_koncowy INT NOT NULL,
    Punkt_poczatkowy INT NOT NULL,
    Osoba_Id INT NOT NULL
);


CREATE TABLE Przystanek (
    Id INT NOT NULL PRIMARY KEY,
    Nazwa NVARCHAR(50) NOT NULL,
    Numer INT NOT NULL,
    Adres_Id INT NOT NULL
);


CREATE TABLE Rozklad (
    Id INT NOT NULL PRIMARY KEY,
    Czas_przyjazdu DATETIME NOT NULL,
    Czas_odjazdu DATETIME NOT NULL,
    Przystanek_Id INT NOT NULL,
    Transport_Id INT NOT NULL
);


CREATE TABLE Transport (
    Id INT NOT NULL PRIMARY KEY,
    Typ_transportu_Id INT NOT NULL,
    Linia NVARCHAR(20) NOT NULL
);


CREATE TABLE Trasa_Czesc_trasy (
    Podroz_Id INT NOT NULL,
    Rozklad_Id INT NOT NULL,
    PRIMARY KEY (Podroz_Id, Rozklad_Id)
);


CREATE TABLE Typ_transportu (
    Id INT NOT NULL PRIMARY KEY,
    Typ_transportu NVARCHAR(20) NOT NULL,
    Opis NVARCHAR(50) NOT NULL
);


ALTER TABLE Adres ADD CONSTRAINT FK_Adres_Miasto
    FOREIGN KEY (Miasto_Id)
    REFERENCES Miasto (Id);


ALTER TABLE Podroz ADD CONSTRAINT FK_Podroz_Osoba
    FOREIGN KEY (Osoba_Id)
    REFERENCES Osoba (Id);


ALTER TABLE Przystanek ADD CONSTRAINT FK_Przystanek_Adres
    FOREIGN KEY (Adres_Id)
    REFERENCES Adres (Id);


ALTER TABLE Rozklad ADD CONSTRAINT FK_Rozklad_Przystanek
    FOREIGN KEY (Przystanek_Id)
    REFERENCES Przystanek (Id);


ALTER TABLE Rozklad ADD CONSTRAINT FK_Rozklad_Transport
    FOREIGN KEY (Transport_Id)
    REFERENCES Transport (Id);


ALTER TABLE Transport ADD CONSTRAINT FK_Transport_Typ_transportu
    FOREIGN KEY (Typ_transportu_Id)
    REFERENCES Typ_transportu (Id);


ALTER TABLE Podroz ADD CONSTRAINT FK_Trasa_Adres_Punkt_poczatkowy
    FOREIGN KEY (Punkt_poczatkowy)
    REFERENCES Adres (Id);


ALTER TABLE Podroz ADD CONSTRAINT FK_Trasa_Adres_Punkt_koncowy
    FOREIGN KEY (Punkt_koncowy)
    REFERENCES Adres (Id);


ALTER TABLE Trasa_Czesc_trasy ADD CONSTRAINT FK_Trasa_Czesc_trasy_Podroz
    FOREIGN KEY (Podroz_Id)
    REFERENCES Podroz (Id);


ALTER TABLE Trasa_Czesc_trasy ADD CONSTRAINT FK_Trasa_Czesc_trasy_Rozklad
    FOREIGN KEY (Rozklad_Id)
    REFERENCES Rozklad (Id);

