<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
sql = ""
sql = sql & " select archivo, "
sql = sql & " cast(fecha_auditoria as datetime) as fecha_auditoria, "
sql = sql & " evaluacion "
sql = sql & " from SUC_sucursal_auditoria "
sql = sql & " where id_sucursal = '"&idSucursal&"' "
sql = sql & " and id_auditoria = "
sql = sql & " (select max(id_auditoria) "
sql = sql & " from SUC_sucursal_auditoria ) "
set rs=db.execute(sql)
if not rs.eof then
  tieneDatos = "1"
  evaluacion = trim(rs("evaluacion"))
  if evaluacion = "1" then
    claseEvaluacion = "fondo100"
  else
    claseEvaluacion = "fondo0"
  end if
  fechaAuditoria = trim(rs("fecha_auditoria"))
  diaFechaActual = formateaParaFecha(day(fechaAuditoria))
  mesFechaActual = formateaParaFecha(month(fechaAuditoria))
  anioFechaActual = year(fechaAuditoria)
  fechaAuditoria = diaFechaActual&"-"&mesFechaActual&"-"&anioFechaActual
  archivo = trim(rs("archivo"))
else
  claseEvaluacion = ""
  tieneDatos = "0"
  archivo="No presenta Datos"
end if
%>
<div class="row-fliud">
  <div class="span12 ">
    <%if tieneDatos = "0" then
      %><i class="icon-legal icon-large"></i>&nbsp;<b><%response.write(archivo)%></b>
	<%
    else
      %><i class="icon-legal icon-large"></i>&nbsp;<b><%response.write("Última:" &fechaAuditoria&" ")%></b>
    <span class="icon-stack icon-large mano descargaArchivo" data-descarga="<%=archivo%>">
      <i class="icon-check-empty icon-stack-base"></i>
      <i class="icon-download-alt"></i>
    </span>
    <%end if%>
  </div>
</div>
<script type="text/javascript">
$(function(){
  $('#auditoria').addClass('<%=claseEvaluacion%>');
});
$('.descargaArchivo').click(function(e){
  e.preventDefault();
  var archivo = $(this).attr('data-descarga');
  window.open('auditoria/archivos/<%=idSucursal%>/'+archivo,'_blank');
});
</script>