USE [ZooManagement]
GO

/****** Objekt:  StoredProcedure [dbo].[sp_TierZuweisen]    Skriptdatum: 26.08.2026 10:35:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Hamza Ifa
-- Create date: 26.08.2026
-- Description: Weist einem Mitarbeiter ein Tier 
--              zu. Enthält 5 Sicherheitsprüfungen:
--              1. Existenz (Mitarbeiter)
--              2. Existenz (Tier)
--              3. Berechtigung (nur Tierpfleger)
--              4. Verfügbarkeit (keine Doppel-
--                 zuweisung)
--              5. Überlastungsschutz (Normal: 12,
--                 Notfall: 15 Tiere)
--              Nutzt die Funktion sf_Anzahl-
--              BetreuterTiere. Gibt Erfolg/Fehler
--              über OUTPUT-Parameter zurück.
-- =============================================

CREATE PROCEDURE [dbo].[sp_TierZuweisen]
(
    @MitarbeiterID INT,           -- ID des Mitarbeiters, dem das Tier zugewiesen werden soll
    @TierID INT,                  -- ID des Tieres, das zugewiesen werden soll
    @IstNotfall BIT = 0,          -- 0 = Normalfall (Limit 12), 1 = Notfall (Limit 15)
    @Erfolg BIT OUTPUT,           -- OUTPUT: 1 = Erfolg, 0 = Fehler
    @Meldung NVARCHAR(255) OUTPUT -- OUTPUT: Detailierte Erfolgs- oder Fehlermeldung
)
AS
BEGIN
    -- Verhindert, dass die Anzahl der betroffenen Zeilen zurückgegeben wird
    -- (verbessert die Performance und vermeidet unnötige Netzwerk-Traffic)
    SET NOCOUNT ON;
    
    -- Initialisiere OUTPUT-Parameter mit Standardwerten (Fehlerfall)
    SET @Erfolg = 0;
    SET @Meldung = '';

    -- ========================================
    -- SICHERHEITSPRÜFUNGEN (Business-Logik)
    -- ========================================

    -- 1. Prüfung: Existiert der Mitarbeiter?
    -- Verhindert, dass nicht-existente Mitarbeiter zugewiesen werden
    IF NOT EXISTS (SELECT 1 FROM Mitarbeiter WHERE MitarbeiterID = @MitarbeiterID)
    BEGIN
        SET @Meldung = 'Fehler: Mitarbeiter-ID existiert nicht.';
        RETURN; -- Prozedur sofort beenden
    END

    -- 2. Prüfung: Existiert das Tier?
    -- Verhindert, dass nicht-existente Tiere zugewiesen werden
    IF NOT EXISTS (SELECT 1 FROM Tier WHERE TierID = @TierID)
    BEGIN
        SET @Meldung = 'Fehler: Tier-ID existiert nicht.';
        RETURN; -- Prozedur sofort beenden
    END

    -- 3. Prüfung: Ist der Mitarbeiter berechtigt?
    -- Nur Tierpfleger und Revierleiter dürfen Tiere betreuen (Compliance/Tierschutz)
    DECLARE @Typ NVARCHAR(50);
    SELECT @Typ = Mitarbeitertyp FROM Mitarbeiter WHERE MitarbeiterID = @MitarbeiterID;
    
    IF @Typ NOT IN ('Tierpfleger', 'Tierpflegerin', 'Revierleiter')
    BEGIN
        SET @Meldung = 'Fehler: Mitarbeiter ist kein Tierpfleger/Revierleiter. Keine Berechtigung!';
        RETURN; -- Prozedur sofort beenden
    END

    -- 4. Prüfung: Wird das Tier bereits aktiv betreut?
    -- Ein Tier darf immer nur einen aktiven Betreuer haben (BisDatum IS NULL)
    IF EXISTS (SELECT 1 FROM Tierbetreuung WHERE TierID = @TierID AND BisDatum IS NULL)
    BEGIN
        SET @Meldung = 'Fehler: Dieses Tier wird bereits von einem anderen Pfleger betreut.';
        RETURN; -- Prozedur sofort beenden
    END

    -- 5. Prüfung: Überlastungsschutz (Business-Logik Highlight)
    -- Verhindert Überlastung der MA  und sichert Tierwohl durch maximale Tieranzahl pro Pfleger
    DECLARE @AktuelleAnzahl INT;  -- Aktuelle Anzahl der betreuten Tiere
    DECLARE @MaxLimit INT;        -- Maximale erlaubte Anzahl (abhängig von Notfall)

    -- Hole aktuelle Anzahl der Tiere über eigene Skalarwertfunktion
    SET @AktuelleAnzahl = dbo.sf_AnzahlBetreuterTiere(@MitarbeiterID);

    -- Bestimme das Limit basierend auf dem Notfall-Parameter
    IF @IstNotfall = 1
        SET @MaxLimit = 15; -- Notfall: bis zu 15 Tiere erlaubt (z.B. bei Krankheit eines Kollegen)
    ELSE
        SET @MaxLimit = 12; -- Normalfall: max. 12 Tiere für Tierwohl

    -- Prüfe ob das Limit bereits erreicht ist
    IF @AktuelleAnzahl >= @MaxLimit
    BEGIN
        SET @Meldung = 'Fehler: Überlastung! Mitarbeiter hat bereits ' + CAST(@AktuelleAnzahl AS NVARCHAR) + ' Tiere. (Limit: ' + CAST(@MaxLimit AS NVARCHAR) + ')';
        RETURN; -- Prozedur sofort beenden
    END

    -- ========================================
    -- AKTION: Zuweisung durchführen
    -- ========================================
    
    -- Alle Prüfungen bestanden: Neue Betreuung in Datenbank einfügen
    -- VonDatum = heute, BisDatum = NULL (unbegrenzt/aktiv)
    INSERT INTO Tierbetreuung (MitarbeiterID, TierID, VonDatum, BisDatum)
    VALUES (@MitarbeiterID, @TierID, GETDATE(), NULL);

    -- Erfolg melden: OUTPUT-Parameter setzen
    SET @Erfolg = 1;
    SET @Meldung = 'Erfolg: Tier ' + CAST(@TierID AS NVARCHAR) + ' wurde erfolgreich zugewiesen.';
    
    -- Prozedur erfolgreich beendet
END;
GO