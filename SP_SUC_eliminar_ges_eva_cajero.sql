IF OBJECT_ID('dbo.SP_SUC_eliminar_ges_eva_cajero', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_eliminar_ges_eva_cajero;
GO

IF OBJECT_ID('dbo.SP_SUC_eliminar_eva_cajero', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_eliminar_eva_cajero;
GO

CREATE PROCEDURE [dbo].[SP_SUC_eliminar_ges_eva_cajero]
    @ID_EVA  INT,
    @EVA_USR VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SET @EVA_USR = LTRIM(RTRIM(ISNULL(@EVA_USR, '')));

        IF @ID_EVA IS NULL OR @ID_EVA <= 0
        BEGIN
            SELECT 'ERROR' AS resultado, 'El identificador de la evaluacion es obligatorio.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM dbo.SUC_CAP_EVA WHERE ID_EVA = @ID_EVA)
        BEGIN
            SELECT 'ERROR' AS resultado, 'No existe la evaluacion indicada.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

		IF EXISTS (SELECT 1 FROM dbo.SUC_CAP_EVA WHERE ID_EVA = @ID_EVA AND EVA_EST<>1)
        BEGIN
            SELECT 'ERROR' AS resultado, 'Solo se pueden eliminar evaluación esta estado de CAPACITACION.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

       DELETE FROM dbo.SUC_CAP_EVA WHERE ID_EVA = @ID_EVA;

        SELECT 'OK' AS resultado, 'Registro eliminado correctamente.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS resultado, ERROR_MESSAGE() AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
    END CATCH
END;
GO
