<!--#include file="../funciones.asp"-->
<%
idSucursal = trim(request("idSucursal"))
fechaActual = date()
sql = ""
'sql = sql & " set dateformat dmy "
sql = sql & " select id "
sql = sql & " from SUC_encuesta_aseo "
sql = sql & " where id_sucursal = '"&idSucursal&"' "
sql = sql & " and fecha_reg = cast(getdate() as date)"

set rs = db.execute(sql)
if not rs.eof then
	tieneDatos = "1"
	idEncuesta = trim(rs("id"))
	'response.Write("idEncuesta: "& idEncuesta & "<br/>")
else
	tieneDatos = "0"
end if
if tieneDatos = "0" then %>
	<span class="alert alert-info"> La encuesta aún no es respondida por la sucursal</span>
<%else
	'idEncuesta = "3"
	sql= ""
	sql = sql & "select p1, p2,p3,p4,p5,p6,p7,p8 from SUC_encuesta_aseo where id = '"&idEncuesta&"'"
	set rs = db.execute(sql)
	if not rs.eof then
	respuesta1 = server.htmlencode(trim(rs("p1")))
	respuesta2 = server.htmlencode(trim(rs("p2")))
	respuesta3 = server.htmlencode(trim(rs("p3")))
	respuesta4 = server.htmlencode(trim(rs("p4")))
	respuesta5 = server.htmlencode(trim(rs("p5")))
	respuesta6 = server.htmlencode(trim(rs("p6")))
	respuesta7 = server.htmlencode(trim(rs("p7")))
	respuesta8 = server.htmlencode(trim(rs("p8")))%>

	<form class="form-horizontal" id="formEncuestaAseo">
		<div class="control-group">
			<label class="inline well">1.- <strong>&#191;Llegó el servicio de aseo?</strong>
				<span class="alert alert-success pull-right">
					<%=respuesta1%>
				</span>
			</label>
			<label class="inline well">2.- <strong>&#191;Llegó a la hora?   </strong>
				<span class="alert alert-success pull-right">
					<%=respuesta2%>
				</span>
			</label>
			<label class="inline well">3.- <strong>&#191;Tiene materiales de aseo?   </strong>
				<span class="alert alert-success pull-right">
					<%=respuesta3%>
				</span>
			</label>
			<label class="inline well">4.- <strong>&#191;El trabajo realizado es satisfactorio?   </strong>
				<span class="alert alert-success pull-right">
					<%=respuesta4%>
				</span>
			</label>
			<label class="inline well">5.- <strong>El personal de aseo, &#191;tiene problemas de relacionamiento?   </strong>
				<span class="alert alert-success pull-right">
					<%=respuesta5%>
				</span>
			</label>
			<label class="inline well">6.- <strong>El horario en que se realiza el servicio de aseo, &#191;este responde a la necesidad de la sucursal?   </strong>
				<span class="alert alert-success pull-right">
					<%=respuesta6%>
				</span>
			</label>
			<label class="inline well">7.- <strong>Evalue globalmente el servicio de aseo.   </strong>
				<span class="alert alert-success pull-right">
					<%=respuesta7%>
				</span>
			</label>
			<%if respuesta8 <> "" then%>
				<label class="inline well">8.- <strong>Observaciones   </strong>
					<br>
					<br>
					<span class="alert alert-success">
						<%=respuesta8%>
					</span>
				</label>
			<%end if%>
		</div>
	</form>
	<%else%>
		<span class="alert alert-info"> La encuesta aún no es respondida por la sucursal</span>
	<%end if%>
<%end if%>