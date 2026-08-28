USE ZooManagement;
GO
-- Test 1: Funktioniert?
SELECT dbo.sf_BerechneTierAlter(1) AS Test_Tier_1;

-- Test 2: Vergleich Geburtsdatum vs berechnetes Alter
SELECT TOP 10 
    TierID, 
    Name, 
    Geburtsdatum, 
    DATEDIFF(YEAR, Geburtsdatum, GETDATE()) AS Einfach_DATEDIFF,
    dbo.sf_BerechneTierAlter(TierID) AS Korrektes_Alter
FROM Tier
ORDER BY Geburtsdatum;

-- Test 3: NULL Test
SELECT dbo.sf_BerechneTierAlter(9999) AS NichtExistierendeTierID; -- Muss NULL liefern