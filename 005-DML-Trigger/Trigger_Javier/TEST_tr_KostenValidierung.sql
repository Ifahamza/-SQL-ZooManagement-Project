USE ZooManagement;
GO
-- Test 1: INSERT mit negativen Kosten MUSS fehlschlagen (Trigger)
BEGIN TRY
    INSERT INTO Untersuchung (TierID, TierarztID, Untersuchungsdatum, Untersuchungsart, Diagnose, Kosten, NaechsterTermin)
    VALUES (1, 1, '2026-08-24', 'Test Trigger', 'Test', -100, '2026-11-24');
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS Fehlermeldung_Trigger_Hat_Gegriffen;
END CATCH

-- Test 2: INSERT mit positiven Kosten MUSS funktionieren
INSERT INTO Untersuchung (TierID, TierarztID, Untersuchungsdatum, Untersuchungsart, Diagnose, Kosten, NaechsterTermin)
VALUES (1, 1, '2026-08-24', 'Test Trigger OK', 'Test', 50, '2026-11-24');

SELECT 'INSERT OK funktioniert' AS Ergebnis;
SELECT TOP 1 * FROM Untersuchung ORDER BY UntersuchungID DESC;

-- Test 3: UPDATE mit negativen Kosten MUSS auch fehlschlagen
BEGIN TRY
    UPDATE Untersuchung SET Kosten = -5 WHERE UntersuchungID = (SELECT MAX(UntersuchungID) FROM Untersuchung);
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS Fehlermeldung_Bei_UPDATE;
END CATCH

-- Test 4: Mit Prozedur testen (Kombination sp + tr)
DECLARE @T DATE;
BEGIN TRY
    EXEC dbo.sp_UntersuchungEintragen 1, 1, '2026-08-24', 'Test Kombi', 'Test', -20, @T OUTPUT;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS Kombi_SP_und_Trigger;
END CATCH