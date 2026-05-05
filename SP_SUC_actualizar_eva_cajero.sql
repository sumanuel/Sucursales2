IF OBJECT_ID('dbo.SP_SUC_actualizar_eva_cajero', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_actualizar_eva_cajero;
GO

CREATE PROCEDURE dbo.SP_SUC_actualizar_eva_cajero
    @ID_EVA     INT,
    @EVA_RUT    VARCHAR(10),
    @EVA_NOMBRE VARCHAR(150),
    @EVA_SUC    INT,
    @EVA_EMP    VARCHAR(150),
    @EVA_FCH_DES DATE,
    @EVA_FCH_HAS DATE,
    @EVA_COM    VARCHAR(250) = NULL,
    @EVA_EST    SMALLINT = 1,
    @EVA_USR    VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SET @EVA_RUT = LTRIM(RTRIM(ISNULL(@EVA_RUT, '')));
        SET @EVA_NOMBRE = LTRIM(RTRIM(ISNULL(@EVA_NOMBRE, '')));
        SET @EVA_EMP = LTRIM(RTRIM(ISNULL(@EVA_EMP, '')));
        SET @EVA_COM = LTRIM(RTRIM(ISNULL(@EVA_COM, '')));
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

        IF @EVA_RUT = ''
        BEGIN
            SELECT 'ERROR' AS resultado, 'El rut del cajero es obligatorio.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_NOMBRE = ''
        BEGIN
            SELECT 'ERROR' AS resultado, 'El nombre del cajero es obligatorio.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_SUC IS NULL OR @EVA_SUC <= 0
        BEGIN
            SELECT 'ERROR' AS resultado, 'La sucursal es obligatoria y debe ser mayor a cero.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_EMP = ''
        BEGIN
            SELECT 'ERROR' AS resultado, 'La empresa es obligatoria.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
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

        IF LEN(@EVA_RUT) > 10
        BEGIN
            SELECT 'ERROR' AS resultado, 'El rut excede el largo permitido de la columna EVA_RUT (10).' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_NOMBRE) > 10
        BEGIN
            SELECT 'ERROR' AS resultado, 'El nombre excede el largo permitido de la columna EVA_NOMBRE (10). Ajuste la tabla o reduzca el valor.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_EMP) > 150
        BEGIN
            SELECT 'ERROR' AS resultado, 'La empresa excede el largo permitido de la columna EVA_EMP (150).' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_COM) > 250
        BEGIN
            SELECT 'ERROR' AS resultado, 'El comentario excede el largo permitido de la columna EVA_COM (250).' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_USR) > 50
        BEGIN
            SELECT 'ERROR' AS resultado, 'El usuario excede el largo permitido de la columna EVA_USR (50).' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.SUC_CAP_EVA
            WHERE EVA_RUT = @EVA_RUT
              AND EVA_SUC = @EVA_SUC
              AND EVA_EMP = @EVA_EMP
              AND EVA_FCH_DES = @EVA_FCH_DES
              AND EVA_FCH_HAS = @EVA_FCH_HAS
              AND EVA_EST = ISNULL(@EVA_EST, 1)
              AND ID_EVA <> @ID_EVA
        )
        BEGIN
            SELECT 'ERROR' AS resultado, 'Ya existe otra evaluacion activa con los mismos datos para el cajero.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        UPDATE dbo.SUC_CAP_EVA
        SET EVA_RUT = @EVA_RUT,
            EVA_NOMBRE = @EVA_NOMBRE,
            EVA_SUC = @EVA_SUC,
            EVA_EMP = @EVA_EMP,
            EVA_FCH_DES = @EVA_FCH_DES,
            EVA_FCH_HAS = @EVA_FCH_HAS,
            EVA_COM = NULLIF(@EVA_COM, ''),
            EVA_EST = ISNULL(@EVA_EST, 1),
            EVA_USR = NULLIF(@EVA_USR, ''),
            EVA_FCH = GETDATE()
        WHERE ID_EVA = @ID_EVA;

        SELECT 'OK' AS resultado, 'Registro actualizado correctamente.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS resultado, ERROR_MESSAGE() AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
    END CATCH
END;
GO

/*
Nota:
- La tabla definida actualmente usa EVA_NOMBRE VARCHAR(10).
- Si se requiere editar nombres mas largos, primero ajustar la columna.
*/