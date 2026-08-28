USE [ZooManagement]
GO

/****** Objekt:  UserDefinedFunction [dbo].[sf_AnzahlBetreuterTiere]    Skriptdatum: 26.08.2026 10:18:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Hamza Ifa
-- Create date: 25.08.2026
-- Description: Zählt die Anzahl der aktuell 
--              aktiven Tierbetreuungen eines 
--              Mitarbeiters (BisDatum IS NULL).
--              Wird in der Prozedur sp_TierZuweisen 
--              für den Überlastungsschutz verwendet.
-- =============================================

CREATE FUNCTION [dbo].[sf_AnzahlBetreuterTiere]
(
    @MitarbeiterID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Anzahl INT;
    
    -- Zähle nur AKTIVE Betreuungen (BisDatum IS NULL)
    SELECT @Anzahl = COUNT(TierID)
    FROM Tierbetreuung
    WHERE MitarbeiterID = @MitarbeiterID
      AND BisDatum IS NULL;
    
    -- Wenn NULL, dann 0 zurückgeben
    RETURN ISNULL(@Anzahl, 0);
END;
GO


