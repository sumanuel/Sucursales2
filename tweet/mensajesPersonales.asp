<!--#include file="../funciones.asp"-->
<%tipo = trim(request("tipo"))
idUsuario = trim(request("idUsuario"))
if tipo = "1" then
	sql = ""
	sql = sql & " select a.id_mensaje_tw as mensajeRespondido, "
	sql = sql & " a.id_usuario as idUsuarioRespondido, "
	sql = sql & " a.id_sucursal, "
	sql = sql & " a.mensaje as mensajeOriginal, "
	sql = sql & " a.fecha as fechaEnvio, "
	sql = sql & " b.id_mensaje_tw as idMensajeRespuesta, "
	sql = sql & " b.mensaje as mensajeRespuesta, "
	sql = sql & " b.fecha as fechaRespuesta "
	sql = sql & " from "
	sql = sql & " suc_timeline a, "
	sql = sql & " SUC_timeline b "
	sql = sql & " where a.id_mensaje_tw = b.id_usuario_respuesta "
	sql = sql & " and b.id_usuario = '"&idUsuario&"' "
	sql = sql & " and b.id_usuario_respuesta <> '0'"
	set rs = db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		tabla = ""
		tabla = tabla & "<div class=""row-fluid""><div class=""span12""><div class=""row-fluid""><div class=""span12""><span class=""alert alert-danger"">Mis respuestas</span></div></div>"
		for i=0 to ubound(datos,2)
			idMensajeRespondido = trim(datos(0,i))
			idUsuarioRespuesta = trim(datos(1,i))
			idSucursal = trim(datos(2,i))
			mensajeOriginal = trim(datos(3,i))
			fechaEnvio = trim(datos(4,i))
			idRespuesta = trim(datos(5,i))
			mensajeRespuesta = trim(datos(6,i))
			fechaRespuesta = trim(datos(7,i))

			sql2 = ""
			sql2 = sql2 & "select u_nombres + ' ' + u_apellidos,"
			sql2 = sql2 & " id_perfil from suc_usuario where id_usuario = '"&idUsuarioRespuesta&"'"
			set rs2 = db.execute(sql2)
			if not rs2.eof then
				nombreUsuarioOriginal = trim(rs2(0))
				idPerfil = trim(rs2(1))
			end if
			if idPerfil = "1" then
				sql2 = ""
				sql2 = sql2 & " select suc_nombre from suc_sucursal where id_sucursal = '"&idSucursal&"'"
				set rs2 = db.execute(sql2)
				if not rs2.eof then
					nombreSucursal = trim(rs2(0))
					icono = "icon-home"
				end if
			end if
			if idPerfil = "2" then
				nombreSucursal = "Zonal"
				icono = "icon-building"
			end if
			if idPerfil = "2" then
				nombreSucursal = "Zonal"
				icono = "icon-building"
			end if
			if idPerfil = "3" then
				nombreSucursal = "Operaciones"
				icono= "icon-briefcase"
			end if
			if idPerfil = "4" then
				nombreSucursal = "Divisional"
				icono = "icon-group"
			end if
			
			tabla = tabla & " <div class=""row-fluid""><div class=""span12""><table class=""table"">"
			tabla = tabla & " <tbody>"
			tabla = tabla & " <tr class=""info"">"
			tabla = tabla & " <td>"
			tabla = tabla & "<i class="""&icono&"""></i>    "
			tabla = tabla & nombreUsuarioOriginal
			tabla = tabla & " </td>"
			tabla = tabla & " <td>"
			tabla = tabla & nombreSucursal
			tabla = tabla & " </td>"
			tabla = tabla & " <td>Fecha :"&fechaEnvio&"</td>"
			tabla = tabla & " </tr>"
				'tr para mensaje antiguo'
			tabla = tabla & " <tr class=""warning"">"
			tabla = tabla & " <td>Mensaje Original: </td>"
			tabla = tabla & " <td colspan=""2"">"
			tabla = tabla & mensajeOriginal
			tabla = tabla & " </td>"
			tabla = tabla & " </tr>"
			tabla = tabla & " <tr class=""success"">"
			tabla = tabla & " <td>Respuesta: </td>"
			tabla = tabla & " <td></td>"
			tabla = tabla & " <td>Fecha : "&fechaRespuesta&"</td>"
			tabla = tabla & " </tr>"
			tabla = tabla & " <tr class=""success"">"
			tabla = tabla & " <td colspan=""3"">"
			tabla = tabla & mensajeRespuesta
			tabla = tabla & " </td>"
			tabla = tabla & " </tr>"
			tabla = tabla & " </tbody>"
			tabla = tabla & " </table></div></div>"
		next
	
	else
		tabla = tabla & "<div class=""row-fluid""><div class=""span12""><span class=""alert alert-danger"">Usted no ha respondido mensajes</span></div></div>"
	end if
end if
if tipo = "2" then
	sql = ""
	sql = sql & " select b.id_mensaje_tw as mensajeRespondido, "
	sql = sql & " a.id_usuario as idUsuarioRespondido, "
	sql = sql & " b.id_sucursal, "
	sql = sql & " b.mensaje as mensajeOriginal, "
	sql = sql & " b.fecha as fechaEnvio, "
	sql = sql & " a.id_mensaje_tw as idMensajeRespuesta, "
	sql = sql & " a.mensaje as mensajeRespuesta, "
	sql = sql & " a.fecha as fechaRespuesta "
	sql = sql & " from SUC_timeline a, "
	sql = sql & " SUC_timeline b "
	sql = sql & " where a.id_usuario_respuesta = b.id_mensaje_tw "
	sql = sql & " and a.id_usuario_respuesta in "
	sql = sql & " (select id_mensaje_tw from SUC_timeline where id_usuario = '"&idUsuario&"') "
	set rs = db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()

		tabla = ""
		tabla = tabla & "<div class=""row-fluid""><div class=""span12""><span class=""alert alert-danger"">Respuestas a mis mensajes</span></div></div>"
		for i=0 to ubound(datos,2)
			idMensajeRespondido = trim(datos(0,i))
			idUsuarioRespuesta = trim(datos(1,i))
			idSucursal = trim(datos(2,i))
			mensajeOriginal = trim(datos(3,i))
			fechaEnvio = trim(datos(4,i))
			idRespuesta = trim(datos(5,i))
			mensajeRespuesta = trim(datos(6,i))
			fechaRespuesta = trim(datos(7,i))

			sql2 = ""
			sql2 = sql2 & "select u_nombres + ' ' + u_apellidos,"
			sql2 = sql2 & " id_perfil from suc_usuario where id_usuario = '"&idUsuarioRespuesta&"'"
			set rs2 = db.execute(sql2)
			if not rs2.eof then
				nombreUsuarioOriginal = trim(rs2(0))
				idPerfil = trim(rs2(1))
			end if
			if idPerfil = "1" then
				sql2 = ""
				sql2 = sql2 & " select suc_nombre from suc_sucursal where id_sucursal = '"&idSucursal&"'"
				set rs2 = db.execute(sql2)
				if not rs2.eof then
					nombreSucursal = trim(rs2(0))
					icono = "icon-home"
				end if
			end if
			if idPerfil = "2" then
				nombreSucursal = "Zonal"
				icono = "icon-building"
			end if
			if idPerfil = "2" then
				nombreSucursal = "Zonal"
				icono = "icon-building"
			end if
			if idPerfil = "3" then
				nombreSucursal = "Operaciones"
				icono= "icon-briefcase"
			end if
			if idPerfil = "4" then
				nombreSucursal = "Divisional"
				icono = "icon-group"
			end if
			
			tabla = tabla & "<div class=""row-fluid""><div class=""span12""> <table class=""table"">"
			tabla = tabla & " <tbody>"
			tabla = tabla & " <tr class=""info"">"
			tabla = tabla & " <td>"
			tabla = tabla & "<i class="""&icono&"""></i>    "
			tabla = tabla & nombreUsuarioOriginal
			tabla = tabla & " </td>"
			tabla = tabla & " <td>"
			tabla = tabla & nombreSucursal
			tabla = tabla & " </td>"
			tabla = tabla & " <td>Fecha :"&fechaEnvio&"</td>"
			tabla = tabla & " </tr>"
			tabla = tabla & " <tr class=""warning"">"
			tabla = tabla & " <td>Mensaje Original: </td>"
			tabla = tabla & " <td colspan=""2"">"
			tabla = tabla & mensajeOriginal
			tabla = tabla & " </td>"
			tabla = tabla & " </tr>"
			tabla = tabla & " <tr class=""success"">"
			tabla = tabla & " <td>Respuesta: </td>"
			tabla = tabla & " <td></td>"
			tabla = tabla & " <td>Fecha : "&fechaRespuesta&"</td>"
			tabla = tabla & " </tr>"
			tabla = tabla & " <tr class=""success"">"
			tabla = tabla & " <td colspan=""3"">"
			tabla = tabla & mensajeRespuesta
			tabla = tabla & " </td>"
			tabla = tabla & " </tr>"
			tabla = tabla & " </tbody>"
			tabla = tabla & " </table></div></div>"
		next
	else
		tabla = tabla & "<div class=""row-fluid""><div class=""span12""><span class=""alert alert-danger"">Sus mensajes aún no tienen respuesta</span></div></div>"
	end if
end if
response.write(tabla)%>