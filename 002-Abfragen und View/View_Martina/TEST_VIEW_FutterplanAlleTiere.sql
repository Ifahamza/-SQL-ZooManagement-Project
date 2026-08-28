USE [ZooManagement]
GO
-- =============================================
-- Author: Martina Kratt
-- Create date: 25.08.2026
-- Description:  View zeigt Futterplan fuer alle Tiere an (welches Futter, in welcher Menge, wie oft gefuettert werden soll)
-- =============================================
SELECT *
FROM dbo.View_FutterplanAlleTiere
ORDER BY TierID;