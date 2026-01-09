<!--#include file="../funciones2.asp"-->
<%idUsuario = trim(request("IdUsuario"))
txtCaja = trim(request("txtCaja"))
txtCarpeta = trim(request("txtCarpeta"))
periodo = trim(request("periodo"))
modo = trim(request("modo"))
mes = trim(request("mes"))
anio = trim(request("anio"))
idSuc = trim(request("idSuc"))


if modo = "" then modo = "1"
if modo="2" then
	txtCaja = trim(request("txtCajaCambia"))
end if
sql = ""
sql = sql & "select 1 from SUC_vcc_caja where id_codigo_barra = '"&txtCaja&"'"
set rs = db.execute(sql)
if rs.eof then
	sql = ""
	sql = sql & "execute SCSS_prc_ingresa_caja '"&txtCaja&"', '"&idUsuario&"', '"&idSuc&"' "
	db.execute(sql)
	'creo caja y la abro'
	sql = ""
	sql = sql & " execute SCSS_prc_modifica_caja '"&txtCaja&"', '"&idUsuario&"', '202' "
	db.execute(sql)
end if
sql = ""
sql = sql & " select id_estado "
sql = sql & " from SUC_vcc_caja where "
sql = sql & " id_codigo_barra = '"&txtCaja&"' "
set rs = db.execute(sql)
if not rs.eof then
	txtEstado = trim(rs(0))
end if
if txtEstado = "202" then
	if modo = "1" then
	'verifico que la caja no este cerrada o enviada'
		valorArray = split(txtCarpeta, ",")
		for i=LBound(valorArray) to UBound(valorArray)
			carpeta = valorArray(i)
			sql = ""
			sql = sql & " select fecha_recepcion "
			sql = sql & " from SUC_vcc_carpeta_credito "
			sql = sql & " where id_carpeta = '"&carpeta&"' "
			set rs = db.execute(sql)
			if not rs.eof then
				fechaRecepcion = trim(rs(0))
			end if
			sql = ""
			sql = sql & " execute SCSS_sp_modifica_carpeta_credito "
			sql = sql & " '"&carpeta&"' ,"
			'sql = sql & " '"&fechaRecepcion&"', "
			sql = sql & " '"&txtCaja&"', "
			sql = sql & " '"&idUsuario&"', "
			sql = sql & " '102' "
			db.execute(sql)
			sql = ""
			sql = sql & "execute SCSS_prc_modifica_caja '"&txtCaja&"','"&idUsuario&"','202' "
			db.execute(sql)
		next%>
		<script type="text/javascript">
			$('#bloqueAgregaCarpeta, #bloqueBotonCierraAgregarCarpeta').slideUp('fast');
			$('#bloqueBotonAgregaCarpeta, #bloqueListadoCarpetas').slideDown('slow');
			var pagina, div, datos, mes, anio;
			mes = <%=mes%>;
			anio = <%=anio%>;			
			pagina = 'CheckListCredito/listaChecklistColo03.asp';
			div = 'listaChecklistColo3';
			datos ='mes='+mes+'&anio='+anio;
			enviaDatos(pagina,div,datos);
		</script>
	<%else 
		sql = ""
		sql = sql & "select fecha_recepcion from SUC_vcc_carpeta_credito where id_carpeta = '"&txtCarpeta&"' "
		set rs = db.execute(sql)
		if not rs.eof then
			fechaRecepcion = trim(rs(0))
		end if
		sql = ""
		sql = sql & " execute SCSS_sp_modifica_carpeta_credito "
		sql = sql & " '"&txtCarpeta&"' ,"
		'sql = sql & " '"&fechaRecepcion&"', "
		sql = sql & " '"&txtCaja&"', "
		sql = sql & " '"&idUsuario&"', "
		sql = sql & " '102' "
		db.execute(sql)
		sql = ""
		sql = sql & "execute SCSS_prc_modifica_caja '"&txtCaja&"','"&idUsuario&"','202' "
		db.execute(sql)
		if modo = "2" then%>
		<span id="txtCarpeta" data-txtCarpeta="<%=txtCarpeta%>"></span>
			<script type="text/javascript">
				$('#bloqueAgregaCarpeta, #bloqueBotonCierraAgregarCarpeta').slideUp('fast');
				$('#bloqueBotonAgregaCarpeta, #bloqueListadoCarpetas').slideDown('slow');				
				var pagina, div, datos, mes, anio, txtCarpeta;
				mes = <%=mes%>;
				anio = <%=anio%>;
				pagina = 'CheckListCredito/listaChecklistColo03.asp';
				txtCarpeta = $('#txtCarpeta').attr('data-txtCarpeta');
				//alert(mes);
				div = 'listaChecklistColo3';
				datos ='mes='+mes+'&anio='+anio;
				enviaDatos(pagina,div,datos);
				$('#modalCheck').modal('hide');
			</script>
		<%end if
		if modo = "3" then%>
			<span id="txtCarpeta" data-txtCarpeta="<%=txtCarpeta%>"></span>
			<script type="text/javascript">
				var txtCarpeta;
				txtCarpeta = $('#txtCarpeta').attr('data-txtCarpeta');
				$('#modalCambiaCodigoCaja').modal('hide');
			</script>
		<%end if
	end if
	if modo = "" then modo = "0"
	if modo = "0" and txtEstado = "202" then%>
		<script type="text/javascript">
			$('#divDocumentoCaja').slideUp('fast');
			$('.itemMenu').each(function(index, val) {
				if ($(this).hasClass('active'))
				{
					var tipo = $(this).attr('data-tipoMenu');
					var pagina, div, datos;
					pagina = 'carpetas/tablaCarpetas.asp';
					div = 'divTablaCarpetas';
					datos='tipo='+tipo;
					enviaDatos(pagina,div,datos);
				}
			});
		</script>
	<%end if	
else%>
	<script type="text/javascript">
		<%if modo = "1" then%>
			$('#errorCaja').html('La caja no se encuentra abierta').addClass('badge badge-important');
		<%end if
		if modo = "3" then%>
			$('#errorCaja<%=txtCarpeta%>').html('La caja no se encuentra abierta').addClass('badge badge-important');
		<%end if
		if modo = "2" then%>
			$('#errorCajaCambia<%=txtCarpeta%>').html('La caja no se encuentra abierta').addClass('badge badge-important');
		<%end if%>
	</script>
<%end if%>
