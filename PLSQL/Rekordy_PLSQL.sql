
INSERT INTO Typ_transportu (Id, Typ_transportu, Opis)
VALUES (1, 'Metro', 'Szybki transport podziemny');

INSERT INTO Typ_transportu (Id, Typ_transportu, Opis)
VALUES (2, 'Autobus', 'Transport naziemny po mieście');

INSERT INTO Typ_transportu (Id, Typ_transportu, Opis)
VALUES (3, 'Tramwaj', 'Pojazdy szynowe na ulicach');

INSERT INTO Typ_transportu (Id, Typ_transportu, Opis)
VALUES (4, 'Pociąg', 'Transport międzymiastowy');


INSERT INTO Transport (Id, Typ_transportu_Id, Linia)
VALUES (1, 1, 'M1'); -- Metro linia M1

INSERT INTO Transport (Id, Typ_transportu_Id, Linia)
VALUES (2, 1, 'M2'); -- Metro linia M2

INSERT INTO Transport (Id, Typ_transportu_Id, Linia)
VALUES (3, 2, '186'); -- Autobus linia 186

INSERT INTO Transport (Id, Typ_transportu_Id, Linia)
VALUES (4, 2, '190'); -- Autobus linia 190

INSERT INTO Transport (Id, Typ_transportu_Id, Linia)
VALUES (5, 2, '167'); -- Autobus linia 167

INSERT INTO Transport (Id, Typ_transportu_Id, Linia)
VALUES (6, 3, '17'); -- Tramwaj linia 17

INSERT INTO Transport (Id, Typ_transportu_Id, Linia)
VALUES (7, 3, '1'); -- Tramwaj linia 1

INSERT INTO Transport (Id, Typ_transportu_Id, Linia)
VALUES (8, 3, '6'); -- Tramwaj linia 6

INSERT INTO Transport (Id, Typ_transportu_Id, Linia)
VALUES (9, 4, 'S1'); -- Pociąg linia S1


INSERT INTO Miasto (Id, Nazwa)
VALUES (1, 'Warszawa');

INSERT INTO Miasto (Id, Nazwa)
VALUES (2, 'Kraków');

INSERT INTO Miasto (Id, Nazwa)
VALUES (3, 'Elbląg');


INSERT INTO Adres (Id, Ulica, Numer, Geolokalizacja, Miasto_Id)
VALUES (1, 'Marszałkowska', 100, 123456, 1);

INSERT INTO Adres (Id, Ulica, Numer, Geolokalizacja, Miasto_Id)
VALUES (2, 'Królewska', 15, 654321, 1); 

INSERT INTO Adres (Id, Ulica, Numer, Geolokalizacja, Miasto_Id)
VALUES (3, 'Floriańska', 10, 987654, 2); 


INSERT INTO Osoba (Id, Gmail, Haslo)
VALUES (1, 'gluba.lyba@gmail.com', 'password123');

INSERT INTO Osoba (Id, Gmail, Haslo)
VALUES (2, 'zenon.ziembiewicz@gmail.com', 'securepass456');


INSERT INTO Przystanek (Id, Nazwa, Numer, Adres_Id)
VALUES (1, 'Dworzec Centralny', 1, 1); 

INSERT INTO Przystanek (Id, Nazwa, Numer, Adres_Id)
VALUES (2, 'Plac Zbawiciela', 2, 2); 

INSERT INTO Przystanek (Id, Nazwa, Numer, Adres_Id)
VALUES (3, 'Rynek Główny', 3, 3); 

-- Rekordy dla tabeli Rozklad
INSERT INTO Rozklad (Id, Czas_przyjazdu, Czas_odjazdu, Przystanek_Id, Transport_Id)
VALUES (1, TO_TIMESTAMP('2025-01-20 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-20 08:05:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 1); 

INSERT INTO Rozklad (Id, Czas_przyjazdu, Czas_odjazdu, Przystanek_Id, Transport_Id)
VALUES (2, TO_TIMESTAMP('2025-01-20 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-20 09:05:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 2); 

INSERT INTO Rozklad (Id, Czas_przyjazdu, Czas_odjazdu, Przystanek_Id, Transport_Id)
VALUES (3, TO_TIMESTAMP('2025-01-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-20 10:05:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 9); 


INSERT INTO Podroz (Id, DataWyjazdu, Punkt_koncowy, Punkt_poczatkowy, Osoba_Id)
VALUES (1, TO_DATE('2025-01-20', 'YYYY-MM-DD'), 3, 1, 1); 

INSERT INTO Podroz (Id, DataWyjazdu, Punkt_koncowy, Punkt_poczatkowy, Osoba_Id)
VALUES (2, TO_DATE('2025-01-21', 'YYYY-MM-DD'), 2, 1, 2); 


INSERT INTO Trasa_Czesc_trasy (Podroz_Id, Rozklad_Id)
VALUES (1, 1); 

INSERT INTO Trasa_Czesc_trasy (Podroz_Id, Rozklad_Id)
VALUES (1, 3); 

INSERT INTO Trasa_Czesc_trasy (Podroz_Id, Rozklad_Id)
VALUES (2, 1); 

INSERT INTO Trasa_Czesc_trasy (Podroz_Id, Rozklad_Id)
VALUES (2, 2); 


INSERT INTO Adres (Id, Ulica, Numer, Geolokalizacja, Miasto_Id)
VALUES (4, 'Prosta', 51, 223344, 1); 

INSERT INTO Adres (Id, Ulica, Numer, Geolokalizacja, Miasto_Id)
VALUES (5, 'Plac Dworcowy', 1, 111222, 3); 


INSERT INTO Przystanek (Id, Nazwa, Numer, Adres_Id)
VALUES (4, 'Rondo ONZ', 4, 4); 

INSERT INTO Przystanek (Id, Nazwa, Numer, Adres_Id)
VALUES (5, 'PKP Dworzec', 5, 5);

INSERT INTO Osoba (Id, Gmail, Haslo)
VALUES (3, 'jacek.soplica@gmail.com', 'PaNtAdEuSz');


INSERT INTO Rozklad (Id, Czas_przyjazdu, Czas_odjazdu, Przystanek_Id, Transport_Id)
VALUES (6, TO_TIMESTAMP('2025-01-22 07:50:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-22 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 1); 

INSERT INTO Rozklad (Id, Czas_przyjazdu, Czas_odjazdu, Przystanek_Id, Transport_Id)
VALUES (7, TO_TIMESTAMP('2025-01-22 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-22 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 9);


INSERT INTO Podroz (Id, DataWyjazdu, Punkt_poczatkowy, Punkt_koncowy, Osoba_Id)
VALUES (3, TO_DATE('2025-01-22', 'YYYY-MM-DD'), 4, 5, 3); 


INSERT INTO Trasa_Czesc_trasy (Podroz_Id, Rozklad_Id)
VALUES (3, 6); 

INSERT INTO Trasa_Czesc_trasy (Podroz_Id, Rozklad_Id)
VALUES (3, 7); 











