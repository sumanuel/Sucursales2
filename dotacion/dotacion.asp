<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<% 
idSucursal=request("idSucursalMain")  
'response.Write("idSucursal: " & idSucursal)
'response.End()

if idSucursal="" then
%>
	<div class="row-fluid">
        <span class="span12 alert alert-danger">
        <strong><h4><span id="loadIcon" style="display:none;"><i class="icon-spinner icon-spin icon-large"></i></span> <span class="icon-stack icon-large"><i class="icon-check-empty icon-stack-base"></i><i class="icon-group"></i></span> Seleccione una Sucursal</h4></strong>
        </span>
    </div>
<%else

'dotacion ="select a.id_dotacion,a.bt,CASE WHEN a.bt<> '' THEN (select nombre_sucursal from sucursales.dbo.sucursales where bt_sucursal=a.bt) ELSE '---' END as bt_nombre,a.rut,a.dv,CASE WHEN a.nombres<>'' THEN a.nombres+' '+a.apep+' '+a.apem ELSE '---' END as nombre,b.cargo,CASE WHEN a.anexo<>'' THEN a.anexo ELSE '---' END as anexo,CASE WHEN a.zonal<>'' THEN (select zonal from DOTA_zonales where id_zonal=a.zonal) ELSE '---' END as zonal,CASE WHEN a.zona<>'' THEN (select zona from DOTA_zonas where id_zona=a.zona) ELSE '---' END as zona,c.tipo,CASE WHEN a.sucursal<>'' THEN (select nombre_sucursal from sucursales.dbo.sucursales where bt_sucursal=a.sucursal) ELSE '---' END as sucursal,CASE WHEN a.detalle<>'' THEN a.detalle ELSE '---' END as detalle from DOTA_dotacion a join DOTA_cargos b on a.cargo=b.id_cargo join DOTA_tipos c on a.tipo=c.id_tipo where a.bt="&bt_sucursal&" and a.est_reg=1"
dotacion =""
dotacion = dotacion & " select a.id_sucdot, "
dotacion = dotacion & " b.tipo, "
dotacion = dotacion & " a.rut, "
dotacion = dotacion & " a.dv, "
dotacion = dotacion & " a.nombres, "
dotacion = dotacion & " a.apep, "
dotacion = dotacion & " a.apem, "
dotacion = dotacion & " c.cargo, "
dotacion = dotacion & " a.anexo, "
dotacion = dotacion & " d.zona, "
dotacion = dotacion & " e.zonal, "
dotacion = dotacion & " a.id_sucursal_dest, "
dotacion = dotacion & " f.suc_nombre, "
dotacion = dotacion & " a.detalle "
dotacion = dotacion & "from SUC_sucursal_dotacion a "
dotacion = dotacion & "inner join SUC_sucursal_dotacion_tipo b on a.tipo = b.id_tipo "
dotacion = dotacion & "inner join SUC_sucursal_dotacion_cargos c on a.cargo = c.id_cargo "
dotacion = dotacion & "left outer join SUC_sucursal_dotacion_zonas d on a.zona = d.id_zona "
dotacion = dotacion & "left outer join SUC_sucursal_dotacion_zonales e on a.zonal = e.id_zonal "
dotacion = dotacion & "left outer join SUC_sucursal f on a.id_sucursal_dest = f.id_sucursal "
dotacion = dotacion & "where a.id_sucursal = "& idSucursal &" "
'dotacion = dotacion & "and a.fecha_ingreso = cast(GETDATE() as date) "
dotacion = dotacion & "order by a.id_sucdot "
Set rsDotacion = DB.execute(dotacion)

dotDerivada = ""
dotDerivada = dotDerivada & "select a.id_sucdot, a.id_sucursal, b.tipo, a.rut, a.dv, a.nombres, a.apep, a.apem, c.cargo, a.anexo, d.zona, e.zonal, a.id_sucursal_dest, f.suc_nombre, a.detalle "
dotDerivada = dotDerivada & "from SUC_sucursal_dotacion a "
dotDerivada = dotDerivada & "inner join SUC_sucursal_dotacion_tipo b on a.tipo = b.id_tipo "
dotDerivada = dotDerivada & "inner join SUC_sucursal_dotacion_cargos c on a.cargo = c.id_cargo "
dotDerivada = dotDerivada & "left outer join SUC_sucursal_dotacion_zonas d on a.zona = d.id_zona "
dotDerivada = dotDerivada & "left outer join SUC_sucursal_dotacion_zonales e on a.zonal = e.id_zonal "
dotDerivada = dotDerivada & "left outer join SUC_sucursal f on a.id_sucursal_dest = f.id_sucursal "
dotDerivada = dotDerivada & "where a.id_sucursal_dest = "& idSucursal &" "
'dotDerivada = dotDerivada & "and a.fecha_ingreso = cast(GETDATE() as date) "
dotDerivada = dotDerivada & "order by a.id_sucdot"
Set rsDotDerivada = DB.execute(dotDerivada)

'Response.Write(dotacion)

tipos ="select * from dbo.SUC_sucursal_dotacion_tipo where est_reg=1"
set rsTipos = DB.execute(tipos)

arr_ruts = "select rut from SUC_sucursal_dotacion where id_sucursal = "& idSucursal &" and fecha_ingreso = CAST(getdate() as date) and rut <> '' "
arr_ruts = arr_ruts & "union select rut from SUC_sucursal_dotacion where id_sucursal_dest = 147 and fecha_ingreso = CAST(getdate() as date) and rut <> '' "
set rsRuts = DB.execute(arr_ruts)
'Response.Write(arr_ruts & "<br/>")

arr_validRut = ""
while not rsRuts.Eof
	arr_validRut = arr_validRut & rsRuts("rut")	& ";"
rsRuts.MoveNext
wend
if not arr_validRut = "" then
	arr_validRut = Mid(arr_validRut, 1, (len(arr_validRut)-1))
end if 
'response.write(dotDerivada)

%>
<div class="row-fluid span12">
<input type="hidden" name="idSucursal" id="idSucursal" value="<%=idSucursal%>" />
    <div class="row-fluid">    	
        <span class="span12 alert alert-success">
        <strong><h4><span id="loadIcon" style="display:none;"><i class="icon-spinner icon-spin icon-large"></i></span> <span class="icon-stack icon-large"><i class="icon-check-empty icon-stack-base"></i><i class="icon-group"></i></span> Ingreso Dotaci&oacute;n</h4></strong>
        </span>        
    </div>
    <div class="row-fluid">
    	<div class="span12">
            <strong>Favor seleccionar un Tipo</strong>&nbsp;
            <select name="slcTipo" id="slcTipo">
                <option value="0">Seleccione...</option>            
                <% do while not rsTipos.EOF %>
                <option value="<% response.Write(rsTipos("id_tipo")) %>"><% response.Write(rsTipos("tipo")) %></option>
                <% rsTipos.MoveNext
                loop %>
            </select>
            <input type="hidden" name="tipoDot" id="tipoDot" value=""/>
        </div>
    </div>   

    <script type="text/javascript">
    	$('#slcTipo').change(function(){
			var pagina = 'dotacion/tipo_dotacion.asp';
			var div = 'formsIng';
			var datos = '';
			if(this.value != '0'){
				datos = 'tipo=' + this.value;
				enviaDatos(pagina, div, datos);
				$("#tipoDot").val(this.value);
				$('#formsIng').fadeIn('slow');
			}
            else
            {
                $('#formsIng').fadeOut('fast');
            }
		});
    </script>
    <br/>

    <div class="row-fluid" id="alertaRut" style="display:none">
	    <div class="span12">
        	<span class="span12 alert">
            	<h4>El Rut ya existe en la dotaci&oacute;n</h4>
                <span><strong>Tips:</strong></span> 
                <ol>
                    <li>Revisa si la dotaci&oacute;n ya existe en la lista de Titulares o Derivadas.</li>
                    <li>Si la dotaci&oacute;n existe como Derivada comun&iacute;cate con tu Zonal para verificar la asignaci&oacute;n.</li>                	
                </ol>
            </span>
        </div>
    </div>
    <div class="row-fluid">
    	<div class="span12 well" id="formsIng">formularios de ingreso</div>        
    </div>    
    <div class="row-fluid" id="idTablaDotacion">
    	<div class="span12">
        <span><h6>Dotaci&oacute;n Titular</h6></span>
    	<table class="table table-bordered table-hover pagination-centered">
            <thead> 
                <tr align="center">
                    <th width=""><b>ID</b></th>
                    <th width="" align="left"><b>Tipo</b></th>
                    <th align="left"><b>Rut</b></th>
                    <th align="left"><b>Nombre</b></th>
                    <th width=""><b>Cargo</b></th>
                    <th width=""><b>Anexo</b></th>
                    <th width=""><b>Zona</b></th>
                    <th><b>Zonal</b></th>
                    <th width=""><b>Suc. Asig.</b></th>
                    <th width=""><b>Detalle</b></th>
                    <th width=""><b><i class="icon-trash icon-large"></i></b></th>
                </tr>
            </thead> 
            <tbody> 
                <% while not rsDotacion.Eof %>
                    <tr align="center" id="dotRow<%=rsDotacion("id_sucdot")%>">
                        <td><%=rsDotacion("id_sucdot")%></td>
                        <td><%=rsDotacion("tipo")%></td>
                        <td id="dotRowRut<%=rsDotacion("id_sucdot")%>"><%=rsDotacion("rut")%>-<%=rsDotacion("dv")%></td>
                        <td><%=server.HTMLEncode(rsDotacion("nombres"))%>&nbsp;<%=server.HTMLEncode(rsDotacion("apep"))%>&nbsp;<%=server.HTMLEncode(rsDotacion("apem"))%></td>
                        <td><%=rsDotacion("cargo")%></td>
                        <td><%=rsDotacion("anexo")%></td>
                        <td><%=rsDotacion("zona")%></td>
                        <td><%=rsDotacion("zonal")%></td>
                        <td><%=rsDotacion("suc_nombre")%></td>
                        <td><i id="<%=rsDotacion("id_sucdot")%>" class="detailDot icon-file-text-alt icon-large mano"></i></td>
                        <td><i id="<%=rsDotacion("id_sucdot")%>" class="dropDot icon-trash icon-large mano"></i></td>
                    </tr>
                    <% rsDotacion.MoveNext 
                wend %>
            </tbody>
        </table>

        <script type="text/javascript">
        	$('.detailDot').click(function(){
				var datos = '';
				datos += 'q=2&';
				datos += 'idsucdot=' + this.id;
				
				var  executeDetalle = $.ajax({
					url: 'dotacion/dotacion_ingreso.asp',
					data: datos,
					type: "GET",
					dataType: "html",
					cache:false,
					//async:true,
					timeout:120000,
					success: function(source){						
						$('#idDetDot').html('');
						$('#idDetDot').html(source);						
					},
					error: function(source){
				
					}
				});	
				$('#mDot').modal()
			});
			$('.dropDot').click(function(){								
				if(confirm('Confirme eliminacion de dotacion seleccionada.')){
					var dotRow = this.id;
					var dotRowRut = 'dotRowRut' + this.id;
					var datos = '';
					datos += 'q=3&';
					datos += 'idsucdot=' + dotRow;
					
					var delRut = $('#' + dotRowRut).text();
					delRut = delRut.substring(0,(delRut.length)-2);
					var rutIngresados = $('#arrValidRuts').val();					
					rutIngresados = rutIngresados.replace(delRut, '');
					rutIngresados = rutIngresados.replace(';;', ';');
					
					if (rutIngresados.length > 0){						
						if(rutIngresados.substring((rutIngresados.length)-1) == ';'){							
							rutIngresados = rutIngresados.substring(0,(rutIngresados.length)-1);
							$('#arrValidRuts').val(rutIngresados);
						}
						if(rutIngresados.substring(0, 1) == ';'){							
							rutIngresados = rutIngresados.substring(1, rutIngresados.length);	
							$('#arrValidRuts').val(rutIngresados);
						}
						if((rutIngresados.substring((rutIngresados.length)-1) != ';') && (rutIngresados.substring(0, 1) != ';')){
							$('#arrValidRuts').val(rutIngresados);
						}		
					}else{
						$('#arrValidRuts').val('');
					}
					
					var  executeDel = $.ajax({
						url: 'dotacion/dotacion_ingreso.asp',
						data: datos,
						type: "GET",
						dataType: "text",
						cache:false,
						//async:true,
						timeout:120000,
						success: function(source){
							$('#dotRow' + dotRow).remove();						
						},
						error: function(source){
							alert(source);								
						}
					});	
				}
			});
        </script>
        </div>
    </div> 

    <div class="row-fluid" id="idTablaDotacionDerivada">
    	<div class="span12">
        	<span><h6>Dotaci&oacute;n Derivada</h6></span>
        	<table class="table table-bordered table-hover pagination-centered">
                <thead> 
                    <tr align="center">
                        <th width=""><b>ID</b></th>
                        <th width="" align="left"><b>Tipo</b></th>
                        <th align="left"><b>Rut</b></th>
                        <th align="left"><b>Nombre</b></th>
                        <th width=""><b>Cargo</b></th>
                        <th width=""><b>Anexo</b></th>
                        <th width=""><b>Zona</b></th>
                        <th><b>Zonal</b></th>
                        <th width=""><b>Suc. Asig.</b></th>
                        <th width=""><b>Detalle</b></th>                        
                    </tr>
                </thead>                 
                <tbody>  
                <% while not rsDotDerivada.Eof %>                  
                        <tr align="center" id="dotRow<%=rsDotDerivada("id_sucdot")%>">
                            <td><%=rsDotDerivada("id_sucdot")%></td>
                            <td><%=rsDotDerivada("tipo")%></td>
                            <td id="dotRowRut<%=rsDotDerivada("id_sucdot")%>"><%=rsDotDerivada("rut")%>-<%=rsDotDerivada("dv")%></td>
                            <td><%=server.HTMLEncode(rsDotDerivada("nombres"))%>&nbsp;<%=server.HTMLEncode(rsDotDerivada("apep"))%>&nbsp;<%=server.HTMLEncode(rsDotDerivada("apem"))%></td>
                            <td><%=rsDotDerivada("cargo")%></td>
                            <td><%=rsDotDerivada("anexo")%></td>
                            <td><%=rsDotDerivada("zona")%></td>
                            <td><%=rsDotDerivada("zonal")%></td>
                            <td><%=rsDotDerivada("suc_nombre")%></td>
                            <td><i id="<%=rsDotDerivada("id_sucdot")%>" class="detailDot icon-file-text-alt icon-large mano"></i></td>                            
                        </tr>
                 <% rsDotDerivada.MoveNext 
                wend %>                        
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal -->
<div id="mDot" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="mDotLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel">Detalle Dotaci&oacute;n</h3>
  </div>
  <div class="modal-body" id="idDetDot">
    
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Cerrar</button>    
  </div>
</div>
<br/>
<input type="hidden" name="arrValidRuts" id="arrValidRuts" value="<%=arr_validRut%>"/>
<input name="btSucursal" type="hidden" value="" id="btnSucursal" />

<script type="text/javascript">
$(function(){
    $('#formsIng').slideUp('fast');
});
  /*	function enviaDatos(pagina,div,datos)
	{
		var rand = '&v='+ Math.random() * 999
		var ajaxobject = $.ajax(
		{
			type:'GET',
			url:pagina,
			cache:false,
			//async:true,
			global:false,
			dataType:"html",
			data:datos+rand,
			timeout:10000,
			success:function(contenido)
			{
				$('#'+div).html(contenido);
			}
		});
		if(ajaxobject == undefined)
		alert('Problemas en la generacion del objeto');
		return false;
	}*/
  </script>
  
<% 	
	
	end if 
%>