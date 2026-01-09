<!--#include file="../funciones.asp"-->
<%perfil = trim(request("perfil"))
idSucursal = trim(request("idSucursal"))
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
    end if
    rs2.Close
    set rs2.ActiveConnection = nothing
    set rs2=nothing%>    
    <div class="row-fluid">
      <div class="span12">
        <table class="table table-bordered table-hover">
          <tr>
            <td>Sucursal:</td>
            <td id="nombreSucursal"><%=nombreSucursal%> (<%=suc_tipo%>)</td>
            <td>Dirección</td>
            <td id="direccionSucursal"><%=direccionSucursal%></td>
            <td>Jeps</td>
            <td id="nombreJeps"><span class="label label-info"><%=nombreJeps%></span></td>
          </tr>
          <tr>
            <td>Anexo</td>
            <td id="anexoSucursal"><%=anexoSucursal%></td>
            <td>Celular</td>
            <td id="celujarJeps"><%=celujarJeps%></td>
            <td>Encargado Zonal</td>
            <td id="nombreEncargadoZonal"><span class="label label-info"><%=nombreEncargadoZonal_Ext%></span></td>
          </tr>
          <tr>
            <td>Cod BTT</td>
            <td id="codbtt"><%=codBTT%></td>
            <td>Cod SAP</td>
            <td id="codsap"><%=codSAP%></td>
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
                        var horaInicioAbre = 330;
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
                      </script>
                    <%end if
                  end if%>
                </td>
              <%else
                sql3 = ""
                sql3 = sql3 & " select situacion "
                sql3 = sql3 & " from SUC_desbordes a "
                sql3 = sql3 & " where fecha = cast(getdate() as DATE) "
                sql3 = sql3 & " and hora = (select max(b.hora) "
                sql3 = sql3 & " from SUC_desbordes b "
                sql3 = sql3 & " where b.fecha=CAST(GETDATE() as date) "
                sql3 = sql3 & " and a.id_sucursal = b.id_sucursal) "
                sql3 = sql3 & " and id_sucursal = '"&idSucursal&"' "
                set rs3 = db.execute(sql3)
                if not rs3.eof then
                  txtEstado = server.htmlencode(trim(rs3("situacion")))
                  tieneEstado = 1
                else
                  tieneEstado = 0
                end if
                rs3.Close
                set rs3.ActiveConnection = nothing
                set rs3=nothing%>
                <td id="muestraEstadoSucursal">
                  <%if tieneEstado = 0 then
                    response.write("Estado Sucursal: ")
                  else
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
                    <span class="label <%=claseEstado%>" id="claseEstado">
                      Último estado: <%=txtEstado%>
                  </span>
                  <%end if%>
                </td>
                <td id="estadoSucursal">
                  <%sql4 = ""
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
                    'hEfectiva = hour(trim(rs4("hora_ingreso")))
                    'mEfectiva = minute(trim(rs4("hora_ingreso")))
                    'horaCierre = hEfectiva&":"&mEfectiva
					'horaCierre = hEfectiva&":"&mEfectiva
					horaCierre = trim(rs4("hora_ingreso"))
                  end if
                  rs4.Close
                  set rs4.ActiveConnection = nothing
                  set rs4=nothing
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
                  <!--<div class="oculto" id="cierraSucursal"></div>-->
                    
                  <!--</div>-->
                  <!--<div class="btn btn-danger botonCierraSucursal oculto">
                    <i class="icon-signout"></i>
                    <strong>
                      Cerrar Sucursal
                    </strong>
                  </div>-->
                  <script type="text/javascript">
                    
                    //setTimeout(cierra(),miliMinutosFaltantes);
                  </script>
                  <%else%>
                    La sucursal fue cerrada a las <%=horaCierre%>
                  <%end if%>
                </td>
              <%end if
            'end if%>
          </tr>
        </table>
      </div>
    </div>
    <div class="row-fluid oculto" id="cierreSucursal">
    	<div class="span12 alert alert-error"><i class="icon-signout icon-large"></i>&nbsp;<strong>Se ha cerrado la sucursal exitosamente</strong></div>
    </div>
  <script type="text/javascript" src="js/bootstrap-tooltip.js"></script>
  <script type="text/javascript">
  $(function(){
    $('.tool').tooltip();
  });
  function abre()
  {
    $('.botonAbreSucursal').removeClass('oculto');
  }
  //$(function () {
//    var fecha = new Date();
//    var horaActual = fecha.getHours();
//    var minutoActual = fecha.getMinutes();
//    var horaEnMinutos = horaActual * 60;
//    horaEnMinutos += minutoActual;
//    var horaInicioCierre = 1035;
//    var minutosFaltantes = horaInicioCierre - horaEnMinutos;
//    var miliMinutosFaltantes = minutosFaltantes * 60000;
//    $('.tool').tooltip();
//    setTimeout(function() {
//      $(".botonCierraSucursal").removeClass("oculto");
//    }, miliMinutosFaltantes);
//  })

$('.botonAbreSucursal').click(function(){
  idSucursal = $(this).attr('data-idSucursal')
  pagina = 'sucursales/abreSucursal.asp';
  div = 'abreSucursal';
  datos = 'idSucursal='+idSucursal;
  try{
         enviaDatos(pagina,div,datos);
  }catch(err){}
  $('#aperturaSucursal').html('<i class="icon-check"></i>La apertura de sucursal fue correcta');
  
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
$('.muestraRanking').click(function(){
  var textoEstado = $(this).attr('rel');
  var nuevaClase
  if (textoEstado == 'Nadie')
  {
    nuevaClase = 'label';
  }
  if (textoEstado == '1/4')
  {
    nuevaClase = 'label label-success';
  }
  if (textoEstado == '1/2')
  {
    nuevaClase = 'label label-success';
  }
  if (textoEstado == '3/4')
  {
    nuevaClase = 'label label-success';
  }
  if (textoEstado == 'Full')
  {
    nuevaClase = 'label label-warning';
  }
  if (textoEstado == 'Desborde')
  {
    nuevaClase = 'label label-important';
  }
  var pagina,div,datos
  $('#muestraEstadoSucursal').html('<span id="claseEstado">Último estado: '+textoEstado+'</span>');
  $("#claseEstado").removeClass().addClass(nuevaClase);
  pagina = 'sucursales/sqlEstado.asp';
  div = 'cambiaEstado';
  datos = 'valor='+textoEstado;
  try{
         enviaDatos(pagina,div,datos);
  }catch(err){}
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
            <td id="direccionSucursal"><%=direccionSucursal%></td>
            <td>Jeps</td>
            <td id="nombreJeps"><span class="label label-info"><%=nombreJeps%></span></td>
          </tr>
          <tr>
            <td>Anexo</td>
            <td id="anexoSucursal"><%=anexoSucursal%></td>
            <td>Celular</td>
            <td id="celujarJeps"><%=celujarJeps%></td>
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
                  <span class="btn btn-success botonAbreSucursal oculto" data-idSucursal=<%=idSucursal%>>
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
    })
    $('.botonAbreSucursal').click(function(){
      idSucursal = $(this).attr('data-idSucursal')
      pagina = 'sucursales/abreSucursal.asp';
      div = 'abreSucursal';
      datos = 'idSucursal='+idSucursal;
      enviaDatos(pagina,div,datos);
      $('#aperturaSucursal').html('<i class="icon-check"></i>La apertura de sucursal fue correcta');
      $('#areaZonal').slideUp('fast');
      $('#trabajoZonal').removeClass('span8').addClass('span5');
      $('#estadoSucursalesZonal').removeClass('span2').addClass('span5');
      $('.listado').slideDown('slow');
      $('#sucursalSeleccionada').addClass('oculto').removeClass(' span12 label label-inverse');
      pagina = 'sucursales/estadoSucursal.asp';
      div = 'estadoSucursalesZonal';
      datos = ''
      try{
             enviaDatos(pagina,div,datos);
      }catch(err){}
      try{
             enviaDatos(pagina,div,datos);
      }catch(err){}
      pagina = 'sucursales/sucursalesAbiertasZonal.asp';
      div='divSucursalesAbiertas';
      datos = 'idPerfil=2'
      try{
             enviaDatos(pagina,div,datos);
      }catch(err){}
      $('#flash').slideDown('fast');
    });
    $('.descargaArchivo').click(function(e){
      e.preventDefault();
      var archivo = $(this).attr('data-descarga');
      window.open('auditoria/archivos/<%=idSucursal%>/'+archivo,'_blank');
    });
  </script>
<%end if
rs.Close
set rs.ActiveConnection = nothing
set rs=nothing
DB.Close
set DB=nothing%>