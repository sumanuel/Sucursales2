<!--#include file="../funciones2.asp"-->
<%idColocacion = trim(request("idColocacion"))
id_zonal = trim(request("id_zonal"))
if id_zonal = "" then
  id_zonal = 0
end if
mes = trim(request("mes"))
anio = trim(request("anio"))
periodo = anio&"/"&mes
perfilMain = trim(request("perfilMain"))
idUsuarioMain = trim(request("idUsuarioMain"))
idSucursalMain = trim(request("idSucursalMain"))

'response.write(id_zonal)
'response.end

%>

<input type="hidden" name="idCombo" id="idCombo" value="2">
<input type="hidden" name="idZonales" id="idZonales" value="<%=id_zonal%>">

<%if perfilMain = "3" then%>
  <div class="controls">
    <span class="btn btn-success btnVolverVisZPais">Volver</span>
  </div>
  <p></p>
<%end if%>

<table id="tableP02" class="table table-bordered table-hover table-condensed table-striped mano" data-anio2="<%=anio%>" data-mes2="<%=mes%>" data-zonal="<%=id_zonal%>" data-perfil="<%=perfilMain%>" data-usuario="<%=idUsuarioMain%>">
<thead>
<tr>
    <th><strong>Regional</strong></th>
    <th><strong>Nombre Zonal</strong></th>
    <th><strong>Id Sucursal</strong></th>
    <th><strong>Cod Bantotal</strong></th>
    <th><strong>Nombre Sucursal</strong></th>
    <th><strong>Total Colo Crédito</strong></th>
</tr>
</thead>
<tbody>

<script type="text/javascript">
$(document).ready(function() {  
  var mes = $('#tableP02').attr('data-mes2');
  var anio = $('#tableP02').attr('data-anio2');
  var id_zonal = $('#tableP02').attr('data-zonal');
  var idUsuarioMain = $('#tableP02').attr('data-usuario');
  var perfilMain = $('#tableP02').attr('data-perfil');
  //alert(perfilMain);
  var url = 'CheckListCredito/datosTab02.asp?mes='+mes+'&anio='+anio+'&id_zonal='+id_zonal+'&perfilMain='+perfilMain+'&idUsuarioMain='+idUsuarioMain;  
  $('#tableP02').dataTable( {
    "ajax": url,    
    "sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
    "sPaginationType": "bootstrap",
        "columns": [
            { "data": "regional" },
            { "data": "Zonal" },
            { "data": "Id_Sucursal"},
            { "data": "cod_bantotal" },
            { "data": "nom_sucursal" },
            { "data": "cantidadColocaciones" }]
       
    });
  $('#tableP02 tbody').delegate('tr','click', function(){
      var idSuc = $('td:eq(2)', this).text();
      //alert(idSuc);
      var id_sucursal = idSuc;      
      var div = 'listaChecklistColo3';
      var pagina = 'CheckListCredito/listaChecklistColo03.asp';
      var datos = 'mes='+mes+'&anio='+anio+'&id_sucursal='+id_sucursal+'&id_zonal='+id_zonal;
      enviaDatos(pagina,div,datos);
      $('#listaChecklistColo2').html('').hide();
    });
});
$('.btnVolverVisZPais').click(function(){   
    var mes = <%=mes%>;    
    var anio = <%=anio%>;
    var div = 'listaChecklistColo';
    var pagina = 'CheckListCredito/listaChecklistColo01.asp';
    var idColocacion = 1
    var datos = 'idColocacion='+idColocacion+'&mes='+mes+'&anio='+anio;
    enviaDatos(pagina,div,datos);
    $('#listaChecklistColo2').html('').hide();    
  }); 
</script>