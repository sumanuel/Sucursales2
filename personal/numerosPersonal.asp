<div class="row-fluid">
	<div class="span12">
		<dl class="dl-horizontal">
			<dt><span class="label label-info">Cajeros Titulares </span></dt>
			<dd><span class="label"><i class="icon-user"></i> <span id="cajerotitular"></span></span></dd>
			<dt><span class="label label-info">Cajeros Reemplazos </span></dt>
			<dd><span class="label"><i class="icon-user"></i> <span id="cajeroreemplazo"></span></span></dd>
			<dt><span class="label label-info">Cajeros Adicionales </span></dt>
			<dd><span class="label"><i class="icon-user"></i> <span id="cajeroadicional"></span></span></dd>
			<dt><span class="label label-info">Cajeros Resgitrados </span></dt>
			<dd><span class="label"><i class="icon-user"></i> <span id="cajerosregistrados"></span></span></dd>
			<dt><span class="label label-info">Cajeros Presentes </span></dt>
			<dd><span class="label"><i class="icon-user"></i> <span id="cajerospresentes"></span></span></dd>
			<dt><span class="label label-important">Cajeros Ausentes</span></dt>
			<dd><span class="label"><i class="icon-user"></i> <span id="cajerosausentes"></span></span></dd>
			<dt><span class="label label-important">Cajeros Ausentes adici...</span></dt>
			<dd><span class="label"><i class="icon-user"></i> <span id="cajerosausentesadi"></span></span></dd>
			<dt><span class="label label-important">Cajeros Ausentes titu...</span></dt>
			<dd><span class="label"><i class="icon-user"></i> <span id="cajerosausentestitu"></span></span></dd>
		</dl>

		<!--<dl class="dl-horizontal">
			<dt><span class="label label-info">Anfitriones Titulares </span></dt>
			<dd><span class="label"><i class="icon-chevron-right"></i> <span id="asesortitular"></span></span></dd>
			<dt><span class="label label-info">Anfitriones Reemplazos </span></dt>
			<dd><span class="label"><i class="icon-chevron-right"></i> <span id="asesoreemplazo"></span></span></dd>      
			<dt><span class="label label-info">Anfitriones Resgitrados </span></dt>
			<dd><span class="label"><i class="icon-chevron-right"></i> <span id="asesoresregistrados"></span></span></dd>
			<dt><span class="label label-info">Anfitriones Presentes </span></dt>
			<dd><span class="label"><i class="icon-chevron-right"></i> <span id="asesorespresentes"></span></span></dd>
			<dt><span class="label label-important">Anfitriones Ausentes </span></dt>
			<dd><span class="label"><i class="icon-chevron-right"></i> <span id="asesoresausentes"></span></span></dd>
		</dl> 

		<dl class="dl-horizontal">
			<dt><span class="label label-info">Param&eacute;dicos Titulares </span></dt>
			<dd><span class="label"><i class="icon-plus-sign"></i> <span id="paramedicotitular"></span></span></dd>
			<dt><span class="label label-info">Param&eacute;dicos Reemplazos </span></dt>
			<dd><span class="label"><i class="icon-plus-sign"></i> <span id="paramedicoreemplazo"></span></span></dd>      
			<dt><span class="label label-info">Param&eacute;dicos Resgitrados </span></dt>
			<dd><span class="label"><i class="icon-plus-sign"></i> <span id="paramedicosregistrados"></span></span></dd>
			<dt><span class="label label-info">Param&eacute;dicos Presentes </span></dt>
			<dd><span class="label"><i class="icon-plus-sign"></i> <span id="paramedicospresentes"></span></span></dd>
			<dt><span class="label label-important">Param&eacute;dicos Ausentes </span></dt>
			<dd><span class="label"><i class="icon-plus-sign"></i> <span id="paramedicosausentes"></span></span></dd>
		</dl>-->  

		<dl class="dl-horizontal">
			<dt><span class="label label-info">Guardias Titulares </span></dt>
			<dd><span class="label"><i class="icon-shield"></i> <span id="guardiatitular"></span></span></dd>
			<dt><span class="label label-info">Guardias Reemplazos </span></dt>
			<dd><span class="label"><i class="icon-shield"></i> <span id="guardiareemplazo"></span></span></dd>      
			<dt><span class="label label-info">Guardias Resgitrados </span></dt>
			<dd><span class="label"><i class="icon-shield"></i> <span id="guardiaregistrados"></span></span></dd>
			<dt><span class="label label-info">Guardias Presentes </span></dt>
			<dd><span class="label"><i class="icon-shield"></i> <span id="guardiapresentes"></span></span></dd>
			<dt><span class="label label-important">Guardias Ausentes </span></dt>
			<dd><span class="label"><i class="icon-shield"></i> <span id="guardiasausentes"></span></span></dd>
		</dl>
	</div>
</div>
<script type="text/javascript">
var idPerfil = $("#idPerfil").val();
var idUsuario = $("#idUsuario").val();
//Carga numeros totales
var pagina, div, datos
pagina='personal/personal_numeros.asp';
dv='';
datos='idUsuario='+idUsuario+'&idPerfil='+idPerfil;	

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
	setTimeout(function() {
		renderData(data);

	}, 1000);
}

var renderData = function(objectJson){
$.each(objectJson, function(index, value) {            
	$("#cajerotitular").html(value.cajerotitular);			
	$("#cajeroreemplazo").html(value.cajeroreemplazo);			
	$("#cajeroadicional").html(value.cajeroadicional);			
	$("#cajerosregistrados").html(value.cajerosregistrados);			
	$("#cajerospresentes").html(value.cajerospresentes);			
	$("#cajerosausentes").html(value.cajerosausentes);
	$("#cajerosausentesadi").html(value.cajerosausentesadicionales);
	$("#cajerosausentestitu").html(value.cajerosausentestitulares);

	/*$("#asesortitular").html(value.asesortitular);			
	$("#asesoreemplazo").html(value.asesoreemplazo);			
	$("#asesoresregistrados").html(value.asesoresregistrados);			
	$("#asesorespresentes").html(value.asesorespresentes);			
	$("#asesoresausentes").html(value.asesoresausentes);			
	$("#paramedicotitular").html(value.paramedicotitular);			
	$("#paramedicoreemplazo").html(value.paramedicoreemplazo);			
	$("#paramedicosregistrados").html(value.paramedicosregistrados);						
	$("#paramedicospresentes").html(value.paramedicospresentes);			
	$("#paramedicosausentes").html(value.paramedicosausentes);*/

	$("#guardiatitular").html(value.guardiastitulares);
	$("#guardiareemplazo").html(value.guardiasreemp);
	$("#guardiaregistrados").html(value.guardiasregistrados);
	$("#guardiapresentes").html(value.guardiaspresentes);
	$("#guardiasausentes").html(value.guardiasausentes);

	});     
}
</script>