IF OBJECT_ID('dbo.SP_SUC_actualizar_ges_eva_cajero_central', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_actualizar_ges_eva_cajero_central;
GO

CREATE PROCEDURE dbo.SP_SUC_actualizar_ges_eva_cajero_central
    @ID_EVA       INT,
    @EVA_COM_CEN  VARCHAR(250) = NULL,
    @EVA_USR      VARCHAR(50) = NULL,
    @EVA_PERFIL   VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SET @EVA_COM_CEN = LTRIM(RTRIM(ISNULL(@EVA_COM_CEN, '')));
        SET @EVA_USR = LTRIM(RTRIM(ISNULL(@EVA_USR, '')));
        SET @EVA_PERFIL = LTRIM(RTRIM(ISNULL(@EVA_PERFIL, '')));
        IF @EVA_USR = '' SET @EVA_USR = 'SISTEMA';
        IF @EVA_PERFIL = '' SET @EVA_PERFIL = 'General';

        IF @ID_EVA IS NULL OR @ID_EVA <= 0
        BEGIN
            SELECT 'ERROR' AS resultado, 'El identificador de la evaluacion es obligatorio.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_COM_CEN) > 250
        BEGIN
            SELECT 'ERROR' AS resultado, 'El resultado de areas centrales excede el maximo permitido de 250 caracteres.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM dbo.SUC_CAP_EVA WHERE ID_EVA = @ID_EVA)
        BEGIN
            SELECT 'ERROR' AS resultado, 'No existe la evaluacion indicada.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        UPDATE dbo.SUC_CAP_EVA
        SET EVA_COM_CEN = NULLIF(@EVA_COM_CEN, '')
        WHERE ID_EVA = @ID_EVA;

        EXEC dbo.SCSS_insertar_reporte_log
            @usuario = @EVA_USR,
            @perfil = @EVA_PERFIL,
            @funcionalidad = 'Maestro y Reportes',
            @tipo_accion = 'Guardar resultado areas centrales',
            @id_registro = @ID_EVA;

        SELECT 'OK' AS resultado, 'Resultado de areas centrales actualizado correctamente.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS resultado, ERROR_MESSAGE() AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
    END CATCH
END;
GO