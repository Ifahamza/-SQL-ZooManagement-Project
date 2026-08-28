USE ZooManagement;
GO
-- Test 1: View liefert Daten?
SELECT COUNT(*) AS Anzahl_Protokolle FROM dbo.View_UntersuchungsProtokoll;

-- Test 2: Kein ID mehr sichtbar, nur Namen?
SELECT TOP 5 TierName, TierarztName, Diagnose FROM dbo.View_UntersuchungsProtokoll;

-- Test 3: Funktioniert JOIN korrekt? (keine NULLs)
SELECT * FROM dbo.View_UntersuchungsProtokoll 
WHERE TierName IS NULL OR TierarztName IS NULL;
-- Sollte 0 Zeilen liefern