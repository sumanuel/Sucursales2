<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../conexion/conexion.asp"-->
<% 
idSucursal = ""
idSucursal=request("idSucursal")
if idSucursal = "" then
	idSucursal = request("idSucursal")
end if 

'Response.Write("idSucursal: " & idSucursal)

dotacion =""
dotacion = dotacion & "select a.id_sucdot, b.tipo, a.rut, a.dv, a.nombres, a.apep, a.apem, c.cargo, a.anexo, d.zona, e.zonal, a.id_sucursal_dest, f.suc_nombre, a.detalle "
dotacion = dotacion & "from SUC_sucursal_dotacion a "
dotacion = dotacion & "inner join SUC_sucursal_dotacion_tipo b on a.tipo = b.id_tipo "
dotacion = dotacion & "inner join SUC_sucursal_dotacion_cargos c on a.cargo = c.id_cargo "
dotacion = dotacion & "left outer join SUC_sucursal_dotacion_zonas d on a.zona = d.id_zona "
dotacion = dotacion & "left outer join SUC_sucursal_dotacion_zonales e on a.zonal = e.id_zonal "
dotacion = dotacion & "left outer join SUC_sucursal f on a.id_sucursal_dest = f.id_sucursal "
dotacion = dotacion & "where a.id_sucursal = "& idSucursal &" "
dotacion = dotacion & "order by a.id_sucdot "
Set rsDotacion = DB.execute(dotacion)

%>
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
            alert(source);								
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
<%
rsDotacion.Close
set rsDotacion.ActiveConnection = nothing
set rsDotacion=nothing

DB.Close
set DB=nothing	
%>