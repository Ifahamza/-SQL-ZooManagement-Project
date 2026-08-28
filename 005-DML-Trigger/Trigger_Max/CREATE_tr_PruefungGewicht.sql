USE [ZooManagement]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		von der Bank, Maximilian
-- Create date: 25.08.2026
-- Description:	AFTER-UPDATE-Trigger auf dbo.Tier: prüft nach jeder Gewichtsänderung,
--              ob das neue Gewicht eines Tieres um mehr als 50% vom Durchschnittsgewicht
--              seiner Tierart abweicht. Es wird IMMER ein Eintrag in
--              dbo.TierLogGewichtWarnung angelegt - entweder eine Warnung
--              (Abweichung > 50%) oder eine Bestätigung "Alles ok", falls das
--              Gewicht im erlaubten Bereich liegt. So ist die jeweils neueste
--              Zeile für ein Tier immer eindeutig dem letzten Update zuordenbar.
-- =============================================

CREATE OR ALTER TRIGGER dbo.tr_TierGewichtPruefen
ON dbo.Tier
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON

    IF NOT UPDATE(Gewicht)     -- Trigger soll nur reagieren, wenn sich tatsächlich die Spalte Gewicht geändert hat 
        RETURN

    INSERT INTO dbo.TierLogGewichtWarnung (TierID, Warnungstext)
    SELECT 
        TierID,
        CASE 
            
            WHEN Gewicht IS NULL 
                THEN 'Hinweis: Kein Gewicht angegeben – Prüfung nicht möglich.'

            
            WHEN Durchschnitt.AvgGewicht IS NULL OR Durchschnitt.AvgGewicht = 0 
                THEN 'Hinweis: Kein Vergleichswert vorhanden – Durchschnittsgewicht der Tierart konnte nicht berechnet werden.'

            -- Abweichung > 50% -> Warnung, mit Unterscheidung ÜBER/UNTER Durchschnitt
            WHEN ABS(Gewicht - Durchschnitt.AvgGewicht) / Durchschnitt.AvgGewicht * 100 > 50
                THEN 'Warnung: '
                    + CASE WHEN Gewicht > Durchschnitt.AvgGewicht THEN 'Übergewicht' ELSE 'Untergewicht' END
                    + ' – das neue Gewicht weicht um '
                    + CAST(CAST(ROUND(ABS(Gewicht - Durchschnitt.AvgGewicht) / Durchschnitt.AvgGewicht * 100, 1) AS DECIMAL(10,1)) AS VARCHAR(20))
                    + '% vom Durchschnittsgewicht der Tierart ab.'

            -- Abweichung <= 50% -> Bestätigung statt Warnung
            ELSE 'Alles ok. Gewicht liegt im erlaubten Bereich (Abweichung: '
                    + CAST(CAST(ROUND(ABS(Gewicht - Durchschnitt.AvgGewicht) / Durchschnitt.AvgGewicht * 100, 1) AS DECIMAL(10,1)) AS VARCHAR(20))
                    + '%).'
        END
    FROM inserted
    CROSS APPLY (SELECT dbo.sf_DurchschnittsGewichtTierart(TierartID) AS AvgGewicht) Durchschnitt
END
GO

ALTER TABLE dbo.Tier ENABLE TRIGGER tr_TierGewichtPruefen
GO