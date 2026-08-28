-- TEST für trg_Fuetterung_Update

-- 1. Vorher-Status ansehen (sollte NULL sein)
SELECT TOP 3 TierID, Name, LetzteFuetterung 
FROM dbo.Tier 
ORDER BY TierID;

-- 2. Ein Tier zum Testen auswählen (nimm ID 1)
SELECT * FROM dbo.Futter; -- schau welche FutterID es gibt, z.B. 1

-- 3. Fütterung einfügen -> das soll den Trigger auslösen
-- HIER mussen evtl. Spaltennamen anpassen je nach deiner Fuetterung-Tabelle
INSERT INTO dbo.Fuetterung (TierID, FutterID, Datum, Menge)
VALUES (1, 1, GETDATE(), 2.5);

-- Wenn deine Fuetterung-Tabelle anders heißt/spalten hat, nimm diese:
-- SELECT * FROM dbo.Fuetterung; -- schau erst welche Spalten du hast

-- 4. Nachher-Status: LetzteFuetterung sollte jetzt aktuelles Datum sein!
SELECT TierID, Name, LetzteFuetterung 
FROM dbo.Tier 
WHERE TierID = 1;

-- Erwartet: LetzteFuetterung = heute 2026-08-24 14:3x