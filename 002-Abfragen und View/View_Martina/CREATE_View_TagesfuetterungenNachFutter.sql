USE [ZooManagement]
GO

/****** Objekt:  View [dbo].[View_TagesfuetterungenNachFutter]    Skriptdatum: 27.08.2026 00:32:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Martina Kratt
-- Create date: 25.08.2026
-- Description: View um anzuzeigen welches Futter mindestens 2mal am Tag verfütert wurde
-- =============================================
CREATE OR ALTER VIEW [dbo].[View_TagesfuetterungenNachFutter]
AS
SELECT         dbo.Futter.FutterID ,dbo.Futter.Futtername, COUNT(*) AS AnzahlFuetterungen, SUM(dbo.Fuetterung.Menge) AS Gesamtmenge, dbo.Futtereinheit.Einheit
FROM          dbo.Fuetterung INNER JOIN
                         dbo.Futter ON dbo.Fuetterung.FutterID = dbo.Futter.FutterID
                         INNER JOIN
                         dbo.Futtereinheit ON dbo.Futter.FuttereinheitID = dbo.Futtereinheit.FuttereinheitID
WHERE CAST(dbo.Fuetterung.Zeitpunkt AS date) = CAST(GETDATE() AS date)

GROUP BY
    dbo.Futter.FutterID,
    dbo.Futter.Futtername,
    dbo.Futtereinheit.Einheit

HAVING COUNT(*) >= 2;
GO


