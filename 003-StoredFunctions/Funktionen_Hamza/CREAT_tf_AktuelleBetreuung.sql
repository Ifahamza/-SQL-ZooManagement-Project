USE [ZooManagement]
GO

/****** Objekt:  UserDefinedFunction [dbo].[tf_AktuelleBetreuung]    Skriptdatum: 26.08.2026 10:25:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Hamza Ifa
-- Create date: 25.08.2026
-- Description: Gibt eine Liste aller aktuell 
--              betreuten Tiere eines Mitarbeiters 
--              zurück. Wird für die tägliche 
--              Arbeitsliste und das Notfall-
--              management (Krankheit/Abwesenheit) 
--              verwendet.
-- =============================================
CREATE FUNCTION [dbo].[tf_AktuelleBetreuung]
(
    @MitarbeiterID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        tb.TierID,
        t.Name AS TierName,
        ta.Tierartname,
        tb.VonDatum,
        tb.BisDatum
    FROM Tierbetreuung tb
    INNER JOIN Tier t ON tb.TierID = t.TierID
    INNER JOIN Tierart ta ON t.TierartID = ta.TierartID
    WHERE tb.MitarbeiterID = @MitarbeiterID
      AND tb.BisDatum IS NULL -- Nur aktive Betreuungen
);
GO


