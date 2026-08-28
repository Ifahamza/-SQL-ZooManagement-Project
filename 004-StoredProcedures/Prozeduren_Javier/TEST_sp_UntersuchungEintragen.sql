 USE ZooManagement;
GO
-- Test 1: Zukunftsdatum muss fehlschlagen
DECLARE @T DATE;
EXEC dbo.sp_UntersuchungEintragen 1, 1, '2027-01-01', 'Test', 'Test', 10, @T OUTPUT;
-- Erwartet: Fehler "darf nicht in der Zukunft liegen"

-- Test 2: Senior-Tier finden (>10 Jahre)
SELECT TierID, Name, Geburtsdatum, dbo.sf_BerechneTierAlter(TierID) AS [Alter]
FROM Tier
WHERE dbo.sf_BerechneTierAlter(TierID) > 10;

-- Test 3: Senior testen - muss +3 Monate setzen
DECLARE @T2 DATE;
EXEC dbo.sp_UntersuchungEintragen 2, 1, '2026-08-24', 'Senior-Check', 'Arthrose Verdacht', 120, @T2 OUTPUT;
SELECT @T2 AS SeniorTermin_Muss_3_Monate_Spaeter_Sein; -- 24.11.2026

-- Test 4: Alles in VIEW sehen
SELECT * FROM dbo.View_UntersuchungsProtokoll ORDER BY Untersuchungsdatum DESC;

-- SUCCESS OF THIS SCRIPT (01_create):
-- Creates the stored procedure dbo.sp_UntersuchungEintragen.
-- It encapsulates the INSERT into the Untersuchung table and ensures
-- that only valid examinations are recorded.

-- ERFOLG DIESES SKRIPTS (01_create):
-- Erstellt die Stored Procedure dbo.sp_UntersuchungEintragen.
-- Sie kapselt das INSERT in die Tabelle Untersuchung und stellt sicher, 
-- dass nur gültige Untersuchungen eingetragen werden.