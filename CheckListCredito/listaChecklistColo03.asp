<!--#include file="../funciones2.asp"-->
<%
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
id_sucursal = trim(request("id_sucursal"))

'response.write(perfilMain)
'response.end

%>

<input type="hidden" name="idCombo" id="idCombo" value="3">
<input type="hidden" name="idSucursales" id="idSucursales" value="<%=id_sucursal%>">
<input type="hidden" name="idZonales3" id="idZonales3" value="<%=id_zonal%>">

<%if perfilMain = "3" or perfilMain = "2" then%>
  <div class="controls">
    <span class="btn btn-success btnVolverVisZona">Volver</span>
  </div>
  <p></p>
<%end if%>

<div class="modal hide fade" id="modalCambiaCodigoCaja" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-header">
      <span class="close" data-dismiss="modal" aria-hidden="true">×</span>
        <h3 id="myModalLabel">
          Cambia Codigo
        </h3>
    </div>
    <div class="modal-body"></div>
    <div class="modal-footer">
      <span class="btn btn-danger cierraModal" data-dismiss="modal" >Cerrar</span>
    </div>
  </div>

<div class="modal hide fade" id="modalCheck" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-header">
      <span class="close" data-dismiss="modal" aria-hidden="true">×</span>
        <h3 id="myModalLabel">
          Check List
        </h3>
    </div>
    <div class="modal-body"></div>
    <div class="modal-footer">
      <span class="btn btn-danger" data-dismiss="modal" >Cerrar</span>
      <span class="btn btn-info" onClick="paso2Check();" id="botonPaso2Modal">Modificar caja</span>
    </div>
  </div>

<table id="tableP03" class="table table-bordered table-hover table-condensed table-striped" data-anio2="<%=anio%>" data-mes2="<%=mes%>" data-idsucursal="<%=id_sucursal%>" data-perfil="<%=perfilMain%>" data-usuario="<%=idUsuarioMain%>" data-idSucursalMain="<%=idSucursalMain%>">
<thead>
<tr>
    <th><strong>Carpeta</strong></th>
    <th><strong>Cliente</strong></th>    
    <th><strong>Op</strong></th>
    <th><strong>Fec Colo</strong></th>    
    <th><strong>Cliente</strong></th>
    <th><strong>Caja</strong></th>    
    <th><strong>%</strong></th>
    <th><strong>Acciones</strong></th>
</tr>
</thead>
<tbody>

<script type="text/javascript">
$(document).ready(function (){
  var mes = $('#tableP03').attr('data-mes2');
  var anio = $('#tableP03').attr('data-anio2');
  var id_sucursal = $('#tableP03').attr('data-idsucursal');
  var idUsuarioMain = $('#tableP03').attr('data-usuario');
  var perfilMain = $('#tableP03').attr('data-perfil');
  var idSucursalMain = $('#tableP03').attr('data-idSucursalMain');
  //alert(perfilMain);
  var url = 'CheckListCredito/datosTab03.asp?mes='+mes+'&anio='+anio+'&id_sucursal='+id_sucursal+'&perfilMain='+perfilMain+'&idUsuarioMain='+idUsuarioMain+'&idSucursalMain='+idSucursalMain;  
  var table = $('#tableP03').DataTable( {
    "ajax": url,    
    "sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
    "sPaginationType": "bootstrap",
        "columns": [
            { "data": "idCarpeta" },
            { "data": "segmento" },
            { "data": "numero_credito"},
            { "data": "fecha_colocacion" },            
            { "data": "rut_cliente" },
            { "data": "caja" },            
            { "data": "totalPorcentaje" },
            {
                data: null,
                className: "center",
                defaultContent: '<span class="botonera"></span>'
            }
          ]       
    });
  $('#tableP03').on( 'draw.dt', function () {
      $('tbody > tr').each(function() {
        var idCarpeta = $(this).attr('id');
        var idCaja = $.trim($('#'+idCarpeta+' > td:eq( 5 )').text());
        var tipCliente = $.trim($('#'+idCarpeta+' > td:eq( 1 )').text());
        if(tipCliente == "PEN"){
          tipCliente = 32;
        }else{
          tipCliente = 30;
        }
        $('#'+idCarpeta+' > td > span').each(function() {        
          if ($(this).hasClass('botonera')){
            if(perfilMain == "1"){
              $(this).html('  <span class="label label-success ayuda mano btnModal '+idCarpeta+'" onClick="abreModal('+idCarpeta+','+tipCliente+');" title="Ingresar al check list"><i class="icon-check"></i></span>&nbsp;&nbsp;<span class="label label-important ayuda mano" onClick="modalCodigo('+idCarpeta+','+idCaja+',202);" id="btnModalCodigo'+idCarpeta+'" title="Modificar caja"><i class="icon-exchange"></i></span>');
            }
            else{
              $(this).html('  <span class="label label-success ayuda mano btnModal '+idCarpeta+'" onClick="abreModal('+idCarpeta+','+tipCliente+');" title="Ingresar al check list"><i class="icon-check"></i></span>&nbsp;&nbsp;');
            }
          }
        });          
      });    
  });
});

function abreModal(idCarpeta, tipCliente){
  var idUsuario = $('#tableP03').attr('data-usuario');
  var perfilMain = <%=perfilMain%>;
  $('#modalCheck').attr('data-idCarpeta', idCarpeta);
  $('#botonPaso2Modal').slideDown('fast');
  $('#modalCheck').modal({
    keyboard: false,
    show: true,
    backdrop: true,
    remote: 'CheckListCredito/checkList.asp?idCarpeta='+idCarpeta+'&idUsuario='+idUsuario+'&tipCliente='+tipCliente+'&perfilMain='+perfilMain
  });
  $('#'+idCarpeta+' > td:eq( 6 )').addClass('modificaCheck'+idCarpeta);
}

$('#modalCheck').on('hidden', function () {
  var idUsuario = $.trim($('#idUsuario').val());
  var pagina, div, datos,idCarpeta, codigoBarras;
  idCarpeta = $('#modalCheck').attr('data-idCarpeta');  
  codigoBarras = $.trim($('#codigoBarras'+idCarpeta).text());  
  $(this).removeData('modal');
  pagina = 'CheckListCredito/porcentajeCarpeta.asp';
  div = 'modificaCheck'+idCarpeta;
  datos='idCarpeta='+idCarpeta+'&idUsuario='+idUsuario+'&codigoBarras='+codigoBarras;
  enviaDatosClase(pagina,div,datos);
});

function modalCodigo(idCarpeta,codigoBarra,estado){
  var idSuc = <%=idSucursalMain%>;
  $('#modalCambiaCodigoCaja').attr('data-idCarpeta',idCarpeta);
  $('#modalCambiaCodigoCaja').attr('data-codigoBarra',codigoBarra);
  $('#modalCambiaCodigoCaja').modal({
    keyboard: false,
    show: true,
    backdrop: true,
    remote: 'CheckListCredito/cambiaCaja.asp?idCarpeta='+idCarpeta+'&idSuc='+idSuc
  });
  $('#'+idCarpeta+' > td:eq( 5 )').addClass('modificaCarpeta'+idCarpeta);
  
}
$('#modalCambiaCodigoCaja').on('hidden', function () {
  $(this).removeData('modal');
  var pagina, div, datos,idCarpeta;
  idCarpeta = $('#modalCambiaCodigoCaja').attr('data-idCarpeta');
  var codigoBarra = $('#modalCambiaCodigoCaja').attr('data-codigoBarra');
  pagina = 'CheckListCredito/buscaCaja.asp';
  div = 'modificaCarpeta'+idCarpeta;
  datos='idCarpeta='+idCarpeta;
  enviaDatosClase(pagina,div,datos);//
  $('#btnModalCodigo'+idCarpeta).attr('onClick', 'modalCodigo('+idCarpeta+','+codigoBarra+',202);');
});

function paso2Check(){  
  var pagina, div, datos,idCarpeta;
  idCarpeta = $('#modalCheck').attr('data-idCarpeta');  
  var mes = $('#tableP03').attr('data-mes2');
  var anio = $('#tableP03').attr('data-anio2');
  //alert(mes);
  pagina = 'CheckListCredito/carpetaCaja2.asp';
  div = 'datosModal'+idCarpeta;
  datos='idCarpeta='+idCarpeta+'&mes='+mes+'&anio='+anio;
  enviaDatos(pagina,div,datos);
  $('#botonPaso2Modal'+idCarpeta).slideUp('fast');
}

$('.btnVolverVisZona').click(function(){    
    var id_zonal = <%=id_zonal%>;
    //alert(id_zonal);
    var mes = <%=mes%>;
    var anio = <%=anio%>;
    var div = 'listaChecklistColo2';
    var pagina = 'CheckListCredito/listaChecklistColo02.asp';
    var idColocacion = 1     
    var datos = 'mes='+mes+'&anio='+anio+'&id_zonal='+id_zonal;
    enviaDatos(pagina,div,datos);
    $('#listaChecklistColo3').html('').hide();      
  });
</script>