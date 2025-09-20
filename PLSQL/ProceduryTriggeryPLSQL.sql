
set SERVEROUTPUT on;


-- Procedura 1
CREATE OR REPLACE PROCEDURE AktualizujCzasyKursor(
    p_data_czas IN VARCHAR2 DEFAULT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') 
) AS
    
    CURSOR rozklad_cursor IS
        SELECT Id FROM Rozklad;

    
    CURSOR podroz_cursor IS
        SELECT Id FROM Podroz;
    
    
    v_rozklad_id Rozklad.Id%TYPE;
    v_podroz_id Podroz.Id%TYPE;
    v_data DATE;
    v_czas TIMESTAMP;
BEGIN
    -- kastowanie parametru na date i timestampe
    BEGIN
        v_data := TO_DATE(p_data_czas, 'YYYY-MM-DD HH24:MI:SS');
        v_czas := TO_TIMESTAMP(p_data_czas, 'YYYY-MM-DD HH24:MI:SS');
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20501, 'Niepoprawny formot daty i czasu. Użyj formatu: YYYY-MM-DD HH24:MI:SS');
    END;

    -- aktualizacja rozkładu i podrozy
    
    
    OPEN rozklad_cursor;
    LOOP
        FETCH rozklad_cursor INTO v_rozklad_id;
        EXIT WHEN rozklad_cursor%NOTFOUND;

        UPDATE Rozklad
        SET Czas_przyjazdu = v_czas,
            Czas_odjazdu = v_czas
        WHERE Id = v_rozklad_id;
    END LOOP;
    CLOSE rozklad_cursor;

    
    OPEN podroz_cursor;
    LOOP
        FETCH podroz_cursor INTO v_podroz_id;
        EXIT WHEN podroz_cursor%NOTFOUND;

        UPDATE Podroz
        SET DataWyjazdu = v_data
        WHERE Id = v_podroz_id;
    END LOOP;
    CLOSE podroz_cursor;

    
    DBMS_OUTPUT.PUT_LINE('Czasy w tabelach Rozklad i Podroz zostały zaktualizowane.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
END AktualizujCzasyKursor;


BEGIN
    AktualizujCzasyKursor('2025-01-05 10:00:00');
END;

call AktualizujCzasyKursor();

SELECT Id, 
       TO_CHAR(Czas_przyjazdu, 'YYYY-MM-DD HH24:MI:SS') AS Czas_przyjazdu, 
       TO_CHAR(Czas_odjazdu, 'YYYY-MM-DD HH24:MI:SS') AS Czas_odjazdu
FROM Rozklad
ORDER BY Id;


SELECT Id, 
       Czas_przyjazdu, 
       Czas_odjazdu
FROM Rozklad
ORDER BY Id;






-- procedura 2

CREATE OR REPLACE PROCEDURE WyszukajOsobyWPodanymMiescie(
    p_miasto IN VARCHAR2,  -- miasto
    p_data IN VARCHAR2 DEFAULT NULL -- Data jako string
) AS
    
    v_data DATE := NVL(TO_DATE(p_data, 'YYYY-MM-DD'), TRUNC(SYSDATE)); -- Trunc, bo nie jest potrzebny czas


    CURSOR podrz_cursor IS
        SELECT 
            o.Gmail AS Osoba,
            r.Czas_przyjazdu AS Godzina,
            a.Ulica AS Ulica_przystanku,
            p.Nazwa AS Nazwa_przystanku
        FROM 
            Podroz pod
        JOIN Osoba o ON pod.Osoba_Id = o.Id
        JOIN Rozklad r ON pod.Punkt_koncowy = r.Przystanek_Id
        JOIN Przystanek p ON r.Przystanek_Id = p.Id
        JOIN Adres a ON p.Adres_Id = a.Id
        JOIN Miasto m ON a.Miasto_Id = m.Id
        WHERE 
            m.Nazwa = p_miasto AND TRUNC(r.Czas_przyjazdu) = v_data;

    
    v_osoba VARCHAR2(50);
    v_godzina TIMESTAMP;
    v_ulica VARCHAR2(50);
    v_przystanek VARCHAR2(50);
BEGIN
    
    OPEN podrz_cursor;

    DBMS_OUTPUT.PUT_LINE('Osoby w mieście: ' || p_miasto || ' w dniu: ' || TO_CHAR(v_data, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('===============================================================');
    DBMS_OUTPUT.PUT_LINE('Osoba | Godzina | Ulica przystanku | Nazwa przystanku');
    DBMS_OUTPUT.PUT_LINE('===============================================================');

    -- Pobieranie danych z kursora i wypisywanie ich
    LOOP
        FETCH podrz_cursor INTO v_osoba, v_godzina, v_ulica, v_przystanek;
        EXIT WHEN podrz_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_osoba || ' | ' || TO_CHAR(v_godzina, 'HH24:MI:SS') || ' | ' || v_ulica || ' | ' || v_przystanek);
    END LOOP;

    
    CLOSE podrz_cursor;
EXCEPTION
    WHEN OTHERS THEN
        
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
END WyszukajOsobyWPodanymMiescie;


ACCEPT las_miasto PROMPT 'Podaj miasto';

ACCEPT las_data PROMPT 'Podaj date';

call WyszukajOsobyWPodanymMiescie(las_miasto, las_data);

call WyszukajOsobyWPodanymMiescie('Elbląg', '2025-01-22');

call WyszukajOsobyWPodanymMiescie('Warszawa');





-- procedura 3
CREATE OR REPLACE PROCEDURE add_line (
    p_line_name IN VARCHAR2,
    p_transport_name IN VARCHAR2
) AS
    v_transport_id INTEGER;
    v_new_id INTEGER;
BEGIN
    -- Sprawdź, czy transport o podanej nazwie istnieje
    SELECT Id
    INTO v_transport_id
    FROM Typ_transportu
    WHERE Typ_transportu = p_transport_name;

    -- oblicz nowy id
    SELECT NVL(MAX(Id), 0) + 1
    INTO v_new_id
    FROM Transport;

    -- Dodaj nową linię z obliczonym ID
    INSERT INTO Transport (Id, Linia, Typ_transportu_Id)
    VALUES (v_new_id, p_line_name, v_transport_id);

    DBMS_OUTPUT.PUT_LINE('Dodano nową linię: ' || p_line_name || ' dla transportu: ' || p_transport_name);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Transport o nazwie ' || p_transport_name || ' nie istnieje.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Wystąpił błąd: ' || SQLERRM);
END;



select * from typ_transportu;

BEGIN
    add_line('S2', 'Metro');
END;

-- dodanie nowej linii transportu
CREATE OR REPLACE TRIGGER check_duplicate_transport_line
BEFORE INSERT ON Transport
FOR EACH ROW
DECLARE
    v_count INTEGER;
BEGIN
    -- czy Typ_transportu_Id istnieje w tabeli Typ_transportu
    SELECT COUNT(*)
    INTO v_count
    FROM Typ_transportu
    WHERE Id = :NEW.Typ_transportu_Id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-200502, 'Podany Typ_transportu_Id nie istnieje.');
    END IF;

    -- czy linia o tej samej nazwie istnieje dla tego Typ_transportu_Id
    SELECT COUNT(*)
    INTO v_count
    FROM Transport
    WHERE Typ_transportu_Id = :NEW.Typ_transportu_Id AND Linia = :NEW.Linia;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20503, 'Taka linia już istnieje dla tego typu transportu.');
    END IF;
END;




INSERT INTO Transport (Id, Typ_transportu_Id, Linia)
VALUES (10, 1, 'M2'); -- Metro linia M2


INSERT INTO Transport (Id, Typ_transportu_Id, Linia)
VALUES (11, 2, 'M2'); -- Pociąg linia M2



--dodanie nowego maila
CREATE OR REPLACE TRIGGER check_new_person
BEFORE INSERT ON Osoba
FOR EACH ROW
DECLARE
    v_count INTEGER;
BEGIN
    
    SELECT COUNT(*)
    INTO v_count
    FROM Osoba
    WHERE Gmail = :NEW.Gmail;

    
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20025, 'Masz już konto z tym adresem e-mail.');
    END IF;

    
    IF SUBSTR(:NEW.Gmail, -10) != '@gmail.com' THEN
        RAISE_APPLICATION_ERROR(-20026, 'Dozwolone są tylko adresy e-mail z domeny @gmail.com.');
    END IF;
END;

INSERT INTO Osoba (Id, Gmail, Haslo)
VALUES (3, 'jacek.soplica@gmail.com', 'newpass');


INSERT INTO Osoba (Id, Gmail, Haslo)
VALUES (3, 'user@yandex.com', 'password123');





-- trigger 3
-- jesli jest powiazany z rozkladem jazdy to nie pozwoli usunac

CREATE OR REPLACE TRIGGER usunienciePrzystankaPowiazanego
BEFORE DELETE ON Przystanek
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    
    SELECT COUNT(*)
    INTO v_count
    FROM Rozklad r
    WHERE r.Przystanek_Id = :OLD.Id;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-23134, 'Nie można usunąć przystanku, ponieważ jest powiązany z rozkładem jazdy.');
    
    END IF;
END;



SELECT * FROM Przystanek;


DELETE FROM Przystanek WHERE Id = 5;

