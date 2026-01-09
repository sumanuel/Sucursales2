<!--#include file="../funciones2.asp"-->
<%
idUsuarioMain = trim(request("idUsuarioMain"))
perfilMain = trim(request("perfilMain"))
mes = trim(request("mes"))
anio = trim(request("anio"))
id_zonal  = trim(request("id_zonal"))

'response.write(id_zonal)
'response.end()

sql = ""
sql = sql & "select "
sql = sql & "z.regional, z.id_usuario, z.Zonal, z.id_sucursal, z.cod_bantotal, z.suc_nombre, z.qRepro "
sql = sql & "from ( "
sql = sql & "select suc.suc_zonal_jefe as regional, zn.id_usuario, us.u_nombres+' '+us.u_apellidos as Zonal, "
sql = sql & "suc.id_sucursal, suc.cod_bantotal, suc.suc_nombre, "
sql = sql & "(select count(0) as q from scvcc.dbo.opreprocr opcr where opcr.sucursalorigen = suc.cod_bantotal "
sql = sql & "and year(cast(opcr.fecreprogramacion as date)) = "&anio&" and month(cast(opcr.fecreprogramacion as date)) = "&mes&") as qRepro "
sql = sql & "from SUC_usuario_zona zn inner join SUC_sucursal suc on zn.id_sucursal = suc.id_sucursal "
sql = sql & "inner join SUC_usuario us on us.id_usuario = zn.id_usuario "
if perfilMain = "2" then
sql = sql & "where suc.suc_estado = 1 and us.id_usuario = '"&idUsuarioMain&"' "
end if
if perfilMain = "3" then
sql = sql & "where suc.suc_estado = 1 and us.id_usuario = '"&id_zonal&"' "
end if
sql = sql & ") z group by z.regional, z.id_usuario, z.Zonal, z.id_sucursal, z.cod_bantotal, z.suc_nombre, z.qRepro "
sql = sql & "having z.qRepro > 0 order by z.qRepro desc "

'response.write(sql)
'response.end()

set rs = db.execute(sql)
if not rs.eof then
    datos = rs.getrows()%>

{
    "data": [
    <%for i = 0 to ubound(datos,2)
    regional = trim(datos(0,i))
    id_usuario = trim(datos(1,i))
    Zonal= trim(datos(2,i))
    id_sucursal= trim(datos(3,i))
    cod_bantotal= trim(datos(4,i))
    suc_nombre= trim(datos(5,i))
    cantidadColocaciones= trim(datos(6,i))
    %>
    {
    	"regional": "<%=regional%>",
        "Zonal": "<%=Zonal%>",
        "Id_Sucursal": "<%=id_sucursal%>",
        "cod_bantotal": "<%=cod_bantotal%>",
        "nom_sucursal": "<%=suc_nombre%>",
        "cantidadColocaciones": "<%=cantidadColocaciones%>"      
    }
    <%if i <> ubound(datos,2) then%>
    ,
    <%end if%>
    <%next%>

    ]
}
<%end if%>