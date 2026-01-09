<!--#include file="../funciones.asp"-->
<%
'gAdministrativa
Response.ContentType = "application/json"
   Response.Write "{"
   Response.Write "  ""datos"": ["
	sql =""
	sql = sql & " select a.id_zonal, "
	sql = sql & " zonal, "
	sql = sql & " a.id_zona, "
	sql = sql & " b.zona, "
	sql = sql & " d.id_sucursal, "
	sql = sql & " d.suc_nombre "
	sql = sql & " from SUC_zonales a, "
	sql = sql & " SUC_zonas b, "
	sql = sql & " SUC_zonales_sucursal c, "
	sql = sql & " SUC_sucursal d "
	sql = sql & " where a.id_zona = b.id_zona "
	sql = sql & " and a.id_zonal = c.id_zonal "
	sql = sql & " and c.id_sucursal = d.id_sucursal "
	set rs = db.execute(sql)
	datos = rs.GetRows()
	For i = 0 to ubound(datos, 2)
		idZonal = trim(datos(0,i))
		nombreZonal = trim(datos(1,i))
		idZona = trim(datos(2,i))
		nombreZona = trim(datos(3,i))
		idSucursal = trim(datos(4,i))
		nombreSucursal = trim(datos(5,i))
		count = count + 1
		If count > 1 Then
			Response.Write ", "
		End If
		Response.Write "{ "      
    	Response.Write "   ""idZonal"": """ & idZonal & ""","
    	Response.Write "   ""nombreZonal"": """ & nombreZonal & ""","
    	Response.Write "   ""idZona"": """ & idZona & ""","
    	Response.Write "   ""nombreZona"": """ & nombreZona & ""","
    	Response.Write "   ""idSucursal"": """ & idSucursal & ""","
    	Response.Write "   ""nombreSucursal"": """ & nombreSucursal & ""","
    	

    	sql2 =""
    	sql2 = sql2 & " select porc_cumpl "
    	sql2 = sql2 & " from SUC_gest_cont_control "
    	sql2 = sql2 & " where fecha_operacion = cast (GETDATE() as DATE) "
    	sql2 = sql2 & " and id_sucursal = '"&idSucursal&"' "
    	set rs2 = db.execute(sql2)
    	if not rs2.eof Then
    		porcentaje_cont = trim(rs2(0))
    	else
    		porcentaje_cont = 0
    	end if
        porcentaje_cont = validaPorcentaje(porcentaje_cont)
    	Response.Write "   ""porcentaje_cont"": """ & porcentaje_cont & ""","
    	sql2 =""
    	sql2 = sql2 & " select porc_cumpl "
    	sql2 = sql2 & " from SUC_gest_admin_control "
    	sql2 = sql2 & " where fecha_operacion = cast (GETDATE() as DATE) "
    	sql2 = sql2 & " and id_sucursal = '"&idSucursal&"' "
    	set rs2 = db.execute(sql2)
    	if not rs2.eof Then
    		porcentaje_adm = trim(rs2(0))
    	else
    		porcentaje_adm = 0
    	end if
        porcentaje_adm = validaPorcentaje(porcentaje_adm)
    	Response.Write "   ""porcentaje_adm"": """ & porcentaje_adm & ""","
    	sql2 =""
    	sql2 = sql2 & " select porc_cumpl "
    	sql2 = sql2 & " from SUC_gest_doc_control "
    	sql2 = sql2 & " where fecha_operacion = cast (GETDATE() as DATE) "
    	sql2 = sql2 & " and id_sucursal = '"&idSucursal&"' "
    	set rs2 = db.execute(sql2)
    	if not rs2.eof Then
    		porcentaje_doc = trim(rs2(0))
    	else
    		porcentaje_doc = 0
    	end if
            porcentaje_doc = validaPorcentaje(porcentaje_doc)
    		Response.Write "   ""porcentaje_doc"": """ & porcentaje_doc & """"
    	Response.Write "}"
	next
	Response.Write "]}"%>