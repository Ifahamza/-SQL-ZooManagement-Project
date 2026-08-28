USE [ZooManagement]
GO

/****** Objekt:  Trigger [dbo].[trg_Fuetterung_Update]    Skriptdatum: 24.08.2026 14:44:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   TRIGGER [dbo].[trg_Fuetterung_Update]
ON [dbo].[Fuetterung]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Tier SET LetzteFuetterung = GETDATE()
    WHERE TierID IN (SELECT TierID FROM inserted);
END;
GO

ALTER TABLE [dbo].[Fuetterung] ENABLE TRIGGER [trg_Fuetterung_Update]
GO


