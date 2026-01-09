<!--#include file="../funciones2.asp"-->
<%
idSucursalMain = trim(request("idSucursalMain"))
perfilMain = trim(request("perfilMain"))
id_sucursal = trim(request("id_sucursal"))
mes = trim(request("mes"))
anio = trim(request("anio"))

sql = ""
sql = sql & "select "
sql = sql & "id_carpeta, "
sql = sql & "case a.tipo_pens_trab "
sql = sql & "when 30 then 'TRAB' when 32 then 'PEN' end as segmento "
sql = sql & ",a.num_credito, a.fecha_colocacion, cast(a.rut_cliente as varchar(10))+'-'+a.dv_cliente as rutcliente "
sql = sql & ",a.id_codigo_barra as caja,  "
sql = sql & "(select COUNT(*) from SUC_vcc_checklist b, SUC_vcc_tipo_doc c where a.id_carpeta = b.id_carpeta and b.ID_Tipo_Doc = "
sql = sql & "c.ID_Tipo_Doc and c.excluyente = 0 ) as totalCheck, "
sql = sql & "(select COUNT(*) from SUC_vcc_checklist b, SUC_vcc_tipo_doc c where a.id_carpeta = b.id_carpeta and b.ID_Tipo_Doc = "
sql = sql & "c.ID_Tipo_Doc and check_OK = 0 and c.excluyente = 0) as respondidasCheck "
sql = sql & "from SUC_vcc_carpeta_credito a "
sql = sql & "inner join SUC_vcc_Nombre_Cliente e on "
sql = sql & "a.rut_cliente = e.rut_cliente "
sql = sql & "inner join SUC_sucursal suc on "
sql = sql & "a.cod_sucursal = suc.cod_bantotal "
if perfilMain = "1" then
sql = sql & "where suc.id_sucursal = "&idSucursalMain&" "
end if
if perfilMain = "3" or perfilMain = "2" then
sql = sql & "where suc.id_sucursal = "&id_sucursal&" "
end if
sql = sql & "and year(a.fecha_colocacion) = "&anio&" and month(a.fecha_colocacion) = "&mes&" "
sql = sql & "and a.tipo = 'COLO' "

'response.write(sql)
'response.end

set rs = db.execute(sql)
if not rs.eof then
    datos = rs.getrows()%>

{
    "data": [
    <%for i = 0 to ubound(datos,2)
    idCarpeta = trim(datos(0,i))
    segmento = trim(datos(1,i))
    numero_credito = trim(datos(2,i))
    fecha_colocacion = trim(datos(3,i))
    rut_cliente = trim(datos(4,i))
    caja = trim(datos(5,i))    
    totalCheck = trim(datos(6,i))
    totalResponde = trim(datos(7,i))
    if totalCheck <> 0 then
        totalnoResponde = totalCheck - totalnoResponde        '
        totalPorcentaje = formatpercent(totalResponde/totalCheck,1)
        formatoPorcentaje = replace(totalPorcentaje,"%","")
        if right(formatoPorcentaje,2) = ",0" then
            totalPorcentaje = replace(formatoPorcentaje,",0","")
            totalPorcentaje = totalPorcentaje&"%"
        end if
        enteroPorcentaje = cint(replace(totalPorcentaje,"%",""))
    else
        totalCheck = 0
        totalPorcentaje = "0%"
        enteroPorcentaje = 0
    end if
    %>
    {
        "idCarpeta": "<%=idCarpeta%>",
        "segmento": "<%=segmento%>",
        "numero_credito": "<%=numero_credito%>",
        "fecha_colocacion": "<%=fecha_colocacion%>",
        "rut_cliente": "<%=rut_cliente%>",
        "caja": "<%=caja%>",        
        "totalPorcentaje": "<%=totalPorcentaje%>",
        "DT_RowId": "<%=idCarpeta%>"
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
        "idCarpeta": "--",
        "segmento": "--",
        "numero_credito": "--",
        "fecha_colocacion": "--",
        "rut_cliente": "--",
        "caja": "--",
        "totalPorcentaje": "--",
        "DT_RowId": "--"
        }
    ]
}
<%end if%>