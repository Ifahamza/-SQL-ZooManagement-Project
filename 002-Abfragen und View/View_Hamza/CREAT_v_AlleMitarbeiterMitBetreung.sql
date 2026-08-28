USE [ZooManagement]
GO

/****** Objekt:  View [dbo].[v_AlleMitarbeiterMitBetreuung]    Skriptdatum: 26.08.2026 10:14:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Hamza Ifa
-- Create date: 24.08.2026
-- Description: Komplette Übersicht aller aktiven
--              Tierbetreuungen mit Details zu 
--              Mitarbeiter, Tier, Tierart und 
--              Gehege. Verknüpft 5 Tabellen
--              mit INNER JOIN.
-- =============================================

CREATE VIEW [dbo].[v_AlleMitarbeiterMitBetreuung]
AS
SELECT        m.MitarbeiterID, m.Vorname, m.Nachname, m.Mitarbeitertyp, t.TierID, t.Name AS TierName, ta.Tierartname, g.GehegeID, tb.VonDatum, CASE WHEN tb.BisDatum IS NULL THEN 'unbegrenzt' ELSE CONVERT(VARCHAR(10), 
                         tb.BisDatum, 104) END AS BisDatum
FROM            dbo.Mitarbeiter AS m INNER JOIN
                         dbo.Tierbetreuung AS tb ON m.MitarbeiterID = tb.MitarbeiterID INNER JOIN
                         dbo.Tier AS t ON tb.TierID = t.TierID INNER JOIN
                         dbo.Tierart AS ta ON t.TierartID = ta.TierartID INNER JOIN
                         dbo.Gehege AS g ON t.GehegeID = g.GehegeID
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[51] 4[10] 2[20] 3) )"
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
         Begin Table = "m"
            Begin Extent = 
               Top = 41
               Left = 391
               Bottom = 171
               Right = 578
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tb"
            Begin Extent = 
               Top = 12
               Left = 687
               Bottom = 142
               Right = 867
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 89
               Left = 966
               Bottom = 219
               Right = 1133
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ta"
            Begin Extent = 
               Top = 6
               Left = 1170
               Bottom = 136
               Right = 1422
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "g"
            Begin Extent = 
               Top = 227
               Left = 719
               Bottom = 357
               Right = 901
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
En' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_AlleMitarbeiterMitBetreuung'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'd
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_AlleMitarbeiterMitBetreuung'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_AlleMitarbeiterMitBetreuung'
GO


