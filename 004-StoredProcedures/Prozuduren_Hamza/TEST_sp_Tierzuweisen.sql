-- ============================================
-- SICHERES TEST-SKRIPT FÜR sp_TierZuweisen
-- ============================================
BEGIN TRAN; -- Startet die sichere Test-Umgebung (ändert nichts an den Gruppendaten!)

PRINT '==================================================';
PRINT 'START DER TESTS FÜR PROZEDUR: sp_TierZuweisen';
PRINT '==================================================';
PRINT '';

-- Vorbereitung: Ein Tier freigeben
-- Da alle Tiere belegt sind, löschen wir testweise den Eintrag für Tier 1.
DELETE FROM Tierbetreuung WHERE TierID = 1 AND BisDatum IS NULL;
PRINT '--- Vorbereitung: Tier 1 wurde testweise freigegeben ---';
PRINT '';


-- ============================================
-- TEST 1: Erfolgreiche normale Zuweisung
-- ============================================
PRINT '--- TEST 1: Tier 1 an Daniel Fischer (ID 4, Tierpfleger) zuweisen ---';

DECLARE @E1 BIT, @M1 NVARCHAR(255);

EXEC sp_TierZuweisen 
    @MitarbeiterID = 4, 
    @TierID = 1, 
    @IstNotfall = 0, 
    @Erfolg = @E1 OUTPUT, 
    @Meldung = @M1 OUTPUT;

SELECT @E1 AS [Erfolg (1=Ja)], @M1 AS [Meldung vom System];
-- Erwartetes Ergebnis: Erfolg = 1
-- Erwartete Meldung: 'Erfolg: Tier 1 wurde erfolgreich zugewiesen.'

-- Zeige die Änderung in der Tabelle Tierbetreuung
PRINT '';
PRINT '--- Tabelle Tierbetreuung nach Test 1 (Tier 1 wurde Daniel zugewiesen): ---';
SELECT TierbetreuungsID, TierID, MitarbeiterID, VonDatum, BisDatum
FROM Tierbetreuung
WHERE TierID = 1
ORDER BY TierbetreuungsID DESC;
PRINT '';


-- ============================================
-- TEST 2: Unberechtigter Mitarbeiter (Verwaltung)
-- ============================================
PRINT '--- TEST 2: Tier 1 an Julia Koch (ID 13, Verwaltung) zuweisen ---';

-- Tier 1 wieder freigeben (den neuen Eintrag von Daniel löschen)
DELETE FROM Tierbetreuung WHERE TierID = 1 AND BisDatum IS NULL;

DECLARE @E2 BIT, @M2 NVARCHAR(255);

EXEC sp_TierZuweisen 
    @MitarbeiterID = 13, 
    @TierID = 1, 
    @IstNotfall = 0, 
    @Erfolg = @E2 OUTPUT, 
    @Meldung = @M2 OUTPUT;

SELECT @E2 AS [Erfolg (1=Ja)], @M2 AS [Meldung vom System];
-- Erwartetes Ergebnis: Erfolg = 0
-- Erwartete Meldung: 'Fehler: Mitarbeiter ist kein Tierpfleger/Revierleiter. Keine Berechtigung!'

-- Zeige, dass KEINE Änderung in der Tabelle stattfand
PRINT '';
PRINT '--- Tabelle Tierbetreuung nach Test 2 (KEINE Änderung - Julia wurde blockiert): ---';
SELECT TierbetreuungsID, TierID, MitarbeiterID, VonDatum, BisDatum
FROM Tierbetreuung
WHERE TierID = 1
ORDER BY TierbetreuungsID DESC;
PRINT '';


-- ============================================
-- TEST 3: Überlastung im Normalfall
-- ============================================
PRINT '--- TEST 3: Überlastung bei Laura Schmidt (ID 3) testen ---';

-- Tier 1 wieder freigeben
DELETE FROM Tierbetreuung WHERE TierID = 1 AND BisDatum IS NULL;

DECLARE @E3 BIT, @M3 NVARCHAR(255);

-- Laura (hat 11 Tiere) bekommt Tier 1. Das ist ihr 12. Tier (noch im Limit).
EXEC sp_TierZuweisen 
    @MitarbeiterID = 3, 
    @TierID = 1, 
    @IstNotfall = 0, 
    @Erfolg = @E3 OUTPUT, 
    @Meldung = @M3 OUTPUT;

SELECT @E3 AS [Erfolg (1=Ja)], @M3 AS [Meldung vom System];
-- Erwartetes Ergebnis: Erfolg = 1 (Laura hat jetzt 12 Tiere, das Limit ist erreicht)
PRINT 'Laura hat jetzt 12 Tiere. Das Limit ist erreicht.';

-- Zeige die Änderung in der Tabelle
PRINT '';
PRINT '--- Tabelle Tierbetreuung nach Test 3 (Tier 1 wurde Laura zugewiesen): ---';
SELECT TierbetreuungsID, TierID, MitarbeiterID, VonDatum, BisDatum
FROM Tierbetreuung
WHERE TierID = 1
ORDER BY TierbetreuungsID DESC;
PRINT '';

-- Jetzt Tier 2 freigeben
DELETE FROM Tierbetreuung WHERE TierID = 2 AND BisDatum IS NULL;

DECLARE @E4 BIT, @M4 NVARCHAR(255);

-- Laura versucht, Tier 2 zu bekommen (wäre das 13. Tier).
EXEC sp_TierZuweisen 
    @MitarbeiterID = 3, 
    @TierID = 2, 
    @IstNotfall = 0, 
    @Erfolg = @E4 OUTPUT, 
    @Meldung = @M4 OUTPUT;

SELECT @E4 AS [Erfolg (1=Ja)], @M4 AS [Meldung vom System];
-- Erwartetes Ergebnis: Erfolg = 0
-- Erwartete Meldung: 'Fehler: Überlastung! Mitarbeiter hat bereits 12 Tiere. (Limit: 12)'

-- Zeige, dass KEINE Änderung für Tier 2 stattfand
PRINT '';
PRINT '--- Tabelle Tierbetreuung nach Test 3b (KEINE Änderung - Überlastung blockiert): ---';
SELECT TierbetreuungsID, TierID, MitarbeiterID, VonDatum, BisDatum
FROM Tierbetreuung
WHERE TierID IN (1, 2)
ORDER BY TierbetreuungsID DESC;
PRINT '';


-- ============================================
-- TEST 4: Notfall-Modus (Ausnahmeregelung)
-- ============================================
PRINT '--- TEST 4: Notfall-Modus für Laura Schmidt (ID 3) ---';

DECLARE @E5 BIT, @M5 NVARCHAR(255);

-- Laura versucht es nochmal mit Tier 2, aber diesmal als NOTFALL.
EXEC sp_TierZuweisen 
    @MitarbeiterID = 3, 
    @TierID = 2, 
    @IstNotfall = 1, -- 1 bedeutet NOTFALL
    @Erfolg = @E5 OUTPUT, 
    @Meldung = @M5 OUTPUT;

SELECT @E5 AS [Erfolg (1=Ja)], @M5 AS [Meldung vom System];
-- Erwartetes Ergebnis: Erfolg = 1
-- Erwartete Meldung: 'Erfolg: Tier 2 wurde erfolgreich zugewiesen.'

-- Zeige die Änderung in der Tabelle (Notfall-Modus hat funktioniert!)
PRINT '';
PRINT '--- Tabelle Tierbetreuung nach Test 4 (Tier 2 wurde Laura im Notfall zugewiesen): ---';
SELECT TierbetreuungsID, TierID, MitarbeiterID, VonDatum, BisDatum
FROM Tierbetreuung
WHERE TierID IN (1, 2)
ORDER BY TierbetreuungsID DESC;
PRINT '';


-- ============================================
-- ABSCHLUSS: Alles rückgängig machen!
-- ============================================
PRINT '==================================================';
PRINT 'ABSCHLUSS: Alle Änderungen werden rückgängig gemacht';
PRINT '==================================================';

PRINT 'Zustand VOR dem ROLLBACK:';
SELECT TierbetreuungsID, TierID, MitarbeiterID, VonDatum, BisDatum
FROM Tierbetreuung
WHERE TierID IN (1, 2)
ORDER BY TierbetreuungsID DESC;

ROLLBACK TRAN;

PRINT '';
PRINT 'Zustand NACH dem ROLLBACK (Originalzustand):';
SELECT TierbetreuungsID, TierID, MitarbeiterID, VonDatum, BisDatum
FROM Tierbetreuung
WHERE TierID IN (1, 2)
ORDER BY TierbetreuungsID DESC;

PRINT '';
PRINT '==================================================';
PRINT 'ENDE DER TESTS. Alle Änderungen wurden rückgängig gemacht.';
PRINT 'Die Datenbank ist wieder im Originalzustand.';
PRINT '==================================================';