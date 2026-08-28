USE [ZooManagement]
GO

/****** Objekt:  View [dbo].[v_MitarbeiterStruktur]    Skriptdatum: 26.08.2026 10:05:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Hamza Ifa
-- Create date: 24.08.2026
-- Description: Zeigt alle Mitarbeiter mit ihren
--              aktuellen Tierbetreuungen. Nutzt
--              LEFT JOIN, um auch Mitarbeiter 
--              ohne Tiere (z.B. Verwaltung) 
--              anzuzeigen. Wandelt NULL bei 
--              BisDatum in 'unbegrenzt' um.
-- =============================================

CREATE VIEW [dbo].[v_MitarbeiterStruktur]
AS
SELECT        dbo.Mitarbeiter.MitarbeiterID, dbo.Mitarbeiter.Vorname, dbo.Mitarbeiter.Nachname, dbo.Mitarbeiter.Einstellungsdatum, dbo.Mitarbeiter.AbteilungID, dbo.Mitarbeiter.Mitarbeitertyp, dbo.Tier.TierID, dbo.Tier.Name AS TierName, 
                         dbo.Tierbetreuung.VonDatum, CASE WHEN Tierbetreuung.TierID IS NULL THEN NULL WHEN Tierbetreuung.BisDatum IS NULL THEN 'unbegrenzt' ELSE CONVERT(VARCHAR(10), Tierbetreuung.BisDatum, 104) 
                         END AS BisDatum
FROM            dbo.Mitarbeiter LEFT OUTER JOIN
                         dbo.Tierbetreuung ON dbo.Mitarbeiter.MitarbeiterID = dbo.Tierbetreuung.MitarbeiterID LEFT OUTER JOIN
                         dbo.Tier ON dbo.Tierbetreuung.TierID = dbo.Tier.TierID
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[59] 4[12] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Mitarbeiter"
            Begin Extent = 
               Top = 27
               Left = 7
               Bottom = 157
               Right = 194
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Tierbetreuung"
            Begin Extent = 
               Top = 6
               Left = 263
               Bottom = 136
               Right = 443
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Tier"
            Begin Extent = 
               Top = 23
               Left = 578
               Bottom = 153
               Right = 745
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_MitarbeiterStruktur'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_MitarbeiterStruktur'
GO


