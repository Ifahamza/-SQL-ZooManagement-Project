USE [ZooManagement]
GO
-- =============================================
-- Author: Martina Kratt
-- Create date: 25.08.2026
-- Description: Testskript fuer sf_IstFutterbestandAusreichend
-- Überprüft ob gewünschtes Futter in gewünschter Menge ausreichend im Lagerbestand vorhanden ist und gibt 
-- @Ausreichend BIT = 0 (nicht ausreichend) oder @Ausreichend = 1 (aureichend vorhanden) zurück.
-- Wird in dbo.sp_FuetterungEintragen genutzt
-- =============================================

SELECT
    FutterID,
    Futtername,
    Lagerbestand
FROM dbo.Futter;

SELECT dbo.sf_IstFutterbestandAusreichend(3, 5) AS IstGenugVorhanden;

SELECT dbo.sf_IstFutterbestandAusreichend(3, 500) AS IstGenugVorhanden;