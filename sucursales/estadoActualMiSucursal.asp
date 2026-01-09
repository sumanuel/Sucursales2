<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
sql = ""
sql = sql & " Select a.id_sucursal, "
sql = sql & " a.situacion, "
sql = sql & " convert(varchar(5),a.hora), "
sql = sql & " a.tipo "
sql = sql & " from SUC_desbordes a "
sql = sql & " where a.fecha = cast(getdate() as date) "
sql = sql & " and a.id_sucursal = '"&idSucursal&"' "
sql = sql & " and a.hora = (select max(b.hora) "
sql = sql & " from SUC_desbordes b "
sql = sql & " where a.fecha = b.fecha "
sql = sql & " and a.tipo = b.tipo) "
sql = sql & " order by a.tipo "
'response.write(sql)
'response.end
set rs = db.execute(sql)
if not rs.eof then
    datos = rs.getrows()
for i=0 to ubound(datos,2)
    tipo = trim(datos(3,i))
    txtEstado = server.htmlencode(trim(datos(1,i)))
    horaDato = formateaParaFecha(trim(datos(2,i)))
     select case tipo 
        case  "1"
            txtTextoTipo = " AFP"
        case  "2"
            txtTextoTipo = " IPS"
        case else
            txtTextoTipo = "Normal"
    end select
    select case txtEstado
        case "Nadie":
            claseEstado =""
        case "1/4":
            claseEstado ="label-success"
        case "1/2":
            claseEstado = "label-success"
        case "3/4":
            claseEstado = "label-success"
        case "Full":
            claseEstado = "label-warning"
        case "Desborde":
            claseEstado = "label-important"
    end select%>
    <span class="label <%=claseEstado%> tool" data-placement="top" title="<%=horaDato&"  "&txtEstado%>">
        <%=txtTextoTipo%>
    </span>
<%next%>
<script type="text/javascript" src="js/bootstrap-tooltip.js"></script>
<script type="text/javascript">
    $(function(){
        $('.tool').tooltip();
    });
</script>
<%else%>
    <span class="label tool" data-placement="top" title="Sin dato">
        Sin datos
    </span>
<%end if%>