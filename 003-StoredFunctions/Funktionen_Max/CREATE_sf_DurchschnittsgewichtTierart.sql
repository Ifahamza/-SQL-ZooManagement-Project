USE [ZooManagement]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		von der Bank, Maximilian
-- Create date: 25.08.2026
-- Description:	Skalarwertfunktion, die für eine gegebene TierartID
--              das durchschnittliche Gewicht aller Tiere dieser Tierart
--              berechnet und als einzelnen DECIMAL-Wert zurückgibt.
-- =============================================
CREATE OR ALTER FUNCTION dbo.sf_DurchschnittsGewichtTierart 
(
	@TierartID int		
)
RETURNS DECIMAL(10,2)		
AS
BEGIN
	DECLARE @Durchschnitt DECIMAL(10,2)	

	
	SELECT @Durchschnitt = AVG(Gewicht)		-- Durchschnittsgewicht aller Tiere einer Tierart, welche im Eingabeparameter übergeben wurde
	FROM dbo.Tier
	WHERE TierartID = @TierartID

	RETURN @Durchschnitt

END
GO

