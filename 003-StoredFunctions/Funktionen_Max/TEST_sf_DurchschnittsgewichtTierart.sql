USE[ZooManagement]
GO

-- manuelle Durchschnitssermittlung
SELECT AVG(Gewicht) AS DurchschnittManuell
FROM dbo.Tier
WHERE TierartID = 1


-- automatisch über Skalarwertfunktion
SELECT dbo.sf_DurchschnittsGewichtTierart(1) AS DurchschnittsGewichtInKg

SELECT dbo.sf_DurchschnittsGewichtTierart(99999) AS DurchschnittsGewichtInKg

SELECT dbo.sf_DurchschnittsGewichtTierart(NULL) AS DurchschnittsGewichtInKg

-- SELECT dbo.sf_DurchschnittsGewichtTierart(abc) AS DurchschnittsGewichtInKg