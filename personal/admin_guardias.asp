<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../funciones2.asp"-->
<%

'if Session("id_usuario")<>"" and Session("tipo")="admin" then
%>
<!DOCTYPE html>
<html lang="es">
<head>
	<meta charset="utf-8">
    <title>Sucursales</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=9">
    <!-- Le styles -->
    <link href="../css/bootstrap.css" rel="stylesheet" type="text/css">
    <link href="../css/bootstrap-responsive.css" rel="stylesheet" type="text/css">
    <link href="../css/estilo.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="../css/font-awesome.min.css" type="text/css">
    <link href="../css/bootstrap-datetimepicker.min.css" rel="stylesheet" type="text/css">
    <link href="../css/bootstrap-fileupload.min.css" rel="stylesheet" type="text/css">
    
    
    <!--[if IE 7]>
      <link rel="stylesheet" href="css/font-awesome-ie7.min.css">
    <![endif]-->

	<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
	<!--[if lt IE 9]>
    	<script src="../js/html5shiv.js"></script>
	<![endif]-->
	<!-- Fav and touch icons -->
  <link rel="apple-touch-icon-precomposed" sizes="144x144" href="../ico/apple-touch-icon-144-precomposed.png">
  <link rel="apple-touch-icon-precomposed" sizes="114x114" href="../ico/apple-touch-icon-114-precomposed.png">
  <link rel="apple-touch-icon-precomposed" sizes="72x72" href="../ico/apple-touch-icon-72-precomposed.png">
  <link rel="apple-touch-icon-precomposed" href="../ico/apple-touch-icon-57-precomposed.png">
  
  <script src="../js/jquery.js" type="text/javascript"></script>  
  <script type="text/javascript" src="../js/bootstrap-tooltip.js"></script>
  <script type="text/javascript" src="../js/bootstrap-modal.js"></script>
  <script type="text/javascript" src="../js/bootstrap-datetimepicker.min.js"></script>
  <script type="text/javascript" src="../js/bootstrap-datetimepicker.es-cl.js"></script>
  <script type="text/javascript">
  	function enviaDatos(pagina,div,datos)
	{
		var rand = '&v='+ Math.random() * 999
		var ajaxobject = $.ajax(
		{
			type:'GET',
			url:pagina,
			cache:false,
			//async:true,
			global:false,
			dataType:"html",
			data:datos+rand,
			timeout:10000,
			success:function(contenido)
			{
				$('#'+div).html(contenido);
			}
		});
		if(ajaxobject == undefined)
		alert('Problemas en la generacion del objeto');
		return false;
	}
  </script>
  <link rel="shortcut icon" href="../ico/favicon.png">
</head>
<% 
sql = ""
sql = sql & " select id_sucursal, cod_bantotal, suc_nombre from SUC_sucursal order by suc_nombre "
set rsTotalSucursales = db.execute(sql)
if not rsTotalSucursales.eof then
%>
<body topmargin="0">
	<div id="MarcoGeneral">    	
        <div id="Limite"></div>
       <div id="Central">
         <!--	<div id="Central_Columna_mensual">
            	<br />
            	<div class="row-fluid">                	
                    <div class="span1"></div><div class="span10 alert alert-info pagination pagination-centered"><h4>Personal Titular</h4></div>
                </div>
                <div class="row-fluid">
                	<div class="span1">&nbsp;</div>
                    <div class="span10">
                    	<span class="excelTitulares">Descargar listado actual de personal: <i class="icon-cloud-download icon-2x"></i><a href="admin_personal_excel_titulares.asp">&nbsp;</a></span>                     
                        <span class=""><a class="btn btn-warning excelTitulares" href="#"><i class="icon-cloud-download icon-large"></i>&nbsp;&nbsp;Personal Titular</a></span>                        
                        <span class=""><a class="btn btn-primary titulares_paso1"  href="#myModal" data-toggle="modal"><i class="icon-upload-alt icon-large"></i>&nbsp;&nbsp;Paso 1: subir listado titulares</a></span>
                        <span class=""><a class="btn btn-info titulares_paso2 oculto" href="#"><i class="icon-cogs icon-large"></i>&nbsp;&nbsp;Paso 2: cargar titulares</a></span>
                        <script type="text/javascript">
                            $('.excelTitulares').click(function(e){
                                $('.excelTitulares').attr({
									'download': 'admin_personal_excel_titulares.xls',
									'href': 'admin_personal_excel_titulares.asp',
									'target': '_blank'
								});														
                            });
                        </script>
                    </div>
                </div>
                <div class="row-fluid oculto" id="contResultTit" style="padding-top:25px">                
                	<div class="span2"></div>
                    <div class="span8">                    	
                    	 <div class="alert span11 oculto" id="resultTitulares"></div>                         
                    </div>
                </div>
                <br/>                                      
                
                <div class="row-fluid">
                	<div class="span1"></div>
                    <div class="span10 alert alert-info pagination pagination-centered"><h4>Personal Reemplazo</h4></div>
                </div>    
                <div class="row-fluid">
                	<div class="span1"></div>
                    <div class="span10">
                    	<span class=""><a class="btn btn-warning excelReemplazos" href="#"><i class="icon-cloud-download icon-large"></i>&nbsp;&nbsp;Personal Reemplazo</a></span>                        
                        <span class=""><a class="btn btn-primary reemplasos_paso1" href="#myModal2" data-toggle="modal"><i class="icon-upload-alt icon-large"></i>&nbsp;&nbsp;Paso 1: subir listado reemplazos</a></span>
                        <span class=""><a class="btn btn-info reemplasos_paso2 oculto" href="#"><i class="icon-cogs icon-large"></i>&nbsp;&nbsp;Paso 2: cargar reemplazos</a></span>
                        <script type="text/javascript">
                            $('.excelReemplazos').click(function(){
                                $('.excelReemplazos').attr({
									'download': 'admin_personal_excel_reemplazos.xls',
									'href': 'admin_personal_excel_reemplazos.asp',
									'target': '_blank'
								});
                            });							
                        </script>
                    </div>
                </div>-->
                <div class="row-fluid oculto" id="contResultReemp" style="padding-top:25px">                
                	<div class="span2"></div>
                    <div class="span8">                    	
                    	 <div class="alert span11 oculto" id="resultReemplazos"></div>                         
                    </div>
                </div>     
                <br/>
                <div class="row-fluid">
                	<div class="span1"></div>
                    <div class="span10 alert alert-info pagination pagination-centered"><h4>Descargas Asistencia de Guardias</h4></div>
                </div> 
                <div class="row-fluid">
                	<div class="span3"></div>
                    <div class="span8">
                        <span class="tool" rel="tooltip" title="Titulo Descarga">
                            <a class="btn btn-danger fechaRespald" data-fecha="" id="btnDescarga" data-estado="1" href="#atrasos" data-descarga="">
                                <i class="icon-cloud-download icon-large"></i>
                                &nbsp;&nbsp;Atrasos 
                            </a>
                        </span>
                        <% sql = "" 
                            sql = sql & " set dateformat dmy "
                            sql = sql & " select top 30 fecha_respaldo "
                            sql = sql & " from SUC_sucursal_guardias_asistencia_respaldo "
                            sql = sql & " group by fecha_respaldo "
                            sql = sql & " order by fecha_respaldo desc "
                            set rs = db.execute(sql)
                            if not rs.eof then
                                fecha_respaldo = rs.getrows()
                             end if%>
                        <span id="spanFechaResp" class="oculto">
                            <select id="fechaResp" name="fechaResp">
                                <option value="">[Seleccione Fecha]</option>
                                <option value="<%=date()%>" data-valor="0">Hoy</option>
                                <%for w = 0 to ubound(fecha_respaldo,2)
                                    fechaRespaldo = trim(fecha_respaldo(0,w))%>
                                    <option value="<%=fechaRespaldo%>" data-valor="1">
                                        <%=fechaRespaldo%>
                                    </option>
                                <%next%>
                            </select>
                        </span>    
                    	<!--<span class="tool" rel="tooltip" title="(Listado con los registros de asistencia de todo el personal.)"><a class="btn btn-warning excel1" href="#"><i class="icon-cloud-download icon-large"></i>&nbsp;&nbsp;Asistencia Personal</a></span>
                        <span class="tool" rel="tooltip" title="(Listado con los registros sólo de los cajeros y cajeros adicionales ausente.)"><a class="btn btn-warning excel2" href="#"><i class="icon-cloud-download icon-large"></i>&nbsp;&nbsp;Ausencia Personal</a></span>
                        <span class="tool" rel="tooltip" title="(Listado con los registros del personal de reemplazo.)"><a class="btn btn-warning excel3" href="#"><i class="icon-cloud-download icon-large"></i>&nbsp;&nbsp;Asistencia Reemplazos</a></span>
                        <span class="tool" rel="tooltip" title="(Listado con los registros de ausencia del personal de reemplazo.)"><a class="btn btn-warning excel4" href="#"><i class="icon-cloud-download icon-large"></i>&nbsp;&nbsp;Ausencia Reemplazos</a></span>-->
                    </div>
                     <script type="text/javascript">
                        $('.fechaRespald').click(function(){  
                            var descargaDatos = $(this).attr('data-descarga');
                            var valor = $('#fechaResp option:selected').attr('data-valor');
                            if (descargaDatos !== '1'){
                                $(this).html('<i class="icon-calendar icon-large"></i> Seleccione fecha');
                                $('#spanFechaResp').removeClass('oculto').slideDown('slow');
                            }else{
                                if(descargaDatos === '1'){
                                    if (valor === "0"){
                                         $(this).attr({
                                             'download': 'informeGuardias.xls',
                                             'href': 'informeGuardias.asp?tipoInforme=1',
                                             'target': '_blank'
                                        });
                                    }else{ 
                                        var valorFecha = $('.fechaRespald').attr('data-fecha');
                                        $(this).attr({
                                            'download': 'informeGuardias.xls',
                                            'href': 'informeGuardias.asp?tipoInforme=0&valorFecha='+valorFecha,
                                            'target': '_blank'
                                        });
                                    }
                                }
                            }     
                        });

                        $('#spanFechaResp').change(function(event){
                                var valorFecha = $('#spanFechaResp option:selected').val();
                                if (valorFecha !=='')
                                {                                   
                                    $('.fechaRespald').html('<i class="icon-cloud-download icon-large"></i> Descargar').attr('data-descarga', '1');
                                    $('.fechaRespald').attr('data-fecha', valorFecha);
                                }
                                else
                                {
                                     $('.fechaRespald').attr('data-descarga','0');
                                }
                            });

                        /*$('.excel1').click(function(){    
                            $('.excel1').attr({
                                //'download': 'informeGuardias.xls',
                                'href': 'informeGuardias.asp',
                                //'target': '_blank'
                            });                     
                        });*/

                        /*$('#btnDescarga').click(function(){
                            var visible;
                            visible = $('#btnDescarga').attr('data-estado');
                            if (visible == "1"){
                                $('#fechaResp').val('');
                                $(this).html('<i class="icon-calendar icon_large"></i> Fecha');
                                $('#spanFechaResp').removeClass('oculto').slideDown('fast');
                                $('#btnDescarga').attr('data-estado','0');
                            }else{
                                 $(this).html('<i class="icon-cloud-download icon-large"></i>  &nbsp;&nbsp;Atrasos ');
                                 $('#spanFechaResp').addClass('oculto').slideUp('fast');
                                 $('#btnDescarga').attr('data-estado','1');
                            }
                           
                        });
                         $('#fechaResp').change(function(event){
                            var valorFecha;
                            valorFecha = $('#fechaResp option:selected').val();
                             $(this).attr({
                            'download': 'admin_personal_excel_atrasos_'+valorFecha+'.xls',
                            'href': 'informeGuardias.asp?valorFecha='+valorFecha,
                            'target': '_blank'
                            });
                        });*/


					/*	$('.excel2').click(function(){	
							$('.excel2').attr({
								'download': 'admin_personal_excel_asistencia_titulares.xls',
								'href': 'admin_personal_excel_asistencia_titulares.asp',
								'target': '_blank'
							});							
						});
						$('.excel3').click(function(){		
							$('.excel3').attr({
								'download': 'admin_personal_excel_asistencia_reemplazos.xls',
								'href': 'admin_personal_excel_asistencia_reemplazos.asp',
								'target': '_blank'
							});											
						});
						$('.excel4').click(function(){
							$('.excel4').attr({
								'download': 'admin_personal_excel_asistencia_reemplazos_ausentes.xls',
								'href': 'admin_personal_excel_asistencia_reemplazos_ausentes.asp',
								'target': '_blank'
							});							
						});*/
                    </script>
                </div>    
                <br/><br/> 
                <div class="row-fluid">
                	<div class="span1"></div>
                    <div class="span10 alert alert-info pagination pagination-centered"><h4>Detalle Sucursal</h4></div>
                </div> 
                <div class="row-fluid">
                	<div class="span1">&nbsp;</div>
                    <div class="span10 well">
                    	<table width="90%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="18%" align="left" class="TextoNegro">Seleccione una sucursal:</td>
                                <td align="left" class="TextoNegro">
                                <select name="sucursales" id="sucursales">
                                    <option value="0">Seleccione</option>
									<%'Se muestran todas las sucursales
                                    rsTotalSucursales.movefirst
                                    do while not rsTotalSucursales.eof  %>
                                    <option data-codbt="<%=rsTotalSucursales("cod_bantotal")%>" value="<%=rsTotalSucursales("id_sucursal")%>"><%=rsTotalSucursales("suc_nombre")&" (BT"&rsTotalSucursales("cod_bantotal")&")"%></option>
                                    <%'Se avanza al siguiente registro    
                                    rsTotalSucursales.movenext  
                                    loop  
                                    'Se libera memoria 
                                    set rsTotalSucursales = nothing  
									
									%>
                                </select>                                
                                </td>
                            </tr>
                        </table>
                        <script type="text/javascript">
                        	$("#sucursales").change(function () {
								var div = 'lst_persuc_rem';
								var datos = '';
								var pagina = 'asistenciaSucursalGuardias.asp';								
								datos = 'idSucursal=' + $("#sucursales").val();
								enviaDatos(pagina,div,datos)								
								$('#forms_add').slideUp('slow');
								div = 'lst_persuc_head';
								pagina = '../sucursales/miSucursal_ver.asp';
								datos = 'idSucursal=' + $(this).val();
								enviaDatos(pagina,div,datos);
								
								$('#butons_add').show();
								$('#lst_persuc_head').show();
								$('#lst_persuc_rem').show();
							});
                        </script>
                    </div>                    
                </div>
                <div class="row-fluid">
                	<div class="row-fluid oculto" id="butons_add">
                        <div class="span1">&nbsp;</div>
                        <div class="span11">
                            <a class="btn btn-success addTitular"><i class="icon-plus-sign icon-large"></i>&nbsp;&nbsp;Titular</a>&nbsp;
                            <a class="btn btn-success addReemplazo"><i class="icon-plus-sign icon-large"></i>&nbsp;&nbsp;Reemplazo</a>
                        </div>
                    </div>                    
                    <div class="row-fluid oculto" id="forms_add">
                    	<br/>
                        <div class="span1">&nbsp;</div>
                        <div class="span10" id="forms_add2">
                            
                        </div>
                    </div>
                    <br/>
                    <div class="row-fluid">
                    	<div class="span1">&nbsp;</div>
                    	<div class="span10 hide" id="lst_persuc_head"></div>
                    </div>
                </div>
                <div class="row-fluid ">
                    <div class="span1">&nbsp;</div>
                    <div class="span10 hide" id="lst_persuc_rem">                    	
                        
                    </div>                    
                </div>   
                <br/>                
            </div>
        </div>
    </div>   
    <div id="excelImport" class="row-fluid oculto"></div>        
     
    <!-- Modal 1-->
    <div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 id="myModalLabel">Paso 1: Subir Listado de Titulares</h3>
      </div>
      <div class="modal-body">
         <iframe id="ifrmUpload" src="pruebaupload.asp" style="" width="99.6%" height="250" frameborder="0"></iframe>
      </div>
      <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true">Cerrar</button>
        <button class="btn btn-primary nextPaso2">Siguiente Paso</button>
      </div>
    </div>    
    <br/>
    
    <!-- Modal 2-->
    <div id="myModal2" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 id="myModalLabel">Paso 1: Subir Listado de Reemplazos</h3>
      </div>
      <div class="modal-body">
         <iframe id="ifrmUpload2" src="pruebaupload.asp" style="" width="99.6%" height="250" frameborder="0"></iframe>
      </div>
      <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true">Cerrar</button>
        <button class="btn btn-primary nextPaso2R">Siguiente Paso</button>
      </div>
    </div>    
<script type="text/javascript">
$(function () {
	
    $('.addTitular').on('click',function(){
    	var codBtt = $('option:selected','#sucursales').attr('data-codbt');   	
    	var idSucursal = $('#sucursales').val();
    	var $currentIFrame = $('#ifrmPIng'); 
    	
    	var div = 'forms_add2';
    	var pagina = 'guardia_ingreso.asp?tipoPersonal=1&idSucursal='+idSucursal+'&codBtt='+codBtt;	
    	enviaDatos(pagina,div,'');
    	$('#forms_add').removeClass('oculto').fadeIn('slow');	

    });
    	
    $('.addReemplazo').on('click',function(){    
    	var codBtt = $('option:selected','#sucursales').attr('data-codbt');   
    	var idSucursal = $('#sucursales').val();
    	var $currentIFrame = $('#ifrmPIng'); 
    	
    	var div = 'forms_add2';
    	var pagina = 'guardia_ingreso.asp?tipoPersonal=2&idSucursal='+idSucursal+'&codBtt='+codBtt;	
    	enviaDatos(pagina,div,'');
    	$('#forms_add').removeClass('oculto').fadeIn('slow');
    	
    });
	
	
	$('.tool').tooltip();
	
	$('.nextPaso2').click(function(){								
		var $currentIFrame = $('#ifrmUpload'); 
		var inputProcess = $currentIFrame.contents().find("body #statusProcess");		
		if(inputProcess.val() == '1'){			
			$('.titulares_paso1').removeClass('btn-primary').addClass('btn-success');
			$('#myModal').modal('hide');	
			$('.titulares_paso2').removeClass('oculto');
		}		
	});
	$('.titulares_paso2').click(function(){
		var div = '';
		var datos = '';
		var pagina = 'admin_guardias_procesar_titulares.asp';		
		$('.titulares_paso2').removeClass('btn-info').addClass('btn-danger');
		$('#contResultTit').addClass('oculto');	

		var loadData = $.ajax({
			url: pagina,
			data: "",
			type: "POST",
			dataType: "json",
			success: function(source){
				data = source;
				dispatchInfo();
			},
			error: function(dato){
				alert("ERROR");
			}
		});							
	
		var dispatchInfo = function(){
			renderData(data);
		}
		
		var renderData = function(objectJson){
			var html = '';
			var objIndex = '';
			
			var result = objectJson['datos']['result'];
			
			//Clean Msg
			$('#resultTitulares').html('');
			$('#contResultTit').removeClass('oculto');	
			
			if(result=='error'){
				$('#resultTitulares').removeClass('oculto').addClass('alert-error');	
				$('#resultTitulares').append('<h4>Error de Validacion</h4>');
			}else{			
				$('#resultTitulares').removeClass('alert-error');
				$('#resultTitulares').removeClass('oculto').addClass('alert-success');	
				$('#resultTitulares').append('<h4>Validacion Terminada con Exito</h4>');			
			}
			
			var msg = '';
			msg += '<ol>';
			$.each(objectJson['datos']['msg'], function(index, value) {						
				msg += '<li>' + value.m + '</li>';
			});		
			msg += '</ol>';
			$('#resultTitulares').append(msg);
			
			if(result=='exito'){
				setTimeout(function(){				
					$('#resultTitulares').html('');
					$('#resultTitulares').append('<h4><i class="icon-spinner icon-spin icon-large"></i> Procesando Carga</h4>');
					$('#resultTitulares').append('<ol><li>Ejecutando proceso de carga de asistencia.</li></ol>');
					var  executeCarga = $.ajax({
						url: 'admin_guardias_procesar_titulares_prc.asp',
						data: "",
						type: "GET",
						dataType: "text",
						cache:false,
						//async:true,
						timeout:120000,
						success: function(source){						
							$('#resultTitulares').html('');
							$('#resultTitulares').append('<h4>Ejecucion Ok</h4>');
							$('.titulares_paso2').removeClass('btn-danger').addClass('btn-success');
							setTimeout(function(){
								$('#resultTitulares').fadeOut('slow');
								$('.titulares_paso2').fadeOut('slow');
								$('.titulares_paso1').removeClass('btn-success').addClass('btn-primary')
								$('#ifrmUpload')[0].contentWindow.location.reload(true);
							}, 1800);
						},
						error: function(source){
							alert(source);
						}
					});
				},1500);	
			}
		}	
	
		});
	
		$('.nextPaso2R').click(function(){								
			var $currentIFrame = $('#ifrmUpload2'); 
			var inputProcess = $currentIFrame.contents().find("body #statusProcess");		
			if(inputProcess.val() == '1'){			
				$('.reemplasos_paso1').removeClass('btn-primary').addClass('btn-success');
				$('.reemplasos_paso2').removeClass('oculto');
				$('.reemplasos_paso2').show();
				$('#myModal2').modal('hide')	
			}		
		});	
		
		$('.reemplasos_paso2').click(function(){
			var div = '';
			var datos = '';		
			var pagina = 'admin_guardias_procesar_reemplazos.asp';
			$('.reemplasos_paso2').removeClass('btn-info').addClass('btn-danger');		
			
			var loadData = $.ajax({
				url: pagina,
				data: "",
				type: "POST",
				dataType: "json",
				success: function(source){
					data = source;
					dispatchInfo();
				},
				error: function(dato){
					alert("ERROR");
				}
			});		
			
			var dispatchInfo = function(){
				renderData(data);
			}

			var renderData = function(objectJson){
				var html = '';
				var objIndex = '';
				
				var result = objectJson['datos']['result'];
				
				//Clean Msg
				$('#resultReemplazos').html('');
				$('#contResultReemp').removeClass('oculto');	
				
				if(result=='error'){
					$('#resultReemplazos').removeClass('oculto').addClass('alert-error');	
					$('#resultReemplazos').show();
					$('#resultReemplazos').append('<h4>Error de Validacion</h4>');
				}else{			
					$('#resultReemplazos').removeClass('alert-error');
					$('#resultReemplazos').removeClass('oculto').addClass('alert-success');	
					$('#resultReemplazos').show();
					$('#resultReemplazos').append('<h4>Validacion Terminada con Exito</h4>');			
				}
				
				var msg = '';
				msg += '<ol>';
				$.each(objectJson['datos']['msg'], function(index, value) {						
					msg += '<li>' + value.m + '</li>';
				});		
				msg += '</ol>';
				$('#resultReemplazos').append(msg);
				
				if(result=='exito'){
					setTimeout(function(){				
						$('#resultReemplazos').html('');
						$('#resultReemplazos').append('<h4><i class="icon-spinner icon-spin icon-large"></i> Procesando Carga</h4>');
						$('#resultReemplazos').append('<ol><li>Ejecutando proceso de carga de asistencia.</li></ol>');
						var  executeCarga = $.ajax({
							url: 'admin_guardias_procesar_reemplazos_prc.asp',
							data: "",
							type: "GET",
							dataType: "text",
							cache:false,
							//async:true,
							timeout:120000,
							success: function(source){						
								$('#resultReemplazos').html('');
								$('#resultReemplazos').append('<h4>Ejecucion Ok</h4>');
								$('.reemplasos_paso2').removeClass('btn-danger').addClass('btn-success');
								setTimeout(function(){
									$('#resultReemplazos').fadeOut('slow');
									$('.reemplasos_paso2').fadeOut('slow');
									$('.reemplasos_paso2').removeClass('btn-success').addClass('btn-info');
									$('.reemplasos_paso1').removeClass('btn-success').addClass('btn-primary');
									$('#ifrmUpload2')[0].contentWindow.location.reload(true);
								}, 1800);
							},
							error: function(source){
								alert(source);
							}
						});
					},1500);	
				}
			}
				
		});	
  
});
</script>  
</body>
</html>
<%	
End If
'else 'Si no esxiste una sesión
'	Session("id_usuario") = ""
'	Session("nombre") = ""
'	Session("tipo") = ""
'	response.Redirect("login.asp")
'end if
%>