--Create Berechnung freie Plätze
USE ZooManagement;
GO

-- =======================================================================================================================================
-- Author:		Bernhard Ehnle
-- Create date: 26.8.2026
-- Description:	Diese Skalarwertfunktion berechnet die freien Plätze für ein Gehege, GehegeID muss übergeben werden
-- =======================================================================================================================================

CREATE OR ALTER FUNCTION dbo.sf_BerechneFreiePlaetze
(
    @GehegeID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @FreiePlaetze INT;

    SELECT @FreiePlaetze =
        Kapazitaet - AktuelleBelegung
    FROM dbo.Gehege
    WHERE GehegeID = @GehegeID;

    RETURN @FreiePlaetze;
END;
GO