USE ZooManagement;
GO

-- =======================================================================================================================================
-- Author:		Bernhard Ehnle
-- Create date: 26.8.2026
-- Description:	Testskript für die Prozedur dbo.sp_TierInGehegeVerlegen
-- =======================================================================================================================================

-------------------------------------------------------------------------
-- Zunächst geeignete Tier- und Gehege-IDs ermitteln:
-- Mögliche Umzüge
-------------------------------------------------------------------------

SELECT
    Tier.TierID,
    Tier.Name AS Tier,
    Tierart.Tierartname,
    AktuellesGehege.Gehegename AS AktuellesGehege,
    Zielgehege.GehegeID AS ZielGehegeID,
    Zielgehege.Gehegename AS MoeglichesZielgehege,
    dbo.sf_BerechneFreiePlaetze(Zielgehege.GehegeID)
        AS FreiePlaetze
FROM dbo.Tier
INNER JOIN dbo.Tierart
    ON Tier.TierartID = Tierart.TierartID
INNER JOIN dbo.Gehege AS AktuellesGehege
    ON Tier.GehegeID = AktuellesGehege.GehegeID
INNER JOIN dbo.TierartGehegeTyp
    ON Tier.TierartID = TierartGehegeTyp.TierartID
INNER JOIN dbo.Gehege AS Zielgehege
    ON TierartGehegeTyp.GehegeTypID = Zielgehege.GehegeTypID
WHERE Zielgehege.GehegeID <> Tier.GehegeID
  AND Zielgehege.Status = 1
  AND dbo.sf_BerechneFreiePlaetze(Zielgehege.GehegeID) > 0
ORDER BY
    Tier.Name,
    Zielgehege.Gehegename;

-------------------------------------------------------------------------
--Prozedur ausführen
-------------------------------------------------------------------------
DECLARE @Erfolg BIT;
DECLARE @Feedback NVARCHAR(500);

EXEC dbo.sp_TierInGehegeVerlegen
    @TierID = 54,
    @ZielGehegeID = 13,
    @Erfolg = @Erfolg OUTPUT,
    @Feedback = @Feedback OUTPUT;

SELECT
    @Erfolg AS Erfolg,
    @Feedback AS Feedback;

--Test: Tier in nicht geeignetes Gehege umziehen
DECLARE @Erfolg BIT;
DECLARE @Feedback NVARCHAR(500);

EXEC dbo.sp_TierInGehegeVerlegen
    @TierID = 4,
    @ZielGehegeID = 12,
    @Erfolg = @Erfolg OUTPUT,
    @Feedback = @Feedback OUTPUT;

SELECT
    @Erfolg AS Erfolg,
    @Feedback AS Feedback;

-------------------------------------------------------------------------
--Ergebniskontrolle
-------------------------------------------------------------------------
SELECT
    Tier.TierID,
    Tier.Name,
    Gehege.Gehegename,
    Gehege.GehegeID
FROM dbo.Tier
INNER JOIN dbo.Gehege
    ON Tier.GehegeID = Gehege.GehegeID
WHERE Tier.TierID = 54;