<!--#include file="../funciones2.asp"-->
<%
mes = trim(request("mes"))
anio = trim(request("anio"))
perfilMain = trim(request("perfilMain"))
idUsuarioMain = trim(request("idUsuarioMain"))
idSucursalMain = trim(request("idSucursalMain"))
'response.write(idUsuarioMain)
'response.end
%>
<table id="tableP0010" class="table table-bordered table-hover table-condensed table-striped">
<thead>
<tr>
    <th><strong>Cod Barras</strong></th>
    <th><strong>Fec Envio</strong></th>    
    <th><strong>JEPS</strong></th>
    <th><strong>Cant Carpetas</strong></th>
    <th><strong>% Caja</strong></th>
    <th><strong>Estado</strong></th>
</tr>
</thead>
<tbody>

<script type="text/javascript">
$(document).ready(function (){
  var mes = <%=mes%>;
  var anio = <%=anio%>;
  var idUsuarioMain = <%=idUsuarioMain%>;
  var perfilMain = <%=perfilMain%>;
  var idSucursalMain = <%=idSucursalMain%>;
  var url = 'CheckListCredito/datosTab0010.asp?mes='+mes+'&anio='+anio+'&perfilMain='+perfilMain+'&idUsuarioMain='+idUsuarioMain+'&idSucursalMain='+idSucursalMain;
  var table = $('#tableP0010').DataTable({
    "ajax": url,    
    "sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
    "sPaginationType": "bootstrap",
        "columns": [
            { "data": "codBarra" },
            { "data": "fecEnvio" },
            { "data": "jeps"},
            { "data": "cantCarpetas" },            
            { "data": "porcentajeCaja" },
            { "data": "estado" }
          ]       
    });
});
</script>