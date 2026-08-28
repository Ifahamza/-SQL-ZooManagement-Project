USE ZooManagement;
GO
-- =======================================================================================================================================
-- Author:		Bernhard Ehnle
-- Create date: 26.8.2026
-- Description:	Prozedur um Tiere in andere Gehege zu verschieben, es muss die TierID, ZeilgehegeID übergeben werden
-- Es finden folgende Prüfungen statt:
-- - ob das angegebene Tier exisitert
-- - ob das Zeilgehege existiert und aktiv ist
-- - ob sich das Tier bereits in diesem Gehege befindet
-- - ob die Tierart für das Gehege zugelassen ist
-- =======================================================================================================================================


CREATE OR ALTER PROCEDURE dbo.sp_TierInGehegeVerlegen
    @TierID          INT,
    @ZielGehegeID    INT,
    @Erfolg          BIT OUTPUT,
    @Feedback        NVARCHAR(500) OUTPUT
AS
BEGIN

    DECLARE @AltesGehegeID INT;
    DECLARE @TierartID INT;
    DECLARE @FreiePlaetze INT;
    DECLARE @GehegeStatus BIT;
    DECLARE @AnzahlTiereImZielgehege INT;

    BEGIN TRY

        SET @Erfolg = 0;
        SET @Feedback = NULL;

        /* 1. Prüfen, ob das Tier existiert */
        SELECT
            @AltesGehegeID = Tier.GehegeID,
            @TierartID = Tier.TierartID
        FROM dbo.Tier
        WHERE Tier.TierID = @TierID;

        IF @TierartID IS NULL
        BEGIN
            ;THROW 50001, N'Das angegebene Tier existiert nicht.', 1;
        END;

        /* 2. Prüfung ob Gehege existiert */
        SELECT @GehegeStatus = Gehege.Status
        FROM dbo.Gehege 
        WHERE Gehege.GehegeID = @ZielGehegeID;

        IF @GehegeStatus IS NULL
        BEGIN
            ;THROW 50002, N'Das angegebene Zielgehege existiert nicht.', 1;
        END;

        /* 3. Tier befindet sich bereits im Zielgehege */
        IF @AltesGehegeID = @ZielGehegeID
        BEGIN
            ;THROW 50003, N'Das Tier befindet sich bereits in diesem Gehege.', 1;
        END;

        /* 4. Zielgehege muss aktiv sein */
        IF @GehegeStatus = 0
        BEGIN
            ;THROW 50004, N'Das Zielgehege ist aktuell nicht aktiv.', 1;
        END;

        /* 5. Tierart muss für den Gehegetyp zugelassen sein */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Gehege
            INNER JOIN dbo.TierartGehegeTyp
                ON Gehege.GehegeTypID =
                    TierartGehegeTyp.GehegeTypID
            WHERE Gehege.GehegeID = @ZielGehegeID
                AND TierartGehegeTyp.TierartID = @TierartID
        )
        BEGIN
            ;THROW 50005,
                N'Die Tierart ist für den Gehegetyp nicht zugelassen.',
                1;
        END;

        /* 6. Skalarwertfunktion verwenden um freie Plätze pro Gehege zu erhalten */
        SET @FreiePlaetze =
            dbo.sf_BerechneFreiePlaetze(@ZielGehegeID);

        IF @FreiePlaetze <= 0
        BEGIN
            ;THROW 50006,
                N'Das Zielgehege ist vollständig belegt.',
                1;
        END;

        /* 7. Tier in das Zielgehege verlegen */
        UPDATE dbo.Tier
        SET GehegeID = @ZielGehegeID
        WHERE TierID = @TierID;

         /* Verwendeung Tabellenwertfunktion um die Anzahl der Tiere im Gehege zu bestimmen */
        SELECT @AnzahlTiereImZielgehege = COUNT(*)
        FROM dbo.tf_TiereImGehege(@ZielGehegeID);

         /* Ausgabe ob Verlegung erfolgreich war und wieviele Tiere jetzt im Zielgehege sind */
        SET @Erfolg = 1;
        SET @Feedback =
            N'Das Tier wurde erfolgreich verlegt. Im Zielgehege befinden sich jetzt '
            + CONVERT(NVARCHAR(10), @AnzahlTiereImZielgehege)
            + N' Tiere.';

        --SELECT *
        --FROM dbo.tf_TiereImGehege(@ZielGehegeID)
        --ORDER BY Name;

    END TRY

    BEGIN CATCH

        SET @Erfolg = 0;

        SET @Feedback =
            ERROR_MESSAGE()
            + N' Fehlernummer: '
            + CONVERT(NVARCHAR(10), ERROR_NUMBER());
    END CATCH;
END;
GO