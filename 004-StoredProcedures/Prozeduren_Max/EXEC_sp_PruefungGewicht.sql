USE [ZooManagement]
GO

BEGIN TRANSACTION;

PRINT '=== Test 1: Gültige TierID, starke Gewichtsabweichung (erwartet: Warnung Über-/Untergewicht) ===';
DECLARE @Feedback1 NVARCHAR(200);
EXEC dbo.sp_TierGewichtAktualisieren 
    @TierID = 1, 
    @NeuesGewicht = 10.00, 
    @Feedback = @Feedback1 OUTPUT;
SELECT @Feedback1 AS Ergebnis;

PRINT '=== Test 2: Gültige TierID, normales Gewicht (erwartet: "Alles ok") ===';
DECLARE @Feedback2 NVARCHAR(200);
EXEC dbo.sp_TierGewichtAktualisieren 
    @TierID = 1, 
    @NeuesGewicht = 125.00,
    @Feedback = @Feedback2 OUTPUT;
SELECT @Feedback2 AS Ergebnis;

PRINT '=== Test 3: Nicht existierende TierID (erwartet: Fehlermeldung "Tier existiert nicht") ===';
DECLARE @Feedback3 NVARCHAR(200);
EXEC dbo.sp_TierGewichtAktualisieren 
    @TierID = 99999, 
    @NeuesGewicht = 100.00, 
    @Feedback = @Feedback3 OUTPUT;
SELECT @Feedback3 AS Ergebnis;

PRINT '=== Test 4: Gewicht auf NULL setzen (erwartet: Hinweis "Kein Gewicht angegeben") ===';
DECLARE @Feedback4 NVARCHAR(200);
EXEC dbo.sp_TierGewichtAktualisieren 
    @TierID = 1, 
    @NeuesGewicht = NULL, 
    @Feedback = @Feedback4 OUTPUT;
SELECT @Feedback4 AS Ergebnis;

PRINT '=== Test 5: Deutliches Übergewicht (erwartet: Warnung "Übergewicht") ===';
DECLARE @Feedback5 NVARCHAR(200);
EXEC dbo.sp_TierGewichtAktualisieren 
    @TierID = 1, 
    @NeuesGewicht = 500.00,     -- deutlich über dem Tierart-Durchschnitt
    @Feedback = @Feedback5 OUTPUT;
SELECT @Feedback5 AS Ergebnis;

ROLLBACK TRANSACTION;
PRINT '=== Transaktion zurückgerollt, Ausgangszustand wiederhergestellt ===';
GO