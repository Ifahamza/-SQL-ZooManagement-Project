-- 1. Zuerst die fehlende Spalte in Tier hinzufügen
ALTER TABLE dbo.Tier ADD LetzteFuetterung DATETIME NULL;
GO

-- 2. Jetzt funktioniert dein Trigger
CREATE OR ALTER TRIGGER trg_Fuetterung_Update
ON Fuetterung
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Tier SET LetzteFuetterung = GETDATE()
    WHERE TierID IN (SELECT TierID FROM inserted);
END;
GO