USE ZooManagement;
GO
-- =============================================
-- Author:		Javier Montanez
-- Create date: August 25th 2026
-- Description (DE):	
-- Erstellt den View View_UntersuchungsProtokoll. 
--Der View vereint Daten aus Untersuchung, Tier, Tierart und Tierarzt zu einem
--vollständigen Untersuchungsprotokoll für Reporting und Auswertung.
--Description (EN):
-- Creates the view View_UntersuchungsProtokoll.
--This view provides a consolidated examination report
-- by joining Untersuchung with Tier, Tierart and Tierarzt, 
--including animal details, species origin, diagnosis, costs and veterinarian information.
-- =============================================
DROP VIEW IF EXISTS dbo.View_UntersuchungsProtokoll;
GO
CREATE VIEW dbo.View_UntersuchungsProtokoll
AS
SELECT
    u.UntersuchungID,
    u.Untersuchungsdatum,
    u.Untersuchungsart,
    u.Diagnose,
    u.Kosten,
    u.NaechsterTermin,
    t.TierID,
    t.Name AS TierName,
    ta.Tierartname,
    ta.Herkunftsland,
    ta.WissenschaftlicherName,
    tarzt.TierarztID,
    CONCAT(tarzt.Vorname, ' ', tarzt.Nachname) AS TierarztName,
    tarzt.Spezialisierung
FROM Untersuchung u
INNER JOIN Tier t ON u.TierID = t.TierID
INNER JOIN Tierart ta ON t.TierartID = ta.TierartID
INNER JOIN Tierarzt tarzt ON u.TierarztID = tarzt.TierarztID;
GO