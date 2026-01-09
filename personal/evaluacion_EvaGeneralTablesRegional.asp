
<!--#include file="../funciones.asp"-->
<%
per = trim(request("periodo"))

sql = "exec SUC_prc_eva_get_regional "&per

'response.write(sql)
'response.end()

set rs = db.execute(sql)
%>
<table class="table table-bordered table-condensed" style="border-bottom: 2px solid">
	<thead style="background-color: #e6f2ff; ">
		<th style="border-bottom: 1px solid; border-top: 2px solid; border-left: 2px solid;">Nombre</th>
		<th style="border-bottom: 1px solid; border-top: 2px solid; border-left: 1px solid;">Buenos</th>
		<th style="border-bottom: 1px solid; border-top: 2px solid; border-left: 1px solid;">Normal</th>
		<th style="border-bottom: 1px solid; border-top: 2px solid; border-left: 1px solid;border-right: 2px solid;">Malos</th>
	</thead>
	<tbody >
		<% if not rs.eof then		
			do while not rs.eof 	
				nombre = rs("NOMBRE")
				buenos = rs("BUENO") 
				regular = rs("NORMAL") 
				malos = rs("MALO")
				%>
				<tr>												
					<td style="border-left: 2px solid;"><%=nombre%></td>
					<td style="border-left: 1px solid;" ><%=buenos%></td>
					<td style="border-left: 1px solid;" ><%=regular%></td>
					<td style="border-right: 2px solid;border-left: 1px solid;" ><%=malos%></td>
				</tr>
				<%
				rs.MoveNext
				loop
		   end if
		%>
	</tbody>
</table>

