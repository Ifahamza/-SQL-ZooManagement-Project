USE [ZooManagement]
GO

SELECT TOP (1000) [Mitarbeitertyp]
      ,[AnzahlBetreuteGehege]
      ,[AnzahlMitarbeiter]
  FROM [ZooManagement].[dbo].[View_MitarbeitertypGehegebetreuung]
