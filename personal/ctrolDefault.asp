<!--#include file="../funciones.asp"-->

<%accesoCajero = trim(request("accesoCajero"))
perfilMain = trim(request("perfilMain"))
%>
<%if accesoCajero = "0" then%>
	<!DOCTYPE html>
	<html lang="es">
		<head>
			<meta charset="utf-8">
			<title>
				Usuario sin acceso.
			</title>
		</head>
		<body>
			<div class="container-fluid">
				<div class="row-fluid">
					<form class="form-inline">
						<div class="span12 well-large well-transparent lead" class="text-center" id="cajaTrabajo">
							<div class="text-center">
								<span class="icon-stack"><i class="icon-user"></i>
								<i class="icon-ban-circle icon-stack-base text-error">
								</i></span>
								<h4>Estimado/a, usted no puede ingresar al sistema.</h4>
								<h5>Favor comuniquese con el área de <strong>Soporte Canales</strong> (<a href="mailto:soportenacales@losheroes.cl">soportenacales@losheroes.cl</a>) para solicitar acceso.</h5>
							</div>
						</div>
					</form>
				</div>
			</div>
		</body>
	</html>
<%else%>
	<!DOCTYPE html>
	<html lang="es">
		<head>
			<meta charset="utf-8">
			<title>
				Usuario No Posee Perfil Correspondiente.
			</title>
		</head>
		<body>
			<div class="container-fluid">
				<div class="row-fluid">
					<form class="form-inline">
						<div class="span12 well-large well-transparent lead" class="text-center" id="cajaTrabajo">
							<div class="text-center">
								<span class="icon-stack"><i class="icon-user"></i>
								<i class="icon-ban-circle icon-stack-base text-error">
								</i></span>
								<h4>Estimado/a, usted no posee perfil correspondiente.</h4>
								<h5>Favor comuniquese con el área de <strong>Soporte Canales</strong> (<a href="mailto:soportenacales@losheroes.cl">soportenacales@losheroes.cl</a>) para actualizar su perfil.</h5>
							</div>
						</div>
					</form>
				</div>
			</div>
		</body>
	</html>
<%end if%>