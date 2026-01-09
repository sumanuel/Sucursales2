<!--#include file="../funciones2.asp"-->
<%idCodigoNotario = trim(request("idCodigoNotario"))
idEstadoNotario = trim(request("idEstadoNotario"))
idUsuarioMain = trim(request("idUsuarioMainEnvio"))
idSucursalMain = trim(request("idSucursalEnvio")) 
action = trim(request("action"))
%>

<%
if action = "1" then
  sql = " "
  sql =  sql & " EXEC SCSS_prc_notario_actualiza_credito_noRecep_notario '"&idUsuarioMain&"','"&idCodigoNotario&"','"&idSucursalMain&"' "
  'response.write(sql)
  'response.end
	set rs = db.execute(sql)
	if not rs.eof then
	    COD_MSG = trim(rs(0))
	    MSG = trim(rs(1))
	end if
%>
 <div id="msgAllNoRecep" data-codMsgAllNoRecep="<%=COD_MSG%>"></div>	
  	<script type="text/javascript">
        $(function(){ 
	        var idMsgNotario = $('#msgAllNoRecep').attr('data-codMsgAllNoRecep');
	        //console.log(idMsgNotario);
	        if (parseInt(idMsgNotario) === 1){  
	            $('#msgAllNoRecep').show();
	            $('#msgAllNoRecep').html('<span id="msgUpdAllRecep" class="label label-success"><%=MSG%></span>');
	            setTimeout(function() {
	              	$('#msgAllNoRecep').fadeOut('fast');
	              	$('#menuTrabPens').slideUp('fast');
					$('#divMuestraCaja, #listarContenido').slideUp('fast');
	              	cargaIndicadores();
	            }, 2500);
	        }else{
	            $('#msgAllNoRecep').show();
	            $('#msgAllNoRecep').html('<span id="msgUpdAllRecep" class="label label-important"><%=MSG%></span>');
	            setTimeout(function() {
	               $('#msgAllNoRecep').fadeOut('fast');
	            }, 2500);
	        }  
    	});	
  </script>
<%end if%>

<%
if action = "2" then
	sql = " "
    sql =  sql & " EXEC SCSS_prc_notario_upd_all_estadoRecep '"&idUsuarioMain&"','"&idCodigoNotario&"','"&idSucursalMain&"','"&idEstadoNotario&"' "
    'response.write(sql)
    'response.end
	set rs = db.execute(sql)
	if not rs.eof then
	    codMsg = trim(rs(0))
	    msgRecep = trim(rs(1))
	end if
%>

 <div id="msgAllRecep" data-codMsgAllRecep="<%=codMsg%>"></div>
    <script type="text/javascript">
	  	$(function(){ 
	  	 	var idMsgNotario = $('#msgAllRecep').attr('data-codMsgAllRecep');
	  	 	//console.log(idMsgNotario);
	   		if (parseInt(idMsgNotario) === 1){  
	         	$('#msgAllRecep').show();
	            $('#msgAllRecep').html('<span id="msgUpdAllRecep" class="label label-success"><%=msgRecep%></span>');
	         	setTimeout(function() {
	            	$('#msgAllRecep').fadeOut('fast');
	            	$('#menuTrabPens').slideUp('fast');
					$('#divMuestraCaja, #listarContenido').slideUp('fast');
	            	cargaIndicadores();
	            }, 2500);
	  		}else{
	          	$('#msgAllRecep').show();
	          	$('#msgAllRecep').html('<span id="msgUpdAllRecep" class="label label-important"><%=msgRecep%></span>');
	          	setTimeout(function() {
	            	$('#msgAllRecep').fadeOut('fast');
	      		}, 2500);
	   		}  
	    });	
  </script>
<%end if%>
