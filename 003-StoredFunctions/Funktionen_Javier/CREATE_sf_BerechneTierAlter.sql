USE ZooManagement;
GO
-- =============================================
-- Author:		Javier Montanez
-- Create date: August 25th 2026
-- Description (DE):
--1. Was erreichen wir mit sf_BerechneTierAlter? 
--Wir können eine komplexe Berechnung verbergen und wiederverwenden. 
--Ohne diese Funktion müssten Sie dies JEDES MAL in jeder SELECT-Anweisung,
--jedem Report und jeder View schreiben
--Description (EN):
--1. What do we achieve with sf_BerechneTierAlter?
--We manage to hide a complex calculation and reuse it. 
--Without the function, you would have to write this out
--EVERY TIME in every SELECT statement, report, or view:
-- =============================================
DROP FUNCTION IF EXISTS dbo.sf_BerechneTierAlter;
GO
CREATE FUNCTION dbo.sf_BerechneTierAlter(@TierID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Alter INT;
    DECLARE @Geburtsdatum DATE;

    -- Geburtsdatum holen
    SELECT @Geburtsdatum = Geburtsdatum 
    FROM Tier 
    WHERE TierID = @TierID;

    -- Wenn kein Datum vorhanden
    IF @Geburtsdatum IS NULL
        RETURN NULL;

    -- Alter in Jahren berechnen (genaue Berechnung)
    SET @Alter = DATEDIFF(YEAR, @Geburtsdatum, GETDATE()) - 
                 CASE 
                    WHEN MONTH(@Geburtsdatum) > MONTH(GETDATE()) 
                      OR (MONTH(@Geburtsdatum) = MONTH(GETDATE()) AND DAY(@Geburtsdatum) > DAY(GETDATE())) 
                    THEN 1 
                    ELSE 0 
                 END;

    RETURN @Alter;
END;
GO

 