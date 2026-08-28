USE ZooManagement;
GO
-- =============================================
-- Author:		Javier Montanez
-- Create date: August 25th 2026
-- Description(DE): 
-- Erstellung den Trigger tr_KostenValidierung. Es ist ein AFTER INSERT, UPDATE Trigger auf der
--Tabelle Untersuchung, der verhindert, dass negative Kosten gespeichert werden. 
--Bei Kosten < 0 wird die Transaktion mit ROLLBACK abgebrochen.
-- Description(EN):
-- Description: Creating the trigger tr_KostenValidierung.
-- It is an AFTER INSERT, UPDATE trigger on table Untersuchung that validates costs.
-- If inserted costs are negative (< 0), it aborts the transaction 
--with ROLLBACK TRANSACTION.
-- =============================================
DROP TRIGGER IF EXISTS dbo.tr_KostenValidierung;
GO
CREATE TRIGGER dbo.tr_KostenValidierung
ON dbo.Untersuchung
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

-- Erklärung:
-- AFTER INSERT, UPDATE = Trigger feuert NACH dem Versuch zu schreiben
-- inserted = virtuelle Tabelle mit den neuen Daten
-- IF EXISTS (Kosten < 0) -> ROLLBACK macht alles rückgängig
-- RAISERROR informiert den Benutzer