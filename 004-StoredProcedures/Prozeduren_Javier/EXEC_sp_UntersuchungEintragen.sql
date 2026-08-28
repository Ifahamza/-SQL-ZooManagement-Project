USE ZooManagement;
GO
DECLARE @NeuerTermin DATE;

-- Beispiel 1: Normales Tier (jung)
EXEC dbo.sp_UntersuchungEintragen
    @TierID = 1,
    @TierarztID = 1,
    @Untersuchungsdatum = '2026-08-24',
    @Untersuchungsart = 'Routinekontrolle',
    @Diagnose = 'Gesund',
    @Kosten = 50.00,
    @NaechsterTermin = @NeuerTermin OUTPUT;

SELECT @NeuerTermin AS AutomatischGesetzterTermin;

-- Krankenakte prüfen
SELECT * FROM dbo.tf_KrankenakteTier(1) ORDER BY Untersuchungsdatum DESC;