USE [ZooManagement]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		von der Bank, Maximilian
-- Create date: 25.08.2026
-- Description:	Aktualisiert das Gewicht eines Tieres. Durch das Update
--              wird automatisch der Trigger tr_TierGewichtPruefen
--              ausgelöst, der bei starker Abweichung vom Tierart-
--              Durchschnitt eine Warnung protokolliert. Diese Prozedur
--              liest anschließend die neueste Warnung (falls vorhanden)
--              aus und gibt sie über einen OUTPUT-Parameter zurück.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.sp_TierGewichtAktualisieren
(
    @TierID INT,                                    
    @NeuesGewicht DECIMAL(10,2),                   
    @Feedback NVARCHAR(200) OUTPUT    
)
AS
BEGIN
    SET NOCOUNT ON

    IF NOT EXISTS (SELECT 1 FROM dbo.Tier WHERE TierID = @TierID)
    BEGIN
        SET @Feedback = N'Fehler: Das angegebene Tier existiert nicht.';
        RETURN;
    END

    -- Gewicht des angegebenen Tieres aktualisieren
    -- (löst den AFTER-UPDATE-Trigger tr_TierGewichtPruefen aus)
    UPDATE dbo.Tier
    SET Gewicht = @NeuesGewicht
    WHERE TierID = @TierID

    -- Neuesten Eintrag in der Tabelle TierLogGewichtWarnung für dieses Tier auslesen, der ggf. gerade durch den Trigger erzeugt wurde, 
    -- und in den OUTPUT-Parameter schreiben. Gibt es keine Warnung, bleibt der Parameter NULL (Gewicht im Rahmen)
    SELECT TOP 1 @Feedback = Warnungstext
    FROM dbo.TierLogGewichtWarnung
    WHERE TierID = @TierID
    ORDER BY WarnungID DESC
END
GO
