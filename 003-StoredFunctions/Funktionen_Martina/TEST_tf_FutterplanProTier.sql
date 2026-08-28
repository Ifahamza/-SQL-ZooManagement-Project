USE [ZooManagement]
GO
-- =============================================
-- Author: Martina Kratt
-- Create date: 25.08.2026
-- Description: Ruft Tabellenwertfunktion tf_FutterplanProTier auf, die Futterplanhistorie eines Tiers zurückgibt
-- =============================================

SELECT
    TierID,
    Tiername,
    --Tierart,
    Futtername,
    Futterart,
    MengeProTier,
    Einheit,
    FuetterungenProTag,
    Fuetterungszeitpunkt,
    TatsächlicheMenge
FROM dbo.tf_FutterplanProTier(1)
ORDER BY Fuetterungszeitpunkt;