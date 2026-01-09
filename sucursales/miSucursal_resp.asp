<!--#include file="../funciones.asp"-->
<%
perfil = trim(request("perfilMain"))
idSucursal = trim(request("idSucursalMain"))
idUsuario = trim(request("idUsuarioMain"))
if idSucursal = "0" then
  idSucursal = trim(request("idSucursal"))
end if
if perfil = "1" then
  sql = ""
  sql = sql & " select suc_nombre, suc_direccion, suc_tipo, "
  sql = sql & " suc_jeps, suc_jeps_enexo, "
  sql = sql & " suc_jeps_celular, suc_zonal, suc_zonal_ext, "
  sql = sql & " cod_sap, cod_bantotal "
  sql = sql & " from SUC_sucursal "
  sql = sql & " where id_sucursal = '"&idSucursal&"'"
  'response.write(sql)
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
            <td>
              Sucursal:
            </td>
            <td id="nombreSucursal">
              <%=nombreSucursal%> (<%=suc_tipo%>)
            </td>
            <td>
              Dirección
            </td>
            <td id="direccionSucursal">
              <%=direccionSucursal%>
            </td>
            <td>
              Jeps
            </td>
            <td id="nombreJeps">
              <span class="label label-info">
                <%=nombreJeps%>
              </span>
            </td>
          </tr>
          <tr>
            <td>
              Anexo
            </td>
            <td id="anexoSucursal">
              <%=anexoSucursal%>
            </td>
            <td>
              Celular
            </td>
            <td id="celujarJeps">
              <%=celujarJeps%>
            </td>
            <td>
              Encargado Zonal
            </td>
            <td id="nombreEncargadoZonal">
              <span class="label label-info">
                <%=nombreEncargadoZonal_Ext%>
              </span>
            </td>
          </tr>
          <tr>
            <td>
              Cod BTT
            </td>
            <td id="codbtt">
              <%=codBTT%>
            </td>
            <td>
              Cod SAP
            </td>
            <td id="codsap">
              <%=codSAP%>
            </td>
            <%if sucursalAbierta = 0 then%>
              <td colspan="2" id="aperturaSucursal">
                <%if perfil = "1"  then
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
  end if
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
      claseEvaluacion = "alert alert-success"
    else
      claseEvaluacion = "alert alert-error"
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
  end if%>
  <div class="row-fluid">
    <div class="span12">
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
            <td>
              <span class="<%=claseEvaluacion%>">
                Auditoria
              </span>
            </td>
            <td id="auditoria">
              <%if tieneDatos = "0" then
                response.write(archivo)
              else
                response.write(fechaAuditoria)%>
              <span class="icon-stack icon-large mano descargaArchivo" data-descarga="<%=archivo%>">
                <i class="icon-check-empty icon-stack-base"></i>
                <i class="icon-download-alt"></i>
              </span>
              <%end if%>
              </td>
            <td></td>
            <td id="aperturaSucursal">
              <% if perfil = "2"  then
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
                  <span class="btn btn-success botonAbreSucursal oculto" data-idSucursal="<%=idSucursal%>" onClick="abreSucursalZonal(<%=idSucursal%>);">
                       <i class="icon-signin"></i>   
                        <strong>
                          Abrir sucursal
                        </strong>
                      </span>
                      <div id="abreSucursal"></div>
                      <script type="text/javascript">
                        
                      </script>
                    <%end if
                  end if%>
              </td>
          </tr>
      </table>
    </div>
  </div>
  <script type="text/javascript">
$(function(){
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
      /*Anexo*/
      var valorAnexo = $('td#anexoSucursal').attr('data-anexo');
      
      $("#muestraAnexo").on({
        dblclick: function() {
          $('#muestraAnexo').slideUp('slow');
          $('#modificaAnexo').html('<div class="input-prepend"><span class="add-on"><i class="icon-phone"></i></span><input class="span4" id="campoAnexo" type="text" placeholder="Anexo" name="campoAnexo" value="'+valorAnexo+'"></div><br><span id="textoModificaAnexo"></span><span id="guardaAnexo" class="btn btn-mini btn-success">Guardar</span><span id="cancelaAnexo" class="btn btn-mini btn-danger">Cancelar</span>').addClass('campoIngresado').slideDown('slow');
        }, mouseenter: function() {
          if (!$(this).hasClass("campoIngresado"))
          {
            $(this).html(valorAnexo+'   <i class="icon-edit"></i>');
          }
        }, mouseleave: function() {
          if (!$(this).hasClass("campoIngresado"))
          {
            $(this).html(valorAnexo);  
          }
        }
      });
      /*direccion*/
      var valorDireccion = $('td#direccionSucursal').attr('data-direccion');
      $("#muestraDireccion").on({
        dblclick: function() {
          $('#muestraDireccion').slideUp('slow');
          $('#modificaDireccion').html('<div class="input-prepend"><span class="add-on"><i class="icon-home"></i></span><input class="span12" id="campoDireccion" type="text" placeholder="Direccion" name="campoDireccion" value="'+valorDireccion+'"></div><br><span id="textoModificaDireccion"></span><span id="guardaDireccion" class="btn btn-mini btn-success">Guardar</span><span id="cancelaDireccion" class="btn btn-mini btn-danger">Cancelar</span>').addClass('campoIngresado').slideDown('slow');
        }, mouseenter: function() {
          if (!$(this).hasClass("campoIngresado"))
          {
            $(this).html(valorDireccion+'   <i class="icon-edit"></i>');
          }
        }, mouseleave: function() {
          if (!$(this).hasClass("campoIngresado"))
          {
            $(this).html(valorDireccion);  
          }
        }
      });

      /*Celular*/
      var valorCelular = $('td#celujarJeps').attr('data-celular');
      $("#muestraCelular").on({
        dblclick: function() {
          $('#muestraCelular').slideUp('slow');
          $('#modificaCelular').html('<div class="input-prepend"><span class="add-on"><i class="icon-mobile-phone"></i></span><input class="span12" id="campoCelular" type="text" placeholder="Celular" name="campoCelular" value="'+valorCelular+'"></div><br><span id="textoModificaCelular"></span><span id="guardaCelular" class="btn btn-mini btn-success">Guardar</span><span id="cancelaCelular" class="btn btn-mini btn-danger">Cancelar</span>').addClass('campoIngresado').slideDown('slow');
        }, mouseenter: function() {
          if (!$(this).hasClass("campoIngresado"))
          {
            $(this).html(valorCelular+'   <i class="icon-edit"></i>');
          }
        }, mouseleave: function() {
          if (!$(this).hasClass("campoIngresado"))
          {
            $(this).html(valorCelular);  
          }
        }
      });
    }
  </script>
<%end if
rs.Close
set rs.ActiveConnection = nothing
set rs=nothing
DB.Close
set DB=nothing%>