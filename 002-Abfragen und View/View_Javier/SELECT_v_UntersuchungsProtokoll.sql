USE ZooManagement;
GO
SELECT * FROM dbo.View_UntersuchungsProtokoll ORDER BY Untersuchungsdatum DESC;

-- Mit Filter für schnellen Überblick:
SELECT TierName, Tierartname, TierarztName, Diagnose, Untersuchungsdatum, NaechsterTermin
FROM dbo.View_UntersuchungsProtokoll
WHERE Tierartname = 'Löwe';