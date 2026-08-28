USE ZooManagement;
GO
-- =======================================================================================================================================
-- Author:		Bernhard Ehnle
-- Create date: 26.8.2026
-- Description:	Trigger auf Tabelle Tier um automatisch die Gehegebelegung zu aktualiseren
-- Es finden folgende Prüfungen statt:
-- - ob das Tier für den Gehegetyp zugelassen ist
-- - ob das Zielgehege inaktiv ist 
-- =======================================================================================================================================


CREATE OR ALTER TRIGGER dbo.tr_GehegeBelegungsDoku
ON dbo.Tier
AFTER INSERT, DELETE, UPDATE
AS
BEGIN

    /* Zulässigkeit der Tierart prüfen */
    IF EXISTS
    (
        SELECT 1
        FROM inserted
        INNER JOIN dbo.Gehege
            ON inserted.GehegeID = Gehege.GehegeID
        LEFT JOIN dbo.TierartGehegeTyp
            ON inserted.TierartID =
               TierartGehegeTyp.TierartID
           AND Gehege.GehegeTypID =
               TierartGehegeTyp.GehegeTypID
        WHERE TierartGehegeTyp.TierartID IS NULL
    )
    BEGIN
        ;THROW 50007,
            N'Die Tierart ist für den Gehegetyp nicht zugelassen.',
            1;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM inserted
        INNER JOIN dbo.Gehege
            ON inserted.GehegeID = Gehege.GehegeID
        WHERE Gehege.Status = 0
    )
    BEGIN
        ;THROW 50008,
            N'Dem Tier kann kein inaktives Gehege zugeordnet werden.',
            1;
    END;


    /* Belegung des alten und neuen Geheges aktualisieren */
    /* Es werden immer alle Tiere in jedem Gehege gezählt, 
    aus Performancegründen könnte man auch nur die Gehege 
    aktualisieren wo sich Änderungen ergeben haben*/
    UPDATE dbo.Gehege
    SET AktuelleBelegung =
    (
        SELECT COUNT(*)
        FROM dbo.Tier
        WHERE Tier.GehegeID = Gehege.GehegeID
    );

END;
GO