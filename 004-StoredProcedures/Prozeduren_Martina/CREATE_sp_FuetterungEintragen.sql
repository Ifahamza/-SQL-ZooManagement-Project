

USE [ZooManagement]
GO

/****** Objekt:  StoredProcedure [dbo].[sp_FuetterungEintragen]    Skriptdatum: 25.08.2026 12:25:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Martina Kratt
-- Create date: 25.08.2026
-- Description: Stored procedure [sp_FuetterungEintragen] nimmt TierID,FutterID, MitarbeiterID, Menge als Input und prüft ob die Werte gueltig sind,
--der Mitabeiter laut dbo.Tiebetreuung das Tier fuettern darf, das Tier laut Futterplan dieses Futter essen darf
--und ob gneug von dem Futter in geüwnschter mEnge im Lagerbestand vorhanden ist ( über dbo.sf_IstFutterbestandAusreichend)
--Wenn ja wird FUetterung mit diesen Daten in Tabelle dbo.Fuetterung mit aktuellem Zeitpunkt eingetragen

-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_FuetterungEintragen]
(
    @TierID INT,
    @FutterID INT,
    @MitarbeiterID INT,
    @Menge DECIMAL(10,2),
    @Fehlermeldung NVARCHAR(500) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    SET @Fehlermeldung = NULL;

    BEGIN TRY

        ------------------------------------------------------------
        -- 1. Menge prüfen
        ------------------------------------------------------------

        IF @Menge <= 0
        BEGIN
            SET @Fehlermeldung =
                N'Die Menge muss größer als 0 sein.';
            RETURN 1;
        END;


        ------------------------------------------------------------
        -- 2. Prüfen, ob das Tier existiert
        ------------------------------------------------------------

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Tier
            WHERE TierID = @TierID
        )
        BEGIN
            SET @Fehlermeldung =
                N'Das angegebene Tier existiert nicht.';
            RETURN 2;
        END;


        ------------------------------------------------------------
        -- 3. Prüfen, ob das Futter existiert
        ------------------------------------------------------------

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Futter
            WHERE FutterID = @FutterID
        )
        BEGIN
            SET @Fehlermeldung =
                N'Das angegebene Futter existiert nicht.';
            RETURN 3;
        END;


        ------------------------------------------------------------
        -- 4. Prüfen, ob der Mitarbeiter existiert
        ------------------------------------------------------------

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Mitarbeiter
            WHERE MitarbeiterID = @MitarbeiterID
        )
        BEGIN
            SET @Fehlermeldung =
                N'Der angegebene Mitarbeiter existiert nicht.';
            RETURN 4;
        END;
         ------------------------------------------------------------
        -- 5. Prüfen, ob der Mitarbeiter dieses Tier betreut
        ------------------------------------------------------------
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Tierbetreuung
            WHERE TierID = @TierID
              AND MitarbeiterID = @MitarbeiterID
        )
        BEGIN
            SET @Fehlermeldung =
                N'Der Mitarbeiter ist nicht für dieses Tier zuständig.';
            RETURN 5;
        END;

        ------------------------------------------------------------
        -- 6. Prüfen, ob das Futter für das Tier vorgesehen ist
        --    Der aktuelle Futterplan der Tierart wird berücksichtigt.
        ------------------------------------------------------------

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Tier
            INNER JOIN dbo.Futterplan
                ON dbo.Tier.TierartID = dbo.Futterplan.TierartID
            WHERE dbo.Tier.TierID = @TierID
              AND dbo.Futterplan.FutterID = @FutterID
              AND dbo.Futterplan.GueltigAb <= CAST(GETDATE() AS date)
              AND (
                    dbo.Futterplan.GueltigBis IS NULL
                    OR dbo.Futterplan.GueltigBis >= CAST(GETDATE() AS date)
                  )
        )
        BEGIN
            SET @Fehlermeldung =
                N'Das angegebene Futter ist für dieses Tier laut Futterplan nicht vorgesehen.';
            RETURN 6;
        END;

        ------------------------------------------------------------
        -- 7. Prüfen, ob genügend Futter vorhanden ist
        --    Verwende Skalarwertfunkmtion  dbo.sf_IstFutterbestandAusreichend
        ------------------------------------------------------------

        IF dbo.sf_IstFutterbestandAusreichend(@FutterID, @Menge) = 0
        BEGIN
            SET @Fehlermeldung =
                N'Der Lagerbestand reicht für diese Fütterung nicht aus.';
            RETURN 7;
        END;


        ------------------------------------------------------------
        -- 8. Fütterung eintragen
        ------------------------------------------------------------

        INSERT INTO dbo.Fuetterung
        (
            TierID,
            FutterID,
            MitarbeiterID,
            Zeitpunkt,
            Menge
        )
        VALUES
        (
            @TierID,
            @FutterID,
            @MitarbeiterID,
            SYSDATETIME(),
            @Menge
        );


        ------------------------------------------------------------
        -- 9. Erfolgsmeldung
        ------------------------------------------------------------

        SET @Fehlermeldung =
            N'Fütterung wurde erfolgreich eingetragen.';

        RETURN 0;

    END TRY

    BEGIN CATCH

        SET @Fehlermeldung =
            ERROR_MESSAGE();

        RETURN 99;

    END CATCH;
END;
GO


