-- Scripts para crear tablas de evaluación de cajeros
-- Fecha: 9 de enero de 2026

-- Tabla 1: SUC_ficha_items_evaluacion_cajeros
IF OBJECT_ID('dbo.SUC_ficha_items_evaluacion_cajeros', 'U') IS NOT NULL
    DROP TABLE dbo.SUC_ficha_items_evaluacion_cajeros;

CREATE TABLE [dbo].[SUC_ficha_items_evaluacion_cajeros](
    [id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [descripcion_pregunta] [nvarchar](500) NOT NULL,
    [estado] [bit] NOT NULL DEFAULT 1,
    [fecha_registro] [datetime] NOT NULL DEFAULT GETDATE()
);

-- Tabla 2: SUC_cajeros_a_evaluar
IF OBJECT_ID('dbo.SUC_cajeros_a_evaluar', 'U') IS NOT NULL
    DROP TABLE dbo.SUC_cajeros_a_evaluar;

CREATE TABLE [dbo].[SUC_cajeros_a_evaluar](
    [id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [rut_cajero] [varchar](20) NOT NULL,
    [nombre_cajero] [nvarchar](100) NOT NULL,
    [proveedor] [nvarchar](100) NOT NULL,
    [sucursal] [nvarchar](100) NOT NULL,
    [fecha_Desde] [date] NOT NULL,
    [fecha_Hasta] [date] NOT NULL,
    [fecha_registro] [datetime] NOT NULL DEFAULT GETDATE()
);

-- Tabla 3: SUC_evaluacion_cajeros
IF OBJECT_ID('dbo.SUC_evaluacion_cajeros', 'U') IS NOT NULL
    DROP TABLE dbo.SUC_evaluacion_cajeros;

CREATE TABLE [dbo].[SUC_evaluacion_cajeros](
    [id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [rut_cajero] [varchar](20) NOT NULL,
    [nombre_cajero] [nvarchar](100) NOT NULL,
    [proveedor] [nvarchar](100) NOT NULL,
    [sucursal] [nvarchar](100) NOT NULL,
    [puntuacion] [decimal](5,2) NULL,
    [respuestas] [nvarchar](max) NULL,  -- Para almacenar JSON con las respuestas evaluadas
    [fecha_evaluacion] [datetime] NOT NULL DEFAULT GETDATE()
);

-- Tabla 4: SUC_cat_estados_solicitud_rebaja
IF OBJECT_ID('dbo.SUC_cat_estados_solicitud_rebaja', 'U') IS NOT NULL
    DROP TABLE dbo.SUC_cat_estados_solicitud_rebaja;

CREATE TABLE [dbo].[SUC_cat_estados_solicitud_rebaja](
	[id_estado_rebaja] [int] NOT NULL,
	[nombre_estado] [varchar](50) NOT NULL,
	[descripcion] [varchar](200) NULL,
	[color_badge] [varchar](20) NULL,
	[orden_flujo] [int] NOT NULL,
	[requiere_comentario] [bit] NOT NULL,
	[activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_estado_rebaja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];

-- Tabla 5: SUC_historial_estados_solicitud_rebaja
IF OBJECT_ID('dbo.SUC_historial_estados_solicitud_rebaja', 'U') IS NOT NULL
    DROP TABLE dbo.SUC_historial_estados_solicitud_rebaja;

CREATE TABLE [dbo].[SUC_historial_estados_solicitud_rebaja](
    [id_historial] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [id_solicitud] [int] NOT NULL,
    [id_estado_anterior] [int] NULL,
    [id_estado_nuevo] [int] NOT NULL,
    [comentario] [varchar](500) NULL,
    [usuario_cambio] [varchar](50) NOT NULL,
    [fecha_cambio] [datetime] NOT NULL
);