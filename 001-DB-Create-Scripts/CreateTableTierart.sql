USE [ZooManagement]
GO

/****** Objekt:  Table [dbo].[Tierart]    Skriptdatum: 26.08.2026 14:39:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Tierart](
	[TierartID] [int] IDENTITY(1,1) NOT NULL,
	[Tierartname] [nvarchar](50) NOT NULL,
	[WissenschaftlicherName] [nvarchar](100) NULL,
	[Herkunftsland] [nvarchar](50) NULL,
	[UntersuchungsintervallMonate] [int] NULL,
 CONSTRAINT [PK_Tierart] PRIMARY KEY CLUSTERED 
(
	[TierartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Tierart_Tierartname] UNIQUE NONCLUSTERED 
(
	[Tierartname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Tierart]  WITH CHECK ADD  CONSTRAINT [CK_Tierart_UntersuchungsintervallMonate] CHECK  (([UntersuchungsintervallMonate] IS NULL OR [UntersuchungsintervallMonate]>(0)))
GO

ALTER TABLE [dbo].[Tierart] CHECK CONSTRAINT [CK_Tierart_UntersuchungsintervallMonate]
GO


