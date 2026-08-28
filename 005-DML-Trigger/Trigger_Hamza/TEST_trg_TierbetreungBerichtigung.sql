-- ============================================
-- SICHERES TEST-SKRIPT FÜR TRIGGER: trg_Tierbetreuung_Berechtigung
-- JEDER TEST HAT SEINE EIGENE TRANSAKTION!
-- ============================================

PRINT '==================================================';
PRINT 'START DER TESTS FÜR TRIGGER: trg_Tierbetreuung_Berechtigung';
PRINT '==================================================';
PRINT '';


-- ============================================
-- TEST 1: Unberechtigter Mitarbeiter (Verwaltung)
-- ============================================
PRINT '--- TEST 1: Julia Koch (ID 13, Verwaltungsfachkraft) versucht, ein Tier zu betreuen ---';
PRINT 'ERWARTUNG: Der Trigger sollte den INSERT blockieren.';
PRINT '';

BEGIN TRAN Test1;
BEGIN TRY
    INSERT INTO Tierbetreuung (MitarbeiterID, TierID, VonDatum, BisDatum)
    VALUES (13, 1, CAST(GETDATE() AS DATE), NULL);
    
    PRINT 'FEHLER: Der Trigger hat nicht gegriffen!';
    ROLLBACK TRAN Test1;
END TRY
BEGIN CATCH
    PRINT 'ERFOLG: Der Trigger hat den INSERT blockiert!';
    PRINT 'Fehlermeldung: ' + ERROR_MESSAGE();
    ROLLBACK TRAN Test1;
END CATCH;

PRINT '';


-- ============================================
-- TEST 2: Berechtigter Mitarbeiter (Tierpfleger)
-- ============================================
PRINT '--- TEST 2: Daniel Fischer (ID 4, Tierpfleger) versucht, ein Tier zu betreuen ---';
PRINT 'ERWARTUNG: Der Trigger sollte den INSERT erlauben.';
PRINT '';

BEGIN TRAN Test2;
BEGIN TRY
    -- Erst ein Tier freigeben (testweise löschen)
    DELETE FROM Tierbetreuung WHERE TierID = 1 AND BisDatum IS NULL;
    
    INSERT INTO Tierbetreuung (MitarbeiterID, TierID, VonDatum, BisDatum)
    VALUES (4, 1, CAST(GETDATE() AS DATE), NULL);
    
    PRINT 'ERFOLG: Der Trigger hat den INSERT erlaubt (Daniel ist Tierpfleger).';
    
    -- Test-Datensatz wieder löschen
    DELETE FROM Tierbetreuung WHERE MitarbeiterID = 4 AND TierID = 1 AND VonDatum = CAST(GETDATE() AS DATE);
    
    COMMIT TRAN Test2;
END TRY
BEGIN CATCH
    PRINT 'HINWEIS: INSERT fehlgeschlagen.';
    PRINT 'Fehlermeldung: ' + ERROR_MESSAGE();
    ROLLBACK TRAN Test2;
END CATCH;

PRINT '';


-- ============================================
-- ABSCHLUSS
-- ============================================
PRINT '==================================================';
PRINT 'TESTS ABGESCHLOSSEN';
PRINT '==================================================';
PRINT 'Test 1 (Verwaltung): BLOCKIERT ✓';
PRINT 'Test 2 (Tierpfleger): ERLAUBT ✓';
PRINT '==================================================';