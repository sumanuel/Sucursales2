<!--#include file="../funciones2.asp"-->
<%action = trim(request("action"))
idUsuarioMain = trim(request("idUsuarioMain1"))
numNotario = trim(request("numNotario"))
idCarpeta = trim(request("idCarpeta"))
tipoInsDel = trim(request("tipoInsDel"))
idSucursalMain = trim(request("idSucursalMain1"))
idCodigoNotario = trim(request("idCodigoNotario"))
selectIdCodigoNotario = trim(request("selectIdCodigoNotario"))
idEstadoNotario = trim(request("idEstadoNotario"))
selectIdCodigoBarra = trim(request("selectIdCodigoBarra"))%>
<%
if action = "1" then
	if idUsuarioMain = "" then%>
		Usuario no valido para registrar
	<%else
		sql = ""
		sql = sql & " EXECUTE SCSS_prc_notario_ins_numero '"&numNotario&"','"&idUsuarioMain&"','"&idSucursalMain&"' "
		set rs = db.execute(sql)
		if not rs.eof then
	   		 codMsg = trim(rs(0))
	   		 msg = trim(rs(1))
	   	end if%>

		<div id="codMsgNotarioSuc" data-codMsg="<%=codMsg%>"></div>
		<div id="msgErrorAddNotario"></div>
		<span id="cargaAddNumNotario" class="oculto"><img src="../cdn/img/loader.gif"></span>

		<script type="text/javascript">
		$(function(){ 
		   var idMsgNotario = $('#codMsgNotarioSuc').attr('data-codMsg');
		   if (parseInt(idMsgNotario) === 1){  
		         $('#cargaAddNumNotario').fadeIn('fast');
		          setTimeout(function(){
		             $('#cargaAddNumNotario').fadeOut('fast');
		         }, 1000);
		          setTimeout(function() {
			         $('#msgErrorAddNotario').show();
			         $('#msgErrorAddNotario').html('<span id="msgErrorNotario" class="label label-success"><%=msg%></span>');
			         $('#txtCreaNumNotario').focus();
		            }, 2000);
		          setTimeout(function() {
			         $('#msgErrorAddNotario').fadeOut('fast');
			         $('#txtCreaNumNotario').val('');
			         $('#msgErrorNotario').html('');
		         	 muestraNumNotario();
		          }, 4500);
		   }else{
		        $('#msgErrorAddNotario').fadeIn('fast');
		        $('#msgErrorAddNotario').html('<span id="msgErrorNotario" class="label label-important"><%=msg%></span>');
		        $('#txtCreaNumNotario').focus();
		        setTimeout(function() {
		          $('#msgErrorAddNotario').fadeOut('fast');
		          $('#msgErrorNotario').html('');
		          $('#btnCreaNumNotario').show();
		        }, 2500);
		    }  
		});	
		</script>
	<%end if
end if%>

<%
if action = "2" then
	 sql = ""
	 sql = sql & " SELECT  MAX(codigo_notario) AS NumNotario, id_codigo_notario FROM SUC_notario_envio WHERE id_usuario = '"&idUsuarioMain&"' AND id_estado_notario = 0 AND id_sucursal = '"&idSucursalMain&"' GROUP BY id_codigo_notario "
	 set rs = db.execute(sql)
	 if not rs.eof then
	 	idNumNotario = trim(rs("NumNotario"))
	 	idCodigoNotario = trim(rs("id_codigo_notario"))
	 end if
	 Response.ContentType = "application/json"
		Response.Write "{"
		Response.Write "  ""datos"": " 
		Response.Write "{ "
		Response.Write " ""idNumNotario"": """&idNumNotario&""", "
		Response.Write " ""idCodigoNotario"": """&idCodigoNotario&""" "
		Response.Write "} }"
end if
%>

<%
if action = "3" then
	sql = ""
	sql =  sql & " EXEC SCSS_prc_notario_ins_del_credito_asoc_notario '"&idCarpeta&"','"&idUsuarioMain&"','"&idCodigoNotario&"','"&idSucursalMain&"','"&tipoInsDel&"' "
	'response.write (sql)
	'response.end
	set rs = db.execute(sql)
	if not rs.eof then
		codMsg = trim(rs(0))
   		msg = trim(rs(1))
   end if
%>
  <!--<span id="cargaMsgAddCred" class="oculto" class="span6"><img src="../cdn/img/loader.gif"></span>-->
  <div id="msgAddCredito" data-codMsgAddCred="<%=codMsg%>"></div>
  
  <script type="text/javascript">
    $(function(){ 
       var idMsgNotario = $('#msgAddCredito').attr('data-codMsgAddCred');
       if (parseInt(idMsgNotario) === 1){  
             $('#msgAddCredito').show();
             $('#msgAddCredito').html('<span id="msgErrorNotario" class="label label-success"><%=msg%></span>');
             setTimeout(function() {
                $('#msgAddCredito').fadeOut('fast');
              }, 2500);
       }else{
              $('#msgAddCredito').show();
              $('#msgAddCredito').html('<span id="msgErrorNotario" class="label label-important"><%=msg%></span>');
              setTimeout(function() {
                $('#msgAddCredito').fadeOut('fast');
          }, 2500);
       }  
      
    });	
  </script>
<%end if%>

<%
if action = "4" then
  sql = ""
  sql =  sql & " EXEC SCSS_prc_notario_actualiza_credito_enviado_notario '"&idUsuarioMain&"','"&idCodigoNotario&"','"&idSucursalMain&"' "
  'response.write (sql)
  'response.end
	set rs = db.execute(sql)
	if not rs.eof then
	    cod_Msg = trim(rs(0))
	    msg = trim(rs(1))
	end if
%>
  <div id="msgAddCreditoNotario" data-codMsgAddCreditoNotario="<%=cod_Msg%>"></div>
  <script type="text/javascript">
    $(function(){ 
        var idMsgAddCredNotario = $('#msgAddCreditoNotario').attr('data-codMsgAddCreditoNotario');
		if (parseInt(idMsgAddCredNotario) === 1){  
		   $('#msgAddCreditoNotario').show();
		   $('#msgAddCreditoNotario').html('<span id="msgEnviaCredNotario" class="label label-success"><%=msg%></span>');
		   setTimeout(function() {
		     	$('#msgAddCreditoNotario').fadeOut('fast');
				$('#reporteDetalleTabla').slideUp('fast');
				$('#menuTrabPens').slideUp('fast');
				$('#divMuestraCaja, #listarContenido').slideUp('fast');
		      	cargaIndicadores();
		    }, 2500);
		}else{
		    $('#msgAddCreditoNotario').show();
		    $('#msgAddCreditoNotario').html('<span id="msgEnviaCredNotario" class="label label-important"><%=msg%></span>');
		    setTimeout(function() {
		      $('#msgAddCreditoNotario').fadeOut('fast');
		    }, 2500);
		}  
    }); 
  </script>
<%end if %>

<%
if action = "5" then
  sql = ""
  sql =  sql & " EXEC SCSS_prc_notario_actualiza_credito_recep_notario_v2 '"&tipoInsDel&"','"&idCarpeta&"','"&idUsuarioMain&"','"&selectIdCodigoNotario&"','"&idSucursalMain&"','"&idEstadoNotario&"' "
  'response.write (sql)
  'response.end
	set rs = db.execute(sql)
	if not rs.eof then
	    codMsg = trim(rs(0))
	    msg = trim(rs(1))
	end if
%>
  <div id="msgAddRecepNotario" data-codMsgAddRecepNotario="<%=codMsg%>"></div>
  <script type="text/javascript">
    $(function(){ 
        var idMsgAddRecepCredNotario = $('#msgAddRecepNotario').attr('data-codMsgAddRecepNotario');
		if (parseInt(idMsgAddRecepCredNotario) === 1){  
		   $('#msgAddRecepNotario').show();
		   $('#msgAddRecepNotario').html('<span id="msgRecepCredNotario" class="label label-success"><%=msg%></span>');
		   setTimeout(function() {
		     	$('#msgAddRecepNotario').fadeOut('fast');
		    }, 2500);
		}else{
		    $('#msgAddRecepNotario').show();
		    $('#msgAddRecepNotario').html('<span id="msgRecepCredNotario" class="label label-important"><%=msg%></span>');
		    setTimeout(function() {
		      $('#msgAddRecepNotario').fadeOut('fast');
		    }, 2500);
		}  
    }); 
  </script>
<%end if %>

<%
if action = "6" then
    sql = ""
    sql =  sql & " EXEC SCSS_prc_asoc_credito_caja '"&idCarpeta&"','"&selectIdCodigoBarra&"','"&tipoInsDel&"' "
    'response.write (sql)
    'response.end
	set rs = db.execute(sql)
	if not rs.eof then
	    codMsg = trim(rs(0))
	    msg = trim(rs(1))
	end if
%>
	<div id="msgAddRecepNotario" data-codMsgAddRecepNotario="<%=codMsg%>"></div>
	<div id="idCarpetaCaja" data-idCarpetaCaja="<%=idCarpeta%>"></div>
 	<script type="text/javascript">
	    $(function(){ 
	        var idMsgAddRecepCredNotario = $('#msgAddRecepNotario').attr('data-codMsgAddRecepNotario');
	        var idCarpeta =  $('#idCarpetaCaja').attr('data-idCarpetaCaja');
	         var selectIdCodigoBarra;
			if (parseInt(idMsgAddRecepCredNotario) === 1){  
			   $('#msgAddRecepNotario').show();
			   $('#msgAddRecepNotario').html('<span id="msgRecepCredNotario" class="label label-success"><%=msg%></span>');
			   setTimeout(function() {
			     	$('#msgAddRecepNotario').fadeOut('fast');
			     	$('#'+idCarpeta+' > td:eq( 5 )').html(selectIdCodigoBarra);
			    }, 2500);
			}else{
			    $('#msgAddRecepNotario').show();
			    $('#msgAddRecepNotario').html('<span id="msgRecepCredNotario" class="label label-important"><%=msg%></span>');
			    setTimeout(function() {
			      $('#msgAddRecepNotario').fadeOut('fast');
			      $('#'+idCarpeta+' > td:eq( 5 )').html('0');
			    }, 2500);
			}  
	    }); 
    </script>
<%end if %>

<%
if action = "7" then
  sql = ""
  sql =  sql & " EXEC SCSS_prc_notario_actualiza_EnNotario_NoRecep_x_carpeta '"&tipoInsDel&"','"&idCarpeta&"','"&idUsuarioMain&"','"&selectIdCodigoNotario&"','"&idSucursalMain&"','"&idEstadoNotario&"' "
  'response.write (sql)
  'response.end
	set rs = db.execute(sql)
	if not rs.eof then
	    codMsg = trim(rs(0))
	    msg = trim(rs(1))
	end if
%>
  <div id="msgAddNoRecepNotario" data-codMsgAddRecepNotario="<%=codMsg%>"></div>
  <script type="text/javascript">
    $(function(){ 
        var idMsgAddNoRecepCredNotario = $('#msgAddNoRecepNotario').attr('data-codMsgAddRecepNotario');
		if (parseInt(idMsgAddNoRecepCredNotario) === 1){  
		   $('#msgAddNoRecepNotario').show();
		   $('#msgAddNoRecepNotario').html('<span id="msgRecepCredNotario" class="label label-warning"><%=msg%></span>');
		   setTimeout(function() {
		     	$('#msgAddNoRecepNotario').fadeOut('fast');
		    }, 2500);
		}else{
		    $('#msgAddNoRecepNotario').show();
		    $('#msgAddNoRecepNotario').html('<span id="msgRecepCredNotario" class="label label-important"><%=msg%></span>');
		    setTimeout(function() {
		      $('#msgAddNoRecepNotario').fadeOut('fast');
		    }, 2500);
		}  
    }); 
  </script>
<%end if %>

<%
if action = "8" then
  sql = ""
  sql =  sql & " EXEC SCSS_prc_notario_actualiza_NoRecep_EnNotario_x_carpeta '"&tipoInsDel&"','"&idCarpeta&"','"&idUsuarioMain&"','"&selectIdCodigoNotario&"','"&idSucursalMain&"','"&idEstadoNotario&"' "
  'response.write (sql)
  'response.end
	set rs = db.execute(sql)
	if not rs.eof then
	    codMsg = trim(rs(0))
	    msg = trim(rs(1))
	end if
%>
  <div id="msgAddNoRecepEnNotario" data-codMsgAddNoRecepEnNotario="<%=codMsg%>"></div>
  <script type="text/javascript">
    $(function(){ 
        var idMsgAddNoRecepEnNotario = $('#msgAddNoRecepEnNotario').attr('data-codMsgAddNoRecepEnNotario');
		if (parseInt(idMsgAddNoRecepEnNotario) === 1){  
		   $('#msgAddNoRecepEnNotario').show();
		   $('#msgAddNoRecepEnNotario').html('<span id="msgRecepCredNotario" class="label label-warning"><%=msg%></span>');
		   setTimeout(function() {
		     	$('#msgAddNoRecepEnNotario').fadeOut('fast');
		    }, 2500);
		}else{
		    $('#msgAddNoRecepEnNotario').show();
		    $('#msgAddNoRecepEnNotario').html('<span id="msgRecepCredNotario" class="label label-important"><%=msg%></span>');
		    setTimeout(function() {
		      $('#msgAddNoRecepEnNotario').fadeOut('fast');
		    }, 2500);
		}  
    }); 
  </script>
<%end if %>