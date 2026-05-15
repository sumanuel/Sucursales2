IF OBJECT_ID('dbo.SP_SUC_actualizar_ges_eva_cajero', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_actualizar_ges_eva_cajero;
GO

IF OBJECT_ID('dbo.SP_SUC_actualizar_eva_cajero', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_actualizar_eva_cajero;
GO

CREATE PROCEDURE dbo.SP_SUC_actualizar_ges_eva_cajero
    @ID_EVA      INT,
    @EVA_FCH_DES DATE,
    @EVA_FCH_HAS DATE,
    @EVA_USR     VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SET @EVA_USR = LTRIM(RTRIM(ISNULL(@EVA_USR, '')));
        IF @EVA_USR = '' SET @EVA_USR = 'SISTEMA';

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

        IF @EVA_FCH_DES IS NULL OR @EVA_FCH_HAS IS NULL
        BEGIN
            SELECT 'ERROR' AS resultado, 'Las fechas desde y hasta son obligatorias.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_FCH_DES > @EVA_FCH_HAS
        BEGIN
            SELECT 'ERROR' AS resultado, 'La fecha desde no puede ser mayor que la fecha hasta.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_USR) > 50
        BEGIN
            SELECT 'ERROR' AS resultado, 'El usuario excede el largo permitido de la columna EVA_USR (50).' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.SUC_CAP_EVA A
            INNER JOIN dbo.SUC_CAP_EVA B
                ON B.ID_EVA = @ID_EVA
            WHERE A.ID_EVA <> @ID_EVA
              AND A.EVA_RUT = B.EVA_RUT
              AND A.EVA_SUC = B.EVA_SUC
              AND A.EVA_EMP = B.EVA_EMP
              AND A.EVA_FCH_DES = @EVA_FCH_DES
              AND A.EVA_FCH_HAS = @EVA_FCH_HAS
        )
        BEGIN
            SELECT 'ERROR' AS resultado, 'Ya existe otra evaluacion con los mismos datos para el cajero.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        UPDATE dbo.SUC_CAP_EVA
        SET EVA_FCH_DES = @EVA_FCH_DES,
            EVA_FCH_HAS = @EVA_FCH_HAS,
            EVA_USR = @EVA_USR,
            EVA_FCH = GETDATE()
        WHERE ID_EVA = @ID_EVA;

        EXEC dbo.SCSS_insertar_reporte_log
            @usuario = @EVA_USR,
            @perfil = 'General',
            @funcionalidad = 'Gestion de Cajeros a Evaluar',
            @tipo_accion = 'Editar cajero a evaluar',
            @id_registro = @ID_EVA;

        SELECT 'OK' AS resultado, 'Registro actualizado correctamente.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS resultado, ERROR_MESSAGE() AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
    END CATCH
END;
GO
