<!--#include file="funciones.asp"-->
<%idUsrWin = request.servervariables("LOGON_USER")
usuarios = split(idUsrWin,"\")
usuarioWinMain = usuarios(1)
dominio = usuarios(0)

	'response.write(usuarios)
	'response.end

function obtieneIdSucursal(idUsuario)
	sql2 = ""
	sql2 = sql2 & "select id_sucursal from SUC_usuario_sucursal where id_usuario = " & idUsuario& " and estado = 0"
	
	'response.write(sql2)
	'response.end

	Set rsUserSuc = DB.execute(sql2)
	if not rsUserSuc.Eof then
		idSucursal = rsUserSuc("id_sucursal")
	else
		idSucursal = "0"
	end if	
	rsUserSuc.Close
	set rsUserSuc.ActiveConnection = nothing
	set rsUserSuc = nothing
	obtieneIdSucursal = idSucursal
end function

sql = ""
sql = sql & "select id_perfil, "
sql = sql & " id_usuario "
sql = sql & " from SUC_usuario "
sql = sql & " where usuario_nombre2 = '"&usuarioWinMain&"' "
sql = sql & " and estado = 0 "
'response.write(sql)
'response.end

set rs = db.execute(sql)
if not rs.eof then
	idPerfil = trim(rs(0))
	idUsuario = trim(rs(1))	

	if (idPerfil = 2) then
		idSucursal = 0
	else
		idSucursal = obtieneIdSucursal(idUsuario)
	end if 
	
	'if usuarioWinMain = "rmorales" then
		'idPerfil = "2"
		'idUsuario = "2"
		'idSucursal = "0"
	'end if

	ip = Request.ServerVariables("remote_addr")
	sql = ""
	sql = sql & " insert into "
	sql = sql & " SUC_usuario_ingreso "
	sql = sql & " values ('"&usuarioWinMain&"', "
	sql = sql & " '"&dominio&"', "
	sql = sql & " '"&idUsuario&"', "
	sql = sql & " '"&ip&"', "
	sql = sql & " getdate()) "
	
	'response.write(sql)
	'response.end

	db.execute(sql)%>
	<script type="text/javascript" src="js/jquery.js"></script>
	<form name="form2" id="form2" action="main.asp" method="post">
		<input type="hidden" name="perfilMain" id="perfilMain" value="<%=idPerfil%>">
		<input type="hidden" name="idSucursalMain" id="idSucursalMain" value="<%=idSucursal%>">
		<input type="hidden" name="idUsuarioMain" id="idUsuarioMain" value="<%=idUsuario%>">
	</form>
	<script type="text/javascript">
		$('#form2').submit();
	</script>
<%else%>
<!DOCTYPE html>
<html lang="es">
    <head>
    	<meta charset="utf-8">
	    <title>Ingreso sistema</title>
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta name="description" content="">
	    <meta name="author" content="">
	    <link href="css/bootstrap.css" rel="stylesheet" type="text/css">
    	<link href="css/bootstrap-responsive.css" rel="stylesheet">
        <link href="css/estilo.css" rel="stylesheet" type="text/css">
        <link rel="stylesheet" type="text/css" href="css/bootstrap-tour.min.css">
        <link rel="stylesheet" href="css/font-awesome.min.css" type="text/css">
    
		<!-- HTML5 shim, para que IE6-8 soporte elementos de HTML5 -->
    	<!--[if lt IE 9]>
	    	<script src="js/html5shiv.js"></script>
    	<![endif]-->
		<!-- Fav y touch iconos //touch icon solo para moviles basados en osx-->
		<meta http-equiv="X-UA-Compatible" content="IE=9">
	    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="ico/apple-touch-icon-144-precomposed.png">
    	<link rel="apple-touch-icon-precomposed" sizes="114x114" href="ico/apple-touch-icon-114-precomposed.png">
	    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="ico/apple-touch-icon-72-precomposed.png">
	    <link rel="apple-touch-icon-precomposed" href="ico/apple-touch-icon-57-precomposed.png">
	    <link rel="shortcut icon" href="ico/favicon.png">
    </head>
    <body>
	<div class="container-fluid page-header">
		<div class="row-fluid centrado">
			<div id="logo" class="span3">
				<img src="img/LogoLH.gif" class="img-rounded" width="120" height="60">
			</div>
			<div id="espacio" class="span5"></div>
			<div id="titulo" class="span4">
				<strong>
				<h1>Sucursales</h1></strong>
			</div>
		</div>
		<div class="row-fluid" id="formularioIngreso">
			<div class="span6 offset3 well text-center">
				<span class="icon-stack icon-2x">
					<i class="icon-lock"></i>
					<i class="icon-ban-circle icon-stack-base text-error"></i>
	        	</span>
				Usted no tiene acceso o ha sido denegado, comuníquese con Soporte Canales (<strong>soportecanales@losheroes.cl</strong>) para regularizar su situación y garantizar el acceso. Presione aquí para enviar correo
			</div>

			</div>
		</div>

	</div>

	
	<script type="text/javascript" src="js/jquery.js"></script>
    <script type="text/javascript" src="js/bootstrap-transition.js"></script>
    <script type="text/javascript">
    $('#formularioIngreso').click(function() {
		var link = "mailto:SoporteCanales@losheroes.cl";
		link +="&subject=" + escape("Acceso sistema sucursales");
		window.location.href = link;
    });
    </script>
    </body>
</html>
<%end if%>
