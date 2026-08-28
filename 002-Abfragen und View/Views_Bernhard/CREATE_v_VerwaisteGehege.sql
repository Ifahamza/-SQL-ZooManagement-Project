USE ZooManagement;
GO

-- =============================================
-- Author:		Bernhard Ehnle
-- Create date: 26.8.2026
-- Description:	Diese View zeigt alle leeren Gehege
-- =============================================


CREATE OR ALTER VIEW dbo.v_VerwaisteGehege
AS
    SELECT
        Gehege.GehegeID,
        Gehege.Gehegename,
        GehegeTyp.Name AS Gehegetyp,
        Gehege.Kapazitaet,
        Gehege.AktuelleBelegung,
        Gehege.Flaeche,
        Gehege.Status
    FROM dbo.Gehege
    LEFT JOIN dbo.Tier
        ON Gehege.GehegeID = Tier.GehegeID
    INNER JOIN dbo.GehegeTyp
        ON Gehege.GehegeTypID = GehegeTyp.GehegeTypID
    WHERE Tier.TierID IS NULL;
GO


