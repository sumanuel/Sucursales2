<!--#include file="../funciones.asp"-->
<% periodo = trim(request("periodo"))
idSucursalMain = trim(request("idSucursalMain"))
idUsuarioMain = trim(request("idUsuarioMain"))
idAccion = trim(request("idAccion"))

'response.write(periodo)
'response.end
valorSucSinValidaDmsNoIngre = 0
valorSucSinValidaDmsValidado = 0
valorSucSinValidaDmsAlerta = 0
valorSucSinValidaDmsEnValida = 0
valorSucSinValidaDmsRecepcionado = 0

valorSucEnValidaDmsNoIngre = 0
valorSucEnValidaDmsValidado = 0
valorSucEnValidaDmsAlerta = 0
valorSucEnValidaDmsEnValida = 0
valorSucEnValidaDmsRecepcionado = 0

valorSucValidadoDmsNoIngre = 0
valorSucValidadoDmsValidado = 0
valorSucValidadoDmsAlerta = 0
valorSucValidadoDmsEnValida = 0
valorSucValidadoDmsRecepcionado = 0

valorSucEnNotarioDmsNoIngre = 0
valorSucEnNotarioDmsValidado = 0
valorSucEnNotarioDmsAlerta = 0
valorSucEnNotarioDmsEnValida = 0
valorSucEnNotarioDmsRecepcionado = 0

valorSucRecepNotarioDmsNoIngre = 0
valorSucRecepNotarioDmsValidado = 0
valorSucRecepNotarioDmsAlerta = 0
valorSucRecepNotarioDmsEnValida = 0
valorSucRecepNotarioDmsRecepcionado = 0

valorSucNoRecepNotarioDmsNoIngre = 0
valorSucNoRecepNotarioDmsValidado = 0
valorSucNoRecepNotarioDmsAlerta = 0
valorSucNoRecepNotarioDmsEnValida = 0
valorSucNoRecepNotarioDmsRecepcionado = 0

valorSucEnviadoDmsNoIngre = 0
valorSucEnviadoDmsValidado = 0
valorSucEnviadoDmsAlerta = 0
valorSucEnviadoDmsEnValida = 0
valorSucEnviadoDmsRecepcionado = 0

idx_sucColocaciones = 0
idx_sucPendientes = 0
idx_sucEnValidacion = 0
idx_sucValidado = 0
idx_SucEnNotario = 0
idx_SucRecepNotario = 0
idx_SucNoRecepNotario = 0
idx_sucEnviados = 0
idx_dmsEnValidacion = 0
idx_dmsValidado = 0
idx_dmsAlertas = 0
idx_dmsRecepcionado = 0
idx_dmsNoIngresado = 0

sql = ""
'sql = sql & " EXEC SCSS_prc_datos_check_por_suc '"&idAccion&"','"&periodo&"','"&idSucursalMain&"','"&idUsuarioMain&"' "
sql = sql & " EXEC SCSS_prc_datos_check_por_suc2 '0','0','"&idSucursalMain&"','"&idUsuarioMain&"','"&idAccion&"','"&periodo&"' "
'response.write(sql)
'response.end
set rs = db.execute(sql)
if not rs.eof then
	datos = rs.getRows()

 	for i= 0 to ubound(datos,2)
	 	sucEstado = trim(datos(0,i))
		dmsNoIngresado = cInt(trim(datos(1,i)))
		dmsValidado = cInt(trim(datos(2,i)))
		dmsAlerta = cInt(trim(datos(3,i)))
		dmsEnValidacion = cInt(trim(datos(4,i)))
		dmsRecepcionado = cInt(trim(datos(5,i)))
		dmsTotal = cInt(trim(datos(6,i)))

 		if sucEstado = "SUCSINVALIDAR" then
			valorSucSinValidaDmsNoIngre = dmsNoIngresado
			valorSucSinValidaDmsValidado = dmsValidado
			valorSucSinValidaDmsAlerta = dmsAlerta
			valorSucSinValidaDmsEnValida = dmsEnValidacion
			valorSucSinValidaDmsRecepcionado = dmsRecepcionado
			idx_sucSinValidar = dmsTotal
		end if

		if sucEstado = "SUCENVALIDACION" then
			valorSucEnValidaDmsNoIngre = dmsNoIngresado
			valorSucEnValidaDmsValidado = dmsValidado
			valorSucEnValidaDmsAlerta = dmsAlerta
			valorSucEnValidaDmsEnValida = dmsEnValidacion
			valorSucEnValidaDmsRecepcionado = dmsRecepcionado
			idx_sucEnValidacion = dmsTotal
		end if

		if sucEstado = "SUCVALIDADO" then
			valorSucValidadoDmsNoIngre = dmsNoIngresado
			valorSucValidadoDmsValidado = dmsValidado
			valorSucValidadoDmsAlerta = dmsAlerta
			valorSucValidadoDmsEnValida = dmsEnValidacion
			valorSucValidadoDmsRecepcionado = dmsRecepcionado
			idx_sucValidado = dmsTotal
		end if

		if sucEstado = "SUCENNOTARIO" then
			valorSucEnNotarioDmsNoIngre = dmsNoIngresado
			valorSucEnNotarioDmsValidado = dmsValidado
			valorSucEnNotarioDmsAlerta = dmsAlerta
			valorSucEnNotarioDmsEnValida = dmsEnValidacion
			valorSucEnNotarioDmsRecepcionado = dmsRecepcionado
			idx_SucEnNotario = dmsTotal
		end if

		if sucEstado = "SUCRECEPCIONADONOTARIO" then
			valorSucRecepNotarioDmsNoIngre = dmsNoIngresado
			valorSucRecepNotarioDmsValidado = dmsValidado
			valorSucRecepNotarioDmsAlerta = dmsAlerta
			valorSucRecepNotarioDmsEnValida = dmsEnValidacion
			valorSucRecepNotarioDmsRecepcionado = dmsRecepcionado
			idx_SucRecepNotario = dmsTotal
		end if

		if sucEstado = "SUCNORECEPCIONADONOTARIO" then
			valorSucNoRecepNotarioDmsNoIngre = dmsNoIngresado
			valorSucNoRecepNotarioDmsValidado = dmsValidado
			valorSucNoRecepNotarioDmsAlerta = dmsAlerta
			valorSucNoRecepNotarioDmsEnValida = dmsEnValidacion
			valorSucNoRecepNotarioDmsRecepcionado = dmsRecepcionado
			idx_SucNoRecepNotario = dmsTotal
		end if

		if sucEstado = "SUCENVIADO" then
			valorSucEnviadoDmsNoIngre = dmsNoIngresado
			valorSucEnviadoDmsValidado = dmsValidado
			valorSucEnviadoDmsAlerta = dmsAlerta
			valorSucEnviadoDmsEnValida = dmsEnValidacion
			valorSucEnviadoDmsRecepcionado = dmsRecepcionado
			idx_sucEnviados = dmsTotal
		end if
    next
end if

'=====================================================================
	' Suma las filas
'=====================================================================
'idx_sucSinValidar = valorSucSinValidaDmsNoIngre + valorSucSinValidaDmsValidado +                				valorSucSinValidaDmsAlerta + valorSucSinValidaDmsEnValida + 		                valorSucSinValidaDmsRecepcionado

'idx_sucValidado = valorSucValidadoDmsNoIngre + valorSucValidadoDmsValidado +					              valorSucValidadoDmsAlerta + valorSucValidadoDmsEnValida +									  valorSucValidadoDmsRecepcionado

'idx_sucEnValidacion = valorSucEnValidaDmsNoIngre + valorSucEnValidaDmsValidado +								  valorSucEnValidaDmsAlerta + valorSucEnValidaDmsEnValida +									  valorSucEnValidaDmsRecepcionado

'idx_sucEnviados = valorSucEnviadoDmsNoIngre + valorSucEnviadoDmsValidado +									  valorSucEnviadoDmsAlerta + valorSucEnviadoDmsEnValida + 									  valorSucEnviadoDmsRecepcionado

'=====================================================================
	' Suma las columnas
'=====================================================================
idx_dmsEnValidacion = valorSucEnValidaDmsEnValida + valorSucEnviadoDmsEnValida + valorSucSinValidaDmsEnValida + valorSucValidadoDmsEnValida
idx_dmsValidado = valorSucEnValidaDmsValidado + valorSucEnviadoDmsValidado + valorSucSinValidaDmsValidado + valorSucValidadoDmsValidado
idx_dmsAlertas = valorSucEnValidaDmsAlerta + valorSucEnviadoDmsAlerta +valorSucSinValidaDmsAlerta + valorSucValidadoDmsAlerta
idx_dmsRecepcionado = valorSucEnValidaDmsRecepcionado + valorSucEnviadoDmsRecepcionado + valorSucSinValidaDmsRecepcionado + valorSucValidadoDmsRecepcionado
idx_dmsNoIngresado = valorSucSinValidaDmsNoIngre + valorSucEnValidaDmsNoIngre + valorSucValidadoDmsNoIngre + valorSucEnNotarioDmsNoIngre + valorSucRecepNotarioDmsNoIngre + valorSucNoRecepNotarioDmsNoIngre + valorSucEnviadoDmsNoIngre

'=====================================================================
	' Suma todas las filas y columnas
'=====================================================================

idx_sucColocaciones=idx_dmsEnValidacion+valorSucEnValidaDmsNoIngre+valorSucEnValidaDmsValidado+valorSucEnValidaDmsAlerta+valorSucEnValidaDmsRecepcionado+valorSucEnviadoDmsNoIngre+valorSucEnviadoDmsValidado+valorSucEnviadoDmsAlerta+valorSucEnviadoDmsRecepcionado+valorSucSinValidaDmsNoIngre+valorSucSinValidaDmsValidado+valorSucSinValidaDmsAlerta+valorSucSinValidaDmsRecepcionado+valorSucValidadoDmsNoIngre+valorSucValidadoDmsValidado+valorSucValidadoDmsAlerta+valorSucValidadoDmsRecepcionado+valorSucEnNotarioDmsNoIngre+valorSucEnNotarioDmsValidado+valorSucEnNotarioDmsAlerta+valorSucEnNotarioDmsEnValida+valorSucEnNotarioDmsRecepcionado+valorSucRecepNotarioDmsNoIngre+valorSucRecepNotarioDmsValidado+valorSucRecepNotarioDmsAlerta+valorSucRecepNotarioDmsEnValida+valorSucRecepNotarioDmsRecepcionado+valorSucNoRecepNotarioDmsNoIngre+valorSucNoRecepNotarioDmsValidado+valorSucNoRecepNotarioDmsAlerta+valorSucNoRecepNotarioDmsEnValida+valorSucNoRecepNotarioDmsRecepcionado


'=====================================================================
	' JSON
'=====================================================================
Response.ContentType = "application/json"
	 Response.Write "{"
	 Response.Write "  ""datos"": "
	 Response.Write "{ "
	 Response.Write " ""idx_sucColocaciones"": """&idx_sucColocaciones&""", "
	 Response.Write " ""idx_sucEnValidacion"": """&idx_sucEnValidacion&""", "
	 Response.Write " ""idx_sucValidado"": """&idx_sucValidado&""", "
	 Response.Write " ""idx_SucEnNotario"": """&idx_SucEnNotario&""", "
	 Response.Write " ""idx_SucRecepNotario"": """&idx_SucRecepNotario&""", "
	 Response.Write " ""idx_SucNoRecepNotario"": """&idx_SucNoRecepNotario&""", "
	 Response.Write " ""idx_sucEnviados"": """&idx_sucEnviados&""", "
	 Response.Write " ""idx_dmsEnValidacion"": """&idx_dmsEnValidacion&""", "
	 Response.Write " ""idx_dmsValidado"": """&idx_dmsValidado&""", "
	 Response.Write " ""idx_dmsAlertas"": """&idx_dmsAlertas&""", "
	 Response.Write " ""idx_dmsRecepcionado"": """&idx_dmsRecepcionado&""", "
	 Response.Write " ""idx_dmsNoIngresado"": """&idx_dmsNoIngresado&""" "
	 Response.Write "} }"
%>
