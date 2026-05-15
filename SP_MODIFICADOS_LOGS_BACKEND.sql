-- Script consolidado de procedimientos con registro de logs backend
-- Generado automaticamente el 2026-05-15

/* ============================================================
   SCSS_insertar_reporte_log
   ============================================================ */
ALTER PROCEDURE [dbo].[SCSS_insertar_reporte_log]
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

/* ============================================================
   SCSS_obtener_reporte_log
   ============================================================ */
ALTER PROCEDURE [dbo].[SCSS_obtener_reporte_log]
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

/* ============================================================
   SP_SUC_insertar_solicitud_cajero
   ============================================================ */
ALTER PROCEDURE [dbo].[SP_SUC_insertar_solicitud_cajero]
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

/* ============================================================
   SP_SUC_insertar_solicitud_cajero_rebaja
   ============================================================ */
ALTER PROCEDURE [dbo].[SP_SUC_insertar_solicitud_cajero_rebaja]
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

/* ============================================================
   SP_SUC_cambiar_estado_solicitud
   ============================================================ */
ALTER PROCEDURE [dbo].[SP_SUC_cambiar_estado_solicitud]
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

/* ============================================================
   SP_SUC_cambiar_estado_solicitud_rebaja
   ============================================================ */
ALTER PROCEDURE [dbo].[SP_SUC_cambiar_estado_solicitud_rebaja]
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

/* ============================================================
   SP_SUC_insertar_proveedor
   ============================================================ */
ALTER PROCEDURE [dbo].[SP_SUC_insertar_proveedor]
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

/* ============================================================
   SP_SUC_eliminar_proveedor
   ============================================================ */
ALTER PROCEDURE [dbo].[SP_SUC_eliminar_proveedor]
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

/* ============================================================
   SP_SUC_CAP_INSERT
   ============================================================ */
ALTER PROCEDURE [dbo].[SP_SUC_CAP_INSERT]
    @PRE_TIT varchar(50),
    @PRE_PRE varchar(500),
    @PRE_USR varchar(20),
    @PRE_PERFIL varchar(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NuevoOrden smallint;
    DECLARE @NuevoID int;
    DECLARE @UsuarioLog varchar(50);
    DECLARE @PerfilLog varchar(50);

    SET @UsuarioLog = LTRIM(RTRIM(ISNULL(@PRE_USR, '')));
    SET @PerfilLog = LTRIM(RTRIM(ISNULL(@PRE_PERFIL, '')));
    IF @UsuarioLog = '' SET @UsuarioLog = 'SISTEMA';
    IF @PerfilLog = '' SET @PerfilLog = 'General';

    SELECT @NuevoOrden = ISNULL(MAX(PRE_ORD), 0) + 1
    FROM [dbo].[SUC_CAP_PRE];

    INSERT INTO [dbo].[SUC_CAP_PRE] (
        PRE_TIT,
        PRE_PRE,
        PRE_USR,
        PRE_EST,
        PRE_FCH,
        PRE_ORD
    )
    VALUES (
        @PRE_TIT,
        @PRE_PRE,
        @PRE_USR,
        1,
        GETDATE(),
        @NuevoOrden
    );

    SET @NuevoID = CONVERT(int, SCOPE_IDENTITY());

    EXEC dbo.SCSS_insertar_reporte_log
        @usuario = @UsuarioLog,
        @perfil = @PerfilLog,
        @funcionalidad = 'Preguntas capacitacion cajeros',
        @tipo_accion = 'Crear pregunta',
        @id_registro = @NuevoID;

    SELECT 'OK' AS resultado, 'Registro insertado correctamente.' AS mensaje, @NuevoID AS NewID;
END;
GO

/* ============================================================
   SP_SUC_CAP_SWAP
   ============================================================ */
ALTER PROCEDURE [dbo].[SP_SUC_CAP_SWAP]
    @ID_PRE INT,
    @PRE_USR VARCHAR(50) = NULL,
    @PRE_PERFIL VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EstadoActual SMALLINT;
    DECLARE @EstadoNuevo SMALLINT;
    DECLARE @UsuarioLog VARCHAR(50);
    DECLARE @PerfilLog VARCHAR(50);
    DECLARE @AccionLog VARCHAR(100);

    SET @UsuarioLog = LTRIM(RTRIM(ISNULL(@PRE_USR, '')));
    SET @PerfilLog = LTRIM(RTRIM(ISNULL(@PRE_PERFIL, '')));
    IF @UsuarioLog = '' SET @UsuarioLog = 'SISTEMA';
    IF @PerfilLog = '' SET @PerfilLog = 'General';

    SELECT @EstadoActual = PRE_EST
    FROM [dbo].[SUC_CAP_PRE]
    WHERE PRE_ID_PRE = @ID_PRE;

    IF @EstadoActual = 1
        SET @EstadoNuevo = 0;
    ELSE
        SET @EstadoNuevo = 1;

    IF @EstadoActual IS NOT NULL
    BEGIN
        BEGIN TRANSACTION;
        BEGIN TRY
            UPDATE [dbo].[SUC_CAP_PRE]
            SET PRE_EST = @EstadoNuevo
            WHERE PRE_ID_PRE = @ID_PRE;

            COMMIT TRANSACTION;

            SET @AccionLog = CASE WHEN @EstadoNuevo = 1 THEN 'Activar pregunta' ELSE 'Desactivar pregunta' END;

            EXEC dbo.SCSS_insertar_reporte_log
                @usuario = @UsuarioLog,
                @perfil = @PerfilLog,
                @funcionalidad = 'Preguntas capacitacion cajeros',
                @tipo_accion = @AccionLog,
                @id_registro = @ID_PRE;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            THROW;
        END CATCH
    END

    SELECT 'OK' AS RESULTADO;
END;
GO

/* ============================================================
   SP_SUC_CAP_ORDEN
   ============================================================ */
ALTER PROCEDURE [dbo].[SP_SUC_CAP_ORDEN]
    @ID_PRE INT,
    @Direccion VARCHAR(5),
    @PRE_USR VARCHAR(50) = NULL,
    @PRE_PERFIL VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OrdenActual SMALLINT;
    DECLARE @NuevoOrden SMALLINT;
    DECLARE @ID_Vecino INT;
    DECLARE @UsuarioLog VARCHAR(50);
    DECLARE @PerfilLog VARCHAR(50);
    DECLARE @AccionLog VARCHAR(100);

    SET @UsuarioLog = LTRIM(RTRIM(ISNULL(@PRE_USR, '')));
    SET @PerfilLog = LTRIM(RTRIM(ISNULL(@PRE_PERFIL, '')));
    IF @UsuarioLog = '' SET @UsuarioLog = 'SISTEMA';
    IF @PerfilLog = '' SET @PerfilLog = 'General';

    SELECT @OrdenActual = PRE_ORD
    FROM [dbo].[SUC_CAP_PRE]
    WHERE PRE_ID_PRE = @ID_PRE;

    IF @OrdenActual IS NULL RETURN;

    IF @Direccion = 'SUBIR'
        SET @NuevoOrden = @OrdenActual - 1;
    ELSE IF @Direccion = 'BAJAR'
        SET @NuevoOrden = @OrdenActual + 1;
    ELSE
        RETURN;

    SELECT @ID_Vecino = PRE_ID_PRE
    FROM [dbo].[SUC_CAP_PRE]
    WHERE PRE_ORD = @NuevoOrden;

    IF @ID_Vecino IS NOT NULL
    BEGIN
        BEGIN TRANSACTION;
        BEGIN TRY
            UPDATE [dbo].[SUC_CAP_PRE]
            SET PRE_ORD = @OrdenActual
            WHERE PRE_ID_PRE = @ID_Vecino;

            UPDATE [dbo].[SUC_CAP_PRE]
            SET PRE_ORD = @NuevoOrden
            WHERE PRE_ID_PRE = @ID_PRE;

            COMMIT TRANSACTION;

            SET @AccionLog = CASE WHEN @Direccion = 'SUBIR' THEN 'Subir orden pregunta' ELSE 'Bajar orden pregunta' END;

            EXEC dbo.SCSS_insertar_reporte_log
                @usuario = @UsuarioLog,
                @perfil = @PerfilLog,
                @funcionalidad = 'Preguntas capacitacion cajeros',
                @tipo_accion = @AccionLog,
                @id_registro = @ID_PRE;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            THROW;
        END CATCH
    END

    SELECT 'OK' AS RESULTADO;
END;
GO

/* ============================================================
   SP_SUC_insertar_ges_eva_cajero
   ============================================================ */
ALTER PROCEDURE [dbo].[SP_SUC_insertar_ges_eva_cajero]
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

/* ============================================================
   SP_SUC_actualizar_ges_eva_cajero
   ============================================================ */
ALTER PROCEDURE dbo.SP_SUC_actualizar_ges_eva_cajero
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

/* ============================================================
   SP_SUC_eliminar_ges_eva_cajero
   ============================================================ */
ALTER PROCEDURE [dbo].[SP_SUC_eliminar_ges_eva_cajero]
    @ID_EVA  INT,
    @EVA_USR VARCHAR(50) = NULL
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

        IF EXISTS (SELECT 1 FROM dbo.SUC_CAP_EVA WHERE ID_EVA = @ID_EVA AND EVA_EST<>1)
        BEGIN
            SELECT 'ERROR' AS resultado, 'Solo se pueden eliminar evaluación esta estado de CAPACITACION.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
            RETURN;
        END;

        DELETE FROM dbo.SUC_CAP_EVA WHERE ID_EVA = @ID_EVA;

        EXEC dbo.SCSS_insertar_reporte_log
            @usuario = @EVA_USR,
            @perfil = 'General',
            @funcionalidad = 'Gestion de Cajeros a Evaluar',
            @tipo_accion = 'Eliminar cajero a evaluar',
            @id_registro = @ID_EVA;

        SELECT 'OK' AS resultado, 'Registro eliminado correctamente.' AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS resultado, ERROR_MESSAGE() AS mensaje, CAST(@ID_EVA AS INT) AS id_eva;
    END CATCH
END;
GO

/* ============================================================
   SP_SUC_actualizar_ges_eva_cajero_central
   ============================================================ */
ALTER PROCEDURE dbo.SP_SUC_actualizar_ges_eva_cajero_central
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

/* ============================================================
   SP_SUC_guardar_eva_cajero
   ============================================================ */
ALTER PROCEDURE dbo.SP_SUC_guardar_eva_cajero
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

