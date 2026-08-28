USE [ZooManagement]
GO

/****** Objekt:  View [dbo].[View_Tagesfuetterungsstatus]    Skriptdatum: 27.08.2026 01:23:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Martina Kratt
-- Create date: 25.08.2026
-- Description: View um fuer Tier jew.Ist/Soll Fuetterungsmenge nach aktuellem Fuetterungsplan sowie Fuetterungsstatus aus Abgleich anzuzeigen
-- =============================================

CREATE or ALTER  VIEW [dbo].[View_Tagesfuetterungsstatus]
AS
SELECT
    dbo.Tier.TierID,
    dbo.Tier.Name AS Tiername,
    dbo.Futter.Futtername,
    dbo.Futtereinheit.Einheit,

    dbo.Futterplan.MengeProTier
        * dbo.Futterplan.FuetterungenProTag AS SollProTag,

    ISNULL(SUM(dbo.Fuetterung.Menge), 0) AS IstProTag,  --ISNULL(Wert,Ersatzwert) -> falls SUM(dbo.Fuetterung.Menge) = NULL ist, setze IstProTag =0 statt NULL
    -- Berechne aktuellen FuetterungsStatus aus Ist und Soll:
    CASE
        WHEN ISNULL(SUM(dbo.Fuetterung.Menge), 0)
             <
             dbo.Futterplan.MengeProTier
             * dbo.Futterplan.FuetterungenProTag
        THEN 'Noch Nicht Genug Gefüttert'

        WHEN ISNULL(SUM(dbo.Fuetterung.Menge), 0)
             =
             dbo.Futterplan.MengeProTier
             * dbo.Futterplan.FuetterungenProTag
        THEN 'OK'

        ELSE 'Überfüttert'
    END AS Status

FROM dbo.Tier

INNER JOIN dbo.Futterplan                                --INNER JOIN: zeige alle Tiere an fuer die Futterplan existiert
    ON dbo.Tier.TierartID = dbo.Futterplan.TierartID

INNER JOIN dbo.Futter                                    -- INNER JOIN : Futterplan muss auch auf vorhandene FutterID zeigen
    ON dbo.Futterplan.FutterID = dbo.Futter.FutterID

INNER JOIN dbo.Futtereinheit
    ON dbo.Futter.FuttereinheitID = dbo.Futtereinheit.FuttereinheitID

LEFT JOIN dbo.Fuetterung                                       -- LEFT JOIN um auch Tiere anzuzeigen die heute noch nicht gefuettert wurden
    ON dbo.Tier.TierID = dbo.Fuetterung.TierID
    AND dbo.Futter.FutterID = dbo.Fuetterung.FutterID           --es sollen nur heutige Fuetterungen angzeigt werden, die Futter das laut Futterplan vorgesehen ist betreffen 
    AND CAST(dbo.Fuetterung.Zeitpunkt AS date) = CAST(GETDATE() AS date)  -- GETDATE() liefert Datum UND Uhrzeit -> für nur Datum CAST(... AS date)

WHERE CAST(GETDATE() AS date) >= dbo.Futterplan.GueltigAb      --Futterplan muss heute gueltig sein
  AND (
      dbo.Futterplan.GueltigBis IS NULL
      OR CAST(GETDATE() AS date) <= dbo.Futterplan.GueltigBis
  )
 -- in GROUP BY alles auswählen was in SELECT angezeigt werden soll ( direkt oder indirekt ( z.B. bei IstProTag) und nicht schon durch Aggregatfunktion wie SUM() zusammengefasst wird
GROUP BY                           
    dbo.Tier.TierID,
    dbo.Tier.Name,
    dbo.Futter.Futtername,
    dbo.Futtereinheit.Einheit,
    dbo.Futterplan.MengeProTier,
    dbo.Futterplan.FuetterungenProTag;
GO


