IF OBJECT_ID('dbo.SP_SUC_obtener_pre_eva_cajero', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_obtener_pre_eva_cajero;
GO

CREATE PROCEDURE [dbo].[SP_SUC_obtener_pre_eva_cajero]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            PRE_ID_PRE,
            PRE_TIT,
            PRE_PRE,
            PRE_ORD
        FROM dbo.SUC_CAP_PRE
        WHERE ISNULL(PRE_EST, 0) = 1
        ORDER BY PRE_ORD ASC, PRE_ID_PRE ASC;
    END TRY
    BEGIN CATCH
        SELECT
            'ERROR' AS resultado,
            ERROR_MESSAGE() AS mensaje,
            CAST(NULL AS INT) AS pre_id_pre;
    END CATCH
END;
GO
