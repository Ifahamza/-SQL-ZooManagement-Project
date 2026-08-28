USE [ZooManagement]
GO
-- =============================================
-- Author: Martina Kratt
-- Create date: 25.08.2026
-- Description: Skalarwertfunktion um aus Lagerbestand und GesamtbedarfProTag fuer jede Futterart die Reichweite zu berechnen
-- =============================================
SELECT 
    FutterID, 
    Futtername, 
    Lagerbestand,
    dbo.sf_BerechneFutterReichweite(FutterID) AS Reichweite_In_Tagen
FROM dbo.Futter;