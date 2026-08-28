USE ZooManagement;
GO
-- =============================================
-- Author:		Javier Montanez
-- Create date: August 25th 20226
-- Description (DE):	
-- Erstellt die Table-Valued Function tf_KrankenakteTier. 
-- Gibt die komplette Krankenakte (alle Untersuchungen) für eine spezifische TierID zurück,
-- inklusive Tierart und Tierarzt-Informationen.
-- Description (EN):
--Creates the table-valued function tf_KrankenakteTier. 
--Returns the complete medical history (all examinations) for a specific TierID, 
--including animal species and veterinarian details.
-- =============================================
DROP FUNCTION IF EXISTS dbo.tf_KrankenakteTier;
GO
CREATE FUNCTION dbo.tf_KrankenakteTier(@TierID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        u.UntersuchungID,
        u.Untersuchungsdatum,
        u.Untersuchungsart,
        u.Diagnose,
        u.Kosten,
        u.NaechsterTermin,
        CONCAT(tarzt.Vorname, ' ', tarzt.Nachname) AS TierarztName,
        tarzt.Spezialisierung,
        t.Name AS TierName,
        ta.Tierartname
    FROM Untersuchung u
    INNER JOIN Tier t ON u.TierID = t.TierID
    INNER JOIN Tierart ta ON t.TierartID = ta.TierartID
    INNER JOIN Tierarzt tarzt ON u.TierarztID = tarzt.TierarztID
    WHERE u.TierID = @TierID
);
GO

--EN: A table-valued function returns a TABLE, not a number.
--DE: Die Tabellenwertfunktion gibt eine TABELLE zurück, keine Zahl.