USE [ZooManagement]
GO

-- =======================================================================================================================================
-- Author:		Bernhard Ehnle
-- Create date: 26.8.2026
-- Description:	Test der Tabellenwertfunktion dbo.tf_TiereImGehege
-- =======================================================================================================================================

--Anhand GehegeID
SELECT *
FROM dbo.tf_TiereImGehege(1);


--Anhand Gehegename
DECLARE @GehegeID INT;

SELECT @GehegeID = GehegeID
FROM dbo.Gehege
WHERE Gehegename = N'Großkatzenanlage';

SELECT *
FROM dbo.tf_TiereImGehege(@GehegeID);


--Funtkion für alle Gehege
SELECT
    Gehege.Gehegename,
    Tiere.TierID,
    Tiere.Name,
    Tiere.Tierartname,
    Tiere.Geburtsdatum,
    Tiere.Geschlecht
FROM dbo.Gehege
OUTER APPLY dbo.tf_TiereImGehege(Gehege.GehegeID)
    AS Tiere
ORDER BY
    Gehege.Gehegename,
    Tiere.Name;