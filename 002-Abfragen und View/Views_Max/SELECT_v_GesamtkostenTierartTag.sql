USE[ZooManagement]
GO

SELECT TOP (1000) [Tierartname]
      ,[AnzahlTiere]
      ,[GesamtkostenTierartTag]
  FROM [ZooManagement].[dbo].[View_GesamtkostenTierartTag]
