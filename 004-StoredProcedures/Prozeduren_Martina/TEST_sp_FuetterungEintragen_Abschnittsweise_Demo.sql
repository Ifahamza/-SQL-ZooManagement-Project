USE ZooManagement;
GO
-- =============================================
-- Author: Martina Kratt
-- Create date: 25.08.2026
-- Description: Test/Demoskript fuer sp_FuetterungEintragen, View_Tagesfuetterungsstatus,sf_BerechneFutterReichweite, Änderung in Fuetterung ruft Trigger_Fuetterung_Lagerbestand auf
--              um Lagerbestand autpomatisch zu verringern bei erfolgreicher Fuetterung, View_TagesfuetterungenNachFutter mit Having;
-- Hinweis zur Ausführung:
--   - Jeder Abschnitt ist durch eigenes GO getrennt und hat 
--     eigenes DECLARE fuer @Ergebnis/@Fehlermeldung -> kann einzeln
--     markiert und ausgefuehrt werden.
--   - Am Anfang immer zuerst die Transaktion starten (BEGIN TRANSACTION) -> Transaktion bleibt dann ueber alle Abschnitte hinweg
--     bestehen, auch wenn man sie einzeln nacheinander ausfuehrt.
--   - Ganz am Ende immer Abschnitt 6 (ROLLBACK) ausfuehren, egal ob
--     vorher alles wie erwartet lief oder nicht, damit Änderungen an DB 
--     in Transaktion wieder rueckgängig gemacht werden
-- =============================================

BEGIN TRANSACTION;
GO

-- =============================================
-- 1. Ausgangszustand pruefen
-- =============================================
SELECT
    dbo.Futter.FutterID,
    dbo.Futter.Futtername,
    dbo.Futter.Lagerbestand,
    dbo.Futtereinheit.Einheit
FROM dbo.Futter
INNER JOIN dbo.Futtereinheit
    ON dbo.Futter.FuttereinheitID = dbo.Futtereinheit.FuttereinheitID
WHERE dbo.Futter.FutterID IN (5, 13);
GO

-- =============================================
-- 2. Gueltige Fuetterungen testen
-- =============================================

-- Test 2a: gueltige Fuetterung von 15 kg Heu (FutterID 5)
DECLARE @Fehlermeldung NVARCHAR(500);
DECLARE @Ergebnis INT;

EXEC @Ergebnis = dbo.sp_FuetterungEintragen
    @TierID = 9,
    @FutterID = 5,
    @MitarbeiterID = 3,
    @Menge = 15,
    @Fehlermeldung = @Fehlermeldung OUTPUT;

SELECT
    @Ergebnis AS Ergebnis,
    @Fehlermeldung AS Fehlermeldung;

-- Tagesfuetterungsstatus nach erster Fuetterung anzeigen
SELECT *
FROM dbo.View_Tagesfuetterungsstatus
WHERE TierID = 9;
GO

-- Test 2b: gueltige Fuetterung von nochmal 15 kg Heu (FutterID 5)
--          und 10 Bund Laubzweigen (FutterID 13)
-- (nochmal dieselbe Menge, um den veraenderten Status
--  in View_Tagesfuetterungsstatus zu zeigen)
DECLARE @Fehlermeldung NVARCHAR(500);
DECLARE @Ergebnis INT;

EXEC @Ergebnis = dbo.sp_FuetterungEintragen
    @TierID = 9,
    @FutterID = 5,
    @MitarbeiterID = 3,
    @Menge = 15,
    @Fehlermeldung = @Fehlermeldung OUTPUT;

SELECT
    @Ergebnis AS Ergebnis,
    @Fehlermeldung AS Fehlermeldung;

EXEC @Ergebnis = dbo.sp_FuetterungEintragen
    @TierID = 9,
    @FutterID = 13,
    @MitarbeiterID = 3,
    @Menge = 10,
    @Fehlermeldung = @Fehlermeldung OUTPUT;

SELECT
    @Ergebnis AS Ergebnis,
    @Fehlermeldung AS Fehlermeldung;

-- Tagesfuetterungsstatus nach erneuter Fuetterung anzeigen
SELECT *
FROM dbo.View_Tagesfuetterungsstatus
WHERE TierID = 9;
GO

-- =============================================
-- 3. Ungueltige Fuetterungen testen
-- =============================================

-- Test 3a: Mitarbeiter ist nicht fuer Tier zustaendig
DECLARE @Fehlermeldung NVARCHAR(500);
DECLARE @Ergebnis INT;

EXEC @Ergebnis = dbo.sp_FuetterungEintragen
    @TierID = 9,
    @FutterID = 13,
    @MitarbeiterID = 2,
    @Menge = 500,
    @Fehlermeldung = @Fehlermeldung OUTPUT;

SELECT
    @Ergebnis AS Ergebnis,
    @Fehlermeldung AS Fehlermeldung;
GO

-- Test 3b: Ungueltiges Futter fuer dieses Tier
DECLARE @Fehlermeldung NVARCHAR(500);
DECLARE @Ergebnis INT;

EXEC @Ergebnis = dbo.sp_FuetterungEintragen
    @TierID = 9,
    @FutterID = 3,
    @MitarbeiterID = 3,
    @Menge = 500,
    @Fehlermeldung = @Fehlermeldung OUTPUT;

SELECT
    @Ergebnis AS Ergebnis,
    @Fehlermeldung AS Fehlermeldung;
GO

-- Test 3c: Ungueltige Menge, die den Lagerbestand ueberschreitet
DECLARE @Fehlermeldung NVARCHAR(500);
DECLARE @Ergebnis INT;

EXEC @Ergebnis = dbo.sp_FuetterungEintragen
    @TierID = 9,
    @FutterID = 13,
    @MitarbeiterID = 3,
    @Menge = 500,
    @Fehlermeldung = @Fehlermeldung OUTPUT;

SELECT
    @Ergebnis AS Ergebnis,
    @Fehlermeldung AS Fehlermeldung;
GO

-- =============================================
-- 4. Endzustand pruefen
-- =============================================
SELECT
    dbo.Futter.FutterID,
    dbo.Futter.Futtername,
    dbo.Futter.Lagerbestand,
    dbo.Futtereinheit.Einheit
FROM dbo.Futter
INNER JOIN dbo.Futtereinheit
    ON dbo.Futter.FuttereinheitID = dbo.Futtereinheit.FuttereinheitID
WHERE dbo.Futter.FutterID IN (5, 13);

-- Fuetterungsuebersicht anzeigen
SELECT TOP 10
    dbo.Fuetterung.FuetterungID,
    dbo.Fuetterung.TierID,
    dbo.Fuetterung.FutterID,
    dbo.Futter.Futtername,
    dbo.Fuetterung.MitarbeiterID,
    dbo.Fuetterung.Zeitpunkt,
    dbo.Fuetterung.Menge,
    dbo.Futtereinheit.Einheit
FROM dbo.Fuetterung
INNER JOIN dbo.Futter
    ON dbo.Fuetterung.FutterID = dbo.Futter.FutterID
INNER JOIN dbo.Futtereinheit
    ON dbo.Futter.FuttereinheitID = dbo.Futtereinheit.FuttereinheitID
ORDER BY dbo.Fuetterung.Zeitpunkt DESC;
GO

-- =============================================
-- 5. Zusaetzliche Auswertungen
-- =============================================

-- Futtersorten, die heute mindestens 2-mal verfuettert wurden
SELECT *
FROM dbo.View_TagesfuetterungenNachFutter;
GO

-- Kritische Futterbestaende
SELECT *
FROM dbo.View_KritischerFutterbestand;
GO

-- Futterreichweite berechnen
SELECT
    dbo.Futter.FutterID,
    dbo.Futter.Futtername,
    dbo.Futter.Lagerbestand,
    dbo.Futtereinheit.Einheit,
    dbo.sf_BerechneFutterReichweite(dbo.Futter.FutterID) AS ReichweiteInTagen
FROM dbo.Futter
INNER JOIN dbo.Futtereinheit
    ON dbo.Futter.FuttereinheitID = dbo.Futtereinheit.FuttereinheitID;
GO

-- =============================================
-- 6. Aufraeumen - IMMER als letzten Schritt ausfuehren!
-- =============================================

ROLLBACK TRANSACTION;
GO