

USE [ZooManagement]
GO

/****** Objekt:  View [dbo].[VIEW_FutterplanAlleTiere]    Skriptdatum: 25.08.2026 21:32:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Martina Kratt
-- Create date: 25.08.2026
-- Description: Erstellt View die Futterplan fuer alle Tiere anzeigt (welches Futter, in welcher Menge, wie oft gefuettert werden soll)
-- =============================================
CREATE OR ALTER VIEW [dbo].[VIEW_FutterplanAlleTiere]
AS
SELECT
    dbo.Tier.TierID,
    dbo.Tier.Name AS Tiername,
    dbo.Futter.Futtername,
    dbo.Futter.Futterart,
    dbo.Futterplan.MengeProTier,
    dbo.Futtereinheit.Einheit,
    dbo.Futterplan.FuetterungenProTag
FROM dbo.Tier 
INNER JOIN dbo.Tierart 
    ON dbo.Tier .TierartID = dbo.Tierart.TierartID
INNER JOIN dbo.Futterplan 
    ON dbo.Tierart.TierartID = dbo.Futterplan.TierartID
INNER JOIN dbo.Futter 
    ON dbo.Futterplan.FutterID = dbo.Futter.FutterID
INNER JOIN dbo.Futtereinheit 
    ON dbo.Futter.FuttereinheitID = dbo.Futtereinheit.FuttereinheitID;
GO


