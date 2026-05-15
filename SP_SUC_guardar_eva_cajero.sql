IF OBJECT_ID('dbo.SP_SUC_guardar_eva_cajero', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_SUC_guardar_eva_cajero;
GO

CREATE PROCEDURE dbo.SP_SUC_guardar_eva_cajero
    @ID_EVA     INT,
    @EVA_COM    VARCHAR(250) = NULL,
    @EVA_EST    SMALLINT,
    @RESPUESTAS VARCHAR(MAX),
    @EVA_USR    VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @RESPUESTAS_XML XML;
        DECLARE @TOTAL_PREGUNTAS INT;
        DECLARE @TOTAL_RESPUESTAS INT;
        DECLARE @ACCION_LOG VARCHAR(100);

        DECLARE @RESPUESTAS_PARSEADAS TABLE
        (
            ITEM VARCHAR(100) NOT NULL,
            POSICION_DOSPUNTOS INT NOT NULL,
            PRE_ID_PRE INT NULL,
            RES_RES SMALLINT NULL
        );

        DECLARE @RESPUESTAS_VALIDAS TABLE
        (
            PRE_ID_PRE INT NOT NULL,
            RES_RES SMALLINT NOT NULL
        );

        SET @EVA_COM = LTRIM(RTRIM(ISNULL(@EVA_COM, '')));
        SET @RESPUESTAS = LTRIM(RTRIM(ISNULL(@RESPUESTAS, '')));
        SET @EVA_USR = LTRIM(RTRIM(ISNULL(@EVA_USR, '')));

        IF @EVA_USR = ''
            SET @EVA_USR = 'JEPS';

        IF LEN(@EVA_USR) > 50
            SET @EVA_USR = LEFT(@EVA_USR, 50);

        IF @ID_EVA IS NULL OR @ID_EVA <= 0
        BEGIN
            SELECT 'ERROR' AS resultado, 'El identificador de la evaluacion es obligatorio.' AS mensaje, CAST(NULL AS INT) AS id_eva;
            RETURN;
        END;

        IF LEN(@EVA_COM) > 250
        BEGIN
            SELECT 'ERROR' AS resultado, 'La observacion no puede exceder 250 caracteres.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF @EVA_EST NOT IN (2, 3)
        BEGIN
            SELECT 'ERROR' AS resultado, 'Debe seleccionar un estado valido para la evaluacion.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF @RESPUESTAS = ''
        BEGIN
            SELECT 'ERROR' AS resultado, 'Debe enviar las respuestas de la evaluacion.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        SET @RESPUESTAS_XML = TRY_CAST(
            '<root><item>' +
            REPLACE(
                REPLACE(
                    REPLACE(@RESPUESTAS, '&', '&amp;'),
                    '<', '&lt;'
                ),
                '|',
                '</item><item>'
            ) +
            '</item></root>'
            AS XML
        );

        IF @RESPUESTAS_XML IS NULL
        BEGIN
            SELECT 'ERROR' AS resultado, 'El formato de las respuestas es invalido.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        INSERT INTO @RESPUESTAS_PARSEADAS (ITEM, POSICION_DOSPUNTOS, PRE_ID_PRE, RES_RES)
        SELECT
            LTRIM(RTRIM(NODO.value('.', 'varchar(100)'))) AS ITEM,
            CHARINDEX(':', LTRIM(RTRIM(NODO.value('.', 'varchar(100)')))) AS POSICION_DOSPUNTOS,
            TRY_CONVERT(INT, LEFT(LTRIM(RTRIM(NODO.value('.', 'varchar(100)'))), CHARINDEX(':', LTRIM(RTRIM(NODO.value('.', 'varchar(100)')))) - 1)) AS PRE_ID_PRE,
            TRY_CONVERT(SMALLINT, SUBSTRING(LTRIM(RTRIM(NODO.value('.', 'varchar(100)'))), CHARINDEX(':', LTRIM(RTRIM(NODO.value('.', 'varchar(100)')))) + 1, 20)) AS RES_RES
        FROM @RESPUESTAS_XML.nodes('/root/item') AS T(NODO)
        WHERE LTRIM(RTRIM(NODO.value('.', 'varchar(100)'))) <> '';

        IF NOT EXISTS (SELECT 1 FROM @RESPUESTAS_PARSEADAS)
        BEGIN
            SELECT 'ERROR' AS resultado, 'Debe responder todos los items habilitados del formulario.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF EXISTS (
            SELECT 1
            FROM @RESPUESTAS_PARSEADAS
            WHERE POSICION_DOSPUNTOS <= 1
               OR POSICION_DOSPUNTOS >= LEN(ITEM)
               OR PRE_ID_PRE IS NULL
               OR RES_RES IS NULL
               OR RES_RES NOT IN (0, 1, 2)
        )
        BEGIN
            SELECT 'ERROR' AS resultado, 'El formato de las respuestas es invalido.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF EXISTS (
            SELECT PRE_ID_PRE
            FROM @RESPUESTAS_PARSEADAS
            GROUP BY PRE_ID_PRE
            HAVING COUNT(*) > 1
        )
        BEGIN
            SELECT 'ERROR' AS resultado, 'No se puede responder un mismo item mas de una vez.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        INSERT INTO @RESPUESTAS_VALIDAS (PRE_ID_PRE, RES_RES)
        SELECT PRE_ID_PRE, RES_RES
        FROM @RESPUESTAS_PARSEADAS;

        SELECT @TOTAL_PREGUNTAS = COUNT(*)
        FROM dbo.SUC_CAP_PRE
        WHERE ISNULL(PRE_EST, 0) = 1;

        IF @TOTAL_PREGUNTAS <= 0
        BEGIN
            SELECT 'ERROR' AS resultado, 'No hay items habilitados para evaluar.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF EXISTS (
            SELECT 1
            FROM @RESPUESTAS_VALIDAS R
            LEFT JOIN dbo.SUC_CAP_PRE P
                ON P.PRE_ID_PRE = R.PRE_ID_PRE
               AND ISNULL(P.PRE_EST, 0) = 1
            WHERE P.PRE_ID_PRE IS NULL
        )
        BEGIN
            SELECT 'ERROR' AS resultado, 'Se recibio un item que no esta habilitado para evaluar.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        SELECT @TOTAL_RESPUESTAS = COUNT(*)
        FROM @RESPUESTAS_VALIDAS;

        IF @TOTAL_RESPUESTAS <> @TOTAL_PREGUNTAS
        BEGIN
            SELECT 'ERROR' AS resultado, 'Debe responder todos los items habilitados del formulario.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.SUC_CAP_EVA WITH (UPDLOCK, HOLDLOCK)
            WHERE ID_EVA = @ID_EVA
        )
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'ERROR' AS resultado, 'No existe la evaluacion indicada.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.SUC_CAP_EVA WITH (UPDLOCK, HOLDLOCK)
            WHERE ID_EVA = @ID_EVA
              AND EVA_EST <> 1
        )
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'ERROR' AS resultado, 'Esta evaluacion ya fue registrada y no puede repetirse.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.SUC_CAP_RES WITH (UPDLOCK, HOLDLOCK)
            WHERE ID_EVA = @ID_EVA
        )
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'ERROR' AS resultado, 'Esta evaluacion ya fue registrada y no puede repetirse.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        INSERT INTO dbo.SUC_CAP_RES (PRE_ID_PRE, ID_EVA, RES_RES)
        SELECT PRE_ID_PRE, @ID_EVA, RES_RES
        FROM @RESPUESTAS_VALIDAS;

        UPDATE dbo.SUC_CAP_EVA
        SET EVA_COM = NULLIF(@EVA_COM, ''),
            EVA_EST = @EVA_EST,
            EVA_USR = @EVA_USR,
            EVA_FCH = GETDATE()
        WHERE ID_EVA = @ID_EVA
          AND EVA_EST = 1;

        IF @@ROWCOUNT <= 0
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'ERROR' AS resultado, 'No fue posible actualizar el estado de la evaluacion.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        SET @ACCION_LOG = 'Guardar evaluacion';
        IF @EVA_EST = 2
            SET @ACCION_LOG = @ACCION_LOG + ' con estado Aprobado';
        ELSE IF @EVA_EST = 3
            SET @ACCION_LOG = @ACCION_LOG + ' con estado Reprobado';

        EXEC dbo.SCSS_insertar_reporte_log
            @usuario = @EVA_USR,
            @perfil = 'General',
            @funcionalidad = 'Evaluacion Cajeros',
            @tipo_accion = @ACCION_LOG,
            @id_registro = @ID_EVA;

        COMMIT TRANSACTION;

        SELECT 'OK' AS resultado, 'La evaluacion fue guardada correctamente.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT 'ERROR' AS resultado, ERROR_MESSAGE() AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
    END CATCH
END;
GO
