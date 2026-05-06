IF OBJECT_ID('dbo.SP_SUC_listar_ges_eva_cajero', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_listar_ges_eva_cajero;
GO

IF OBJECT_ID('dbo.SP_SUC_listar_eva_cajero', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_listar_eva_cajero;
GO

CREATE PROCEDURE [dbo].[SP_SUC_listar_ges_eva_cajero]
    @ID_EVA        INT = NULL,
    @EVA_EST       SMALLINT = NULL,
    @EVA_SUC       INT = NULL,
    @EVA_RUT       VARCHAR(10) = NULL,
    @TOP_REGISTROS INT = 100,
    @FCH_DESDE     DATE = NULL,
    @FCH_HASTA     DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @INICIO_MES_ACTUAL DATE;
        DECLARE @FIN_MES_ACTUAL DATE;
        DECLARE @FECHA_AUX DATE;

        SET @EVA_RUT = LTRIM(RTRIM(ISNULL(@EVA_RUT, '')));
        SET @INICIO_MES_ACTUAL = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);
        SET @FIN_MES_ACTUAL = EOMONTH(GETDATE());

        IF @TOP_REGISTROS IS NULL OR @TOP_REGISTROS <= 0
            SET @TOP_REGISTROS = 100;

        IF @FCH_DESDE IS NOT NULL AND @FCH_HASTA IS NOT NULL AND @FCH_DESDE > @FCH_HASTA
        BEGIN
            SET @FECHA_AUX = @FCH_DESDE;
            SET @FCH_DESDE = @FCH_HASTA;
            SET @FCH_HASTA = @FECHA_AUX;
        END

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
          AND (@EVA_RUT = '' OR EVA_RUT = @EVA_RUT)
          AND (
              @ID_EVA IS NOT NULL
              OR (
                  @FCH_DESDE IS NULL
                  AND @FCH_HASTA IS NULL
                  AND EVA_FCH_DES <= @FIN_MES_ACTUAL
                  AND EVA_FCH_HAS >= @INICIO_MES_ACTUAL
              )
              OR (
                  (@FCH_DESDE IS NOT NULL OR @FCH_HASTA IS NOT NULL)
                  AND EVA_FCH_DES <= ISNULL(@FCH_HASTA, CONVERT(DATE, '99991231'))
                  AND EVA_FCH_HAS >= ISNULL(@FCH_DESDE, CONVERT(DATE, '19000101'))
              )
          )
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