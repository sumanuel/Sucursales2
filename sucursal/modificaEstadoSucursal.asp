<!--#include file="../funciones.asp"-->
<%idSucursal = trim(request("idSucursal"))
'response.write(idSucursal)
sql4 = ""
sql4 = sql4 & " select convert(varchar(5), isnull(hora_ingreso, '00:00')) as hora_ingreso "
sql4 = sql4 & " from SUC_sucursal_apertura "
sql4 = sql4 & " where id_sucursal = '"&idSucursal&"' "
sql4 = sql4 & " and fecha_ingreso = cast(getdate() as DATE) "
sql4 = sql4 & " and tipo = 2"
set rs4 = db.execute(sql4)
if rs4.eof then
  sucursalCerrada = 0
else
  sucursalCerrada = 1
  horaCierre = trim(rs4("hora_ingreso"))
end if
if sucursalCerrada = 0 then%>
  <div class="rating" id="rating">
  <span class="tool muestraRanking " title="Desborde" rel="Desborde" id="5" data-placement="top">☆</span>
  <span class="tool muestraRanking " title="Full" rel="Full" id="4" data-placement="top">☆</span>
  <span class="tool muestraRanking " title="3/4" rel="3/4" id="3" data-placement="top">☆</span>
  <span class="tool muestraRanking " title="1/2" rel="1/2" id="2" data-placement="top">☆</span>
  <span class="tool muestraRanking " title="1/4" rel="1/4" id="1" data-placement="top">☆</span>
  <span class="tool muestraRanking " title="Nadie" rel="Nadie" id="0" data-placement="top">☆</span>
  </div>
  <div class="oculto" id="cambiaEstado"></div>
<%else%>
  La sucursal fue cerrada a las <%=horaCierre%>
<%end if%>
 <script type="text/javascript" src="js/bootstrap-tooltip.js"></script>
  <script type="text/javascript">
  $(function(){
    $('.tool').tooltip();
  });  
$('.muestraRanking').click(function(){
  $('#rating').slideUp('fast');
  var textoEstado = $(this).attr('rel');
  var nuevaClase, botonConfirmar;
  if (textoEstado == 'Nadie')
  {
    botonConfirmar = '<span class="btn btn-primary btn-mini" onclick="confirma(0,1)">Confirmar</span>';
  }
  if (textoEstado == '1/4')
  {
    botonConfirmar = '<span class="btn btn-primary btn-mini" onclick="confirma(0,2)">Confirmar</span>';
  }
  if (textoEstado == '1/2')
  {
    botonConfirmar = '<span class="btn btn-primary btn-mini" onclick="confirma(0,3)">Confirmar</span>';
  }
  if (textoEstado == '3/4')
  {
    botonConfirmar = '<span class="btn btn-primary btn-mini" onclick="confirma(0,4)">Confirmar</span>';
  }
  if (textoEstado == 'Full')
  {
    botonConfirmar = '<span class="btn btn-warning btn-mini" onclick="confirma(1,5)">AFP</span>  <span class="btn btn-danger btn-mini" onclick="confirma(2,5)">IPS</span>';
  }
  if (textoEstado == 'Desborde')
  {
    botonConfirmar = '<span class="btn btn-warning btn-mini" onclick="confirma(1,6)">AFP</span>  <span class="btn btn-danger btn-mini" onclick="confirma(2,6)">IPS</span>';
  }
  botonConfirmar += ' <span class="btn btn-mini btn-inverse" onclick="cancelaConfirma()">Cancelar acción</span> ';
  var pagina,div,datos
  $('#cambiaEstado').html(botonConfirmar).removeClass('oculto');
});
function confirma(confirmacion,boton)
{
  var textoEstado, nuevaClase, botonConfirmar, textoConfirma;
  if (confirmacion =='1')
  {
    textoConfirma ='AFP';
  }
  else
  {
    textoConfirma ='IPS';
  }
  if (boton =='1') {
    textoEstado = 'Nadie';
    nuevaClase = 'label';
  };
  if (boton =='2') {
    textoEstado = '1/4';
    nuevaClase = 'label label-success';
  };
  if (boton =='3') {
    textoEstado = '1/2';
    nuevaClase = 'label label-success';
  };
  if (boton =='4') {
    textoEstado = '3/4';
    nuevaClase = 'label label-success';
  };
  if (boton =='7') {
    textoEstado = 'Full';
    nuevaClase = 'label label-warning';
  };
  if (boton =='8') {
    textoEstado = 'Desborde';
    nuevaClase = 'label label-important';
  };

  if (boton =='5' || boton =='6')
  {
    if (boton =='5')
    {
      botonConfirmar = '<span class="btn btn-primary btn-mini" onclick="confirma('+confirmacion+',7)">Confirmar cambio estado '+textoConfirma+'</span>';  
    }
    if (boton =='6')
    {
      botonConfirmar = '<span class="btn btn-primary btn-mini" onclick="confirma('+confirmacion+',8)">Confirmar cambio estado '+textoConfirma+'</span>';  
    }   
    $('#cambiaEstado').html(botonConfirmar)
  }
  else
  {
    $('#muestraEstadoSucursal').html('<span>Modificando estado <img src="img/loading.gif"></span>');
    var pagina,div,datos;
    var idUsuario = $('#miSucursalIdUsuario').val();
    var idSucursal = $('#divMisucursal').attr('data-idSucursal');
    pagina = 'sucursales/sqlEstado.asp';
    div = 'cambiaEstado';
    datos = 'idUsuario='+idUsuario+'&valor='+textoEstado+'&confirma='+confirmacion+'&idSucursal='+idSucursal;
    enviaDatos(pagina,div,datos);

    var idSucursal = $('#divMisucursal').attr('data-idSucursal');
    pagina = 'sucursales/estadoActualMiSucursal.asp';
    div = 'muestraEstadoSucursal';
    //datos='idSucursal='+idSucursal;
    detiene(pagina,div,datos,2000);

    pagina = 'sucursales/modificaEstadoSucursal.asp';
    div = 'estadoSucursal';
    detiene(pagina,div,datos,2000);
  }
}
function cancelaConfirma()
{
   var idSucursal = $('#divMisucursal').attr('data-idSucursal');
    pagina = 'sucursales/estadoActualMiSucursal.asp';
    div = 'muestraEstadoSucursal';
    datos='idSucursal='+idSucursal;
    enviaDatos(pagina,div,datos);
    pagina = 'sucursales/modificaEstadoSucursal.asp';
    div = 'estadoSucursal';
    enviaDatos(pagina,div,datos);
}
</script>