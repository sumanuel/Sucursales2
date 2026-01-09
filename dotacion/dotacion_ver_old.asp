<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<% 
idSucursal = ""
idSucursal=request("idSucursal")  
'response.Write(idSucursal)
'response.End()

if idSucursal="" then
%>
	<div class="row-fluid">
        <span class="span12 alert alert-danger">
        <strong><h4><span id="loadIcon" style="display:none;"><i class="icon-spinner icon-spin icon-large"></i></span> <span class="icon-stack icon-large"><i class="icon-check-empty icon-stack-base"></i><i class="icon-group"></i></span> Seleccione una Sucursal</h4></strong>
        </span>
    </div>
<%
else

'dotacion ="select a.id_dotacion,a.bt,CASE WHEN a.bt<>'' THEN (select nombre_sucursal from sucursales.dbo.sucursales where bt_sucursal=a.bt) ELSE '---' END as bt_nombre,a.rut,a.dv,CASE WHEN a.nombres<>'' THEN a.nombres+' '+a.apep+' '+a.apem ELSE '---' END as nombre,b.cargo,CASE WHEN a.anexo<>'' THEN a.anexo ELSE '---' END as anexo,CASE WHEN a.zonal<>'' THEN (select zonal from DOTA_zonales where id_zonal=a.zonal) ELSE '---' END as zonal,CASE WHEN a.zona<>'' THEN (select zona from DOTA_zonas where id_zona=a.zona) ELSE '---' END as zona,c.tipo,CASE WHEN a.sucursal<>'' THEN (select nombre_sucursal from sucursales.dbo.sucursales where bt_sucursal=a.sucursal) ELSE '---' END as sucursal,CASE WHEN a.detalle<>'' THEN a.detalle ELSE '---' END as detalle from DOTA_dotacion a join DOTA_cargos b on a.cargo=b.id_cargo join DOTA_tipos c on a.tipo=c.id_tipo where a.bt="&bt_sucursal&" and a.est_reg=1"
dotacion =""
dotacion = dotacion & "select a.id_sucdot, b.tipo, a.rut, a.dv, a.nombres, a.apep, a.apem, c.cargo, a.anexo, d.zona, e.zonal, a.id_sucursal_dest, f.suc_nombre, a.detalle "
dotacion = dotacion & "from SUC_sucursal_dotacion a "
dotacion = dotacion & "inner join SUC_sucursal_dotacion_tipo b on a.tipo = b.id_tipo "
dotacion = dotacion & "inner join SUC_sucursal_dotacion_cargos c on a.cargo = c.id_cargo "
dotacion = dotacion & "left outer join SUC_sucursal_dotacion_zonas d on a.zona = d.id_zona "
dotacion = dotacion & "left outer join SUC_sucursal_dotacion_zonales e on a.zonal = e.id_zonal "
dotacion = dotacion & "left outer join SUC_sucursal f on a.id_sucursal_dest = f.id_sucursal "
dotacion = dotacion & "where a.id_sucursal = "& idSucursal &" and a.fecha_ingreso = cast(GETDATE() as date) "
dotacion = dotacion & "order by a.id_sucdot "
Set rsDotacion = DB.execute(dotacion)
'response.Write(dotacion & "<br/>")

dotDerivada = ""
dotDerivada = dotDerivada & "select a.id_sucdot, a.id_sucursal, b.tipo, a.rut, a.dv, a.nombres, a.apep, a.apem, c.cargo, a.anexo, d.zona, e.zonal, a.id_sucursal_dest, f.suc_nombre, a.detalle "
dotDerivada = dotDerivada & "from SUC_sucursal_dotacion a "
dotDerivada = dotDerivada & "inner join SUC_sucursal_dotacion_tipo b on a.tipo = b.id_tipo "
dotDerivada = dotDerivada & "inner join SUC_sucursal_dotacion_cargos c on a.cargo = c.id_cargo "
dotDerivada = dotDerivada & "left outer join SUC_sucursal_dotacion_zonas d on a.zona = d.id_zona "
dotDerivada = dotDerivada & "left outer join SUC_sucursal_dotacion_zonales e on a.zonal = e.id_zonal "
dotDerivada = dotDerivada & "left outer join SUC_sucursal f on a.id_sucursal_dest = f.id_sucursal "
dotDerivada = dotDerivada & "where a.id_sucursal_dest = "& idSucursal &" and a.fecha_ingreso = cast(GETDATE() as date) "
dotDerivada = dotDerivada & "order by a.id_sucdot"
Set rsDotDerivada = DB.execute(dotDerivada)
'response.Write(dotDerivada & "<br/>")

tipos ="select * from dbo.SUC_sucursal_dotacion_tipo where est_reg=1"
set rsTipos = DB.execute(tipos)

arr_ruts = "select rut from SUC_sucursal_dotacion where id_sucursal = "& idSucursal &" and fecha_ingreso = CAST(getdate() as date) and rut <> '' "
set rsRuts = DB.execute(arr_ruts)

arr_validRut = ""
while not rsRuts.Eof
	arr_validRut = arr_validRut & rsRuts("rut")	& ";"
rsRuts.MoveNext
wend
if not arr_validRut = "" then
	arr_validRut = Mid(arr_validRut, 1, (len(arr_validRut)-1))
end if 

%>
<div class="row-fluid span12 well">
    <div class="row-fluid">    	
        <span class="span12 alert alert-success">
        <strong><h4><span id="loadIcon" style="display:none;"><i class="icon-spinner icon-spin icon-large"></i></span> <span class="icon-stack icon-large"><i class="icon-check-empty icon-stack-base"></i><i class="icon-group"></i></span> Dotaci&oacute;n</h4></strong>
        </span>        
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
                    <!--<th width=""><b>Suc. Asig.</b></th>-->                    
                    <th width=""><b>Detalle</b></th>
                    <!--<th width=""><b><i class="icon-trash icon-large"></i></b></th>-->
                </tr>
            </thead> 
            <tbody> 
                <% while not rsDotacion.Eof %>
                    <tr align="center" id="dotRow<%=rsDotacion("id_sucdot")%>">
                        <td><%=rsDotacion("id_sucdot")%></td>
                        <td><%=rsDotacion("tipo")%></td>
                        <td id="dotRowRut<%=rsDotacion("id_sucdot")%>"><%=rsDotacion("rut")%>-<%=rsDotacion("dv")%></td>
                        <td><%=rsDotacion("nombres")%></td>
                        <td><%=rsDotacion("cargo")%></td>
                        <td><%=rsDotacion("anexo")%></td>
                        <td><%=rsDotacion("zona")%></td>
                        <td><%=rsDotacion("zonal")%></td>
                        <!--<td><%'=rsDotacion("suc_nombre")%></td>-->
                        <td><i id="<%=rsDotacion("id_sucdot")%>" class="detailDot icon-file-text-alt icon-large mano"></i></td>
                        <!--<td><i id="<%'=rsDotacion("id_sucdot")%>" class="dropDot icon-trash icon-large mano"></i></td>-->
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
						alert(source);								
					}
				});	
				$('#mDot').modal()
			}); 
		</script>     
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
                        <!--<th width=""><b>Detalle</b></th>-->
                    </tr>
                </thead>                 
                <tbody>  
                <% while not rsDotDerivada.Eof %>                  
                        <tr align="center" id="dotRow<%=rsDotDerivada("id_sucdot")%>">
                            <td><%=rsDotDerivada("id_sucdot")%></td>
                            <td><%=rsDotDerivada("tipo")%></td>
                            <td id="dotRowRut<%=rsDotDerivada("id_sucdot")%>"><%=rsDotDerivada("rut")%>-<%=rsDotDerivada("dv")%></td>
                            <td><%=rsDotDerivada("nombres")%></td>
                            <td><%=rsDotDerivada("cargo")%></td>
                            <td><%=rsDotDerivada("anexo")%></td>
                            <td><%=rsDotDerivada("zona")%></td>
                            <td><%=rsDotDerivada("zonal")%></td>
                            <td><%=rsDotDerivada("suc_nombre")%></td>
                            <!--<td><i id="<%'=rsDotDerivada("id_sucdot")%>" class="detailDot icon-file-text-alt icon-large mano"></i></td>-->
                        </tr>
                 <% rsDotDerivada.MoveNext 
                wend %>                        
                </tbody>
            </table>
        </div>
    </div>
</div> 
<% 	
	rsDotacion.Close
	set rsDotacion.ActiveConnection = nothing
	set rsDotacion=nothing
	
	rsDotDerivada.Close
	set rsDotDerivada.ActiveConnection = nothing
	set rsDotDerivada = nothing

	DB.Close
	set DB=nothing	
	end if 
%>