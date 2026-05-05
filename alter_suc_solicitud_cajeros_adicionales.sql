-- Script para agregar campos a la tabla SUC_solicitud_cajeros_adicionales
-- Fecha: 9 de enero de 2026

-- Agregar campos: observaciones_central, eliminado, id_estado_rebaja y observacion_rebaja
ALTER TABLE [dbo].[SUC_solicitud_cajeros_adicionales]
ADD [observaciones_central] VARCHAR(500) NULL,
    [eliminado] BIT NOT NULL DEFAULT 0,
    [id_estado_rebaja] INT NULL,
    [observacion_rebaja] VARCHAR(500) NULL;

-- Agregar foreign key para id_estado_rebaja
ALTER TABLE [dbo].[SUC_solicitud_cajeros_adicionales]
ADD CONSTRAINT FK_SUC_solicitud_cajeros_adicionales_id_estado_rebaja
FOREIGN KEY ([id_estado_rebaja]) REFERENCES [dbo].[SUC_cat_estados_solicitud_rebaja]([id_estado_rebaja]);

-- Script de rollback (en caso de necesitar revertir los cambios)
-- ALTER TABLE [dbo].[SUC_solicitud_cajeros_adicionales]
-- DROP CONSTRAINT FK_SUC_solicitud_cajeros_adicionales_id_estado_rebaja;
-- ALTER TABLE [dbo].[SUC_solicitud_cajeros_adicionales]
-- DROP COLUMN [observaciones_central],
-- DROP COLUMN [eliminado],
-- DROP COLUMN [id_estado_rebaja],
-- DROP COLUMN [observacion_rebaja];
