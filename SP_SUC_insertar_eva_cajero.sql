IF OBJECT_ID('dbo.SP_SUC_insertar_ges_eva_cajero', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_insertar_ges_eva_cajero;
GO

IF OBJECT_ID('dbo.SP_SUC_insertar_eva_cajero', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_insertar_eva_cajero;
GO

CREATE PROCEDURE [dbo].[SP_SUC_insertar_ges_eva_cajero]
    @EVA_RUT     VARCHAR(10),
    @EVA_NOMBRE  VARCHAR(150),
    @EVA_SUC     INT,
    @EVA_EMP     VARCHAR(150),
    @EVA_FCH_DES DATE,
    @EVA_FCH_HAS DATE,
    @EVA_COM     VARCHAR(250) = NULL,
    @EVA_EST     SMALLINT = 1,
    @EVA_USR     VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @ID_SUCURSAL INT;
        DECLARE @ID_EVA INT;
        DECLARE @USUARIO_LOG VARCHAR(50);

        SET @EVA_RUT = LTRIM(RTRIM(ISNULL(@EVA_RUT, '')));
        SET @EVA_NOMBRE = LTRIM(RTRIM(ISNULL(@EVA_NOMBRE, '')));
        SET @EVA_EMP = LTRIM(RTRIM(ISNULL(@EVA_EMP, '')));
        SET @EVA_COM = LTRIM(RTRIM(ISNULL(@EVA_COM, '')));
        SET @EVA_USR = LTRIM(RTRIM(ISNULL(@EVA_USR, '')));
        SET @USUARIO_LOG = @EVA_USR;

        IF @USUARIO_LOG = ''
            SET @USUARIO_LOG = 'SISTEMA';

        IF @EVA_RUT = ''
        BEGIN
            SELECT 'ERROR' AS resultado, 'El rut del cajero es obligatorio.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_NOMBRE = ''
        BEGIN
            SELECT 'ERROR' AS resultado, 'El nombre del cajero es obligatorio.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_SUC IS NULL OR @EVA_SUC <= 0
        BEGIN
            SELECT 'ERROR' AS resultado, 'La sucursal es obligatoria y debe ser mayor a cero.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_EMP = ''
        BEGIN
            SELECT 'ERROR' AS resultado, 'La empresa es obligatoria.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_FCH_DES IS NULL OR @EVA_FCH_HAS IS NULL
        BEGIN
            SELECT 'ERROR' AS resultado, 'Las fechas desde y hasta son obligatorias.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_FCH_DES > @EVA_FCH_HAS
        BEGIN
            SELECT 'ERROR' AS resultado, 'La fecha desde no puede ser mayor que la fecha hasta.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_RUT) > 10
        BEGIN
            SELECT 'ERROR' AS resultado, 'El rut excede el largo permitido de la columna EVA_RUT (10).' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_NOMBRE) > 100
        BEGIN
            SELECT 'ERROR' AS resultado, 'El nombre excede el largo permitido de la columna EVA_NOMBRE (100). Ajuste la tabla o reduzca el valor.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_EMP) > 150
        BEGIN
            SELECT 'ERROR' AS resultado, 'La empresa excede el largo permitido de la columna EVA_EMP (150).' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_COM) > 250
        BEGIN
            SELECT 'ERROR' AS resultado, 'El comentario excede el largo permitido de la columna EVA_COM (250).' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_USR) > 50
        BEGIN
            SELECT 'ERROR' AS resultado, 'El usuario excede el largo permitido de la columna EVA_USR (50).' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        SELECT @ID_SUCURSAL = suc.id_sucursal
        FROM dbo.SUC_sucursal suc
        WHERE suc.cod_bantotal = @EVA_SUC;

        IF @ID_SUCURSAL IS NULL OR @ID_SUCURSAL <= 0
        BEGIN
            SELECT 'ERROR' AS resultado, 'La sucursal ingresada no existe en nuestra base de datos.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.SUC_CAP_EVA
            WHERE EVA_RUT = @EVA_RUT
              AND EVA_SUC = @ID_SUCURSAL
              AND EVA_EMP = @EVA_EMP
              AND EVA_FCH_DES = @EVA_FCH_DES
              AND EVA_FCH_HAS = @EVA_FCH_HAS
        )
        BEGIN
            SELECT 'ERROR' AS resultado, 'Ya existe una evaluacion con los mismos datos para el cajero.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        INSERT INTO dbo.SUC_CAP_EVA
        (
            EVA_RUT,
            EVA_NOMBRE,
            EVA_SUC,
            EVA_EMP,
            EVA_FCH_DES,
            EVA_FCH_HAS,
            EVA_COM,
            EVA_EST,
            EVA_USR,
            EVA_FCH
        )
        VALUES
        (
            @EVA_RUT,
            @EVA_NOMBRE,
            @ID_SUCURSAL,
            @EVA_EMP,
            @EVA_FCH_DES,
            @EVA_FCH_HAS,
            NULLIF(@EVA_COM, ''),
            ISNULL(@EVA_EST, 1),
            NULLIF(@EVA_USR, ''),
            GETDATE()
        );

        SET @ID_EVA = CAST(SCOPE_IDENTITY() AS INT);

        EXEC dbo.SCSS_insertar_reporte_log
            @usuario = @USUARIO_LOG,
            @perfil = 'General',
            @funcionalidad = 'Gestion de Cajeros a Evaluar',
            @tipo_accion = 'Crear cajero a evaluar',
            @id_registro = @ID_EVA;

        SELECT 'OK' AS resultado, 'Registro insertado correctamente.' AS mensaje, @ID_EVA AS id_eva;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS resultado, ERROR_MESSAGE() AS mensaje, CAST(NULL AS INT) AS id_eva;
    END CATCH
END;

GO