
USE [ZooManagement]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Martina Kratt
-- Create date: 25.08.2026
-- Description: Skalarwertfunktion um aus Lagerbestand und GesamtbedarfProTag fuer jede Futterart die Reichweite zu berechnen
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[sf_BerechneFutterReichweite]  
(
	-- Add the parameters for the function here
	@FutterID int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @FutterReichweiteInTagen int
	DECLARE @GesamtbedarfProTag decimal
	DECLARE @Lagerbestand decimal

	-- Add the T-SQL statements to compute the return value here
	--SELECTa <@ResultVar, sysname, @Result> = <@Param1, sysname, @p1>

	-- 1. @Lagerbestand muss vor CTE stehen da Abfrage direkt nach CTE kommen muss
	SET @Lagerbestand =( SELECT dbo.Futter.Lagerbestand FROM dbo.Futter WHERE dbo.Futter.FutterID = @FutterID);
	-- 2. CTE starten
	WITH Anz_Tiere_Tab AS (
	SELECT TierartID, COUNT(TierartID) AS ANZ_Tiere
	FROM   dbo.Tier
	GROUP BY TierartID
	)
   --3. Abfrage welche die CTE nutzt muss direkt nach CTE kommen
	SELECT @GesamtbedarfProTag = SUM(dbo.Futterplan.MengeProTier*  dbo.Futterplan.FuetterungenProTag * Anz_Tiere_Tab.ANZ_Tiere)
	FROM dbo.Futterplan
	INNER JOIN Anz_Tiere_Tab ON dbo.Futterplan.TierartID = Anz_Tiere_Tab.TierartID
	WHERE dbo.Futterplan.FutterID = @FutterID;
	--  4. Absicherung gegen Teilen durch 0, falls kein Tier das Futter frisst
	IF @GesamtbedarfProTag IS NULL OR @GesamtbedarfProTag = 0
		SET @FutterReichweiteInTagen = 0;
	ELSE
		SET @FutterReichweiteInTagen = (@Lagerbestand / @GesamtbedarfProTag);


		--alternative :
	--	SET @Gesamtbedarf = (
	--    SELECT SUM(f.mengeprotier * f.fuetterungenprotag * t.ANZ_Tiere)
	--    FROM dbo.Futterplan AS f
	--    INNER JOIN (
	--        -- Inhalt von CTE
	--        SELECT TierartID, COUNT(TierartID) AS ANZ_Tiere
	--        FROM dbo.Tier
	--        GROUP BY TierartID
	--    ) AS t 
	--        ON f.TierartID = t.TierartID
	--    WHERE f.FutterID = @FutterID
	--);

	-- Return the result of the function
	RETURN @FutterReichweiteInTagen

END
GO

