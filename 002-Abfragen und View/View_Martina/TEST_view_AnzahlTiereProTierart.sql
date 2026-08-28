USE [ZooManagement]
GO
-- =============================================
-- Author: Martina Kratt
-- Create date: 25.08.2026
-- Description: Zeigt View die fuer jede TierartID die Anzahl der Tiere anzeigt
-- =============================================
SELECT TOP (1000) [TierartID]
      ,[Tierartname]
      ,[ANZ_Tiere]
  FROM [ZooManagement].[dbo].[View_AnzahlTiereProTierartID]
