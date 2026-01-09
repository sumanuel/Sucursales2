<!--#include file="conexion/conexion.asp"-->

<% ' sin uso de global.asa
'Session.LCID = 1034
%>

<%
function muestraIconoSla(slaComportamiento, montoCantidad,sla)
	select case slaComportamiento
	   case "nosla":
	        clase = "badge-info"
	        icono = "icon-minus"                            
	   case "pone":
	        if cdbl(montoCantidad) <= Cdbl(sla) then
	            clase = "badge-success"
	            icono = "icon-arrow-up"
	        else
	            clase = "badge-important"
	            icono = "icon-arrow-down"
	       end if
	   case "nepo":
	        if cdbl(montoCantidad) > Cdbl(sla) then
	            clase = "badge-success"
	            icono = "icon-arrow-up"
	        else
	            clase = "badge-important"
	            icono = "icon-arrow-down"
	        end if
	    case else
	        clase = ""
	        icono = ""
	end select
	muestraIconoSla = clase&"#"&icono
end function

function formateaParaFecha(variable)
	if len(variable) = 1 then
		variable = "0"&variable
	end if
	formateaParaFecha = variable
end function

function calculaUltimoDia(fecha)
	fecha =  cdate(fecha)
	mesFecha = month(fecha)
	anioFecha = year(fecha)
	diaFecha = day(fecha)
	'al ser 1 del mes tengo que saltar al 30 del mes anterior
	if diaFecha = 1 then
		fecha = DateAdd("d",-1,fecha)
		'reviso si la fecha anterior es feriado
		feriado = revisaFeriado(fecha)
		if feriado <> "0" then
			do until feriado=0
				fecha = DateAdd("d",-1,fecha)
				feriado = revisaFeriado(fecha)
			loop
		end if
	end if
	calculaUltimoDia = fecha
end function

function fechaDMY(fecha)
	fecha = cdate(fecha)
	mesFecha = month(fecha)
	anioFecha = year(fecha)
	diaFecha = day(fecha)
	fechaDMY = diaFecha&"/"&mesFecha&"/"&anioFecha
end function

function fechaMDY(fecha)
	fecha = cdate(fecha)
	mesFecha = month(fecha)
	anioFecha = year(fecha)
	diaFecha = day(fecha)
	fechaMDY = mesFecha&"/"&diaFecha&"/"&anioFecha
end function

function ultimoDia(mesFecha,anioFecha)
	Select Case mesFecha
		Case 1, 3, 5, 7, 8, 10, 12
			ultimoDia = 31
		Case 4, 6, 9, 11
			ultimoDiaMes = 30
		Case 2
			If anioFecha mod 4 = 0 Then
				If anioFecha mod 100 = 0 AND anioFecha mod 400 <> 0 Then
					ultimoDiaMes = 28
				Else
					ultimoDiaMes = 29
				End If
			Else
				ultimoDiaMes = 28
			End If
	End Select
end function

function revisaFeriado(fecha)
	fecha = fechaMDY(fecha)
	sql = ""
	sql = sql & " select feriado from suc_calendario where fecha = cast('"&fecha&"' as DATE)"
	set rs = db.execute(sql)
	revisaFeriado = trim(rs(0))
end function

function primeraMayuscula(cadena)
	primeraMayuscula = ucase(left(cadena,1)) & lcase(right(cadena,len(cadena)-1))
end function

Function renombraArchivos(carpeta,numbreAntiguo,NombreNuevo)
	path = server.mappath(carpeta)
	archivoAntiguo = path&"\"&numbreAntiguo
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	if fs.FileExists(archivoAntiguo) then
	   	extension = fs.GetExtensionName(archivoAntiguo)
	   	nuevoArchivo = path&"\"&NombreNuevo&"."&extension
	   	fs.MoveFile archivoAntiguo, nuevoArchivo
	   	renombraArchivos = NombreNuevo&"."&extension
	Else
		respuesta = "2"
		renombraArchivos = respuesta
	End If
end function

function creaCarpeta(nombreCarpeta)
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	path =server.mappath(nombreCarpeta)
	if fs.FolderExists(path)=true then
			creaCarpeta = "0"
	else
		set f=fs.CreateFolder(path)
		creaCarpeta = "1"
	end if
	set f=nothing
	set fs=nothing
	creaCarpetaHijo = creaCarpeta
end function

function sacaHora(dato)
	if len (dato) = 1 then
    dato = "0"&dato&":00"
  end if
	if IsNull(dato) then
		sacaHora = ""
	else
		dato = cdate(trim(dato))
		hora = formateaParaFecha(hour(trim(dato)))
		minuto = formateaParaFecha(minute(trim(dato)))
		sacaHora = hora&":"&minuto
	end if
end function

function validaPorcentaje(valor)
	valor = formatnumber(valor,2)
	if right(valor,3) = ",00" Then
		valor = cint(valor)
	end if
	validaPorcentaje = valor
end function

function terminaSql(perfil, idUsuario)
	if perfil = "1" then
		sql = sql & " a.id_sucursal in "
		sql = sql & " (select id_sucursal "
		sql = sql & " from SUC_usuario_sucursal "
		sql = sql & " where id_usuario = '"&idUsuario&"')"
	end if
	if perfil = "2" then
		sql = sql & " a.id_sucursal in "
		sql = sql & " (select id_sucursal "
		sql = sql & " from SUC_zonales_sucursal "
		sql = sql & " where id_zonal = '"&idUsuario&"') "
	end if
end function

function cargaTw()
	idUsuario = trim(request("idUsuario"))
	sql = ""
	sql = sql & " select id_mensaje_tw, "
	sql = sql & " a.id_usuario, "
	sql = sql & " a.id_sucursal, "
	sql = sql & " b.id_perfil, "
	sql = sql & " a.mensaje, "
	sql = sql & " a.id_usuario_respuesta, "
	sql = sql & " b.u_nombres +' '+b.u_apellidos as usuarioEnvia, "
	sql = sql & " a.fecha "
	sql = sql & " from SUC_timeline a, "
	sql = sql & " SUC_usuario b "
	sql = sql & " where "
	'sql = sql & " id_mensaje_tw in (select top 20(id_mensaje_tw) "
	'sql = sql & " from SUC_timeline order by id_mensaje_tw) "
	sql = sql & " a.id_usuario = b.id_usuario "
	'sql = sql & " and fecha <= getdate() "
	sql = sql & " order by id_mensaje_tw desc "
	set rs = db.execute(sql)
	if not rs.eof then
		datos = rs.GetRows()
		datosMuestra = ""
		for i=0 to ubound(datos,2)
			idMensaje = trim(datos(0,i))
			idUsuario = trim(datos(1,i))
			usuarioActual = trim(request("idUsuario"))
			idSucursal = trim(datos(2,i))
			idPerfil = trim(datos(3,i))
			if idPerfil <> "1" then
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
			else
				sql2 = ""
				sql2 = sql2 & " select suc_nombre from suc_sucursal where id_sucursal = '"&idSucursal&"'"
				set rs2 = db.execute(sql2)
				if not rs2.eof then
					nombreSucursal = trim(rs2(0))
					icono = "icon-home"
				end if
			end if
			if idUsuario = usuarioActual then
				nombreSucursal = "Yo" 
				claseUsuario = "label-important"
				selecciona = ""
			else
				claseUsuario = ""
				selecciona = "seleccionaSucursalTl"
			end if
			mensaje = trim(datos(4,i))
			idUsuarioRespuesta = trim(datos(5,i))
			nombreUsuario = server.htmlencode(trim(datos(6,i)))
			fecha = trim(datos(7,i))



			datosMuestra = datosMuestra & "<div clas=""row-fluid"">"
			datosMuestra = datosMuestra & "<div class=""span12 well label "
			datosMuestra = datosMuestra & claseUsuario
			datosMuestra = datosMuestra & " "">"
			'desde aca tabla'
			datosMuestra = datosMuestra & "<table class=""table table-condensed "">"
			datosMuestra = datosMuestra & "<tr class=""mano "
			datosMuestra = datosMuestra & selecciona
			datosMuestra = datosMuestra & """ data-idMensaje="""
			datosMuestra = datosMuestra & idMensaje
			datosMuestra = datosMuestra & """"
			datosMuestra = datosMuestra & " data-nombreSucursal = """
			datosMuestra = datosMuestra & nombreSucursal
			datosMuestra = datosMuestra & """ "
			datosMuestra = datosMuestra & " data-nombreUsuario = """
			datosMuestra = datosMuestra & nombreUsuario
			datosMuestra = datosMuestra & """>"
			datosMuestra = datosMuestra & "<td>"
			datosMuestra = datosMuestra & "<i class="""
			datosMuestra = datosMuestra & icono
			datosMuestra = datosMuestra & """></i>   "
			datosMuestra = datosMuestra & nombreSucursal
			datosMuestra = datosMuestra & "</td>"
			datosMuestra = datosMuestra & "<td>"
			datosMuestra = datosMuestra & nombreUsuario
			datosMuestra = datosMuestra & "</td>"
			datosMuestra = datosMuestra & "<td>"
			datosMuestra = datosMuestra & fecha
			datosMuestra = datosMuestra & "</td>"
			datosMuestra = datosMuestra & "</tr>"
			datosMuestra = datosMuestra & "<tr>"
			datosMuestra = datosMuestra & "<td colspan=""3"" class=""overF"">"
			datosMuestra = datosMuestra & mensaje
			datosMuestra = datosMuestra & "</td>"
			datosMuestra = datosMuestra & "</tr>"
			datosMuestra = datosMuestra & "</table>"

			datosMuestra = datosMuestra & "</div></div>"
		next

	end if
	cargaTw = datosMuestra
end function
%>