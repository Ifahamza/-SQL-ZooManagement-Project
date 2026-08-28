USE ZooManagement;
GO
-- Einzelnes Tier
SELECT dbo.sf_BerechneTierAlter(1) AS [Alter];

-- Alle Tiere mit Alter
SELECT
    TierID,
    Name AS TierName,
    Geburtsdatum,
    dbo.sf_BerechneTierAlter(TierID) AS AlterInJahren
FROM Tier;