<!DOCTYPE html>
<html lang="es">
	<head>
		<meta charset="utf-8">
		<title>Salir sistema</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="description" content="">
		<meta name="author" content="">
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
		<link href="../css/bootstrap.css" rel="stylesheet" type="text/css">
		<link href="../css/bootstrap-responsive.css" rel="stylesheet">
		<link href="../css/estilo.css" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="../css/font-awesome.min.css" type="text/css">   
		<!-- HTML5 shim, para que IE6-8 soporte elementos de HTML5 -->
		<!--[if lt IE 9]>
			<script src="../js/html5shiv.js"></script>
		<![endif]-->
		<!--[if IE 7]>
			<link rel="stylesheet" href="../css/font-awesome-ie7.min.css">
		<![endif]-->
		<!-- Fav y touch iconos //touch icon solo para moviles basados en osx-->
		<meta http-equiv="X-UA-Compatible" content="IE=9">
		<link rel="apple-touch-icon-precomposed" sizes="144x144" href="../ico/apple-touch-icon-144-precomposed.png">
		<link rel="apple-touch-icon-precomposed" sizes="114x114" href="../ico/apple-touch-icon-114-precomposed.png">
		<link rel="apple-touch-icon-precomposed" sizes="72x72" href="../ico/apple-touch-icon-72-precomposed.png">
		<link rel="apple-touch-icon-precomposed" href="../ico/apple-touch-icon-57-precomposed.png">
		<link rel="shortcut icon" href="../ico/favicon.png">
	</head>
	<body>
		<div class="container-fluid page-header">
			<div class="row-fluid centrado">
				<div id="logo" class="span3">
					<img src="../img/LogoLH.gif" class="img-rounded" width="120" height="60">
				</div>
				<div id="espacio" class="span5"></div>
				<div id="titulo" class="span4">
					<strong>
						<h1>Sucursales</h1>
					</strong>
				</div>
			</div>
		</div>
		<div class="container">
			<div class="row-fluid">
				<div class="span5 offset3">
					<img src="../img/salida.jpg" class="img-rounded">
				</div>
			</div>
			<div class="row-fluid">
				<div class="span12"></div>
			</div>
			<div class="row-fluid">
				<div class="span5 offset3 text-center">
					<span class="alert alert-success">
						<i class="icon-signout"></i> Usted salió del sistema
					</span>
				</div>
			</div>
			<div class="row-fluid">
				<div class="span12"></div>
			</div>
			<div class="row-fluid">
				<div class="span5 offset3 text-center">
					<span class="well botonVuelve mano" >
						<i class="icon-backward"></i> Para volver presione aquí
					</span>
				</div>
			</div>
		</div>
		<script type="text/javascript" src="../js/jquery.js"></script>
		<script type="text/javascript" src="../js/bootstrap-transition.js"></script>
		<script type="text/javascript">
		$('.botonVuelve').click(function() {
			location.href='../default.asp';
		});
		</script>
	</body>
</html>
