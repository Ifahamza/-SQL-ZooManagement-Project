USE [ZooManagement]
GO

/****** Objekt:  Trigger [dbo].[tr_KostenValidierung]    Skriptdatum: 24.08.2026 14:48:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[tr_KostenValidierung]
ON [dbo].[Untersuchung]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Prüfen ob negative Kosten eingefügt/aktualisiert wurden
    IF EXISTS (SELECT 1 FROM inserted WHERE Kosten < 0)
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('Fehler: Kosten dürfen nicht negativ sein. Transaktion abgebrochen.', 16, 1);
        RETURN;
    END
END;
GO

ALTER TABLE [dbo].[Untersuchung] ENABLE TRIGGER [tr_KostenValidierung]
GO


