USE [ZooManagement]
GO

BEGIN TRANSACTION;

PRINT '=== Test 1: Starkes Übergewicht (erwartet: "Warnung: Übergewicht") ===';
UPDATE dbo.Tier 
SET Gewicht = 500.00 
WHERE TierID = 1;

SELECT TOP 1 * FROM dbo.TierLogGewichtWarnung 
WHERE TierID = 1 
ORDER BY WarnungID DESC;


PRINT '=== Test 2: Starkes Untergewicht (erwartet: "Warnung: Untergewicht") ===';
UPDATE dbo.Tier 
SET Gewicht = 5.00 
WHERE TierID = 1;

SELECT TOP 1 * FROM dbo.TierLogGewichtWarnung 
WHERE TierID = 1 
ORDER BY WarnungID DESC;


PRINT '=== Test 3: Normales Gewicht, innerhalb der 50%-Toleranz (erwartet: "Alles ok") ===';
UPDATE dbo.Tier 
SET Gewicht = 125.00 
WHERE TierID = 1;

SELECT TOP 1 * FROM dbo.TierLogGewichtWarnung 
WHERE TierID = 1 
ORDER BY WarnungID DESC;


PRINT '=== Test 4: Gewicht auf NULL setzen (erwartet: "Hinweis: Kein Gewicht angegeben") ===';
UPDATE dbo.Tier 
SET Gewicht = NULL 
WHERE TierID = 1;

SELECT TOP 1 * FROM dbo.TierLogGewichtWarnung 
WHERE TierID = 1 
ORDER BY WarnungID DESC;

ROLLBACK