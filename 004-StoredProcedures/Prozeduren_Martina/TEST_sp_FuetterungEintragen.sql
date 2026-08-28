USE ZooManagement;
GO
-- =============================================
-- Author: Martina Kratt
-- Create date: 25.08.2026
-- Description: Test/Demoskript fuer sp_FuetterungEintragen, View_Tagesfuetterungsstatus
-- =============================================
BEGIN TRANSACTION;

-- =============================================
-- 1. Ausgangszustand prüfen
-- =============================================
--Lagerbestand vorher
SELECT
    dbo.Futter.FutterID,
    dbo.Futter.Futtername,
    dbo.Futter.Lagerbestand,
    dbo.Futtereinheit.Einheit
FROM dbo.Futter
INNER JOIN dbo.Futtereinheit
    ON dbo.Futter.FuttereinheitID = dbo.Futtereinheit.FuttereinheitID
WHERE dbo.Futter.FutterID IN (5, 13);

-- =============================================
-- 2. Gültige Fütterungen testen
-- =============================================

-- Test: gültige Fütterung von 15 kg Heu (FutterID 5)
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

  --Tagesfuetterungsstatus nach erster Fuetterung anzeigen
SELECT *
FROM dbo.View_Tagesfuetterungsstatus
WHERE TierID = 9;

-- Test: gültige Fütterung von nochmal 15 kg Heu (FutterID 5) und 10 Bund Laubzweigen (FutterID 13)
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

-- =============================================
-- 3. Ungültige Fütterungen testen
-- =============================================
--Ungueltiger Test: Mitarbieter ist nicht für Tier zuständig
EXEC @Ergebnis = dbo.sp_FuetterungEintragen
    @TierID = 9,
    @FutterID = 13,
    @MitarbeiterID = 2,
    @Menge = 500,
    @Fehlermeldung = @Fehlermeldung OUTPUT;

SELECT
    @Ergebnis AS Ergebnis,
    @Fehlermeldung AS Fehlermeldung;

---Ungueltiger Test:  Ungültiges Futter für dieses Tier
EXEC @Ergebnis = dbo.sp_FuetterungEintragen
    @TierID = 9,
    @FutterID = 3,
    @MitarbeiterID = 3,
    @Menge = 500,
    @Fehlermeldung = @Fehlermeldung OUTPUT;

SELECT
    @Ergebnis AS Ergebnis,
    @Fehlermeldung AS Fehlermeldung;

--Ungueltiger Test:  Ungültige Menge die Lagerbestand überschreitet
EXEC @Ergebnis = dbo.sp_FuetterungEintragen
    @TierID = 9,
    @FutterID = 13,
    @MitarbeiterID = 3,
    @Menge = 500,
    @Fehlermeldung = @Fehlermeldung OUTPUT;

SELECT
    @Ergebnis AS Ergebnis,
    @Fehlermeldung AS Fehlermeldung;


-- =============================================
-- 4. Endzustand prüfen
-- =============================================
--Lagerbestand nachher
SELECT
    dbo.Futter.FutterID,
    dbo.Futter.Futtername,
    dbo.Futter.Lagerbestand,
    dbo.Futtereinheit.Einheit
FROM dbo.Futter
INNER JOIN dbo.Futtereinheit
    ON dbo.Futter.FuttereinheitID = dbo.Futtereinheit.FuttereinheitID
WHERE dbo.Futter.FutterID IN (5, 13);


    --Fuetterungsuebersicht  anzeigen
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


-- =============================================
-- 5. Zusätzliche Auswertungen
-- =============================================
-- Futtersorten, die heute mindestens 2-mal verfüttert wurden
SELECT *
FROM dbo.View_TagesfuetterungenNachFutter;


-- Kritische Futterbestände
SELECT *
FROM dbo.View_KritischerFutterbestand;


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


-- ALLES wieder rückgängig machen
ROLLBACK TRANSACTION;