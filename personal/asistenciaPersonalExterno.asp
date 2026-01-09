<!--#include file="../conexion/conexion.asp"-->
<%
	codBantotal = request("codBantotal")
	codBantotal = 178

	idUsrWin = request.servervariables("LOGON_USER")
	usuarios = split(idUsrWin,"\")
	usuarioWin = usuarios(1)
	dominio = usuarios(0)

	response.write("usuarioWinAD: " & usuarioWin & "<br/>")
	usuarioWin = "ncastro.33"
	'usuarioWin = "ncastro"
%>
<input type="hidden" name="asistExtCodBantotal" id="asistExtCodBantotal" value="<%=codBantotal%>" />
<%
	sql = ""
	sql = sql & "select "
	sql = sql & "rut_personal, "
	sql = sql & "nombre_personal, "
	sql = sql & "tipo_personal, "
	sql = sql & "tipo, "
	sql = sql & "userwinad "
	sql = sql & "from SUC_sucursal_personal_cuentasad "
	sql = sql & "where userwinad = '"& usuarioWin &"' "

	set progCajAD = db.execute(sql)
	if not progCajAD.EOF then

	rut_personal = server.htmlencode(trim(progCajAD("rut_personal")))
	nombre_personal = server.htmlencode(trim(progCajAD("nombre_personal")))
	tipo_personal = server.htmlencode(trim(progCajAD("tipo_personal")))
	tipo = server.htmlencode(trim(progCajAD("tipo")))
	userwinad = server.htmlencode(trim(progCajAD("userwinad")))
%>
	<input type="hidden" name="asistExtRutPersonal" id="asistExtRutPersonal" value="<%=rut_personal%>" />
	<span class="label label-info">DATOS DE IDENTIFICACION PERSONAL</span>
	<table class="table table-bordered table-condensed table-hover">
		<thead>
			<tr>
				<th>RUT</th>
				<th>NOMBRE</th>
				<th>USUARIO AD</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><%=rut_personal%></td>
				<td><%=nombre_personal%></td>
				<td><%=userwinad%></td>
			</tr>
		</tbody>
	</table>
	<%
		sql = ""
		sql = sql & "select "
		sql = sql & "A.fecha_respaldo, "
		sql = sql & "A.hora_llegada, "
		sql = sql & "A.min_llegada, "
		sql = sql & "C.cod_bantotal, "
		sql = sql & "C.suc_nombre, "
		sql = sql & "C.suc_jeps "
		sql = sql & "from SUC_sucursal_asistencia_personal_respaldo A "
		sql = sql & "inner join SUC_sucursal C "
		sql = sql & "on A.bt_sucursal = C.cod_bantotal "
		sql = sql & "where A.rut_personal = '"& rut_personal &"' and "
		sql = sql & "A.fecha_respaldo = "
		sql = sql & "(select MAX(B.fecha_respaldo) "
		sql = sql & "from SUC_sucursal_asistencia_personal_respaldo B "
		sql = sql & "where B.rut_personal = A.rut_personal) "

		set progCajADA = db.execute(sql)
		if not progCajADA.EOF then
			fecha_respaldo = server.htmlencode(trim(progCajADA("fecha_respaldo")))
			suc_nombre = server.htmlencode(trim(progCajADA("suc_nombre")))
			hora_llegada = server.htmlencode(trim(progCajADA("hora_llegada")))
			min_llegada = server.htmlencode(trim(progCajADA("min_llegada")))
			jeps = server.htmlencode(trim(progCajADA("suc_jeps")))
%>
		<span class="label label-info">ULTIMO REGISTRO DE ASISTENCIA</span>
		<table class="table table-bordered table-condensed table-hover">
			<thead>
				<tr>
					<th>FECHA ASISTENCIA</th>
					<th>SUCURSAL</th>
					<th>HORA REGISTRO</th>
					<th>JEPS</th>
				</tr>	
			</thead>
			<tbody>
				<tr>
					<td><%=fecha_respaldo%></td>
					<td><%=suc_nombre%></td>
					<td><b><%=hora_llegada%>:<%=min_llegada%></b></td>
					<td><%=jeps%></td>
				</tr>
			</tbody>
		</table>
<%
		end if
%>
	<span class="label label-info">DETALLE SUCURSAL</span>
	<div id="persExtasistenciaSucursal"></div>
	<script type="text/javascript">
		$(document).ready(function(){
			var codBantotal = $('#asistExtCodBantotal').val();			

			var div = 'persExtasistenciaSucursal';
			var datos = 'tipo=1&codBantotal='+codBantotal;
			var pagina = 'asistenciaSucursal_viewlite.asp';

			enviaDatos(pagina,div,datos);
		});
	</script>
	<div id="btnAsistPersonalExt">
		<a class="btn btn-success btnMarcarAsistencia" id="btnMarcarAsistencia" data-codBantotal="<%=codBantotal%>" data-userwin="<%=usuarioWin%>" data-rutPersonal="<%=rut_personal%>">
			<i class="icon-ok icon-large"></i>
			&nbsp;<span class="bajaLetra"><b>MARCAR ASISTENCIA</b></span>
		</a>
		<a class="btn btn-danger btnOtroUsuario" id="btnOtroUsuario" data-userwin="<%=usuarioWin%>">
			<i class="icon-user icon-large"></i>
			&nbsp;<span class="bajaLetra"><b>OTRO USUARIO</b></span>
		</a>
	</div>
	<script type="text/javascript">
		$(document).ready(function(){
			var codBantotal = $('#asistExtCodBantotal').val()
			var rutPersonal = $('#asistExtRutPersonal').val()
			var pagina = 'asistenciaSucursal_sql.asp';
			var datos = 'tipo=2&codBantotal='+codBantotal+'&rutPersonal='+rutPersonal;

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
			});

			var dispatchInfo = function(){				
				renderData(data);				
			}

			var renderData = function(objectJson){
				var nombrePersonal = '';
				var asistencia = '';
				var horallegada = '';
				var minllegada = '';

				$.each(objectJson, function(index, value) {            					
					nombrePersonal = value.nombrePersonal;
					asistencia = value.asistencia;
					horallegada = value.horallegada;
					minllegada = value.minllegada;
				}); 

				if(asistencia == ''){				
					$('#btnAsistPersonalExt').show('slow');	
				}else{					
					$('#btnAsistPersonalExt').hide();
				}
			}

			$("#btnMarcarAsistencia").click(function(){
				$('#btnAsistPersonalExt').hide();
				$('#persExtasistenciaSucursal').html('<p><strong>MARCANDO ASISTENCIA</strong> <img src="../img/loader.gif"/></p>');

				var codBantotal = $(this).attr('data-codBantotal');
				var rutPersonal = $(this).attr('data-rutPersonal');

				var div = '';
				var datos = 'tipo=1&rutPersonal='+rutPersonal+'&codBantotal='+codBantotal;
				var pagina = 'asistenciaSucursal_sql.asp';
				enviaDatos(pagina,div,datos);

				setTimeout(function(){
					div = 'persExtasistenciaSucursal';
					datos = 'tipo=1&codBantotal='+codBantotal;
					pagina = 'asistenciaSucursal_viewlite.asp';
					enviaDatos(pagina,div,datos);	
				}, 1500);
			});
		});
	</script>
<%  else 'CASO: PERSONARL SIN CUENTA ACTUALIZADA EN ACTIVE DIRECTORI  %>
<div id="dvformingreso">		
	<form class="form-horizontal">
	  <legend><span class="label label-info">PERSONAL NO IDENTIFICADO</span></legend>
	  <div class="control-group">
	    <label class="control-label" for="inputRutpersonal" style="font-size:12px"><strong>CUENTA WIN</strong></label>
	    <div class="controls">	      
	      <label class="label label-success"><strong><%=usuarioWin%></strong></label>
	    </div>
	  </div>
	  <div class="control-group">
	    <label class="control-label" for="inputRutpersonal" style="font-size:12px"><strong>RUT PERSONAL</strong></label>
	    <div class="controls">
	      <input type="text" id="inputRutpersonal" placeholder="rut">
	      <span class="help-block">Ejemplo: 12345678-9</span>
	    </div>
	  </div>
	  <div class="control-group">
	    <label class="control-label" for="inputNombrePersonal" style="font-size:12px"><strong>NOMBRE COMPLETO</strong></label>
	    <div class="controls">
	      <input type="text" id="inputNombrePersonal" placeholder="nombres">
	    </div>
	  </div>
	  <div class="control-group">
	    <div class="controls">
	        <label class="radio inline">
			  <input class="optTipoPersonal" type="radio" name="optTipoPersonal" value="T"> <span style="font-size:10px"><b>TITULAR</b></span>
			</label>
			<label class="radio inline">
			  <input class="optTipoPersonal" type="radio" name="optTipoPersonal" value="R"> <span style="font-size:10px"><b>REEMPLAZO</b></span>
			</label>
	    </div>
	  </div>
	  <div class="control-group">
	    <div class="controls">	      
	      <a class="btn btn-primary btnPersExtRegAsist" id="btnPersExtRegAsist"><i class="icon icon-save"></i>&nbsp;<span style="font-size:10px">REGISTRAR ASISTENCIA</span></a>
	    </div>
	  </div>
	</form>
	<script type="text/javascript">
		$(document).ready(function(){
			function doValidPersExt(){
				var flag = true;
				if($.trim($('#inputRutpersonal').val()) == '')
					flag = false;
				if($.trim($('#inputNombrePersonal').val()) == '')
					flag = false;

				return flag;	
			}
			$('#btnPersExtRegAsist').click(function(){
				if(doValidPersExt()){
					var rutPersonal = $.trim($('#inputRutpersonal').val());
					var nombrePersonal = $.trim($('#inputNombrePersonal').val());

					//console.log("rutPersonal:"+rutPersonal);
					//console.log("nombrePersonal:"+nombrePersonal);	
				}				
			});

			$('.optTipoPersonal').click(function(){
				console.log('optTipoPersonal:'+$(this).val());
			});
		});
	</script>
</div>
<div class="oculto" id="dvAsistenciaSucursal"></div>
<% end if %>