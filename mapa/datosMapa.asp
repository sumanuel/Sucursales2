<!--#include file="../funciones.asp"-->
[
<%sql = ""
sql = sql & " select a.id_sucursal, b.suc_nombre, a.ejex, a.ejey from SUC_sucursal_coordenada a, SUC_sucursal b where a.ejex is not null and a.id_sucursal = b.id_sucursal "
tieneDatos = 0
set rs = db.execute(sql)
if not rs.eof then
    datos = rs.getrows()
    tieneDatos = 1
end if
if tieneDatos = 1 then
    for i = 0 to ubound(datos,2)
        idSucursal = trim(datos(0,i))
        nombreSucursal = trim(datos(1,i))
        ejex= trim(datos(2,i))
        ejey = trim(datos(3,i))%>
    {
        "idSucursal":"<%=idSucursal%>",
        "nombre": "xxxx",
        "region":"<%=i%>",
        "x":<%=ejex%>,
        "y":<%=ejey%>,
        "estado": "Abierta",
        "color": "#ff0000",
        "marker": {
            "fillColor": "black",
            "lineColor": "black",
            "lineWidth": 1,
            "radius": 2
        }
    }

    <% if i <> ubound(datos,2) then response.write(",")
    next
end if%>
]