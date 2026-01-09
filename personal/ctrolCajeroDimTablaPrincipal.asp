<!--#include file="../funciones.asp"-->
<%perfilMain = trim(request("perfilMain"))
idUsuario = trim(request("idUsuario"))
periodo = trim(request("periodo"))
%>


<%sql = ""
sql = sql & " EXEC SCSS_prc_cajeros_dimen_x_periodo '"&periodo&"'"
set rs = db.execute(sql)
if not rs.eof then%>
<style type="text/css"> 
    .cuerpoTabla{
        background: #f2f2f2;
    }              
    .table-hover1>tbody>tr:hover>td, 

    .table-hover1>tbody>tr:hover>th {
       background-color: #FFE49A;
       color:#0d0d0d;
    }
	.table thead {
	  color: #0A090A; 
	  background-color: #D9E8FF; /* Color de fondo de cabecera */
	}
</style>
	<table id="dim" class="table table-bordered table-hover1 table-condensed table-striped cuerpoTabla" data-perfilMain="<%=perfilMain%>" data-idUsuario="<%=idUsuario%>" data-periodo="<%=periodo%>">
		<thead>
			<tr>
				<%for each fld in rs.Fields%>
					 <th><span><%=fld.Name%></span></th>
				<%Next%>
			</tr>
		</thead>
		<tbody>
			<%Do Until rs.EOF%>
				<tr>
	         		<%For Each fld in rs.Fields%>
	           			<td><span><%=server.htmlencode(trim(fld))%></span></td>
	        		<%Next %>
	     	   </tr>
	     	<%rs.MoveNext
     		Loop%>	
		</tbody>
	</table>
<%end if%>

 <script type="text/javascript">
 		$('#dim').dataTable( {
		"sDom": "<'row-flid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
		"sPaginationType": "bootstrap",
		"sLoadingRecords": "Cargando...",
	});
 </script>