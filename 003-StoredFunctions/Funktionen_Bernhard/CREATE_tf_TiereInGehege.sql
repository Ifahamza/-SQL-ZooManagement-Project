USE ZooManagement;
GO
-- =======================================================================================================================================
-- Author:		Bernhard Ehnle
-- Create date: 26.8.2026
-- Description:	Diese Tabellenwertfunktion gibt die Anzahl der Tiere pro Gehege aus
-- =======================================================================================================================================

CREATE OR ALTER FUNCTION dbo.tf_TiereImGehege
(
    @GehegeID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        Tier.TierID,
        Tier.Name,
        Tierart.Tierartname,
        Tier.Geburtsdatum,
        Tier.Geschlecht
    FROM dbo.Tier
    INNER JOIN dbo.Tierart
        ON Tier.TierartID = Tierart.TierartID
    WHERE Tier.GehegeID = @GehegeID
);
GO