USE [ZooManagement]
GO

ALTER TABLE [dbo].[Tier]  WITH CHECK ADD  CONSTRAINT [CK_Tier_Gewicht] CHECK  (([Gewicht] IS NULL OR [Gewicht]>(0)))
GO

ALTER TABLE [dbo].[Tier] CHECK CONSTRAINT [CK_Tier_Gewicht]
GO


