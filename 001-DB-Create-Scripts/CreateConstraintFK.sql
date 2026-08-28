USE [ZooManagement]
GO

ALTER TABLE [dbo].[Tier]  WITH CHECK ADD  CONSTRAINT [FK_Tier_Gehege] FOREIGN KEY([GehegeID])
REFERENCES [dbo].[Gehege] ([GehegeID])
GO

ALTER TABLE [dbo].[Tier] CHECK CONSTRAINT [FK_Tier_Gehege]
GO


