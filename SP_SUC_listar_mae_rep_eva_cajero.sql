IF OBJECT_ID('dbo.SP_SUC_listar_mae_rep_eva_cajero', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_listar_mae_rep_eva_cajero;
GO

CREATE PROCEDURE dbo.SP_SUC_listar_mae_rep_eva_cajero
    @ID_EVA        INT = NULL,
    @FCH_DESDE     DATE = NULL,
    @FCH_HASTA     DATE = NULL,
    @TOP_REGISTROS INT = 5000
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @TOP_REGISTROS IS NULL OR @TOP_REGISTROS <= 0
            SET @TOP_REGISTROS = 5000;

        IF @FCH_DESDE IS NULL
            SET @FCH_DESDE = DATEADD(MONTH, -3, CONVERT(DATE, GETDATE()));

        IF @FCH_HASTA IS NULL
            SET @FCH_HASTA = CONVERT(DATE, GETDATE());

        IF @FCH_DESDE > @FCH_HASTA
        BEGIN
            DECLARE @FCH_AUX DATE;
            SET @FCH_AUX = @FCH_DESDE;
            SET @FCH_DESDE = @FCH_HASTA;
            SET @FCH_HASTA = @FCH_AUX;
        END;

        SELECT TOP (@TOP_REGISTROS)
            eva.ID_EVA,
            eva.EVA_RUT,
            eva.EVA_NOMBRE,
            eva.EVA_EMP,
            suc.suc_nombre AS EVA_SUC,
            eva.EVA_FCH_DES AS FCH_ENVIO_CAPACITACION,
            CASE
                WHEN eva.EVA_EST IN (2, 3) THEN eva.EVA_FCH
                ELSE NULL
            END AS FCH_EVALUACION,
            eva.EVA_COM,
            ISNULL(eva.EVA_COM_CEN, '') AS EVA_COM_CEN,
            eva.EVA_EST AS EVA_EST_NUM,
            CASE eva.EVA_EST
                WHEN 1 THEN 'EN CAPACITACION'
                WHEN 2 THEN 'APROBADA'
                WHEN 3 THEN 'RECHAZADA'
                ELSE CAST(eva.EVA_EST AS VARCHAR(10))
            END AS EVA_EST,
            CASE
                WHEN ISNULL(puntaje.TOTAL_RESPUESTAS, 0) > 0 THEN
                    CAST(ISNULL(puntaje.TOTAL_SI, 0) AS VARCHAR(10)) + '/' + CAST(puntaje.TOTAL_RESPUESTAS AS VARCHAR(10))
                ELSE ''
            END AS PUNTAJE_EVALUACION
        FROM dbo.SUC_CAP_EVA eva
        INNER JOIN dbo.SUC_sucursal suc
            ON suc.id_sucursal = eva.EVA_SUC
        OUTER APPLY
        (
            SELECT
                SUM(CASE WHEN res.RES_RES = 1 THEN 1 ELSE 0 END) AS TOTAL_SI,
                SUM(CASE WHEN res.RES_RES IN (0, 1) THEN 1 ELSE 0 END) AS TOTAL_RESPUESTAS
            FROM dbo.SUC_CAP_RES res
            WHERE res.ID_EVA = eva.ID_EVA
        ) puntaje
                WHERE (@ID_EVA IS NULL OR eva.ID_EVA = @ID_EVA)
                        AND (
                                @ID_EVA IS NOT NULL
                                OR eva.EVA_EST IN (1, 2, 3)
                            )
          AND (
                @ID_EVA IS NOT NULL
                OR (
                    eva.EVA_FCH_DES >= @FCH_DESDE
                    AND eva.EVA_FCH_DES <= @FCH_HASTA
                )
              )
        ORDER BY eva.EVA_FCH_DES DESC, eva.ID_EVA DESC;
    END TRY
    BEGIN CATCH
        SELECT
            'ERROR' AS resultado,
            ERROR_MESSAGE() AS mensaje,
            CAST(NULL AS INT) AS id_eva;
    END CATCH
END;
GO