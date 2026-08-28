USE [ZooManagement]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		von der Bank, Maximilian
-- Create date: 25.08.2026
-- Description:	Protokolltabelle, in der der Trigger tr_TierGewichtPruefen automatisch
--              eine Warnung einträgt, sobald sich das Gewicht eines Tieres stark
--              vom Durchschnittsgewicht seiner Tierart unterscheidet.
-- =============================================

-- 1. CREATE TABLE
CREATE TABLE dbo.TierLogGewichtWarnung
(
    WarnungID       INT IDENTITY(1,1) PRIMARY KEY,
    TierID          INT NOT NULL,
    Warnungstext    NVARCHAR(200) NOT NULL,
    ErstelltAm      DATETIME NOT NULL DEFAULT GETDATE()
)
GO

-- 2. CREATE NONCLUSTERED INDEX
CREATE NONCLUSTERED INDEX IX_TierLogGewichtWarnung_TierID_WarnungID
ON dbo.TierLogGewichtWarnung (TierID, WarnungID DESC)
GO

-- 3. ADD CONSTRAINT FOREIGN KEY
ALTER TABLE dbo.TierLogGewichtWarnung
ADD CONSTRAINT FK_TierLogGewichtWarnung_Tier
FOREIGN KEY (TierID) REFERENCES dbo.Tier(TierID)
GO

-- 4. ADD CONSTRAINT CHECK
ALTER TABLE dbo.TierLogGewichtWarnung
ADD CONSTRAINT CK_TierLogGewichtWarnung_Warnungstext
CHECK (LEN(Warnungstext) > 0)
GO