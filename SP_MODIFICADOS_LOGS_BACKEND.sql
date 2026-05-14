-- Scripts actuales de SP modificados por ajuste de logs e id_registro
-- Generado desde SQL Server

-- =============================================
-- SCSS_insertar_reporte_log
-- =============================================
CREATE PROCEDURE [dbo].[SCSS_insertar_reporte_log]
    @usuario NVARCHAR(100),
    @perfil NVARCHAR(100),
    @funcionalidad NVARCHAR(200),
    @tipo_accion NVARCHAR(50),
    @fecha DATE = NULL,
    @hora TIME = NULL,
    @id_registro INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT @perfil = per.perfil
    FROM SUC_usuario usu
    INNER JOIN SUC_perfil per ON per.id_perfil = usu.id_perfil
    WHERE usuario_nombre2 = @usuario;

    IF @fecha IS NULL
        SET @fecha = CAST(GETDATE() AS DATE);

    IF @hora IS NULL
        SET @hora = CAST(GETDATE() AS TIME);

    INSERT INTO dbo.SUC_reporte_log (usuario, perfil, funcionalidad, tipo_accion, fecha, hora, id_registro)
    VALUES (@usuario, @perfil, @funcionalidad, @tipo_accion, @fecha, @hora, @id_registro);

    RETURN SCOPE_IDENTITY();
END


GO

-- =============================================
-- SCSS_obtener_reporte_log
-- =============================================
CREATE PROCEDURE [dbo].[SCSS_obtener_reporte_log]
    @fecha_desde DATE = NULL,
    @fecha_hasta DATE = NULL,
    @usuario NVARCHAR(100) = NULL,
    @perfil NVARCHAR(100) = NULL,
    @funcionalidad NVARCHAR(255) = NULL,
    @tipo_accion NVARCHAR(50) = NULL,
    @page INT = 1,
    @page_size INT = 50
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @offset INT = (@page - 1) * @page_size;

    SELECT COUNT(*) AS total_registros
    FROM dbo.SUC_reporte_log
    WHERE (@fecha_desde IS NULL OR fecha >= @fecha_desde)
      AND (@fecha_hasta IS NULL OR fecha <= @fecha_hasta)
      AND (@usuario IS NULL OR usuario LIKE '%' + @usuario + '%')
      AND (@perfil IS NULL OR perfil LIKE '%' + @perfil + '%')
      AND (@funcionalidad IS NULL OR funcionalidad = @funcionalidad)
      AND (@tipo_accion IS NULL OR tipo_accion LIKE @tipo_accion + '%');

    SELECT
        usuario,
        perfil,
        funcionalidad,
        tipo_accion,
        id_registro,
        fecha,
        CONVERT(VARCHAR(8), hora, 108) AS hora
    FROM dbo.SUC_reporte_log
    WHERE (@fecha_desde IS NULL OR fecha >= @fecha_desde)
      AND (@fecha_hasta IS NULL OR fecha <= @fecha_hasta)
      AND (@usuario IS NULL OR usuario LIKE '%' + @usuario + '%')
      AND (@perfil IS NULL OR perfil LIKE '%' + @perfil + '%')
      AND (@funcionalidad IS NULL OR funcionalidad = @funcionalidad)
      AND (@tipo_accion IS NULL OR tipo_accion LIKE @tipo_accion + '%')
    ORDER BY fecha DESC, hora DESC
    OFFSET @offset ROWS
    FETCH NEXT @page_size ROWS ONLY;
END


GO

-- =============================================
-- SP_SUC_insertar_solicitud_cajero
-- =============================================
CREATE PROCEDURE [dbo].[SP_SUC_insertar_solicitud_cajero]
    @id_solicitud INT,
    @id_sucursal INT,
    @motivo_solicitud VARCHAR(50),
    @fecha_desde DATE,
    @fecha_hasta DATE,
    @periodo VARCHAR(50),
    @observaciones VARCHAR(500) = NULL,
    @usuario_registro VARCHAR(50),
    @perfil INT = 1
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @nuevo_id INT;
    DECLARE @id_estado_inicial INT;
    DECLARE @fecha_limite DATETIME;
    DECLARE @fecha_actual DATETIME = GETDATE();
    DECLARE @dia_semana INT;
    DECLARE @tipoAccionLog VARCHAR(100);
    DECLARE @idRegistroLog INT;

    IF @perfil = 2
        SET @id_estado_inicial = 3;
    ELSE IF @perfil = 3
        SET @id_estado_inicial = 5;
    ELSE
        SET @id_estado_inicial = 1;

    BEGIN TRY
        IF (@perfil = 2 OR @perfil = 1) AND @id_solicitud = 0
        BEGIN
            SET @dia_semana = DATEPART(WEEKDAY, @fecha_desde);
            IF @dia_semana = 2
                SET @fecha_limite = DATEADD(DAY, -3, @fecha_desde);
            ELSE IF @dia_semana = 1
                SET @fecha_limite = DATEADD(DAY, -2, @fecha_desde);
            ELSE
                SET @fecha_limite = DATEADD(DAY, -1, @fecha_desde);

            SET @fecha_limite = DATETIMEFROMPARTS(YEAR(@fecha_limite), MONTH(@fecha_limite), DAY(@fecha_limite), 15, 0, 0, 0);

            IF @fecha_desde < CAST(@fecha_actual AS DATE)
            BEGIN
                SELECT 'Alerta: ' AS resultado, 'La fecha desde no puede ser menor a la fecha actual' AS mensaje;
                RETURN;
            END

            IF @fecha_hasta < @fecha_desde
            BEGIN
                SELECT 'Alerta: ' AS resultado, 'La fecha hasta no puede ser menor a la fecha desde' AS mensaje;
                RETURN;
            END
        END

        BEGIN TRANSACTION;

        IF @id_solicitud = 0
        BEGIN
            INSERT INTO SUC_solicitud_cajeros_adicionales (
                id_sucursal, motivo_solicitud, fecha_desde, fecha_hasta,
                periodo, observaciones, id_estado, usuario_registro, fecha_registro, activo
            )
            VALUES (
                @id_sucursal, @motivo_solicitud, @fecha_desde, @fecha_hasta,
                @periodo, ISNULL(@observaciones,''), @id_estado_inicial, @usuario_registro, GETDATE(), 1
            );

            SET @nuevo_id = SCOPE_IDENTITY();

            DECLARE @comentario_inicial VARCHAR(500);
            IF @perfil = 2
                SET @comentario_inicial = 'Solicitud creada por ZONAL - Aprobada automáticamente';
            ELSE IF @perfil = 3
                SET @comentario_inicial = 'Solicitud creada por GERENCIA - Aprobada automáticamente';
            ELSE
                SET @comentario_inicial = 'Solicitud creada';

            INSERT INTO SUC_historial_estados_solicitud (
                id_solicitud, id_estado_anterior, id_estado_nuevo,
                comentario, usuario_cambio, fecha_cambio
            )
            VALUES (
                @nuevo_id, NULL, @id_estado_inicial,
                ISNULL(@observaciones,''),
                @usuario_registro, GETDATE()
            );

            SET @tipoAccionLog = 'Crear solicitud cajero adicional';
            SET @idRegistroLog = @nuevo_id;

            COMMIT TRANSACTION;
            BEGIN TRY
                EXEC dbo.SCSS_insertar_reporte_log @usuario=@usuario_registro, @perfil='General', @funcionalidad='Solicitud Cajeros Adicionales', @tipo_accion=@tipoAccionLog, @id_registro=@idRegistroLog;
            END TRY
            BEGIN CATCH
            END CATCH;
            SELECT 'OK' AS resultado, @nuevo_id AS id_solicitud;
        END
        ELSE
        BEGIN
            UPDATE SUC_solicitud_cajeros_adicionales
            SET id_sucursal = @id_sucursal,
                motivo_solicitud = @motivo_solicitud,
                fecha_desde = @fecha_desde,
                fecha_hasta = @fecha_hasta,
                periodo = @periodo,
                observaciones = ISNULL(@observaciones,''),
                usuario_modificacion = @usuario_registro,
                fecha_modificacion = GETDATE()
            WHERE id_solicitud = @id_solicitud;

            SET @tipoAccionLog = 'Editar solicitud cajero adicional';
            SET @idRegistroLog = @id_solicitud;

            COMMIT TRANSACTION;
            BEGIN TRY
                EXEC dbo.SCSS_insertar_reporte_log @usuario=@usuario_registro, @perfil='General', @funcionalidad='Solicitud Cajeros Adicionales', @tipo_accion=@tipoAccionLog, @id_registro=@idRegistroLog;
            END TRY
            BEGIN CATCH
            END CATCH;
            SELECT 'OK' AS resultado, @id_solicitud AS id_solicitud;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        SELECT 'Alert' AS resultado, ERROR_MESSAGE() AS mensaje;
    END CATCH
END


GO

-- =============================================
-- SP_SUC_insertar_solicitud_cajero_rebaja
-- =============================================
CREATE PROCEDURE [dbo].[SP_SUC_insertar_solicitud_cajero_rebaja]
    @id_solicitud_rebaja INT,
    @id_sucursal INT,
    @motivo_solicitud VARCHAR(50),
    @fecha_desde DATE,
    @fecha_hasta DATE,
    @periodo VARCHAR(50),
    @observaciones VARCHAR(500) = NULL,
    @usuario_registro VARCHAR(50),
    @perfil INT = 1
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @nuevo_id INT;
    DECLARE @id_estado_inicial INT;
    DECLARE @fecha_limite DATETIME;
    DECLARE @fecha_actual DATETIME = GETDATE();
    DECLARE @dia_semana INT;
    DECLARE @tipoAccionLog VARCHAR(100);
    DECLARE @idRegistroLog INT;

    IF @perfil = 2
        SET @id_estado_inicial = 3;
    ELSE IF @perfil = 3
        SET @id_estado_inicial = 5;
    ELSE
        SET @id_estado_inicial = 1;

    BEGIN TRY
        IF (@perfil = 2 OR @perfil = 1) AND @id_solicitud_rebaja = 0
        BEGIN
            SET @dia_semana = DATEPART(WEEKDAY, @fecha_desde);
            IF @dia_semana = 2
                SET @fecha_limite = DATEADD(DAY, -3, @fecha_desde);
            ELSE IF @dia_semana = 1
                SET @fecha_limite = DATEADD(DAY, -2, @fecha_desde);
            ELSE
                SET @fecha_limite = DATEADD(DAY, -1, @fecha_desde);

            IF @perfil = 1
                SET @fecha_limite = DATETIMEFROMPARTS(YEAR(@fecha_limite), MONTH(@fecha_limite), DAY(@fecha_limite), 14, 0, 0, 0);
            IF @perfil = 2
                SET @fecha_limite = DATETIMEFROMPARTS(YEAR(@fecha_limite), MONTH(@fecha_limite), DAY(@fecha_limite), 15, 0, 0, 0);

            IF @fecha_actual > @fecha_limite
            BEGIN
                SELECT 'Alerta: ' AS resultado, 'Ha superado el tiempo para generar una solicitud rebaja de cajero.' AS mensaje;
                RETURN;
            END

            IF @fecha_desde < CAST(@fecha_actual AS DATE)
            BEGIN
                SELECT 'Alerta: ' AS resultado, 'La fecha desde no puede ser menor a la fecha actual' AS mensaje;
                RETURN;
            END

            IF @fecha_hasta < @fecha_desde
            BEGIN
                SELECT 'Alerta: ' AS resultado, 'La fecha hasta no puede ser menor a la fecha desde' AS mensaje;
                RETURN;
            END
        END

        BEGIN TRANSACTION;

        IF @id_solicitud_rebaja = 0
        BEGIN
            INSERT INTO SUC_solicitud_cajeros_adicionales_rebaja (
                id_sucursal, motivo_solicitud_rebaja, fecha_desde, fecha_hasta,
                periodo, observaciones, id_estado_rebaja, usuario_registro, fecha_registro, activo
            )
            VALUES (
                @id_sucursal, @motivo_solicitud, @fecha_desde, @fecha_hasta,
                @periodo, ISNULL(@observaciones,''), @id_estado_inicial, @usuario_registro, GETDATE(), 1
            );

            SET @nuevo_id = SCOPE_IDENTITY();

            DECLARE @comentario_inicial VARCHAR(500);
            IF @perfil = 2
                SET @comentario_inicial = 'Solicitud creada por ZONAL - Aprobada automáticamente';
            ELSE IF @perfil = 3
                SET @comentario_inicial = 'Solicitud creada por GERENCIA - Aprobada automáticamente';
            ELSE
                SET @comentario_inicial = 'Solicitud creada';

            INSERT INTO SUC_historial_estados_solicitud_rebaja (
                id_solicitud_rebaja, id_estado_anterior, id_estado_nuevo,
                comentario, usuario_cambio, fecha_cambio
            )
            VALUES (
                @nuevo_id, NULL, @id_estado_inicial,
                ISNULL(@observaciones,''),
                @usuario_registro, GETDATE()
            );

            SET @tipoAccionLog = 'Crear solicitud rebaja cajero adicional';
            SET @idRegistroLog = @nuevo_id;

            COMMIT TRANSACTION;
            BEGIN TRY
                EXEC dbo.SCSS_insertar_reporte_log @usuario=@usuario_registro, @perfil='General', @funcionalidad='Solicitud Rebaja Cajeros Adicionales', @tipo_accion=@tipoAccionLog, @id_registro=@idRegistroLog;
            END TRY
            BEGIN CATCH
            END CATCH;
            SELECT 'OK' AS resultado, @nuevo_id AS id_solicitud_rebaja;
        END
        ELSE
        BEGIN
            UPDATE SUC_solicitud_cajeros_adicionales_rebaja
            SET id_sucursal = @id_sucursal,
                motivo_solicitud_rebaja = @motivo_solicitud,
                fecha_desde = @fecha_desde,
                fecha_hasta = @fecha_hasta,
                periodo = @periodo,
                observaciones = ISNULL(@observaciones,''),
                usuario_modificacion = @usuario_registro,
                fecha_modificacion = GETDATE()
            WHERE id_solicitud_rebaja = @id_solicitud_rebaja;

            SET @tipoAccionLog = 'Editar solicitud rebaja cajero adicional';
            SET @idRegistroLog = @id_solicitud_rebaja;

            COMMIT TRANSACTION;
            BEGIN TRY
                EXEC dbo.SCSS_insertar_reporte_log @usuario=@usuario_registro, @perfil='General', @funcionalidad='Solicitud Rebaja Cajeros Adicionales', @tipo_accion=@tipoAccionLog, @id_registro=@idRegistroLog;
            END TRY
            BEGIN CATCH
            END CATCH;
            SELECT 'OK' AS resultado, @id_solicitud_rebaja AS id_solicitud_rebaja;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        SELECT 'Alert' AS resultado, ERROR_MESSAGE() AS mensaje;
    END CATCH
END


GO

-- =============================================
-- SP_SUC_cambiar_estado_solicitud
-- =============================================
CREATE PROCEDURE [dbo].[SP_SUC_cambiar_estado_solicitud]
    @id_solicitud INT,
    @id_estado_nuevo INT,
    @comentario VARCHAR(500) = NULL,
    @usuario VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_estado_anterior INT;
    DECLARE @fecha_desde DATE;
    DECLARE @fecha_limite DATETIME;
    DECLARE @fecha_actual DATETIME = GETDATE();
    DECLARE @dia_semana INT;
    DECLARE @nombre_estado VARCHAR(100);
    DECLARE @tipoAccionLog VARCHAR(150);

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT @id_estado_anterior = id_estado,
               @fecha_desde = fecha_desde
        FROM SUC_solicitud_cajeros_adicionales
        WHERE id_solicitud = @id_solicitud;

        IF @id_estado_anterior IS NULL
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'ERROR' AS resultado, 'Solicitud no encontrada' AS mensaje;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM SUC_cat_estados_solicitud WHERE id_estado = @id_estado_nuevo AND activo = 1)
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'ERROR' AS resultado, 'Estado no válido' AS mensaje;
            RETURN;
        END

        SELECT @nombre_estado = nombre_estado
        FROM SUC_cat_estados_solicitud
        WHERE id_estado = @id_estado_nuevo;

        IF @fecha_desde IS NOT NULL
        BEGIN
            SET @dia_semana = DATEPART(WEEKDAY, @fecha_desde);
            IF @dia_semana = 2
                SET @fecha_limite = DATEADD(DAY, -3, @fecha_desde);
            ELSE IF @dia_semana = 1
                SET @fecha_limite = DATEADD(DAY, -2, @fecha_desde);
            ELSE
                SET @fecha_limite = DATEADD(DAY, -1, @fecha_desde);

            SET @fecha_limite = DATETIMEFROMPARTS(YEAR(@fecha_limite), MONTH(@fecha_limite), DAY(@fecha_limite), 16, 0, 0, 0);
        END

        UPDATE SUC_solicitud_cajeros_adicionales
        SET id_estado = @id_estado_nuevo,
            usuario_modificacion = @usuario,
            fecha_modificacion = GETDATE()
        WHERE id_solicitud = @id_solicitud;

        INSERT INTO SUC_historial_estados_solicitud (
            id_solicitud,
            id_estado_anterior,
            id_estado_nuevo,
            comentario,
            usuario_cambio,
            fecha_cambio
        )
        VALUES (
            @id_solicitud,
            @id_estado_anterior,
            @id_estado_nuevo,
            @comentario,
            @usuario,
            GETDATE()
        );

        SET @tipoAccionLog = 'Cambiar estado a ' + ISNULL(@nombre_estado, CAST(@id_estado_nuevo AS VARCHAR(20)));

        COMMIT TRANSACTION;
        BEGIN TRY
            EXEC dbo.SCSS_insertar_reporte_log @usuario=@usuario, @perfil='General', @funcionalidad='Solicitud Cajeros Adicionales', @tipo_accion=@tipoAccionLog, @id_registro=@id_solicitud;
        END TRY
        BEGIN CATCH
        END CATCH;

        SELECT 'OK' AS resultado, 'Estado actualizado correctamente' AS mensaje, @id_solicitud AS id_solicitud;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        SELECT 'Alert' AS resultado, ERROR_MESSAGE() AS mensaje;
    END CATCH
END


GO

-- =============================================
-- SP_SUC_cambiar_estado_solicitud_rebaja
-- =============================================
CREATE PROCEDURE [dbo].[SP_SUC_cambiar_estado_solicitud_rebaja]
    @id_solicitud_rebaja INT,
    @id_estado_nuevo INT,
    @comentario VARCHAR(500) = NULL,
    @usuario VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_estado_anterior INT;
    DECLARE @fecha_desde DATE;
    DECLARE @fecha_limite DATETIME;
    DECLARE @fecha_actual DATETIME = GETDATE();
    DECLARE @dia_semana INT;
    DECLARE @nombre_estado_rebaja VARCHAR(100);
    DECLARE @tipoAccionLog VARCHAR(150);

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT @id_estado_anterior = id_estado_rebaja,
               @fecha_desde = fecha_desde
        FROM SUC_solicitud_cajeros_adicionales_rebaja
        WHERE id_solicitud_rebaja = @id_solicitud_rebaja;

        IF @id_estado_anterior IS NULL
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'ERROR' AS resultado, 'Solicitud no encontrada' AS mensaje;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM SUC_cat_estados_solicitud WHERE id_estado = @id_estado_nuevo AND activo = 1)
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'ERROR' AS resultado, 'Estado no válido' AS mensaje;
            RETURN;
        END

        SELECT @nombre_estado_rebaja = nombre_estado_rebaja
        FROM SUC_cat_estados_solicitud_rebaja
        WHERE id_estado_rebaja = @id_estado_nuevo;

        IF @fecha_desde IS NOT NULL
        BEGIN
            SET @dia_semana = DATEPART(WEEKDAY, @fecha_desde);
            IF @dia_semana = 2
                SET @fecha_limite = DATEADD(DAY, -3, @fecha_desde);
            ELSE IF @dia_semana = 1
                SET @fecha_limite = DATEADD(DAY, -2, @fecha_desde);
            ELSE
                SET @fecha_limite = DATEADD(DAY, -1, @fecha_desde);

            SET @fecha_limite = DATETIMEFROMPARTS(YEAR(@fecha_limite), MONTH(@fecha_limite), DAY(@fecha_limite), 15, 0, 0, 0);

            IF @id_estado_nuevo = 3
            BEGIN
                IF @fecha_actual > @fecha_limite
                BEGIN
                    ROLLBACK TRANSACTION;
                    SELECT 'Alerta: ' AS resultado, 'Ha superado el tiempo para gestionar una solicitud de cajero para el día ' + CAST(@fecha_desde AS NVARCHAR) AS mensaje;
                    RETURN;
                END
            END
        END

        UPDATE SUC_solicitud_cajeros_adicionales_rebaja
        SET id_estado_rebaja = @id_estado_nuevo,
            usuario_modificacion = @usuario,
            fecha_modificacion = GETDATE()
        WHERE id_solicitud_rebaja = @id_solicitud_rebaja;

        INSERT INTO SUC_historial_estados_solicitud_rebaja (
            id_solicitud_rebaja,
            id_estado_anterior,
            id_estado_nuevo,
            comentario,
            usuario_cambio,
            fecha_cambio
        )
        VALUES (
            @id_solicitud_rebaja,
            @id_estado_anterior,
            @id_estado_nuevo,
            @comentario,
            @usuario,
            GETDATE()
        );

        SET @tipoAccionLog = 'Cambiar estado a ' + ISNULL(@nombre_estado_rebaja, CAST(@id_estado_nuevo AS VARCHAR(20)));

        COMMIT TRANSACTION;
        BEGIN TRY
            EXEC dbo.SCSS_insertar_reporte_log @usuario=@usuario, @perfil='General', @funcionalidad='Solicitud Rebaja Cajeros Adicionales', @tipo_accion=@tipoAccionLog, @id_registro=@id_solicitud_rebaja;
        END TRY
        BEGIN CATCH
        END CATCH;

        SELECT 'OK' AS resultado, 'Estado actualizado correctamente' AS mensaje, @id_solicitud_rebaja AS id_solicitud;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        SELECT 'Alert' AS resultado, ERROR_MESSAGE() AS mensaje;
    END CATCH
END


GO

-- =============================================
-- SP_SUC_insertar_proveedor
-- =============================================
CREATE PROCEDURE [dbo].[SP_SUC_insertar_proveedor]
    @id_proveedor INT,
    @nombre_empresa VARCHAR(200),
    @tipo_servicio VARCHAR(100),
    @numero_contrato VARCHAR(50) = NULL,
    @numero_oc VARCHAR(50) = NULL,
    @fecha_inicio DATE = NULL,
    @fecha_fin DATE = NULL,
    @contacto_administrativo VARCHAR(100) = NULL,
    @correo_administrativo VARCHAR(100) = NULL,
    @contacto_operacional VARCHAR(100) = NULL,
    @correo_operacional VARCHAR(100) = NULL,
    @cantidad_titulares INT = 0,
    @cantidad_adicionales INT = 0,
    @usuario_registro VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @nuevo_id INT;
    DECLARE @tipoAccionLog VARCHAR(100);
    DECLARE @idRegistroLog INT;

    BEGIN TRY
        IF @id_proveedor = 0
        BEGIN
            SELECT @nuevo_id = ISNULL(MAX(id_proveedor), 0) + 1
            FROM SUC_cajero_proveedor;

            INSERT INTO SUC_cajero_proveedor (
                id_proveedor, proveedor, tipo_servicio, numero_contrato, numero_oc,
                fecha_inicio, fecha_fin, contacto_administrativo,
                correo_administrativo, contacto_operacional, correo_operacional,
                cantidad_titulares, cantidad_adicionales, usuario_registro,
                fecha_registro, activo
            )
            VALUES (
                @nuevo_id, @nombre_empresa, @tipo_servicio, @numero_contrato, @numero_oc,
                @fecha_inicio, @fecha_fin, @contacto_administrativo,
                @correo_administrativo, @contacto_operacional, @correo_operacional,
                @cantidad_titulares, @cantidad_adicionales, @usuario_registro,
                GETDATE(), 1
            );

            SET @tipoAccionLog = 'Crear proveedor';
            SET @idRegistroLog = @nuevo_id;

            BEGIN TRY
                EXEC dbo.SCSS_insertar_reporte_log @usuario=@usuario_registro, @perfil='General', @funcionalidad='Gestion Proveedores', @tipo_accion=@tipoAccionLog, @id_registro=@idRegistroLog;
            END TRY
            BEGIN CATCH
            END CATCH;

            SELECT 'OK' AS resultado, @nuevo_id AS id_proveedor;
        END
        ELSE
        BEGIN
            UPDATE SUC_cajero_proveedor
            SET proveedor = @nombre_empresa,
                tipo_servicio = @tipo_servicio,
                numero_contrato = @numero_contrato,
                numero_oc = @numero_oc,
                fecha_inicio = @fecha_inicio,
                fecha_fin = @fecha_fin,
                contacto_administrativo = @contacto_administrativo,
                correo_administrativo = @correo_administrativo,
                contacto_operacional = @contacto_operacional,
                correo_operacional = @correo_operacional,
                cantidad_titulares = @cantidad_titulares,
                cantidad_adicionales = @cantidad_adicionales
            WHERE id_proveedor = @id_proveedor;

            SET @tipoAccionLog = 'Editar proveedor';
            SET @idRegistroLog = @id_proveedor;

            BEGIN TRY
                EXEC dbo.SCSS_insertar_reporte_log @usuario=@usuario_registro, @perfil='General', @funcionalidad='Gestion Proveedores', @tipo_accion=@tipoAccionLog, @id_registro=@idRegistroLog;
            END TRY
            BEGIN CATCH
            END CATCH;

            SELECT 'OK' AS resultado, @id_proveedor AS id_proveedor;
        END
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS resultado, ERROR_MESSAGE() AS mensaje;
    END CATCH
END


GO

-- =============================================
-- SP_SUC_eliminar_proveedor
-- =============================================
CREATE PROCEDURE [dbo].[SP_SUC_eliminar_proveedor]
    @id_proveedor INT,
    @usuario VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
        UPDATE SUC_cajero_proveedor
        SET activo = CASE WHEN ISNULL(activo, 1) = 1 THEN 0 ELSE 1 END
        WHERE id_proveedor = @id_proveedor;

        DECLARE @nuevoEstado VARCHAR(20);
        DECLARE @accionLog VARCHAR(100);
        SELECT @nuevoEstado = CASE WHEN ISNULL(activo, 1) = 1 THEN 'Activo' ELSE 'Inactivo' END
        FROM SUC_cajero_proveedor
        WHERE id_proveedor = @id_proveedor;

        SET @accionLog = 'Cambiar estado proveedor a ' + ISNULL(@nuevoEstado, 'Desconocido');

        COMMIT TRANSACTION;

        BEGIN TRY
            EXEC dbo.SCSS_insertar_reporte_log @usuario=@usuario, @perfil='General', @funcionalidad='Gestion Proveedores', @tipo_accion=@accionLog, @id_registro=@id_proveedor;
        END TRY
        BEGIN CATCH
        END CATCH;

        SELECT 'OK' AS resultado;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        SELECT 'ERROR' AS resultado, ERROR_MESSAGE() AS mensaje;
    END CATCH
END


GO
