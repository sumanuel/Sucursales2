<!--#include file="../funciones.asp"-->
<div id="muestraGrafico" class="well oculto">
</div>
<%idSucursal = trim(request("idSucursalMain"))
idUsuario = trim(request("idUsuarioMain"))
perfil = trim(request("perfilMain"))
sql = ""
sql = sql & "select idIndice, nombreIndice from SUC_indices where padre = 0 and estado = 1 order by orden"
set rs = db.execute(sql)
i = 1
if not rs.eof then
	do while not rs.eof
		if i="1" or i="4" then
			response.write("<div class='row-fluid'>")
		end if
		nombreIndice = server.htmlencode(trim(rs("nombreIndice")))
		idIndice = trim(rs("idIndice"))
		%>
	<div id="indice<%=i%>" data-idIndice="<%=idIndice%>" class="indice span4 well cajaEspecial">
		<div id="nombreIndice" class="label"><%=nombreIndice%></div>
		<table border="0" width="100%">
		<%sql2 = ""
		sql2 = sql2 & " select idIndice, nombreIndice, tituloIndice, area, tipo from SUC_indices where padre = '"&idIndice&"' and estado = 1 order by orden"
		set rs2 = db.execute(sql2)
		x= 1
		if not rs2.eof then
			do while not rs2.eof
				nombreSubIndice = server.htmlencode(trim(rs2("nombreIndice")))
				tituloSubIndice = trim(rs2("tituloIndice"))
				idItemIndice = trim(rs2("idIndice"))
                area = server.htmlencode(trim(rs2("area")))
                tipo = server.htmlencode(trim(rs2("tipo")))%>
				
					<tr>
						<td>
							<div id="n<%=area%><%=tipo%>" rel="tooltip" title="<%=tituloSubIndice%>" class="mano abreGrafico tool <% if tipo=0 then response.Write(" label") end if%>" <% if tipo<>0 then response.write("style=padding-left:5px;font-weight:bold;") end if %> data-idIndice="<%=idItemIndice%>" data-idSucursal="<%=idSucursal%>" data-idUsuario="<%=idUsuario%>" data-perfil="<%=perfil%>">
								<%=nombreSubIndice%>
							</div>
						</td>
						<td width="40%" align="right" valign="middle">
							<div id="v<%=area%><%=tipo%>">
								<% if tipo<>0 then response.write("0") end if %>
							</div>
						</td>
					</tr>
				
				<%rs2.MoveNext
				x = x+1
			loop
		end if
		rs2.Close
		set rs2.ActiveConnection = nothing
		set rs2=nothing%>
		</table>
	</div>
		<%rs.MoveNext
		i = i+1
		if i="1" or i="4" then
			response.write("</div>")
		end if
	loop
end if
rs.Close
set rs.ActiveConnection = nothing
set rs=nothing
DB.Close
set DB=nothing%>
<script type="text/javascript" src="js/bootstrap-tooltip.js"></script>
<script type="text/javascript">
$(function () {
	$('.tool').tooltip();
	loadData();
});

$('.abreGrafico').click(function(){
	var idIndice = $(this).attr('data-idIndice');
	var idSucursal = $(this).attr('data-idSucursal');
	var pagina = 'grafico/graficos.asp';
	var div = 'muestraGrafico'
	var datos = 'idIndice='+idIndice+'&idSucursal='+idSucursal;
	setTimeout(function(){
		try{
			enviaDatos(pagina,div,datos);
			return false;
		}
		catch(err){}
	},500);
	return false;
});

function loadData() {
	var urlCompleta = "indices/loadData.asp?idUsuario="+$('.abreGrafico').attr('data-idUsuario');
	urlCompleta += '&idSucursal='+$('.abreGrafico').attr('data-idSucursal');
	urlCompleta += '&perfil='+$('.abreGrafico').attr('data-perfil');
	$.ajax({
		url: urlCompleta,
		data: "",
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
}
function dispatchInfo(){
	renderData(data['datos']);
}
	
function renderData(objectTable){
	var html = '';
	var objIndex = '';
	var objIndexf = '';
	$.each(objectTable, function(index, value) {						
		objIndex = "#v" + value.area + value.tipo;
		objIndexf = "#v" + value.area + value.tipo + "f";
		if($(objIndex)){
			var valor = value.valor;
			var fecha = value.fecha
			valor = numberFormat(valor);
			if(valor!='')
				$(objIndex).html(valor +' <small>['+fecha+']</small>');
			else
				$(objIndex).text(''); 
		}
		if($(objIndexf))
			$(objIndexf).text(value.fecha);			
	});		
}

</script>