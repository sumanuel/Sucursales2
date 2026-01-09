<!--#include file="conexion/conexion.asp"-->

<% ' sin uso de global.asa
'Session.LCID = 1034
%>

<%function muestraIconoSla(slaComportamiento, montoCantidad,sla)
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
	idUsuario = trim(request("idUsuarioMain"))
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
			'datosMuestra = datosMuestra & "<tr>"
			'datosMuestra = datosMuestra & "<td>&nbsp;</td>"
			'datosMuestra = datosMuestra & "<td colspan=""2"">&nbsp;</td>"
			'datosMuestra = datosMuestra & "</tr>"
			datosMuestra = datosMuestra & "</table>"









			'datosMuestra = datosMuestra & "<div class=""span5 "
			'datosMuestra = datosMuestra & selecciona
			'datosMuestra = datosMuestra & " "" "
			'datosMuestra = datosMuestra & " data-idMensaje="""
			'datosMuestra = datosMuestra & idMensaje
			'datosMuestra = datosMuestra & """"
			'datosMuestra = datosMuestra & " data-nombreSucursal = """
			'datosMuestra = datosMuestra & nombreSucursal
			'datosMuestra = datosMuestra & """ "
			'datosMuestra = datosMuestra & " data-nombreUsuario = """
			'datosMuestra = datosMuestra & nombreUsuario
			'datosMuestra = datosMuestra & """>"

			'datosMuestra = datosMuestra & "<i class="""
			'datosMuestra = datosMuestra & icono
			'datosMuestra = datosMuestra & """></i>   "
			'datosMuestra = datosMuestra & nombreSucursal
			'datosMuestra = datosMuestra & "</div>"
			'datosMuestra = datosMuestra & "<div class=""span4 "
			'datosMuestra = datosMuestra & selecciona
			'datosMuestra = datosMuestra & " "" "
			'datosMuestra = datosMuestra & " data-idMensaje="""
			'datosMuestra = datosMuestra & idMensaje
			'datosMuestra = datosMuestra & """"
			'datosMuestra = datosMuestra & " data-nombreSucursal = """
			'datosMuestra = datosMuestra & nombreSucursal
			'datosMuestra = datosMuestra & """ "
			'datosMuestra = datosMuestra & " data-nombreUsuario = """
			'datosMuestra = datosMuestra & nombreUsuario
			'datosMuestra = datosMuestra & """>"
			'datosMuestra = datosMuestra & nombreUsuario
			'datosMuestra = datosMuestra & "</div>"
			'datosMuestra = datosMuestra & "<div class=""span3"">"
			'datosMuestra = datosMuestra & fecha  
			'datosMuestra = datosMuestra & "</div>"
			
			'datosMuestra = datosMuestra & "<div class=""span12"">"
			'datosMuestra = datosMuestra & "<div class=""row-fluid"">"
			'datosMuestra = datosMuestra & "<div class=""span12"">"&mensaje&"</div>"
			'datosMuestra = datosMuestra & "</div>"
			datosMuestra = datosMuestra & "</div></div>"
		next
		'datosMuestra = datosMuestra & "<div clas=""row-fluid"">"
		'datosMuestra = datosMuestra & "<div class=""span12 well cargaMas"" data-idLast="""&idMensaje&""">"
		'datosMuestra = datosMuestra & "cargar mas datos"
		'datosMuestra = datosMuestra & "</div></div>"

	end if
	cargaTw = datosMuestra
end function
function cargaTw2()

	cargaTw2 = "mostrar consulta"
end function
function acortaNumero(numero)
	totalCaracteres = len(numero)
	Select Case totalCaracteres
	Case 7
		numeroFormato = formatnumber(left(numero,1),0)&" M"
	Case 8
		numeroFormato = formatnumber(left(numero,2),0)&" M"
	Case 9
		numeroFormato = formatnumber(left(numero,3),0)&" M"
	Case 10
		numeroFormato = formatnumber(left(numero,4),0)&" MM"
	Case 11
		numeroFormato = formatnumber(left(numero,5),0)&" MM"
	case else
		numeroFormato = formatnumber(numero,0)
	End Select
	acortaNumero = numeroFormato
end function

function IsValidUTF8(s)
	IsValidUTF8 = false
	i = 1
	do while i <= len(s)
		c = asc(mid(s,i,1))
		if c and &H80 then
			n = 1
			do while i + n < len(s)
				if (asc(mid(s,i+n,1)) and &HC0) <> &H80 then
					exit do
				end if
				n = n + 1
			loop
			select case n
				case 1
				exit function
			case 2
				if (c and &HE0) <> &HC0 then
					exit function
				end if
			case 3
				if (c and &HF0) <> &HE0 then
					exit function
				end if
			case 4
				if (c and &HF8) <> &HF0 then
					exit function
				end if
			case else
				exit function
			end select
			i = i + n
		else
			i = i + 1
		end if
	loop
	IsValidUTF8 = true 
end function


function DecodeUTF8(s)
	i = 1
	do while i <= len(s)
		c = asc(mid(s,i,1))
		if c and &H80 then
			n = 1
			do while i + n < len(s)
				if (asc(mid(s,i+n,1)) and &HC0) <> &H80 then
					exit do
				end if
				n = n + 1
			loop
			if n = 2 and ((c and &HE0) = &HC0) then
				c = asc(mid(s,i+1,1)) + &H40 * (c and &H01)
			else
				c = 191 
			end if
			s = left(s,i-1) + chr(c) + mid(s,i+n)
		end if
		i = i + 1
	loop
	DecodeUTF8 = s 
end function

function EncodeUTF8(s)
	i = 1
	do while i <= len(s)
		c = asc(mid(s,i,1))
		if c >= &H80 then
			s = left(s,i-1) + chr(&HC2 + ((c and &H40) / &H40)) + chr(c and &HBF) + mid(s,i+1)
			i = i + 1
		end if
		i = i + 1
	loop
	EncodeUTF8 = s 
end function
function obtieneIdSucursal(idUsuario)
	sql2 = ""
	sql2 = sql2 & "select id_sucursal from SUC_usuario_sucursal where id_usuario = " & idUsuario& " and estado = 0"
	
	'response.write(sql2)
	'response.end

	Set rsUserSuc = DB.execute(sql2)
	if not rsUserSuc.Eof then
		idSucursal = rsUserSuc("id_sucursal")
	else
		idSucursal = "0"
	end if	
	rsUserSuc.Close
	set rsUserSuc.ActiveConnection = nothing
	set rsUserSuc = nothing
	obtieneIdSucursal = idSucursal
end function

'Función para registrar log de eventos del usuario
sub registrarLog(usuario, perfil, funcionalidad, tipo_accion)
	on error resume next
	
	'Obtener fecha y hora actual
	dim fechaActual, horaActual
	fechaActual = Date()
	horaActual = Time()
	
	'Escapar comillas simples para evitar errores SQL
	usuario = Replace(usuario, "'", "''")
	perfil = Replace(perfil, "'", "''")
	funcionalidad = Replace(funcionalidad, "'", "''")
	tipo_accion = Replace(tipo_accion, "'", "''")
	
	'Construir la consulta SQL
	dim sqlLog
	sqlLog = "EXEC dbo.SCSS_insertar_reporte_log "
	sqlLog = sqlLog & "'" & usuario & "', "
	sqlLog = sqlLog & "'" & perfil & "', "
	sqlLog = sqlLog & "'" & funcionalidad & "', "
	sqlLog = sqlLog & "'" & tipo_accion & "', "
	sqlLog = sqlLog & "'" & fechaActual & "', "
	sqlLog = sqlLog & "'" & horaActual & "'"
	
	'Ejecutar el stored procedure
	DB.Execute(sqlLog)
	
	'Limpiar error si existe
	if err.number <> 0 then
		err.clear
	end if
	
	on error goto 0
end sub
%>