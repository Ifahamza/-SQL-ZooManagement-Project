USE [ZooManagement]
GO

/****** Objekt:  Trigger [dbo].[trg_Tierbetreuung_Berechtigung]    Skriptdatum: 26.08.2026 09:47:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Hamza Ifa
-- Create date: 26.08.2026
-- Description: AFTER INSERT Trigger auf der 
--              Tabelle Tierbetreuung. Dient als 
--              letztes Sicherheitsnetz (Compliance/
--              Tierschutz). Verhindert automatisch,
--              dass unberechtigtes Personal (z.B.
--              Verwaltung, Techniker) als Tier-
--              betreuer eingetragen wird.
-- =============================================

CREATE TRIGGER [dbo].[trg_Tierbetreuung_Berechtigung]
ON [dbo].[Tierbetreuung]
AFTER INSERT -- Wird ausgelöst, NACHDEM der INSERT-Vorgang versucht wurde
AS
BEGIN
    -- Verhindert die Rückgabe der Anzahl betroffener Zeilen (verbessert Performance)
    SET NOCOUNT ON;

    -- Prüfen, ob einer der neu eingefügten Mitarbeiter NICHT berechtigt ist.
    -- Die virtuelle Tabelle 'inserted' enthält alle Zeilen, die gerade neu hinzugefügt wurden.
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Mitarbeiter m ON i.MitarbeiterID = m.MitarbeiterID
        WHERE m.Mitarbeitertyp NOT IN ('Tierpfleger', 'Tierpflegerin', 'Revierleiter')
    )
    BEGIN
        -- Gib eine Fehlermeldung an die aufrufende Anwendung zurück.
        -- (16 = Schweregrad für Benutzerfehler, 1 = Status)
        RAISERROR('Fehler: Nur Tierpfleger und Revierleiter dürfen Tiere betreuen! Verstoß gegen Tierschutzbestimmungen.', 16, 1);
        
        -- Mache den gesamten INSERT-Vorgang rückgängig. 
        -- Die Daten werden NICHT in die Tabelle geschrieben.
        ROLLBACK TRANSACTION;
        
        -- Beende den Trigger vorzeitig
        RETURN;
    END
END;
GO

-- Stelle sicher, dass der Trigger nach der Erstellung auch aktiviert ist
ALTER TABLE [dbo].[Tierbetreuung] ENABLE TRIGGER [trg_Tierbetreuung_Berechtigung]
GO