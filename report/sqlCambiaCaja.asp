<!--#include file="../funciones2.asp"-->
<%modo = trim(request("modo"))
idSucursalMain = trim(request("idSucursalMain1"))
idUsuarioMain = trim(request("idUsuarioMain1"))
txtCaja = trim(request("txtCaja"))
txtCarpeta = trim(request("txtCarpeta"))

if modo = "" then modo = "1"
if modo="2" then
	txtCaja = trim(request("txtCajaCambia"))
end if

sql = ""
sql = sql & " SELECT 1 FROM SUC_vcc_caja WHERE id_codigo_barra = '"&txtCaja&"' " 'verifica si tiene numero de caja'
set rs = db.execute(sql)
if rs.eof then
	sql = "" 'si no tiene numero de caja, se ingresa caja'
	sql = sql & " EXEC SCSS_prc_ingresa_caja '"&txtCaja&"', '"&idUsuarioMain&"', '"&idSucursalMain&"' "
	db.execute(sql)
	sql = "" ''
	sql = sql & " EXEC SCSS_prc_modifica_caja '"&txtCaja&"', '"&idUsuarioMain&"', '202' "
	db.execute(sql)
end if

sql = ""
sql = sql & " SELECT id_estado " 'verifica estado de la caja'
sql = sql & " FROM SUC_vcc_caja "
sql = sql & " WHERE id_codigo_barra = '"&txtCaja&"' "
set rs = db.execute(sql)
if not rs.eof then
	txtEstado = trim(rs(0))
end if

if txtEstado = "202" then 'CAJA ABIERTA'
	if modo = "1" then
		valorArray = split(txtCarpeta, ",")
		for i=LBound(valorArray) to UBound(valorArray)
			carpeta = valorArray(i)

			sql = ""
			sql = sql & " EXEC SCSS_sp_modifica_carpeta_credito "
			sql = sql & " '"&carpeta&"' ,"
			'sql = sql & " '"&fechaRecepcion&"', "
			sql = sql & " '"&txtCaja&"', "
			sql = sql & " '"&idUsuarioMain&"', "
			sql = sql & " '102' "
			db.execute(sql)
		next%>	
		<script type="text/javascript">
			/*var pagina, div, datos;
			pagina = 'report/menuColoTipoTrabPens2.asp'; //falta el periodo
			div = 'menuTipoTrabPens';
			datos='';
			enviaDatos(pagina,div,datos);*/
			$('.#modalCambiaCodigoCaja').slideUp('slow');
		</script>
		<%else
			sql = ""
			sql = sql & " EXEC SCSS_sp_modifica_carpeta_credito "
			sql = sql & " '"&txtCarpeta&"' ,"
			'sql = sql & " '"&fechaRecepcion&"', "
			sql = sql & " '"&txtCaja&"', "
			sql = sql & " '"&idUsuarioMain&"', "
			sql = sql & " '102' " 'Documentos pendientes'
			db.execute(sql)

			if modo = "2" then%>
			<span id="txtCarpeta" data-txtCarpeta="<%=txtCarpeta%>"></span>
				<script type="text/javascript">
				$('#bloqueAgregaCarpeta, #bloqueBotonCierraAgregarCarpeta').slideUp('fast');
				$('#bloqueBotonAgregaCarpeta, #bloqueListadoCarpetas').slideDown('slow');
					/*var pagina, div, datos, txtCarpeta;
					txtCarpeta = $('#txtCarpeta').attr('data-txtCarpeta');
					pagina = 'report/menuPrincipalTrabPens.asp';
					div = 'divMenuPrincipalTrabPens';
					datos='';
					enviaDatos(pagina,div,datos);*/
					$('#modalCheck').modal('hide');
				</script>
			<%end if
			if modo = "3" then%>
				<span id="txtCarpeta" data-txtCarpeta="<%=txtCarpeta%>"></span>
				<script type="text/javascript">
					var txtCarpeta = $('#txtCarpeta').attr('data-txtCarpeta');
					$('#modalCambiaCodigoCaja').modal('hide');
				</script>
		<%end if
	end if	
	if modo = "" then modo = "0"
	if modo = "0" and txtEstado = "202" then%>
		<script type="text/javascript">
			$('#divDocumentoCaja').slideUp('fast');
			/*$('.itemMenu').each(function(index, val) {
				if ($(this).hasClass('active'))
				{
					var tipo = $(this).attr('data-tipoMenu');
					var pagina, div, datos;
					//pagina = 'report/menuPrincipalTrabPens.asp';
					div = 'divMenuPrincipalTrabPens';
					datos='';
					enviaDatos(pagina,div,datos);
				}
			});*/
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



