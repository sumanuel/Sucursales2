<!--#include file="../funciones.asp"-->
<%
	idPerfil = request("idPerfil")
	idUsuario = request("idUsuario")
%>
<div class="" id="grafico"></div>
<div class="oculto" id="detalleCaso"></div>
<div class="oculto" id="listaCasos"></div>

<script type="text/javascript">
	$(document).ready(function(){		
	    var div = 'grafico';
	    var datos = 'tipo=1&idPerfil=<%=idPerfil%>&idUsuario=<%=idUsuario%>';   
	    var pagina = 'personal/creagraficogestioncasos.asp';
	        
	    enviaDatos(pagina,div,datos);
	})
</script>