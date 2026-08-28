USE [ZooManagement]
GO

-- =======================================================================================================================================
-- Author:		Bernhard Ehnle
-- Create date: 26.8.2026
-- Description:	Test der Skalarwertfunktion dbo.sf_BerechneFreiePlaetze
-- =======================================================================================================================================

--für ein Gehege
SELECT dbo.sf_BerechneFreiePlaetze(3)
       AS FreiePlaetze;

--Für alle gehege
SELECT
    GehegeID,
    Gehegename,
    Kapazitaet,
    AktuelleBelegung,
    dbo.sf_BerechneFreiePlaetze(GehegeID)
        AS FreiePlaetze
FROM dbo.Gehege
ORDER BY Gehegename;

--Test falls Gehege nicht exisistiert
SELECT dbo.sf_BerechneFreiePlaetze(99999)
       AS FreiePlaetze;