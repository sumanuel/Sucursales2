<!--#include file="../funciones2.asp"-->
<%
idProducto = trim(request("idProducto"))
idItem = trim(request("idItem"))
periodo = trim(request("periodo"))
idSucursalMain = trim(request("idSucursalMain1"))
idUsuarioMain = trim(request("idUsuarioMain1"))
perfilMain = trim(request("perfilMain1"))

if (idProducto="1") then
	producto = "Suc"
	if (idItem="1") then
		itemProducto = "Colocaciones"
	elseif(idItem="2") then
		itemProducto ="En validación"
	elseif(idItem="3") then
		itemProducto = "Validado"
	elseif(idItem="4") then
		itemProducto = "En Notario"
	elseif(idItem="5")then
		itemProducto = "Recep Notario"
	elseif(idItem="6")then
		itemProducto = "No Recep Notario"
	elseif(idItem="7") then
		itemProducto ="Enviadas"
	end if
elseif(idProducto="2")then
	producto = "DMS"
	if (idItem="1") then
		itemProducto ="En Validación"
	elseif(idItem="2") then
		itemProducto ="Validado"
	elseif(idItem="3") then
		itemProducto = "Alertas"
	end if
else
	producto = "Pendientes"
	if (idItem="1") then
		itemProducto="Recepcionado"
	elseif(idItem="2") then
		itemProducto ="No Ingresado"
	end if
end if

formato = ""
formato = producto+" - "+itemProducto
%>
<%
if idItem = "4" then
	sql = ""
	sql = sql & " EXEC SCSS_prc_notario_dropDows_num_notario '1','"&idSucursalMain&"'"
	'response.write (sql)
	'response.end
	tieneDatos = 0
	set rs = db.execute(sql)
	if not rs.eof then
	  datos = rs.getrows()
	  tieneDatos = 1
	end if
	else if idItem = "6" then
		sql = ""
		sql = sql & " EXEC SCSS_prc_notario_dropDows_num_notario '2','"&idSucursalMain&"' "
		'response.write (sql)
		'response.end
		tieneDatos = 0
		set rs = db.execute(sql)
		if not rs.eof then
	 		datos = rs.getrows()
	 	 	tieneDatos = 1
		end if
	 end if
end if

if idItem = "5" then
	sql = ""
	sql = sql & " EXEC SCSS_prc_notario_dropDows_cajas '"&idSucursalMain&"'"
	'response.write (sql)
	'response.end
	tieneDatos = 0
	set rs = db.execute(sql)
	if not rs.eof then
	  datos = rs.getrows()
	  tieneDatos = 1
	end if
end if
%>
<ul class="nav nav-tabs" id="menuDetalleIntPrincipal" data-idProducto="<%=idProducto%>" data-idItem="<%=idItem%>" data-periodo="<%=periodo%>" data-usuario="<%=idUsuarioMain%>" data-sucursal="<%=idSucursalMain%>" data-perfil="<%=perfilMain%>" data-selectIdCodigoNotario="<%=selectIdCodigoNotario%>">

	<li id="<%=idProducto%><%=idItem%>" class="active">
		<a href="#">
		 	<%=formato%>
		</a>
	</li>
	<div class="span10" id="btnAgregaNumNotario">
		<div id="bloqueCreaNumNotario" class="span10">
			<div class="span1">
				<span class="btn btn-primary" id="btnCreaNumNotario" data-toggle="tooltip" title="Registra Envio Notario">
					<i id="iconBtnCreaNumNotario" class="icon-save icon-large"></i>
				</span>
				<span class="btn btn-success" id="btnEnviaNotario" data-toggle="tooltip" title="Confirma Q Carpetas a Envio Notario">
					<i id="iconBtnEnviaNotario" class="icon-ok icon-large"></i>
				</span>
			</div>
			<div class="span3">
				<div class="row-fluid">
					<%if idItem = "4" or idItem = "6" then%>
						<div id="divSelectNumNotario" class="span4">
							<select id="selectNumNotario" name="selectNumNotario">
								<option value="0">Envío Notario</option>
								<%if tieneDatos = 1 then
									for i = 0 to ubound(datos,2)
										selectIdCodigoNotario = datos(0,i)
										selectNumNotario= trim(datos(1,i))%>
										<option value="<%=selectIdCodigoNotario%>"><%=selectNumNotario%></option>
									<%next%>
								<%end if%>
							</select>
						</div>
						<%else if idItem = "5" and idProducto = "1" then %>
							<div id="divSelectCaja" class="span4">
								<select id="selectCaja" name="selectCaja">
									<option value="0">Seleccione Caja</option>
									<%if tieneDatos = 1 then
										for i = 0 to ubound(datos,2)
											selectIdCaja = datos(0,i)
											periodoCaja= trim(datos(1,i))%>
											<option value="<%=selectIdCaja%>"><%=periodoCaja%></option>
										<%next%>
									<%end if%>
								</select>
							</div>
						<%end if%>
					<%end if%>
				</div>
				<input type="text" id="txtCreaNumNotario" placeholder="Envío Notario" maxlength="30">
				<span id="checkOk" class="oculto"><i class="icon-ok"></i></span>
				<span id="idSpanNumNotario" class="label label-success" data-toggle="tooltip" title="Envio Notario"></span>
			</div>
			<div class="span1">
				<span class="btn btn-info" id="btnDownLoadIndicador" data-toggle="tooltip" title="Descarga Informe Crédito">
					<i id="iconDownLoad" class="icon-download-alt icon-large"></i>
				</span>
			</div>
			<div id="bloqueMsgSpanNumNotario" class="span4">
				<div id="msgAddInsCred"></div>
				<div id="msgErrorNotario"></div>
				<div id="msgEnviaCredNotario"></div>
				<div id="msgRecepCredNotario"></div>
				<div id="divIdCodigoNotario" class="oculto"></div>
			</div>
		</div>
	</div>
</ul>
<script type="text/javascript">
	$(function(){
		$('#btnEnviaNotario').hide();
		$('#divSelectCaja').hide();
		$('#divSelectNumNotario').hide();
		muestraNumNotario();
	});

	$('#btnCreaNumNotario').click(function(){
		var pagina, div, datos, numNotario, idUsuarioMain, perfilMain, idSucursalMain
		numNotario = $('#txtCreaNumNotario').val();
		idUsuarioMain = $('#menuDetalleIntPrincipal').attr('data-usuario');
		perfilMain = $('#menuDetalleIntPrincipal').attr('data-perfil');
		idSucursalMain = $('#menuDetalleIntPrincipal').attr('data-sucursal');
		$('#btnCreaNumNotario').tooltip('show');
		var error = '';
		if (numNotario === ""){
			var error = 'Debe ingresar un valor.';
			$('#msgErrorNotario').fadeIn('fast');
			$('#msgErrorNotario').html('<span id="msgErrorNotario" class="label label-warning">'+error+'</span>');
			$('#txtCreaNumNotario').focus();
			$('#txtCreaNumNotario').val('');
		setTimeout(function() {
				$('#msgErrorNotario').fadeOut('fast');
			}, 2500);
		}else{
			$('#btnCreaNumNotario').hide();
			pagina = 'report/sqlMuestraNumNotario.asp';
			div = 'msgErrorNotario';
			datos='action=1&numNotario='+numNotario+'&idUsuarioMain1='+idUsuarioMain+'&idSucursalMain1='+idSucursalMain+'&perfilMain1='+perfilMain;
			enviaDatos(pagina,div,datos);
		}
	});

	function muestraNumNotario(){
		var pagina, div, datos, idUsuarioMain, perfilMain, idSucursalMain, numNotario;
		numNotario = $('#txtCreaNumNotario').val();
		idUsuarioMain = $('#menuDetalleIntPrincipal').attr('data-usuario');
		perfilMain = $('#menuDetalleIntPrincipal').attr('data-perfil');
		idSucursalMain = $('#menuDetalleIntPrincipal').attr('data-sucursal');

		pagina = 'report/sqlMuestraNumNotario.asp';
		div = 'idSpanNumNotario';
		datos='action=2&idUsuarioMain1='+idUsuarioMain+'&numNotario='+numNotario+'&idSucursalMain1='+idSucursalMain+'&perfilMain1='+perfilMain;
		var loadData = $.ajax({
			url: pagina,
			data: datos,
			type: "GET",
			dataType: "json",
			success: function(source){
				data = source;
				dispatchInfo();
			},
			error: function(dato){
				alert("ERROR");
			}
		})
		var dispatchInfo = function(){
			setTimeout(function() {
				renderData(data);
			}, 200);
        }
        var idItem = 0;
        var renderData = function(objectJson){
			$.each(objectJson, function(index, value) {
			 	$('#idSpanNumNotario').html(value.idNumNotario);
			 	$('#divIdCodigoNotario').html(value.idCodigoNotario);
			 	valorNotario = value.idNumNotario;
			 	idCodigoNotario = value.idCodigoNotario;
			});
			var pagina, div, datos, periodo, idItem, idProducto, numNotario, idCodigoNotario, idUsuarioMain, perfilMain;
			periodo = $('#menuDetalleIntPrincipal').attr('data-periodo');
			idItem = $('#menuDetalleIntPrincipal').attr('data-idItem');
			idProducto = $('#menuDetalleIntPrincipal').attr('data-idProducto');
			idUsuarioMain = $('#menuDetalleIntPrincipal').attr('data-usuario');
			perfilMain = $('#menuDetalleIntPrincipal').attr('data-perfil');
			idSucursalMain = $('#menuDetalleIntPrincipal').attr('data-sucursal');
			numNotario = $('#idSpanNumNotario').html();
			idCodigoNotario =  $('#divIdCodigoNotario').html();
			if (idItem === "3"  && idProducto === "1" && perfilMain === "1"){
				$('#divSelectNumNotario').hide();
				$('#'+idProducto+idItem).addClass('active');
				$('#btnCreaNumNotario, #txtCreaNumNotario').slideDown('fast');
				pagina = 'report/reporteDetalleTablaColocacionSuc2.asp';
				div = 'reporteDetalleTabla';
				datos= 'idProducto='+idProducto+"&idItem="+idItem+'&periodo='+periodo+'&idUsuarioMain1='+idUsuarioMain+'&idSucursalMain1='+idSucursalMain+'&perfilMain1='+perfilMain+'&valorNotario='+numNotario+'&idCodigoNotario='+idCodigoNotario;
				enviaDatos(pagina,div,datos);
			}else if (idItem === "4" && idProducto === "1"){
				$('#divSelectNumNotario').show();
				$('#btnCreaNumNotario, #txtCreaNumNotario').hide();
				$('#btnEnviaNotario').hide();
				$('#idSpanNumNotario').hide();
				$('#reporteDetalleTabla').hide();

			    $('#selectNumNotario').change(function(){
			    	$('#btnRegresaNotario').show();
				    var selectIdCodigoNotario = $('#selectNumNotario').val();
				    //var numNotario = $('#idSpanNumNotario').html();
					pagina = 'report/reporteDetalleTablaColocacionSuc2.asp';
					div = 'reporteDetalleTabla';
					datos= 'idProducto='+idProducto+"&idItem="+idItem+'&periodo='+periodo+'&idUsuarioMain1='+idUsuarioMain+'&idSucursalMain1='+idSucursalMain+'&perfilMain1='+perfilMain+'&selectIdCodigoNotario='+selectIdCodigoNotario;
					enviaDatos(pagina,div,datos);
					//HABILITA LA CARGA DEL INDICADOR (EL TOTAL) LUEGO SEGMENTA AL SELECCIONAR
					/*pagina = 'report/reporteDetalleTablaColocacionSuc2.asp';
					div = 'reporteDetalleTabla';
					datos= 'idProducto='+idProducto+"&idItem="+idItem+'&periodo='+periodo+'&idUsuarioMain1='+idUsuarioMain+'&idSucursalMain1='+idSucursalMain+'&perfilMain1='+perfilMain+'&numNotario='+numNotario;
					enviaDatos(pagina,div,datos);*/
				});

			}else if (idItem === "6" ){
				$('#divSelectNumNotario').show();
				$('#btnCreaNumNotario, #txtCreaNumNotario').hide();
				$('#btnEnviaNotario').hide();
				$('#idSpanNumNotario').hide();
				$('#reporteDetalleTabla').hide();
				/*var selectIdCodigoNotario = $('#menuDetalleIntPrincipal').attr('data-SelectIdCodigoNotario');
				pagina = 'report/reporteDetalleTablaColocacionSuc2.asp';
				div = 'reporteDetalleTabla';
				datos= 'idProducto='+idProducto+"&idItem="+idItem+'&periodo='+periodo+'&idUsuarioMain1='+idUsuarioMain+'&idSucursalMain1='+idSucursalMain+'&perfilMain1='+perfilMain+
				'&selectIdCodigoNotario='+selectIdCodigoNotario;
				console.log(datos);
				enviaDatos(pagina,div,datos);*/
				$('#selectNumNotario').change(function(){
			   		var selectIdCodigoNotario = $('#selectNumNotario').val();
					pagina = 'report/reporteDetalleTablaColocacionSuc2.asp';
					div = 'reporteDetalleTabla';
					datos= 'idProducto='+idProducto+"&idItem="+idItem+'&periodo='+periodo+'&idUsuarioMain1='+idUsuarioMain+'&idSucursalMain1='+idSucursalMain+'&perfilMain1='+perfilMain+
					'&selectIdCodigoNotario='+selectIdCodigoNotario;
					enviaDatos(pagina,div,datos);
				});
			}else if (idItem === "5"){
				$('#divSelectCaja').show();
				$('#btnCreaNumNotario, #txtCreaNumNotario').hide();
				$('#btnEnviaNotario').hide();
				$('#idSpanNumNotario').hide();
				$('#reporteDetalleTabla').hide();
				var selectIdCodigoBarra = $('#selectCaja').val();
				pagina = 'report/reporteDetalleTablaColocacionSuc2.asp';
				div = 'reporteDetalleTabla';
				datos= 'idProducto='+idProducto+"&idItem="+idItem+'&periodo='+periodo+'&idUsuarioMain1='+idUsuarioMain+'&idSucursalMain1='+idSucursalMain+'&perfilMain1='+perfilMain;
				enviaDatos(pagina,div,datos);

				$('#selectCaja').change(function(){
			   		var selectIdCodigoBarra = $('#selectCaja').val();
			   		pagina = 'report/reporteDetalleTablaColocacionSuc2.asp';
					div = 'reporteDetalleTabla';
					datos= 'idProducto='+idProducto+"&idItem="+idItem+'&periodo='+periodo+'&idUsuarioMain1='+idUsuarioMain+'&idSucursalMain1='+idSucursalMain+'&perfilMain1='+perfilMain+
					'&selectIdCodigoBarra='+selectIdCodigoBarra;
					enviaDatos(pagina,div,datos);
				});
			}else{
				$('#btnCreaNumNotario, #txtCreaNumNotario').hide();
				$('#btnEnviaNotario').hide();
				$('#idSpanNumNotario').hide();
				pagina = 'report/reporteDetalleTablaColocacionSuc2.asp';
				div = 'reporteDetalleTabla';
				datos= 'idProducto='+idProducto+"&idItem="+idItem+'&periodo='+periodo+'&idUsuarioMain1='+idUsuarioMain+'&idSucursalMain1='+idSucursalMain+'&perfilMain1='+perfilMain+'&numNotario='+numNotario+'&idCodigoNotario='+idCodigoNotario;
				enviaDatos(pagina,div,datos);
			}
			if (parseInt(valorNotario) > 0){
				$('#btnCreaNumNotario, #txtCreaNumNotario').hide();
				$('#divSelectNumNotario').hide();
			}else if (parseInt(valorNotario) === '' && parseInt(idItem) === "3" && parseInt(idProducto) === "1") {
				$('#btnCreaNumNotario, #txtCreaNumNotario').show();
				$('#divSelectNumNotario').hide();
				$('#btnEnviaNotario').hide();
			}else if (parseInt(valorNotario) !== '' && parseInt(idItem) === "4" && parseInt(idProducto) === "1"){
				$('#divSelectNumNotario').show();
				$('#btnCreaNumNotario, #txtCreaNumNotario').hide();
			}
		}
	}
	$('#btnEnviaNotario').click(function(){
		var pagina, div, datos, idCodigoNotario, idUsuarioMain, idSucursalMain;
		idCodigoNotario =  $('#divIdCodigoNotario').html();
		idUsuarioMain = $('#menuDetalleIntPrincipal').attr('data-usuario');
		perfilMain = $('#menuDetalleIntPrincipal').attr('data-perfil');
		idSucursalMain = $('#menuDetalleIntPrincipal').attr('data-sucursal');
		$('#btnEnviaNotario').tooltip('show');
		pagina = 'report/sqlMuestraNumNotario.asp';
		div = 'msgEnviaCredNotario';
		datos='action=4&idUsuarioMain1='+idUsuarioMain+'&idCodigoNotario='+idCodigoNotario+'&idSucursalMain1='+idSucursalMain+'&perfilMain1='+perfilMain;
		enviaDatos(pagina,div,datos);
	});

	$('#btnDownLoadIndicador').click(function(){
		var periodo = $('#menuDetalleIntPrincipal').attr('data-periodo');
		var	idItem = $('#menuDetalleIntPrincipal').attr('data-idItem');
		var	idProducto = $('#menuDetalleIntPrincipal').attr('data-idProducto');
		var	idUsuarioMain = $('#menuDetalleIntPrincipal').attr('data-usuario');
		var	perfilMain = $('#menuDetalleIntPrincipal').attr('data-perfil');
		var	idSucursalMain = $('#menuDetalleIntPrincipal').attr('data-sucursal');
		var	numNotario = $('#idSpanNumNotario').html();
		var	idCodigoNotario =  $('#divIdCodigoNotario').html();
		var idSucursalCaja = $('#idSucursalCaja').attr('data-idSucursalCaja');
		var selectIdCodigoNotario = $('#selectNumNotario').val();
		$('#btnDownLoadIndicador').tooltip('show');
		idAccion = perfilMain;
		if (selectIdCodigoNotario !== '' && selectIdCodigoNotario > 0){
			location.href='report/informeListaDetalleCredito.asp?periodo='+periodo+'&idSucursalMain1='+idSucursalMain+'&idUsuarioMain1='+idUsuarioMain+'&perfilMain1='+perfilMain+'&idProducto='+idProducto+'&idItem='+idItem+'&idAccion='+idAccion+'&selectIdCodigoNotario='+selectIdCodigoNotario;
		}else{
			location.href='report/informeListaDetalleCredito.asp?periodo='+periodo+'&idSucursalMain1='+idSucursalMain+'&idUsuarioMain1='+idUsuarioMain+'&perfilMain1='+perfilMain+'&idProducto='+idProducto+'&idItem='+idItem+'&idAccion='+idAccion;
		}
	});

</script>
