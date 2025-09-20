

DROP PROCEDURE IF EXISTS AktualizujCzasyKursor;


-- aktualizuje daty i czas przyjazdu i odjazdu
-- Procedura 1

CREATE PROCEDURE AktualizujCzasyKursor
    @p_data_czas NVARCHAR(19) = NULL -- YYYY-MM-DD HH24:MI:SS
AS
BEGIN
    BEGIN TRY
        -- Domyślny parametr daty i czasu
        IF @p_data_czas IS NULL
            SET @p_data_czas = CONVERT(NVARCHAR(19), GETDATE(), 120);

       
        DECLARE @v_rozklad_id INT;
        DECLARE @v_podroz_id INT;
        DECLARE @v_data DATE;
        DECLARE @v_czas DATETIME;

        -- Konwersja parametru na DATE i DATETIME
        BEGIN TRY
            SET @v_data = CAST(@p_data_czas AS DATE);
            SET @v_czas = CAST(@p_data_czas AS DATETIME);
        END TRY
        BEGIN CATCH
            RAISERROR ('Niepoprawny format daty i czasu. Użyj formatu: YYYY-MM-DD HH24:MI:SS', 16, 1);
            RETURN;
        END CATCH;

        -- Aktualizacja tabeli Rozklad
        DECLARE rozklad_cursor CURSOR FOR
            SELECT Id FROM Rozklad;

        OPEN rozklad_cursor;
        FETCH NEXT FROM rozklad_cursor INTO @v_rozklad_id;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE Rozklad
            SET Czas_przyjazdu = @v_czas,
                Czas_odjazdu = @v_czas
            WHERE Id = @v_rozklad_id;

            FETCH NEXT FROM rozklad_cursor INTO @v_rozklad_id;
        END;

        CLOSE rozklad_cursor;
        DEALLOCATE rozklad_cursor;

        -- Aktualizacja tabeli Podroz
        DECLARE podroz_cursor CURSOR FOR
            SELECT Id FROM Podroz;

        OPEN podroz_cursor;
        FETCH NEXT FROM podroz_cursor INTO @v_podroz_id;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE Podroz
            SET DataWyjazdu = @v_data
            WHERE Id = @v_podroz_id;

            FETCH NEXT FROM podroz_cursor INTO @v_podroz_id;
        END;

        CLOSE podroz_cursor;
        DEALLOCATE podroz_cursor;

        PRINT 'Czasy w tabelach Rozklad i Podroz zostały zaktualizowane.';
    END TRY
    BEGIN CATCH
        -- pobier informacji o błędzie i zgłoszenie go
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;

EXEC AktualizujCzasyKursor '2025-01-05 10:00:00';

EXEC AktualizujCzasyKursor;

SELECT Id, 
       DataWyjazdu
FROM Podroz
ORDER BY Id;



-- procedura 2
-- szukamy osoby która miała punkt końcowy w tym mieście i w tym dniu

DROP PROCEDURE IF EXISTS WyszukajOsobyWPodanymMiescie;

CREATE PROCEDURE WyszukajOsobyWPodanymMiescie
    @Miasto NVARCHAR(50),
    @Data NVARCHAR(10) = NULL -- Data jako string w formacie YYYY-MM-DD
AS
BEGIN
    

    DECLARE @DataParsed DATE;

    
    SET @DataParsed = ISNULL(CONVERT(DATE, @Data, 120), CONVERT(DATE, GETDATE()));

    
    DECLARE @Osoba NVARCHAR(50);
    DECLARE @Godzina TIME;
    DECLARE @Ulica NVARCHAR(50);
    DECLARE @Przystanek NVARCHAR(50);

    
    DECLARE podrz_cursor CURSOR FOR
        SELECT 
            o.Gmail AS Osoba,
            CONVERT(TIME, r.Czas_przyjazdu) AS Godzina,
            a.Ulica AS Ulica_przystanku,
            p.Nazwa AS Nazwa_przystanku
        FROM 
            Podroz pod
        INNER JOIN Osoba o ON pod.Osoba_Id = o.Id
        INNER JOIN Rozklad r ON pod.Punkt_koncowy = r.Przystanek_Id
        INNER JOIN Przystanek p ON r.Przystanek_Id = p.Id
        INNER JOIN Adres a ON p.Adres_Id = a.Id
        INNER JOIN Miasto m ON a.Miasto_Id = m.Id
        WHERE 
            m.Nazwa = @Miasto AND CAST(r.Czas_przyjazdu AS DATE) = @DataParsed;

    
    OPEN podrz_cursor;

    PRINT 'Osoby w mieście: ' + @Miasto + ' w dniu: ' + CONVERT(VARCHAR, @DataParsed, 120);
    PRINT '===============================================================';
    PRINT 'Osoba | Godzina | Ulica przystanku | Nazwa przystanku';
    PRINT '===============================================================';

    
    FETCH NEXT FROM podrz_cursor INTO @Osoba, @Godzina, @Ulica, @Przystanek;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT @Osoba + ' | ' + CONVERT(VARCHAR, @Godzina, 108) + ' | ' + @Ulica + ' | ' + @Przystanek;

        FETCH NEXT FROM podrz_cursor INTO @Osoba, @Godzina, @Ulica, @Przystanek;
    END;

    
    CLOSE podrz_cursor;
    DEALLOCATE podrz_cursor;
END;



EXEC WyszukajOsobyWPodanymMiescie 'Elbląg', '2025-01-22';

EXEC WyszukajOsobyWPodanymMiescie 'Warszawa';




-- procedura 3
-- dodaje nową linie transportu

DROP PROCEDURE IF EXISTS AddLine;

CREATE PROCEDURE AddLine
    @p_line_name NVARCHAR(50),
    @p_transport_name NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        
        DECLARE @v_transport_id INT;
        DECLARE @v_new_id INT;

        
        SELECT @v_transport_id = Id
        FROM Typ_transportu
        WHERE Typ_transportu = @p_transport_name;

        
        IF @v_transport_id IS NULL
        BEGIN
            RAISERROR ('Transport o nazwie %s nie istnieje.', 16, 1, @p_transport_name);
            RETURN;
        END

        
        SELECT @v_new_id = ISNULL(MAX(Id), 0) + 1
        FROM Transport;

        
        INSERT INTO Transport (Id, Linia, Typ_transportu_Id)
        VALUES (@v_new_id, @p_line_name, @v_transport_id);

        
        PRINT 'Dodano nową linię: ' + @p_line_name + ' dla transportu: ' + @p_transport_name;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR ('Wystąpił błąd: %s', @ErrorSeverity, @ErrorState, @ErrorMessage);
    END CATCH
END;


EXEC AddLine 'M2', 'Metro';

SELECT * FROM Transport;


-- trigger 1
-- jeśli jest nazwa linii i ten typ transportu to zle

DROP TRIGGER IF EXISTS sprawdzDuplikatyLiniiTransportu;

CREATE TRIGGER sprawdzDuplikatyLiniiTransportu
ON Transport
INSTEAD OF INSERT
AS
BEGIN
    

    -- Sprawdzenie Typ_transportu_Id w tabeli Typ_transportu
    IF EXISTS (
        SELECT 1
        FROM Inserted i
        LEFT JOIN Typ_transportu t
        ON i.Typ_transportu_Id = t.Id
        WHERE t.Id IS NULL
    )
    BEGIN
        RAISERROR ('Podany Typ_transportu_Id nie istnieje.', 16, 1);
        RETURN;
    END;

    -- Sprawdzenie, czy linia o tej samej nazwie już istnieje dla tego Typ_transportu_Id
    IF EXISTS (
        SELECT 1
        FROM Inserted i
        JOIN Transport t
        ON i.Typ_transportu_Id = t.Typ_transportu_Id AND i.Linia = t.Linia
    )
    BEGIN
        RAISERROR ('Taka linia już istnieje dla tego typu transportu.', 16, 1);
        RETURN;
    END;

    -- Jeśli warunki są spełnione, wstaw wiersze
    INSERT INTO Transport (Id, Typ_transportu_Id, Linia)
    SELECT Id, Typ_transportu_Id, Linia
    FROM Inserted;

    PRINT 'Dodano nową linię transportu.';
END;



INSERT INTO Transport (Id, Typ_transportu_Id, Linia)
VALUES (10, 1, 'M2'); -- Metro linia M2 

INSERT INTO Transport (Id, Typ_transportu_Id, Linia)
VALUES (11, 99, 'M2'); -- Nieistniejący Typ_transportu_Id


-- Trigger 2
-- sprawdzanie maila

DROP TRIGGER IF EXISTS sprawdzNowaOsobe;

CREATE TRIGGER sprawdzNowaOsobe
ON Osoba
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @v_count INT;
    DECLARE @gmail NVARCHAR(255);

    -- Pętla dla każdego rekordu wstawianego
    DECLARE insert_cursor CURSOR FOR
    SELECT Gmail FROM inserted;

    OPEN insert_cursor;

    FETCH NEXT FROM insert_cursor INTO @gmail;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Sprawdź, czy istnieje już taki Gmail
        SELECT @v_count = COUNT(*)
        FROM Osoba
        WHERE Gmail = @gmail;

        IF @v_count > 0
        BEGIN
            RAISERROR('Masz już konto z tym adresem e-mail: %s', 16, 1, @gmail);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Sprawdź, czy Gmail kończy się na @gmail.com
        IF RIGHT(@gmail, 10) != '@gmail.com'
        BEGIN
            RAISERROR('Dozwolone są tylko adresy e-mail z domeny @gmail.com: %s', 16, 1, @gmail);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        FETCH NEXT FROM insert_cursor INTO @gmail;
    END

    CLOSE insert_cursor;
    DEALLOCATE insert_cursor;

    -- Wstawienie danych, jeśli wszystkie warunki są spełnione
    INSERT INTO Osoba (Id, Gmail, Haslo)
    SELECT Id, Gmail, Haslo
    FROM inserted;
END;

INSERT INTO Osoba (Id, Gmail, Haslo)
VALUES (4, 'jacek.soplica@gmail.com', 'newpass');

INSERT INTO Osoba (Id, Gmail, Haslo)
VALUES (5, 'user@yandex.com', 'password123');

select * from Osoba;

delete from osoba where Id = 4;


-- trigger 3
-- jesli jest powiazany z rozkladem jazdy to nie pozwoli usunac

DROP TRIGGER IF EXISTS usunienciePrzystankaPowiazanego;

CREATE TRIGGER usunienciePrzystankaPowiazanego
ON Przystanek
INSTEAD OF DELETE
AS
BEGIN
    -- czy jest powiązany przystanek
    IF EXISTS (
        SELECT 1
        FROM Rozklad r
        INNER JOIN deleted d ON r.Przystanek_Id = d.Id
    )
    BEGIN
        RAISERROR('Nie można usunąć przystanku, ponieważ jest powiązany z rozkładem jazdy.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    
END;

select * from Przystanek

DELETE FROM Przystanek
WHERE Id = 5;