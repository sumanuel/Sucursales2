<!--#include file="../funciones2.asp"-->
<%
idSucursalMain = trim(request("idSucursalMain"))
perfilMain = trim(request("perfilMain"))
id_sucursal = trim(request("id_sucursal"))
mes = trim(request("mes"))
anio = trim(request("anio"))

sql = ""
sql = sql & "select "
sql = sql & "a.id_codigo_barra, a.fecha_envio_caja, b.descrip_estado, p.suc_jeps_short as nom_usuario, b.id_estado, "
sql = sql & "(select COUNT(*) from SUC_vcc_checklist z, SUC_vcc_carpeta_credito x, SUC_vcc_tipo_doc y where z.id_carpeta = "
sql = sql & "x.id_carpeta and z.ID_Tipo_Doc = y.ID_Tipo_Doc and x.id_codigo_barra = a.id_codigo_barra and z.check_OK = 0 and y.excluyente = 0) as totalSi, "
sql = sql & "(select COUNT(*) from SUC_vcc_checklist z, SUC_vcc_carpeta_credito x, SUC_vcc_tipo_doc y where z.id_carpeta = "
sql = sql & "x.id_carpeta and z.ID_Tipo_Doc = y.ID_Tipo_Doc and y.excluyente = 0 and x.id_codigo_barra = a.id_codigo_barra) as totalMarca, "
sql = sql & "(select COUNT(*) from SUC_vcc_carpeta_credito x where x.id_codigo_barra = a.id_codigo_barra) as totalDocumentos "
sql = sql & "from SUC_vcc_caja a inner join "
sql = sql & "SUC_vcc_estados b on a.id_estado = b.id_estado inner join "
sql = sql & "SUC_sucursal p on a.id_sucursal = p.id_sucursal "
sql = sql & "and a.id_sucursal = "&idSucursalMain&" and a.id_estado = 204 "
sql = sql & "and month(a.fecha_envio_caja) = "&mes&" and year(a.fecha_envio_caja) = "&anio&" "
sql = sql & "order by a.fecha_envio_caja desc "
'response.write(sql)
'response.end

set rs = db.execute(sql)
if not rs.eof then
    datos = rs.getrows()%>

{
    "data": [
    <%for i = 0 to ubound(datos,2)
    codigoBarras = trim(datos(0,i))
    fechaEnvio = trim(datos(1,i))
    estado = server.htmlencode(trim(datos(2,i)))
    usuario = trim(datos(3,i))
    idEstado = trim(datos(4,i))
    totalMarcado = clng(trim(datos(5,i)))
    totalMarca = clng(trim(datos(6,i)))
    if totalMarca <> 0 then
        porcentajeMarca = formatpercent(totalMarcado/totalMarca,1)
    if right(porcentajeMarca,3) = ",0%" then
        enteroPorcentaje = cint(replace(porcentajeMarca,"%",""))
        porcentajeMarca = enteroPorcentaje&"%"
    end if
    else
        porcentajeMarca = "0%"
    end if
    totalDocumentos = clng(trim(datos(7,i)))
    if totalDocumentos = "" then totalDocumentos = 0
    enteroPorcentaje = cint(replace(porcentajeMarca,"%",""))
    %>
    {
        "codBarra": "<%=codigoBarras%>",
        "fecEnvio": "<%=fechaEnvio%>",
        "jeps": "<%=usuario%>",
        "cantCarpetas": "<%=totalDocumentos%>",
        "porcentajeCaja": "<%=porcentajeMarca%>",
        "estado": "<%=estado%>"
    }    
    <%if i <> ubound(datos,2) then%>
    ,
    <%end if%>
    <%next%>

    ]
}
<%else%>
{
    "data": [
     {
        "codBarra": "--",
        "fecEnvio": "--",
        "jeps": "--",
        "cantCarpetas": "--",
        "porcentajeCaja": "--",
        "estado": "--"
        }
    ]
}
<%end if%>