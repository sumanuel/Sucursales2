<!--#include file="../funciones.asp"-->
<%
perfil = trim(request("perfilMain"))
idUsuario = trim(request("idUsuarioMain"))
%>
<div class="row-fluid">    
     <a class="btn btn-success " id="descargaInforme" href="#">
        <i class="icon-cloud-download icon-large"></i>
        &nbsp;<span style="font-size:11px;"><b>DESCARGAR</b></span>
    </a>
</div>
<br/>
<div class="row-fluid">
    <div class="span12">
        <table id="tableP" class="table table-bordered table-hover table-condensed table-striped">
            <thead>
            <tr>
                <th><strong>bt</strong></th>
                <th><strong>Sucursal</strong></th>
                <th><strong>Direccion</strong></th>
                <th><strong>Jeps</strong></th>    
                <th><strong>Rut</strong></th>
                <th><strong>Anexo</strong></th>
                <th><strong>Celular</strong></th>    
                <th><strong>Flujo</strong></th>
                <th><strong>Flujo Hora</strong></th>
                <th><strong>Apertura Hora</strong></th>
                <th><strong>Cierre Hora</strong></th>
                <th><strong>Zonal</strong></th>    
                <th><strong>--</strong></th>
            </tr>
            </thead>
            <tbody>
            <%
              
            sql = ""
            sql = sql & " select * from ( "
            sql = sql & " select  "
            sql = sql & " isnull(a.cod_bantotal,'0') as cod_bantotal,"
            sql = sql & " isnull(a.suc_nombre, '') as suc_nombre, "
            sql = sql & " isnull(a.suc_direccion, '') as suc_direccion,"
            sql = sql & " isnull(a.suc_jeps, '') as suc_jeps, "
            sql = sql & " isnull(a.suc_jeps_rut, '') as suc_jeps_rut, "
            sql = sql & " isnull(a.suc_jeps_dv, '') as suc_jeps_dv, "
            sql = sql & " isnull(a.suc_jeps_enexo, '') as suc_jeps_anexo, "
            sql = sql & " isnull(a.suc_jeps_celular, '') as suc_jeps_celular, "
            sql = sql & " isnull(a.suc_zonal_ext, '') as suc_zonal_ext, "
            sql = sql & " isnull(a.suc_zonal_jefe, '') as suc_zonal_jefe, "
            sql = sql & " isnull(z.situacion, '') as situacion, "
            sql = sql & " convert(varchar(5),isnull(z.hora, '00:00:00')) as hora, "
            sql = sql & " isnull(a.suc_estado, 0) as suc_estado, "
            sql = sql & " convert(varchar(5),isnull(b.hora_ingreso, '00:00:00')) as hora_apertura, "
            sql = sql & " convert(varchar(5),isnull(b2.hora_ingreso, '00:00:00')) as hora_cierre "
            sql = sql & " from SUC_sucursal a left join"
            sql = sql & " (select * from SUC_desbordes a where a.fecha = cast(getdate() as date) and hora ="
            sql = sql & " (select MAX(c.hora) from SUC_desbordes c where c.id_sucursal = a.id_sucursal and a.fecha = c.fecha)) "
            sql = sql & " as z on a.id_sucursal = z.id_sucursal left join "
            sql = sql & " SUC_sucursal_apertura b on a.id_sucursal = b.id_sucursal and b.tipo = 1  "
            sql = sql & " and b.fecha_ingreso = cast(GETDATE() as date) left join SUC_sucursal_apertura b2 on "
            sql = sql & " a.id_sucursal = b2.id_sucursal and b2.tipo = 2 and b2.fecha_ingreso = "
            sql = sql & " cast(GETDATE() as date) ) as x where x.suc_estado = 1"
            'sql = sql & "order by x.suc_nombre "
            'sql = sql & "order by x.suc_zonal_jefe, x.suc_zonal_ext

            'response.Write(sql)
            'response.end

              set rs = db.execute(sql)
              if not rs.eof then    
                do while not rs.eof
                
                  bt_sucursal = trim(rs("cod_bantotal"))
                  suc_nombre = server.htmlencode(trim(rs("suc_nombre")))
                  suc_direccion = server.htmlencode(trim(rs("suc_direccion")))
                  suc_jeps = server.htmlencode(trim(rs("suc_jeps")))
                  suc_jeps_rut = server.htmlencode(trim(rs("suc_jeps_rut")))
                  suc_jeps_dv = server.htmlencode(trim(rs("suc_jeps_dv")))
                  suc_jeps_anexo = server.htmlencode(trim(rs("suc_jeps_anexo")))
                  suc_jeps_celular = server.htmlencode(trim(rs("suc_jeps_celular")))
                  situacion = server.htmlencode(trim(rs("situacion")))
                  hora = server.htmlencode(trim(rs("hora")))
                  hora_apertura = server.htmlencode(trim(rs("hora_apertura")))
                  hora_cierre = server.htmlencode(trim(rs("hora_cierre")))
                  zonal = server.htmlencode(trim(rs("suc_zonal_ext")))
                  zonal_jefe = server.htmlencode(trim(rs("suc_zonal_jefe")))
                  
            %>    
                <tr>
                    <td><%=bt_sucursal%></td>
                    <td><%=suc_nombre%></td>
                    <td><%=suc_direccion%></td>
                    <td><%=suc_jeps%></td>
                    <td><%=suc_jeps_rut%>-<%=suc_jeps_dv%></td>        
                    <td><%=suc_jeps_anexo%></td>
                    <td><%=suc_jeps_celular%></td>
                    <td>
                        <% if situacion = "Nadie" then %>           
                            <span class="label">Nadie</span>
                        <% end if %>
                        <% if situacion = "1/4" then %>         
                            <span class="label label-success">1/4</span>
                        <% end if %>
                        <% if situacion = "1/2" then %>         
                            <span class="label label-success">1/2</span>
                        <% end if %>
                        <% if situacion = "3/4" then %>         
                            <span class="label label-warning">3/4</span>
                        <% end if %>
                        <% if situacion = "Desborde" then %>            
                            <span class="label label-important">Desborde</span>
                        <% end if %>
                        <% if situacion = "Full" then %>            
                            <span class="label label-important">Full</span>
                        <% end if %>   
                    </td>        
                    <td><%=hora%></td>
                    <td><%=hora_apertura%></td>
                    <td><%=hora_cierre%></td>
                    <td><%=zonal%></td>
                    <td><%=zonal_jefe%></td>        
                </tr>
              <%
              
              rs.MoveNext
              Loop    

              end if 
            %>
            </tbody>
            </table>        
    </div>
</div>


<link href="css/tablaSort.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="js/jquery.dataTables.js"></script>
<script type="text/javascript" src="js/jquery.dataTables.bootstrap.js"></script>
<script>
$(document).ready(function (){
	$('#tableP').dataTable( {
		"sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
		"sPaginationType": "bootstrap",
		"aaSorting": [[ 1, "asc" ]],
		"iDisplayLength": 25,
		"oLanguage": {
			"sLengthMenu": "_MENU_ registros por página",
			"sProcessing":     "Procesando...",
			"sZeroRecords":    "No se encontraron resultados",
			"sEmptyTable":     "Ningún dato disponible en esta tabla",
			"sInfo":           "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
			"sInfoEmpty":      "Mostrando registros del 0 al 0 de un total de 0 registros",
			"sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
			"sInfoPostFix":    "",
			"sSearch":         "Buscar:",
			"sUrl":            "",
			"sInfoThousands":  ",",
			"sLoadingRecords": "Cargando...",
			"oPaginate": {
				"sFirst":    "Primero",
				"sLast":     "Último",
				"sNext":     "Siguiente",
				"sPrevious": "Anterior"
			},
			"oAria": {
				"sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
				"sSortDescending": ": Activar para ordenar la columna de manera descendente"
			}
		},
	});	
});
$('#descargaInforme').click(function(){
    location.href='sucursales/listaSucursales_detalleExcell.asp?perfil=<%=perfil%>&idUsuario=<%=idUsuario%>'
});
</script>