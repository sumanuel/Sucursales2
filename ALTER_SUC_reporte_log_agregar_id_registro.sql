-- Agrega el campo id_registro a dbo.SUC_reporte_log si aun no existe

IF COL_LENGTH('dbo.SUC_reporte_log', 'id_registro') IS NULL
BEGIN
    ALTER TABLE dbo.SUC_reporte_log
    ADD id_registro INT NULL;
END
GO
