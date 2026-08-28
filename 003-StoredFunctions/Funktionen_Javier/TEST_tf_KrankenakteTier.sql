USE ZooManagement;
GO
-- Test 1: Tier mit vielen Untersuchungen finden
SELECT TierID, COUNT(*) AS Anzahl_Untersuchungen 
FROM Untersuchung 
GROUP BY TierID 
ORDER BY Anzahl_Untersuchungen DESC;

-- Test 2: Funktion mit dem Tier aus Test 1 testen
SELECT * FROM dbo.tf_KrankenakteTier(3) ORDER BY Untersuchungsdatum DESC;

-- Test 3: Tier ohne Untersuchungen -> muss 0 Zeilen liefern, kein Fehler
SELECT * FROM dbo.tf_KrankenakteTier(9999);

-- Test 4: Join mit v_UntersuchungsProtokoll möglich? 
--We want to prove that VIEW is usable like a normal table. 
--We want to filter it, join it, use WHERE, IN, etc.
--In this case: Shows the whole examination
--protocol from the View but only for TierID = 1.
SELECT * FROM dbo.view_UntersuchungsProtokoll 
WHERE TierID IN (SELECT TierID FROM Tier WHERE TierID = 1);