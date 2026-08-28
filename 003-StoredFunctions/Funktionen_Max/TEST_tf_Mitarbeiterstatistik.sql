USE[ZooManagement]
GO

-- Alle Abteilungen:
SELECT * FROM dbo.tf_MitarbeiterStatistik(NULL)

-- Nur Abteilung 1:
SELECT * FROM dbo.tf_MitarbeiterStatistik(1)

-- Tierart existiert nicht:
SELECT * FROM dbo.tf_MitarbeiterStatistik(99999)