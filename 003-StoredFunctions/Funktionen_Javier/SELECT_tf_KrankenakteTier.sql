USE ZooManagement;
GO
-- Krankenakte für Tier 1, chronologisch sortiert (neueste zuerst)
SELECT * 
FROM dbo.tf_KrankenakteTier(1) 
ORDER BY Untersuchungsdatum DESC;

-- Krankenakte für Tier 5, älteste zuerst
SELECT Untersuchungsdatum, Diagnose, Untersuchungsart, TierarztName
FROM dbo.tf_KrankenakteTier(5)
ORDER BY Untersuchungsdatum ASC;

-- Mit Alter kombinieren (nutzt deine Funktion Nr. 2!)
SELECT 
    k.*,
    dbo.sf_BerechneTierAlter(1) AS AktuellesAlter
FROM dbo.tf_KrankenakteTier(1) k;