IF OBJECT_ID('dbo.SP_SUC_listar_eva_cajero', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_listar_eva_cajero;
GO

CREATE PROCEDURE [dbo].[SP_SUC_listar_eva_cajero]
    @ID_EVA        INT = NULL,
    @EVA_EST       SMALLINT = NULL,
    @EVA_SUC       INT = NULL,
    @ID_SUCURSAL   INT = NULL,
    @EVA_RUT       VARCHAR(10) = NULL,
    @TOP_REGISTROS INT = 100,
    @VALIDAR_FECHA_DESDE BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SET @EVA_RUT = LTRIM(RTRIM(ISNULL(@EVA_RUT, '')));

        IF @TOP_REGISTROS IS NULL OR @TOP_REGISTROS <= 0
            SET @TOP_REGISTROS = 100;

        SELECT TOP (@TOP_REGISTROS)
            ID_EVA,
            EVA_RUT,
            EVA_NOMBRE,
            suc.suc_nombre EVA_SUC,
            EVA_EMP,
            EVA_FCH_DES,
            EVA_FCH_HAS,
            EVA_COM,
            CASE EVA_EST
                WHEN 1 THEN 'EN CAPACITACION'
                WHEN 2 THEN 'APROBADA'
                WHEN 3 THEN 'RECHAZADA'
                ELSE CAST(EVA_EST AS VARCHAR(10))
            END AS EVA_EST,
            EVA_USR,
            EVA_FCH
        FROM dbo.SUC_CAP_EVA eva
        INNER JOIN dbo.SUC_sucursal suc ON eva.EVA_SUC = suc.cod_bantotal
        WHERE (@ID_EVA IS NULL OR ID_EVA = @ID_EVA)
          AND (@EVA_EST IS NULL OR EVA_EST = @EVA_EST)
          AND (@EVA_SUC IS NULL OR EVA_SUC = @EVA_SUC)
          AND (@ID_SUCURSAL IS NULL OR suc.id_sucursal = @ID_SUCURSAL)
          AND (@EVA_RUT = '' OR EVA_RUT = @EVA_RUT)
          AND (@VALIDAR_FECHA_DESDE = 0 OR eva.EVA_FCH_DES <= CONVERT(DATE, GETDATE()))
        ORDER BY ID_EVA DESC;
    END TRY
    BEGIN CATCH
        SELECT
            'ERROR' AS resultado,
            ERROR_MESSAGE() AS mensaje,
            CAST(NULL AS INT) AS id_eva;
    END CATCH
END;
GO