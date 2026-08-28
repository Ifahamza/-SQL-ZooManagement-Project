USE ZooManagement;
GO
-- =============================================
-- Author:		Javier Montanez
-- Create date: August 25th 2026
-- Description (DE):
-- Erstellunds des Stored Procedure sp_UntersuchungEintragen. Sie trägt eine neue
-- Untersuchung sicher ein, prüft ob TierID existiert, 
-- ob das Datum nicht in der Zukunft liegt und setzt automatisch
-- den nächsten Termin per OUTPUT-Parameter basierend auf dem Tieralter.
-- Description (EN):
-- Creating the stored procedure sp_UntersuchungEintragen.
-- It safely inserts a new examination, validates TierID and that the date is not in the future, 
-- calculates the animal's age via sf_BerechneTierAlter, and automatically 
-- sets the next appointment date via an OUTPUT parameter.
-- =============================================
DROP PROCEDURE IF EXISTS dbo.sp_UntersuchungEintragen;
GO
CREATE PROCEDURE dbo.sp_UntersuchungEintragen
    @TierID INT,
    @TierarztID INT,
    @Untersuchungsdatum DATE,
    @Untersuchungsart NVARCHAR(100),
    @Diagnose NVARCHAR(255),
    @Kosten DECIMAL(10,2) = NULL,
    @NaechsterTermin DATE = NULL OUTPUT -- OUTPUT, um zu sehen, welches Datum automatisch festgelegt wurde
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Business-Logik: Datum in der Zukunft?
    IF @Untersuchungsdatum > CAST(GETDATE() AS DATE)
    BEGIN
        RAISERROR('Fehler: Untersuchungsdatum darf nicht in der Zukunft liegen.', 16, 1);
        RETURN;
    END

    -- 2. Prüfen ob Tier existiert
    IF NOT EXISTS (SELECT 1 FROM Tier WHERE TierID = @TierID)
    BEGIN
        RAISERROR('Fehler: TierID existiert nicht.', 16, 1);
        RETURN;
    END

    -- 3. Business-Logik: Senioren-Vorsorge mit deiner Skalarfunktion!
    DECLARE @Alter INT = dbo.sf_BerechneTierAlter(@TierID);

    -- Wenn kein Termin übergeben wurde, automatisch setzen
    IF @NaechsterTermin IS NULL
    BEGIN
        IF @Alter > 15
            SET @NaechsterTermin = DATEADD(MONTH, 3, @Untersuchungsdatum); -- Senior: alle 3 Monate
        ELSE
            SET @NaechsterTermin = DATEADD(MONTH, 12, @Untersuchungsdatum); -- Normal: 1x pro Jahr
    END

    -- 4. Einfügen
    INSERT INTO Untersuchung (TierID, TierarztID, Untersuchungsdatum, Untersuchungsart, Diagnose, Kosten, NaechsterTermin)
    VALUES (@TierID, @TierarztID, @Untersuchungsdatum, @Untersuchungsart, @Diagnose, @Kosten, @NaechsterTermin);

    PRINT CONCAT('Untersuchung eingetragen. Nächster Termin: ', CONVERT(VARCHAR, @NaechsterTermin, 104), ' (Alter Tier: ', @Alter, ' Jahre)');
END;
GO

-- SUCCESS OF THIS SCRIPT (01_create):
-- Creates the stored procedure dbo.sp_UntersuchungEintragen.
-- It encapsulates the INSERT into the Untersuchung table and ensures
-- that only valid examinations are recorded.

-- ERFOLG DIESES SKRIPTS (01_create):
-- Erstellt die Stored Procedure dbo.sp_UntersuchungEintragen.
-- Sie kapselt das INSERT in die Tabelle Untersuchung und stellt sicher, 
-- dass nur gültige Untersuchungen eingetragen werden.