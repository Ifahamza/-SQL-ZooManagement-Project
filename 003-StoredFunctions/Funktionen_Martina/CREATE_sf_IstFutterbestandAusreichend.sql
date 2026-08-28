

USE [ZooManagement]
GO
-- =============================================
-- Author: Martina Kratt
-- Create date: 25.08.2026
-- Description: Überprüft ob gewünschtes FUtter in gewünschter Menge ausreichend im Lagerbestand vorhanden ist und gibt 
-- @Ausreichend BIT = 0 (nicht ausreichend) oder @Ausreichend = 1 (aureichend vorhanden) zurück.
-- Wird in dbo.sp_FuetterungEintragen genutzt
-- =============================================
CREATE OR ALTER FUNCTION dbo.sf_IstFutterbestandAusreichend
(
    @FutterID INT,
    @Menge DECIMAL(10,2)
)
RETURNS BIT
AS
BEGIN
    DECLARE @Ausreichend BIT = 0;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Futter
        WHERE FutterID = @FutterID
          AND Lagerbestand >= @Menge
    )
    BEGIN
        SET @Ausreichend = 1;
    END;

    RETURN @Ausreichend;
END;
GO