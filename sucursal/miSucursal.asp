<!--#include file="../funciones2.asp"-->
<%perfil = trim(request("perfilMain"))
idSucursal = trim(request("idSucursalMain"))
idUsuario = trim(request("idUsuarioMain"))
if idSucursal = "0" then
  idSucursal = trim(request("idSucursal"))
end if%>
<div class="row-fluid">
  <div class="span12" id="divMisucursal" data-perfil="<%=perfil%>" data-idSucursal="<%=idSucursal%>" data-idUsuario="<%=idUsuario%>" data-modificandoCampo="0">
    <input type="hidden" id="miSucursalIdUsuario" value="<%=idUsuario%>"/>
    <table class="table table-bordered table-hover" id="tablaDatosSucursal">
      <tr>
        <td>Sucursal:</td>
        <td><span id="nombreSucursal"></span> ( <span id="tipoSucursal"></span> )</td>
        <td>Dirección</td>
        <td><span id="direccionSucursal" data-btn="1" class="agregaBoton campoModificadoSuc1"></span></td>
        <td>Jeps</td>
        <td>
          <span class="label label-info" id="nombreJeps"></span>
          <span id="usuariosSucursal" class="mano tool" data-placement="top" data-original-title="Usuarios sucursal">
            <i class="icon-user icon-2x"></i>
          </span>
        </td>
      </tr>
      <tr>
        <td>Anexo</td>
        <td><span id="anexoSucursal" data-btn="2" class="agregaBoton campoModificadoSuc2"></span></td>
        <td>Celular</td>
        <td><span id="celujarJeps"  data-btn="3" class="agregaBoton campoModificadoSuc3"></span></td>
        <td>Encargado Zonal</td>
        <td><span class="label label-info" id="nombreEncargadoZonal"></span></td>
      </tr>
      <tr>
        <td>Cod BTT</td>
        <td><span id="codbtt"></span></td>
        <td>Cod SAP</td>
        <td><span id="codsap"></span></td>
        <td colspan="2" id="aperturaSucursal"></td>
        <td id="tdMuestraEstado"><span id="muestraEstadoSucursal"></span></td>
        <td id="tdEstadoSucursal"><span id="estadoSucursal"></span></td>
      </tr>
      <tr id="trUsuariosSucursal"><td colspan="6"><div id="usuariosSucursalTabla"></div></td></tr>
  </table>
  </div>
</div>
<script type="text/javascript">
  $(function(){
    $('#aperturaSucursal').hide('fast');
    $('#trUsuariosSucursal').hide('fast');
     $('.tool').tooltip();
    var perfil = $('#divMisucursal').attr('data-perfil');
    var idUsuario = $('#divMisucursal').attr('data-idUsuario');
    var idSucursal = $('#divMisucursal').attr('data-idSucursal');
    var url = 'sucursales/datosSucursal.asp?perfil='+perfil+'&idUsuario='+idUsuario+'&idSucursal='+idSucursal;
    $.when($.ajax(url)).then(function(data) {
      $.each( data.datosSucursal, function( key, valoresSucursales ) {
        var idSucursal = valoresSucursales.idSucursal;
        $('#nombreSucursal').html(valoresSucursales.nombreSucursal);
        $('#tipoSucursal').html(valoresSucursales.suc_tipo);
        $("#direccionSucursal").html(valoresSucursales.direccionSucursal).attr('data-campo', valoresSucursales.direccionSucursal);
        $('#nombreJeps').html(valoresSucursales.nombreJeps).attr({
          'data-rutJeps': valoresSucursales.rutJeps ,
          'data-nombreJeps': valoresSucursales.nombreOri
        });
        $('#anexoSucursal').html(valoresSucursales.anexoSucursal).attr('data-campo',valoresSucursales.anexoSucursal);
        $('#celujarJeps').html(valoresSucursales.celujarJeps).attr('data-campo',valoresSucursales.celujarJeps);
        $('#codbtt').html(valoresSucursales.codBTT);
        $('#codsap').html(valoresSucursales.codSAP);
        $('#nombreEncargadoZonal').html(valoresSucursales.nombreEncargadoZonal);
        if (perfil == '3' )
        {
          $('#aperturaSucursal').fadeOut('fast');
          $('#tdEstadoSucursal, #tdMuestraEstado').slideDown('fast');
          $('#tdMuestraEstado').html('Auditoria');
          if (valoresSucursales.tieneAuditoria === '0')
          {
            $('#tdEstadoSucursal').html(valoresSucursales.archivo);
          }
        }
        else
        {
          var sucursalAbierta = valoresSucursales.sucursalAbierta;
          if (sucursalAbierta ==='1')
          {
            $('#tdEstadoSucursal, #tdMuestraEstado').slideDown('fast');
            var pagina, div, datos;
            pagina = 'sucursales/estadoActualMiSucursal.asp';
            div = 'muestraEstadoSucursal';
            datos='idSucursal='+idSucursal;
            enviaDatos(pagina,div,datos);

            pagina = 'sucursales/modificaEstadoSucursal.asp';
            div = 'estadoSucursal';
            datos='idSucursal='+idSucursal;
            enviaDatos(pagina,div,datos);

            var horaCierreHora = parseInt(valoresSucursales.horaCierreHora);
            var horaCierremin = parseInt(valoresSucursales.horaCierremin);
            var horaInicioCierre = horaCierreHora * 60 ;
            horaInicioCierre += horaCierremin ;
            
            var fecha = new Date();
            var horaActual = fecha.getHours();
            var minutoActual = fecha.getMinutes();
            var horaEnMinutos = horaActual * 60;
            horaEnMinutos += minutoActual;
            var minutosFaltantes = horaInicioCierre - horaEnMinutos;
            //var miliMinutosFaltantes = minutosFaltantes * 60000; //
            //minutosFaltantes = 0
            if (minutosFaltantes <= 0 )
            {
              if (horaEnMinutos <= 1380)
              {
                $('#divBotonCierraSucursal').removeClass('oculto');  
              }
              
            }
            else
            {
              $('#divBotonCierraSucursal').addClass('oculto');
            }
            
          }
          else if (perfil === '1'){
            $('#tdEstadoSucursal, #tdMuestraEstado').hide('fast');
            $('#aperturaSucursal').fadeIn('fast').html('<span class="btn btn-success botonAbreSucursal oculto" onClick="abreSucursal();"><i class="icon-signin"></i><strong>Abrir sucursal</strong></span> <div id="abreSucursal"></div>');
            var horaAperturaHora = parseInt(valoresSucursales.horaAperturaHora);
            var horaAperturamin = parseInt(valoresSucursales.horaAperturamin);
            var horaInicioAbre = horaAperturaHora * 60 ;
            horaInicioAbre += horaAperturamin ;

            var fecha = new Date();
            var horaActual = fecha.getHours();
            var minutoActual = fecha.getMinutes();
            var horaEnMinutos = horaActual * 60;
            horaEnMinutos += minutoActual;
            //var horaInicioAbre = 895;
            var minutosFaltantes = horaInicioAbre - horaEnMinutos;
            var miliMinutosFaltantes = minutosFaltantes * 60000; //
            if (miliMinutosFaltantes <= 0)
            {
              $('.botonAbreSucursal').removeClass('oculto');
            }
            else
            {
              setTimeout(function () { $('.botonAbreSucursal').removeClass('oculto'); }, 6000);
            }
          }
           else if (perfil === '2'){
           $('#tdEstadoSucursal, #tdMuestraEstado').hide('fast');
            $('#aperturaSucursal').fadeIn('fast').html('<span class="btn btn-success botonAbreSucursal oculto" onClick="abreSucursalZonal(<%=idSucursal%>);"><i class="icon-signin"></i><strong>Abrir sucursal</strong></span> <div id="abreSucursal"></div>');
            var horaAperturaHora = parseInt(valoresSucursales.horaAperturaHora);
            var horaAperturamin = parseInt(valoresSucursales.horaAperturamin);
            var horaInicioAbre = horaAperturaHora * 60 ;
            horaInicioAbre += horaAperturamin ;

            var fecha = new Date();
            var horaActual = fecha.getHours();
            var minutoActual = fecha.getMinutes();
            var horaEnMinutos = horaActual * 60;
            horaEnMinutos += minutoActual;
            //var horaInicioAbre = 895;
            var minutosFaltantes = horaInicioAbre - horaEnMinutos;
            var miliMinutosFaltantes = minutosFaltantes * 60000; //
            if (miliMinutosFaltantes <= 0)
            {
              $('.botonAbreSucursal').removeClass('oculto');
            }
            else
            {
              setTimeout(function () { $('.botonAbreSucursal').removeClass('oculto'); }, 6000);
            }

          }
        }
         
      });
    });
  });
$(document).on('click', '.cambiaInput', function(event) {
  var botonSobre = $(this).attr('data-btn');
  console.log(botonSobre);
  var valorCampo = $(this).attr('data-campo');
  console.log(valorCampo);
  var idSucursal = $('#divMisucursal').attr('data-idSucursal');
  var modificando = $('#divMisucursal').attr('data-modificandoCampo');
  console.log(modificando);
  if (modificando !== '1')
  {
    $('#divMisucursal').attr('data-modificandoCampo', '1');
    $(this).html('<form id="formModificaCampo" name="formModificaCampo"><input type="text" name="modificaCampo" id="modificaCampo" value="'+valorCampo+'"><input type="hidden" name="idCampo" id="idCampo" value="'+botonSobre+'"><input type="hidden" name="idSucursal" id="idSucursal" value="'+idSucursal+'"><span class="btn btn-mini btn-danger" id="btnModificaCampo"  data-btn="'+botonSobre+'">Modificar</span><span id="btnCancelaAccion" data-btn="'+botonSobre+'" class="btn btn-mini btn-info">Cancelar</span></form>');
    $('#modificaCampo').focus();
  }
}).on('mouseover', '.agregaBoton', function(event) {
  event.preventDefault();
  var botonSobre = $(this).attr('data-btn');
  var valorCampo = $(this).attr('data-campo');
  var modificando = $('#divMisucursal').attr('data-modificandoCampo');
  if (modificando ==='0')
  {
    $('.campoModificadoSuc'+botonSobre).html(valorCampo+'  <span><i class="icon-edit"></i></span>').addClass('cambiaInput');
  }
}).on('mouseout', '.agregaBoton', function(event) {
  event.preventDefault();
  var botonSobre = $(this).attr('data-btn');
  var valorCampo = $(this).attr('data-campo');
  var modificando = $('#divMisucursal').attr('data-modificandoCampo');
  if (modificando ==='0')
  {
    $('.campoModificadoSuc'+botonSobre).html(valorCampo).removeClass('cambiaInput');
  }
}).on('click', '#btnCancelaAccion', function(event) {
  event.preventDefault();
  var botonSobre = $(this).attr('data-btn');
  var valorCampo = $('.campoModificadoSuc'+botonSobre).attr('data-campo');
  $('#divMisucursal').attr('data-modificandoCampo',0);
  $('.campoModificadoSuc'+botonSobre).html(valorCampo).removeClass('cambiaInput');
}).on('mouseover', '#nombreJeps', function(event) {
  if ($('#perfilMain').val() ==='2')
  {
    event.preventDefault();
    var nombreJeps = $(this).attr('data-nombreJeps');
    var modificando = $('#divMisucursal').attr('data-modificandoCampo');
    if (modificando ==='0')
    {
      $(this).html(nombreJeps +'  <span><i class="icon-edit"></i></span>' ).addClass('mano');
    }  
  }
  
}).on('mouseout', '#nombreJeps', function(event) {
  if ($('#perfilMain').val() ==='2')
  {
  event.preventDefault();
    var nombreJeps = $(this).attr('data-nombreJeps');
    var modificando = $('#divMisucursal').attr('data-modificandoCampo');
    if (modificando ==='0')
    {
      $(this).html(nombreJeps).removeClass('mano');
    }
  }
}).on('click', '#nombreJeps', function(event) {
  if ($('#perfilMain').val() ==='2')
  {
    event.preventDefault();
    var pagina, div, datos;
    var nombreJeps = $(this).attr('data-nombreJeps');
    var modificando = $('#divMisucursal').attr('data-modificandoCampo');
    $('#nombreJeps').removeClass('label label-info');
    if (modificando ==='0')
    {
      pagina = 'sucursales/comboJeps.asp';
      div = 'nombreJeps';
      var idSucursal = $('#divMisucursal').attr('data-idSucursal');
      var rutJeps = $(this).attr('data-rutJeps');
      datos='rutJeps='+rutJeps+'&nombreJeps='+nombreJeps+'&idSucursal='+idSucursal;
      enviaDatos(pagina,div,datos);
    }
    
    $('#divMisucursal').attr('data-modificandoCampo', '1');
  }
}).on('click', '#btnModificaCampo', function(event) {
  event.preventDefault();
  var botonSobre = $(this).attr('data-btn');
  var datos = $('#formModificaCampo').serialize();
  console.log(datos);
  $('.campoModificadoSuc'+botonSobre).html('<img src="img/loader.gif"><div id="campoModificado"></div>').removeClass('cambiaInput');
  setTimeout(function(){
    var pagina, div;
    pagina = 'sucursales/sqlDatosSucursal.asp';
    div = 'campoModificado';
    enviaDatos(pagina,div,datos);
  }, 1000);
  
});

$('#usuariosSucursal').click(function(){
  $('#trUsuariosSucursal').slideDown('fast');
  var pagina, div, datos;
  var idSucursal = $('#divMisucursal').attr('data-idSucursal');
  pagina = 'sucursales/usuariosSucursal.asp';
  div = 'usuariosSucursalTabla';
  datos='idSucursal='+idSucursal;
  enviaDatos(pagina,div,datos);
});


function abreSucursal()
{
  var pagina,div,datos;
  pagina = 'sucursales/abreSucursal.asp';
  div = 'abreSucursal';
  datos = '';
  try{
    enviaDatos(pagina,div,datos);
  }catch(err){}
  $('#aperturaSucursal').html('<span class="badge badge-success"><i class="icon-check"></i>La apertura de sucursal fue correcta</span>');
  setTimeout(function() {
    try{
      pagina = 'sucursales/miSucursal.asp';
      div = 'miSucursal';
      datos='';
      enviaDatos(pagina,div,datos);
      pagina = 'sucursales/panelSucursal.asp';
      div = 'panelSucursal';
      try{
         enviaDatos(pagina,div,datos);
      }catch(err){}
        $('#divBotonCierraSucursal').removeClass('oculto');
    }catch(err){}
  }, 1500);
}

 function abreSucursalZonal(idSucursal)
    {
      var pagina = 'sucursales/abreSucursal.asp';
      var div = 'abreSucursal';
      var datos = 'idSucursal='+idSucursal;
      try{
        enviaDatos(pagina,div,datos);
      }
      catch(err){}
      
      $('#aperturaSucursal').html('<span class="badge badge-success"><i class="icon-check"></i>La apertura de sucursal fue correcta</span>');
       setTimeout(function() {
        $('#aperturaSucursal').html('<i class="icon-check"></i>La apertura de sucursal fue correcta');
        $('#trabajoZonal').fadeOut('fast');
        $('#trabajoZonal').removeClass('span8').addClass('span5').html('').fadeIn('fast');
        $('#estadoSucursalesZonal').removeClass('span2').addClass('span5');
        $('.listado').slideDown('slow');
        $('#sucursalSeleccionada').addClass('oculto').removeClass(' span12 label label-inverse');
        pagina = 'sucursales/estadoSucursal.asp';
        div = 'estadoSucursalesZonal';
        datos = '';
        try{
               enviaDatos(pagina,div,datos);
        }catch(err){}
        pagina = 'sucursales/sucursalesAbiertasZonal.asp';
        div='divSucursalesAbiertas';
        datos = 'idPerfil=2';
        try{
               enviaDatos(pagina,div,datos);
        }catch(err){}
       try{
            $('#tdEstadoSucursal, #tdMuestraEstado').slideDown('fast');
            var pagina, div, datos;
            pagina = 'sucursales/estadoActualMiSucursal.asp';
            div = 'muestraEstadoSucursal';
            datos='idSucursal='+idSucursal;
            enviaDatos(pagina,div,datos);

            pagina = 'sucursales/modificaEstadoSucursal.asp';
            div = 'estadoSucursal';
            datos='idSucursal='+idSucursal;
            enviaDatos(pagina,div,datos);

            pagina = 'sucursales/miSucursal.asp';
            div = 'miSucursal';
            try{
               enviaDatos(pagina,div,datos);
            }catch(err){}
              $('#divBotonCierraSucursal').removeClass('oculto');
          }catch(err){}

       }, 1500);
    }
  
</script>
<%RESPONSE.END
if perfil = "2" then
  sql = ""
  sql = sql & " select suc_nombre, suc_direccion, suc_tipo, "
  sql = sql & " suc_jeps, suc_jeps_enexo, "
  sql = sql & " suc_jeps_celular, suc_zonal, suc_zonal_ext, "
  sql = sql & " cod_sap, cod_bantotal "
  sql = sql & " from SUC_sucursal "
  sql = sql & " where id_sucursal = '"&idSucursal&"'"
  response.write(sql)
  set rs= db.execute(sql)
  if not rs.eof then
    nombreSucursal = server.HTMLEncode(trim(rs("suc_nombre")))
    direccionSucursal = server.HTMLEncode(trim(rs("suc_direccion")))
    nombreJeps = server.HTMLEncode(trim(rs("suc_jeps")))  
    anexoSucursal = trim(rs("suc_jeps_enexo"))
    celujarJeps = trim(rs("suc_jeps_celular"))
    nombreEncargadoZonal = server.HTMLEncode(trim(rs("suc_zonal")))
    nombreEncargadoZonal_Ext = server.HTMLEncode(trim(rs("suc_zonal_ext")))
    suc_tipo = server.HTMLEncode(trim(rs("suc_tipo")))  
    codSAP = trim(rs("cod_sap"))
    codBTT = trim(rs("cod_bantotal"))
    sql2 = ""
    sql2 = sql2 & " select 1 "
    sql2 = sql2 & " from SUC_sucursal_apertura "
    sql2 = sql2 & " where id_sucursal = '"&idSucursal&"' "
    sql2 = sql2 & " and fecha_ingreso = cast(getdate() as DATE) "
    sql2 = sql2 & " and tipo = 1"
    set rs2 = db.execute(sql2)
    if rs2.eof then
      sucursalAbierta = 0
    else
      sucursalAbierta = 1
    end if%>    
    <div class="row-fluid">
      <div class="span12">
        <input type="hidden" id="miSucursalIdUsuario" value="<%=idUsuario%>"/>
        <table class="table table-bordered table-hover">
          <tr>
            <td>Sucursal:</td>
            <td id="nombreSucursal"><%=nombreSucursal%> (<%=suc_tipo%>)</td>
            <td>Dirección</td>
            <td id="direccionSucursal"><%=direccionSucursal%></td>
            <td>Jeps</td>
            <td id="nombreJeps">
              <span class="label label-info"><%=nombreJeps%></span>
            </td>
          </tr>
          <tr>
            <td>Anexo</td>
            <td id="anexoSucursal"><%=anexoSucursal%></td>
            <td>Celular</td>
            <td id="celujarJeps"><%=celujarJeps%></td>
            <td>Encargado Zonal</td>
            <td id="nombreEncargadoZonal">
              <span class="label label-info"><%=nombreEncargadoZonal_Ext%></span>
            </td>
          </tr>
          <tr>
            <td>Cod BTT</td>
            <td id="codbtt"><%=codBTT%></td>
            <td>Cod SAP</td>
            <td id="codsap"><%=codSAP%></td>

            <%if sucursalAbierta = 0 then%>
              <td colspan="2" id="aperturaSucursal">
                <%if perfil = "2"  then
                  sql4 = ""
                  sql4 = sql4 & " select cast(hora_ingreso as DATETIME) as hora_ingreso "
                  sql4 = sql4 & " from SUC_sucursal_apertura "
                  sql4 = sql4 & " where id_sucursal = '"&idSucursal&"' "
                  sql4 = sql4 & " and fecha_ingreso = cast(getdate() as DATE) "
                  sql4 = sql4 & " and tipo = 1"
                  set rs4 = db.execute(sql4)
                  if rs4.eof then
                    sucursalCerrada = 0
                  else
                    sucursalCerrada = 1
                  end if
                  if sucursalCerrada = 0 then%>
                    <span class="btn btn-success botonAbreSucursal oculto" data-idSucursal=<%=idSucursal%>>
                      <i class="icon-signin"></i>   
                      <strong>
                        Abrir sucursal
                      </strong>
                    </span>
                    <div id="abreSucursalZonal"></div>
                      <script type="text/javascript">
                        var fecha = new Date();
                        var horaActual = fecha.getHours();
                        var minutoActual = fecha.getMinutes();
                        var horaEnMinutos = horaActual * 60;
                        horaEnMinutos += minutoActual;
                        var horaInicioAbre = 895;
                        var minutosFaltantes = horaInicioAbre - horaEnMinutos;
                        var miliMinutosFaltantes = minutosFaltantes * 60000; //
                        if (miliMinutosFaltantes <= 0)
                        {
                          $('.botonAbreSucursal').removeClass('oculto');
                        }
                        else
                        {
                          setTimeout(function () { $('.botonAbreSucursal').removeClass('oculto'); }, 6000);
                        }
                        $('.botonAbreSucursal').click(function(){
                          idSucursal = $(this).attr('data-idSucursal')
                          pagina = 'sucursales/abreSucursal.asp';
                          div = 'abreSucursalZonal';
                          datos = '';
                          try{
                            enviaDatos(pagina,div,datos);
                          }catch(err){}
                          $('#aperturaSucursal').html('<span class="badge badge-success"><i class="icon-check"></i>La apertura de sucursal fue correcta</span>');
                          setTimeout(function() {
                            try{
                              pagina = 'sucursales/miSucursal.asp';
                              div = 'miSucursal';
                              datos='';
                              enviaDatos(pagina,div,datos);
                              pagina = 'sucursales/panelSucursal.asp';
                              div = 'panelSucursal';
                              datos='';
                              try{
                                 enviaDatos(pagina,div,datos);
                              }catch(err){}
                              $('#divBotonCierraSucursal').removeClass('oculto');
                            }catch(err){}
                          }, 2500);
                        });
                      </script>
                    <%end if
                  end if%>
                </td>
              <%else%>
                <td id="muestraEstadoSucursal" data-idSucursal="<%=idSucursal%>"></td>
                <td id="estadoSucursal"></td>
                <script type="text/javascript">
                  var idSucursal = $('#muestraEstadoSucursal').attr('data-idSucursal');
                  var pagina, div, datos;
                  pagina = 'sucursales/estadoActualMiSucursal.asp';
                  div = 'muestraEstadoSucursal';
                  datos='idSucursal='+idSucursal;
                  enviaDatos(pagina,div,datos);

                  pagina = 'sucursales/modificaEstadoSucursal.asp';
                  div = 'estadoSucursal';
                  datos='idSucursal='+idSucursal;
                  console.log(datos)
                  enviaDatos(pagina,div,datos);
                </script>
              <%end if%>
          </tr>
        </table>
      </div>
    </div>
  <script type="text/javascript" src="js/bootstrap-tooltip.js"></script>
  <script type="text/javascript">
  $(function(){
    $('.tool').tooltip();
  });
</script>
  <%end if
else
  sql = ""
  sql = sql & " select suc_nombre, suc_direccion, suc_tipo, "
  sql = sql & " suc_jeps, suc_jeps_enexo, "
  sql = sql & " suc_jeps_celular, suc_zonal, suc_zonal_ext, "
  sql = sql & " cod_sap, cod_bantotal "
  sql = sql & " from SUC_sucursal "
  sql = sql & " where id_sucursal = '"&idSucursal&"'"
  set rs= db.execute(sql)
  if not rs.eof then
    nombreSucursal = server.HTMLEncode(trim(rs("suc_nombre")))
    direccionSucursal = server.HTMLEncode(trim(rs("suc_direccion")))
    nombreJeps = server.HTMLEncode(trim(rs("suc_jeps")))  
    anexoSucursal = trim(rs("suc_jeps_enexo"))
    celujarJeps = trim(rs("suc_jeps_celular"))
    nombreEncargadoZonal = server.HTMLEncode(trim(rs("suc_zonal")))
    nombreEncargadoZonal_Ext = server.HTMLEncode(trim(rs("suc_zonal_ext")))
    suc_tipo = server.HTMLEncode(trim(rs("suc_tipo")))
    codSAP = trim(rs("cod_sap"))
    codBTT = trim(rs("cod_bantotal"))

    sql2 = ""
    sql2 = sql2 & " select 1 "
    sql2 = sql2 & " from SUC_sucursal_apertura "
    sql2 = sql2 & " where id_sucursal = '"&idSucursal&"' "
    sql2 = sql2 & " and fecha_ingreso = cast(getdate() as DATE) "
    sql2 = sql2 & " and tipo = 1"
    set rs2 = db.execute(sql2)
    if rs2.eof then
      sucursalAbierta = 0
    else
      sucursalAbierta = 1
  end if%>
  <div class="row-fluid">
    <div class="span12">
       <input type="hidden" id="miSucursalIdUsuario" value="<%=idUsuario%>"/>
      <table class="table table-bordered table-hover">
        <tr>
            <td>Sucursal:</td>
            <td id="nombreSucursal"><%=nombreSucursal%> (<%=suc_tipo%>)</td>
            <td>Dirección</td>
            <td id="direccionSucursal" data-direccion="<%=direccionSucursal%>">
              <span id="muestraDireccion">
                <%=direccionSucursal%>
              </span>
              <span id="modificaDireccion"></span>
            </td>
            <td>Jeps</td>
            <td id="nombreJeps"><span class="label label-info"><%=nombreJeps%></span></td>
          </tr>
          <tr>
            <td>Anexo</td>
            <td id="anexoSucursal" data-anexo="<%=anexoSucursal%>">
              <span id="muestraAnexo">
                <%=anexoSucursal%>
              </span>
              <span id="modificaAnexo"></span>              
            </td>
            <td>Celular</td>
            <td id="celujarJeps" data-celular="<%=celujarJeps%>">
              <span id="muestraCelular">
                <%=celujarJeps%>
              </span>
              <span id="modificaCelular"></span>
            </td>
            <td>Cod BTT</td>
            <td id="codbtt"><%=codBTT%></td>
          </tr>
          <tr>
            <td>Cod SAP</td>
            <td id="codsap"><%=codSAP%></td>
            <td></td>
            <td id="aperturaSucursal">
              <% if perfil = "1"  then
                sql4 = ""
                sql4 = sql4 & " select cast(hora_ingreso as DATETIME) as hora_ingreso "
                sql4 = sql4 & " from SUC_sucursal_apertura "
                sql4 = sql4 & " where id_sucursal = '"&idSucursal&"' "
                sql4 = sql4 & " and fecha_ingreso = cast(getdate() as DATE) "
                sql4 = sql4 & " and tipo = 1"
                set rs4 = db.execute(sql4)
                if rs4.eof then
                  sucursalCerrada = 0
                else
                  sucursalCerrada = 1
                end if
                if sucursalCerrada = 0 then%>
                  <span class="btn btn-success botonAbreSucursal oculto" data-idSucursal="<%=idSucursal%>" onClick="abreSucursal(<%=idSucursal%>);">
                       <i class="icon-signin"></i>   
                        <strong>
                          Abrir sucursal
                        </strong>
                      </span>
                      <div id="abreSucursal"></div>
                      <script type="text/javascript">
                        var fecha = new Date();
                        var horaActual = fecha.getHours();
                        var minutoActual = fecha.getMinutes();
                        var horaEnMinutos = horaActual * 60;
                        horaEnMinutos += minutoActual;
                        var horaInicioAbre = 895;
                        var minutosFaltantes = horaInicioAbre - horaEnMinutos;
                        var miliMinutosFaltantes = minutosFaltantes * 60000; //
                        if (miliMinutosFaltantes <= 0)
                        {
                          $('.botonAbreSucursal').removeClass('oculto');
                        }
                        else
                        {
                          setTimeout(function () { $('.botonAbreSucursal').removeClass('oculto'); }, 6000);
                        }
                        $('.botonAbreSucursal').click(function(){
                          idSucursal = $(this).attr('data-idSucursal')
                          pagina = 'sucursales/abreSucursal.asp';
                          div = 'abreSucursal';
                          datos = '';
                          try{
                            enviaDatos(pagina,div,datos);
                          }catch(err){}
                          $('#aperturaSucursal').html('<span class="badge badge-success"><i class="icon-check"></i>La apertura de sucursal fue correcta</span>');
                          setTimeout(function() {
                            try{
                              pagina = 'sucursales/miSucursal.asp';
                              div = 'miSucursal';
                              datos='';
                              enviaDatos(pagina,div,datos);
                              pagina = 'sucursales/panelSucursal.asp';
                              div = 'panelSucursal';
                              datos='';
                              try{
                                 enviaDatos(pagina,div,datos);
                              }catch(err){}
                              $('#divBotonCierraSucursal').removeClass('oculto');
                            }catch(err){}
                          }, 2500);
                        });
                        </script>
                     <%end if%>
                  </td>
                <%else%>
                 <td id="muestraEstadoSucursal" data-idSucursal="<%=idSucursal%>"></td>
                  <td id="estadoSucursal"></td>
                  <script type="text/javascript">
                    var idSucursal = $('#muestraEstadoSucursal').attr('data-idSucursal');
                    var pagina, div, datos;
                    pagina = 'sucursales/estadoActualMiSucursal.asp';
                    div = 'muestraEstadoSucursal';
                    datos='idSucursal='+idSucursal;
                    enviaDatos(pagina,div,datos);
                    pagina = 'sucursales/modificaEstadoSucursal.asp';
                    div = 'estadoSucursal';
                    enviaDatos(pagina,div,datos);
                  </script>
                <%end if
              end if%>
            </td>
         </tr>
      </table>
    </div>
  </div>
  <script type="text/javascript">
/*$(function(){
      var fecha = new Date();
      var horaActual = fecha.getHours();
      var minutoActual = fecha.getMinutes();
      var horaEnMinutos = horaActual * 60;
      horaEnMinutos += minutoActual;
      var horaInicioAbre = 330; // a las 5:30 son 330 min
      var minutosFaltantes = horaInicioAbre - horaEnMinutos;
      var miliMinutosFaltantes = minutosFaltantes * 60000; //   
      if (miliMinutosFaltantes <= 0)
      {
        $('.botonAbreSucursal').removeClass('oculto');
      }
      else
      {
        setTimeout(function () { $('.botonAbreSucursal').removeClass('oculto'); }, 6000);
      }

    }).on('click','#cancelaAnexo',function(){
        $('#modificaAnexo').slideUp('slow').empty();
        $('#muestraAnexo').slideDown('slow');
    }).on('click','#guardaAnexo',clickAnexo).on('keyup','#campoAnexo',function(){
      var valorNuevoAnexo = $('#campoAnexo').val();
      if(isNaN(valorNuevoAnexo)) {

        $('#textoModificaAnexo').addClass("text-error").html('Solo números');
        $('#guardaAnexo').addClass('disabled');
      }
      else
      {
        if (valorNuevoAnexo.length !== 4 )
        {
          $('#textoModificaAnexo').addClass("text-error").html('No puede ser mayor o menor a 4 dígitos');
          $('#guardaAnexo').addClass('disabled');
        }
        else
        {
          $('#textoModificaAnexo').removeClass("text-error").html('');
          $('#guardaAnexo').removeClass('disabled');
        }
        
      }
    }).on('click','#cancelaDireccion',function(){
        $('#modificaDireccion').slideUp('slow').empty();
        $('#muestraDireccion').slideDown('slow');
    }).on('click','#guardaDireccion',clickDireccion).on('keyup','#campoDireccion',function(){
      var valornuevaDireccion = $('#campoDireccion').val();
      if (valornuevaDireccion.length < 1)
      {
        $('#textoModificaDireccion').addClass("text-error").html('Debe ingresar direccion');
        $('#guardaDireccion').addClass('disabled');
      }
      else
      {
        $('#textoModificaDireccion').removeClass("text-error").html('');
        $('#guardaDireccion').removeClass('disabled');
      }
    }).on('click','#cancelaCelular',function(){
        $('#modificaCelular').slideUp('slow').empty();
        $('#muestraCelular').slideDown('slow');
    }).on('click','#guardaCelular',clickCelular).on('keyup','#campoCelular',function(){
      var valorNuevoCelular = $('#campoCelular').val();
      if(isNaN(valorNuevoCelular)) {

        $('#textoModificaCelular').addClass("text-error").html('Solo números');
        $('#guardaCelular').addClass('disabled');
      }
      else
      {
        if (valorNuevoCelular.length < 8 )
        {
          $('#textoModificaCelular').addClass("text-error").html('No puede ser mayor o menor a 9 dígitos');
          $('#guardaCelular').addClass('disabled');
        }
        else
        {
          $('#textoModificaCelular').removeClass("text-error").html('');
          $('#guardaCelular').removeClass('disabled');
        }
      }
    });

    function clickAnexo()
    {
      if (!$('#guardaAnexo').hasClass('disabled'))
      {
        var valorNuevoAnexo = $('#campoAnexo').val();
        var valorAnexo = $('td#anexoSucursal').attr('data-anexo');
        if (valorAnexo === valorNuevoAnexo)
        {
          $('#textoModificaAnexo').addClass("text-error").html('El anexo ingresado es igual al anexo antiguo');
          $('#guardaAnexo').addClass('disabled');
        }
        else
        {
          var pagina = 'sucursales/sqlModificaDatosSucursal.asp';
          var div = 'modificaAnexo';
          var datos = 'idSucursal=<%=idSucursal%>&tipo=1&valor='+valorNuevoAnexo;
          try{
            enviaDatos(pagina,div,datos);
          }catch(err){}
        }
      }
      return false;
    }
    function clickDireccion()
    {
      if (!$('#guardaDireccion').hasClass('disabled'))
      {
        var valornuevaDireccion = $('#campoDireccion').val();
        var valorDireccion = $('td#direccionSucursal').attr('data-direccion');
        if (valorDireccion === valornuevaDireccion)
        {
          $('#textoModificaDireccion').addClass("text-error").html('La dirección ingresada es igual a la dirección antigua');
          $('#guardaDireccion').addClass('disabled');
        }
        else
        {
          var pagina = 'sucursales/sqlModificaDatosSucursal.asp';
          var div = 'modificaDireccion';
          var datos = 'idSucursal=<%=idSucursal%>&tipo=2&valor='+valornuevaDireccion;
          try{
            enviaDatos(pagina,div,datos);
          }catch(err){}
        }
      }
      return false;
    }

    function clickCelular()
    {
      if (!$('#guardaCelular').hasClass('disabled'))
      {
        var valorNuevoCelular = $('#campoCelular').val();
        var valorCelular = $('td#celujarJeps').attr('data-celular');
        if (valorCelular === valorNuevoCelular)
        {
          $('#textoModificaCelular').addClass("text-error").html('El el número de celular ingresado es igual al antiguo');
          $('#guardaCelular').addClass('disabled');
        }
        else
        {
          var pagina = 'sucursales/sqlModificaDatosSucursal.asp';
          var div = 'modificaCelular';
          var datos = 'idSucursal=<%=idSucursal%>&tipo=3&valor='+valorNuevoCelular;
          try{
            enviaDatos(pagina,div,datos);
          }catch(err){}
        }
      }
      return false;
    }
 
    function abreSucursalZonal(idSucursal)
    {
      var pagina = 'sucursales/abreSucursal.asp';
      var div = 'abreSucursal';
      var datos = 'idSucursalZonal='+idSucursal;
      try{
        enviaDatos(pagina,div,datos);
      }
      catch(err){}
      
      $('#aperturaSucursal').html('<i class="icon-check"></i>La apertura de sucursal fue correcta');
      $('#trabajoZonal').fadeOut('fast');
      $('#trabajoZonal').removeClass('span8').addClass('span5').html('').fadeIn('fast');
      $('#estadoSucursalesZonal').removeClass('span2').addClass('span5');
      $('.listado').slideDown('slow');
      $('#sucursalSeleccionada').addClass('oculto').removeClass(' span12 label label-inverse');
      pagina = 'sucursales/estadoSucursal.asp';
      div = 'estadoSucursalesZonal';
      datos = '';
      try{
             enviaDatos(pagina,div,datos);
      }catch(err){}
      pagina = 'sucursales/sucursalesAbiertasZonal.asp';
      div='divSucursalesAbiertas';
      datos = 'idPerfil=2';
      try{
             enviaDatos(pagina,div,datos);
      }catch(err){}
      //$('#flash').slideDown('fast');
    }
    $('.descargaArchivo').click(function(e){
      e.preventDefault();
      var archivo = $(this).attr('data-descarga');
      window.open('auditoria/archivos/<%=idSucursal%>/'+archivo,'_blank');
    });
    var perfil = $('#perfilMain').val();
    if (perfil === '2')
    {
      var valorAnexo = $('td#anexoSucursal').attr('data-anexo');
     */
    
  </script>
<%end if
rs.Close
set rs.ActiveConnection = nothing
set rs=nothing
DB.Close
set DB=nothing%>