<!--#include file="../conexion/conexion.asp"-->
<%
	cod_bantotal = trim(request("codBantotal"))
	fecha_respaldo = trim(request("fechaRespaldo"))
	tipoDimen = trim(request("tipoDimen"))

	idUsrWin = request.servervariables("LOGON_USER")
	usuarios = split(idUsrWin,"\")
	usuarioWin = usuarios(1)
	dominio = usuarios(0)

	'response.write("usuarioWin: " & usuarioWin)
%>
<% if tipoDimen = "1" then 'DETALLE DIMENSIONAMIENTO POR SUCURSAL ONLINE 
	sql = ""
	sql = sql & "select "
	sql = sql & "fecha, "
	sql = sql & "nro_adicional "
	sql = sql & "from SUC_sucursal_cajeros_dimen "
	sql = sql & "where year(fecha) = year(getdate()) and "
	sql = sql & "month(fecha) = month(getdate()) and "
	sql = sql & "cod_bantotal = " & cod_bantotal & " "
	sql = sql & "order by fecha "

	set prog2 = db.execute(sql)
	if not prog2.EOF then %>
	<div class="span4 well muestraDetalleDimenTabla" id="muestraDetalleDimenTabla">	
		<table class="table table-bordered table-hover table-condensed">
		<tr>
			<td style="text-align:center;"><b>FECHA</b></td>
			<td style="text-align:center;"><b>ADICIONAL</b></td>
		</tr>		
			<% do until prog2.EOF 
				fecha = trim(prog2("fecha"))
				nro_adicional = trim(prog2("nro_adicional")) %>	
				<tr>
					<td class="span6" style="text-align:center;"><b><%=fecha%></b></td>			
					<td class="span6" style="padding-left:70px;"><input class="input-mini adDimen" style="padding-right:10px;padding-left:20px;margin-bottom:1px;height:15px;width:45px;" type="text" data-dimFecha="<%=fecha%>" value="<%=nro_adicional%>"/></td>
				</tr>
			<% prog2.Movenext 
			Loop %>	
		</table>
	</div>
	<div class="span8 well muestraDetalleDimenSucursal" id="muestraDetalleDimenSucursal">
	<%
		sql = ""
		sql = sql & "select "
		sql = sql & "A.cod_bantotal, "
		sql = sql & "A.suc_tipo, "
		sql = sql & "A.suc_nombre, "
		sql = sql & "A.suc_jeps, "
		sql = sql & "A.suc_jeps_short, "
		sql = sql & "A.suc_jeps_enexo, "
		sql = sql & "A.suc_jeps_celular, "
		sql = sql & "A.suc_zonal_ext, "
		sql = sql & "A.suc_zonal_jefe, "
		sql = sql & "B.modulos_caja, "
		sql = sql & "B.fisicos_pc, "
		sql = sql & "B.cajeros_ips, "
		sql = sql & "B.cajeros_lh, "
		sql = sql & "B.nro_ao "
		sql = sql & "from SUC_sucursal A "
		sql = sql & "inner join SUC_sucursal_cajeros_dotacion B "
		sql = sql & "on A.cod_bantotal = B.cod_bantotal "
		sql = sql & "where A.cod_bantotal = " & cod_bantotal

		'response.write(sql)
		'response.end()
		set prog3 = db.execute(sql)
		if not prog3.EOF then

		suc_tipo = server.htmlencode(trim(prog3("suc_tipo")))
		suc_nombre = server.htmlencode(trim(prog3("suc_nombre")))
		suc_jeps = server.htmlencode(trim(prog3("suc_jeps")))
		suc_jeps_short = server.htmlencode(trim(prog3("suc_jeps_short")))
		suc_jeps_enexo = server.htmlencode(trim(prog3("suc_jeps_enexo")))
		suc_jeps_celular = server.htmlencode(trim(prog3("suc_jeps_celular")))
		suc_zonal_ext = server.htmlencode(trim(prog3("suc_zonal_ext")))
		suc_zonal_jefe = server.htmlencode(trim(prog3("suc_zonal_jefe")))

		layout_modulos = server.htmlencode(trim(prog3("modulos_caja")))
		layout_pcoper = server.htmlencode(trim(prog3("fisicos_pc")))
		layout_cajeips = server.htmlencode(trim(prog3("cajeros_ips")))
		layout_cajelh = server.htmlencode(trim(prog3("cajeros_lh")))
		layout_nroao = server.htmlencode(trim(prog3("nro_ao")))
%>
		<table class="table table-bordered table-hover table-condensed">
			<thead>
				<tr>
					<th style="text-align:center;">COD BTT</th>
					<th style="text-align:center;">SUCURSAL</th>
					<th style="text-align:center;">TIPO</th>
					<th style="text-align:center;">ZONAL</th>
					<th style="text-align:center;">REGIONAL</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="text-align:center;"><%=cod_bantotal%></td>
					<td style="text-align:center;"><%=suc_nombre%></td>
					<td style="text-align:center;"><%=suc_tipo%></td>
					<td style="text-align:center;"><%=suc_zonal_ext%></td>
					<td style="text-align:center;"><%=suc_zonal_jefe%></td>
				</tr>
			</tbody>
		</table>
		<table class="table table-bordered table-hover table-condensed">
			<thead>
				<tr>
					<th>JEPS</th>
					<th>ANEXO</th>
					<th>CELULAR</th>					
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class="span6"><%=suc_jeps%></td>
					<td class="span3"><%=suc_jeps_enexo%></td>
					<td class="span3"><%=suc_jeps_celular%></td>					
				</tr>
			</tbody>
		</table>
		<table class="table table-bordered table-hover table-condensed">
			<thead>
				<tr>
					<th style="text-align:center;">MODULOS CAJA</th>
					<th style="text-align:center;">PC OPERATIVOS</th>
					<th style="text-align:center;">CAJEROS TITULARES</th>
					<th style="text-align:center;">AO</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="text-align:center;" class="span3"><%=layout_modulos%></td>
					<td style="text-align:center;" class="span3"><%=layout_pcoper%></td>
					<td style="text-align:center;" class="span3"><%=(cint(layout_cajeips)+cint(layout_cajelh))%></td>
					<td style="text-align:center;" class="span3"><%=layout_nroao%></td>
				</tr>
			</tbody>
		</table>
		<div id="divDimenBtn">
			<a class="btn btn-primary btnGuardarDimen" id="btnGuardarDimen" data-codBantotal="<%=cod_bantotal%>" data-userwin="<%=usuarioWin%>">
				<i class="icon-save icon-large"></i>
				&nbsp;<span class="bajaLetra"><b>GUARDAR DIMEN.</b></span>
			</a>		
			<a class="btn btn-danger btnCerrarDimen" id=" btnCerrarDimen">
				<i class=""></i>
				&nbsp;<span class="bajaLetra"><b>CERRAR</b></span>
			</a>
		</div>
		<div class="oculto" id="divDimenEnvia"></div>		
		<script type="text/javascript">
			$(document).ready(function(){
				function validDimen(){
					var flagTrue = true;
					$.each($('.adDimen'), function() {
					   var dimVal = $(this).val();
					   if ($.trim(dimVal) == '')
					   		flagTrue = false;
					});

					return flagTrue;
				}
				$('.btnGuardarDimen').click(function(){
					var userwin = $(this).attr('data-userwin');
					var codBantotal = $(this).attr('data-codBantotal');
					var xml = '<root>';
					$.each($('.adDimen'), function() {
					   var dimVal = $.trim($(this).val());
					   var dimFecha = $(this).attr('data-dimFecha');
					   xml = xml + '<item><valor>'+dimVal+'</valor><fecha>'+dimFecha+'</fecha></item>';
					});
					xml = xml + '</root>'					
					
					if(!validDimen()){
						alert('Favor ingresar todos los valores del mes.');
					}else{
						$('#divDimenBtn').hide();
						$('#divDimenEnvia').removeClass('oculto').html('<strong>Guardando</strong> <img src="../img/loader.gif"/>');

						var pagina = 'cuadroControl_sql.asp';
						var div = '';
						var datos = 'cargaCuadrocontrol=6&userwin='+userwin+'&codBantotal='+codBantotal+'&xmlData='+xml;

						var  execAjax = $.ajax({
						  	url: pagina,
						   	data: datos,
						    type: "POST",
							dataType: "html",
							cache:false,
							//async:true,
							timeout:120000,
							success: function(source){								
								var pagina, div, datos
						    	pagina = 'cuadroControlTabla.asp';
						    	div = 'muestraDetalle';
						    	datos='pagina=2&cargaCuadrocontrol='+$('#cargaCuadrocontrol').val();
						    	enviaDatos(pagina,div,datos);

								setTimeout(function(){
									$('#muestraDetalleDimen').slideUp();
									$('#muestraDetalle').slideDown();
									$('#divBotones').show();	
								},2000);
							},
							error: function(source){
								alert('Algo salio mal');
							}
						});
					}		
				});
				$('.btnCerrarDimen').click(function(){
					$('#muestraDetalle').slideDown();
					$('#muestraDetalleDimen').slideUp();
					$('#divBotones').show();
				});
			});
		</script>
<% 		end if %>
	</div>
<% end if %>

<% end if %>

<% if tipoDimen = "2" then 'DETALLE DIMENSIONAMIENTO POR SUCURSAL RESPALDO %>

<% end if %>