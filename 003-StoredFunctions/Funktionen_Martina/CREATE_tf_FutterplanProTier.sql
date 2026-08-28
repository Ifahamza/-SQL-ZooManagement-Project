
USE [ZooManagement];
GO
-- =============================================
-- Author: Martina Kratt
-- Create date: 25.08.2026
-- Description: Erstellt Tabellenwertfunktion die Futterplanhistorie eines Tiers zurückgibt
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[tf_FutterplanProTier]
(
    @TierID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        dbo.Tier.TierID,
        dbo.Tier.Name AS Tiername,
        dbo.Tierart.TierartID,  
        dbo.Futter.FutterID,
        dbo.Futter.Futtername,
        dbo.Futter.Futterart,
        dbo.Futterplan.MengeProTier,
        dbo.Futtereinheit.Einheit,
        dbo.Futterplan.FuetterungenProTag,
        dbo.Fuetterung.Zeitpunkt AS Fuetterungszeitpunkt,
        dbo.Fuetterung.Menge AS TatsächlicheMenge
    FROM dbo.Tier 

    INNER JOIN dbo.Tierart 
        ON dbo.Tier.TierartID = dbo.Tierart.TierartID

    INNER JOIN dbo.Futterplan 
        ON dbo.Tierart.TierartID = dbo.Futterplan.TierartID

    INNER JOIN dbo.Futter
        ON dbo.Futterplan.FutterID = dbo.Futter.FutterID

    INNER JOIN dbo.Futtereinheit
        ON dbo.Futter.FuttereinheitID = dbo.Futtereinheit.FuttereinheitID

    LEFT JOIN dbo.Fuetterung 
        ON dbo.Fuetterung.TierID = dbo.Tier.TierID
        AND dbo.Fuetterung.FutterID = dbo.Futterplan.FutterID

    WHERE dbo.Tier.TierID = @TierID
);
GO