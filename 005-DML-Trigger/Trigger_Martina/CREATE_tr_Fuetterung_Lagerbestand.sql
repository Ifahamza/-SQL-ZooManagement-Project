
USE [ZooManagement]
GO
-- =============================================
-- Author: Martina Kratt
-- Create date: 25.08.2026
-- Description: Trigger, auf dbo.Futter, der nach erfolgreich eingetragener Fuetterung den Lagerbstand um verfuetterte Menge reduziert
-- Wird momentan in sp_FuetterungEintragen genutzt, wo nur eine Fuetterung auf einmal durchgeführt wurde, aber Trigger ist so geschrieben,
-- dass auch INSERT INTO dbo.Fuetterung mit mehreren Fuetterungen  ( Zeilen) auf einmal abgefangen wird

-- =============================================
CREATE OR ALTER TRIGGER dbo.tr_Fuetterung_Lagerbestand
ON dbo.Fuetterung
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Futter
    SET dbo.Futter.Lagerbestand =
        dbo.Futter.Lagerbestand - Verbrauch.GesamtMenge
    FROM dbo.Futter
    INNER JOIN
    (
        SELECT
            FutterID,
            SUM(Menge) AS GesamtMenge
        FROM inserted
        GROUP BY FutterID
    ) AS Verbrauch
        ON dbo.Futter.FutterID = Verbrauch.FutterID;
END;
GO