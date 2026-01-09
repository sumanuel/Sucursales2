<!--#include file="../conexion/conexion.asp"-->
<%periodoSel=trim(request("periodoSel")) 'botones indicadore de SLA Reclamos Cajeros
		
	if periodoSel = 0 then
		sql = ""
		sql = sql & "set dateformat dmy "
		sql = sql & "select z.*, case "
		sql = sql & "when z.id_caso_paso_macro = 5 and z.sla_diff <= z.caso_sla then 'DP'  "
		sql = sql & "when z.id_caso_paso_macro = 5 and z.sla_diff > z.caso_sla then 'FP' "
		sql = sql & "when z.id_caso_paso_macro <> 5 and z.sla_diff < ((z.caso_sla*80)/100) then 'DP' "
		sql = sql & "when z.id_caso_paso_macro <> 5 and z.sla_diff > z.caso_sla then 'FP' "
		sql = sql & "when z.id_caso_paso_macro <> 5 and z.sla_diff >= ((z.caso_sla*80)/100) and z.sla_diff <= z.caso_sla then 'PI' "
		sql = sql & "end SLA "
		sql = sql & "into #temp_SlaCant "
		sql = sql & "from ( "
		sql = sql & "select "
		sql = sql & "E.id_sucursal, E.cod_bantotal, E.suc_nombre, A.id_caso, A.caso_titulo, B.caso_categoria, "
		sql = sql & "C.caso_motivo, isnull(A.caso_creado_por,0) as caso_creado_por, "
		sql = sql & "convert(varchar(12), isnull(A.caso_fecha_cre, getdate()), 105) as caso_fecha_cre, "
		sql = sql & "convert(varchar(12), isnull(A.caso_hora_cre, getdate()), 108) as caso_hora_cre, "
		sql = sql & "convert(varchar(12), isnull(A.caso_fecha_mod, getdate()), 105) as caso_fecha_mod, "
		sql = sql & "convert(varchar(12), isnull(A.caso_hora_mod, getdate()), 108) as caso_hora_mod, "
		sql = sql & "D.caso_paso_macro, D.id_caso_paso_macro, F.proveedor, C.caso_sla, "
		sql = sql & "case "
		sql = sql & "when A.id_caso_paso = 5 and cast(caso_fecha_cre as date) = cast(caso_fecha_mod as date) then "
		sql = sql & "datediff(minute, caso_hora_cre, caso_hora_mod) "
		sql = sql & "when A.id_caso_paso = 5 and cast(caso_fecha_cre as date) < cast(caso_fecha_mod as date) then "
		sql = sql & "datediff(minute, caso_hora_cre, caso_hora_mod ) + datediff(minute, caso_fecha_cre, cast(caso_fecha_mod as date)) "
		sql = sql & "when A.id_caso_paso <> 5 and cast(caso_fecha_cre as date) = cast(getdate() as date) then "
		sql = sql & "datediff(minute, caso_hora_mod, cast(getdate() as time)) "
		sql = sql & "when A.id_caso_paso <> 5 and cast(caso_fecha_cre as date) < cast(getdate() as date) then "
		sql = sql & "datediff(minute, caso_hora_mod, cast(getdate() as time)) + datediff(minute, caso_fecha_cre, cast(getdate() as date)) "
		sql = sql & "end SLA_DIFF "
		sql = sql & "from SUC_casos A "
		sql = sql & "inner join SUC_sucursal E on A.caso_id_sucursal = E.id_sucursal "
		sql = sql & "inner join SUC_sucursal_proveedor F on E.cod_bantotal = F.cod_bantotal "
		sql = sql & "inner join SUC_casos_config_categoria B on A.caso_categoria = B.id_caso_categoria "
		sql = sql & "inner join SUC_casos_config_motivo C on A.caso_motivo = C.id_caso_motivo "
		sql = sql & "inner join SUC_casos_pasos_macro D on A.id_caso_paso = D.id_caso_paso_macro "
		sql = sql & "where A.id_caso_paso not in (5) "
		sql = sql & ") as z "
		sql = sql & "order by z.id_caso desc "
		'sql = sql & " "
		'sql = sql & "select SLA,COUNT(*) as cant_sla "
		'sql = sql & "from #temp_SlaCant "
		'sql = sql & "group by SLA "
		'sql = sql & " "
		'sql = sql & "drop table #temp_SlaCant "
		'response.write(sql)
		'response.end()
	else
		sql = ""
		sql = sql & "set dateformat dmy "
		sql = sql & "select z.*, case "
		sql = sql & "when z.id_caso_paso_macro = 5 and z.sla_diff <= z.caso_sla then 'DP'  "
		sql = sql & "when z.id_caso_paso_macro = 5 and z.sla_diff > z.caso_sla then 'FP' "
		sql = sql & "when z.id_caso_paso_macro <> 5 and z.sla_diff < ((z.caso_sla*80)/100) then 'DP' "
		sql = sql & "when z.id_caso_paso_macro <> 5 and z.sla_diff > z.caso_sla then 'FP' "
		sql = sql & "when z.id_caso_paso_macro <> 5 and z.sla_diff >= ((z.caso_sla*80)/100) and z.sla_diff <= z.caso_sla then 'PI' "
		sql = sql & "end SLA "
		'sql = sql & "into #temp_SlaCant "
		sql = sql & "from ( "
		sql = sql & "select "
		sql = sql & "E.id_sucursal, E.cod_bantotal, E.suc_nombre, A.id_caso, A.caso_titulo, B.caso_categoria, "
		sql = sql & "C.caso_motivo, isnull(A.caso_creado_por,0) as caso_creado_por, "
		sql = sql & "convert(varchar(12), isnull(A.caso_fecha_cre, getdate()), 105) as caso_fecha_cre, "
		sql = sql & "convert(varchar(12), isnull(A.caso_hora_cre, getdate()), 108) as caso_hora_cre, "
		sql = sql & "convert(varchar(12), isnull(A.caso_fecha_mod, getdate()), 105) as caso_fecha_mod, "
		sql = sql & "convert(varchar(12), isnull(A.caso_hora_mod, getdate()), 108) as caso_hora_mod, "
		sql = sql & "D.caso_paso_macro, D.id_caso_paso_macro, F.proveedor, C.caso_sla, "
		sql = sql & "case "
		sql = sql & "when A.id_caso_paso = 5 and cast(caso_fecha_cre as date) = cast(caso_fecha_mod as date) then "
		sql = sql & "datediff(minute, caso_hora_cre, caso_hora_mod) "
		sql = sql & "when A.id_caso_paso = 5 and cast(caso_fecha_cre as date) < cast(caso_fecha_mod as date) then "
		sql = sql & "datediff(minute, caso_hora_cre, caso_hora_mod ) + datediff(minute, caso_fecha_cre, cast(caso_fecha_mod as date)) "
		sql = sql & "when A.id_caso_paso <> 5 and cast(caso_fecha_cre as date) = cast(getdate() as date) then "
		sql = sql & "datediff(minute, caso_hora_mod, cast(getdate() as time)) "
		sql = sql & "when A.id_caso_paso <> 5 and cast(caso_fecha_cre as date) < cast(getdate() as date) then "
		sql = sql & "datediff(minute, caso_hora_mod, cast(getdate() as time)) + datediff(minute, caso_fecha_cre, cast(getdate() as date)) "
		sql = sql & "end SLA_DIFF "
		sql = sql & "from SUC_casos A "
		sql = sql & "inner join SUC_sucursal E on A.caso_id_sucursal = E.id_sucursal "
		sql = sql & "inner join SUC_sucursal_proveedor F on E.cod_bantotal = F.cod_bantotal "
		sql = sql & "inner join SUC_casos_config_categoria B on A.caso_categoria = B.id_caso_categoria "
		sql = sql & "inner join SUC_casos_config_motivo C on A.caso_motivo = C.id_caso_motivo "
		sql = sql & "inner join SUC_casos_pasos_macro D on A.id_caso_paso = D.id_caso_paso_macro "
		sql = sql & ") as z "
		sql = sql & "where CONVERT(nvarchar(6),convert(date,z.caso_fecha_cre),112) = " & periodoSel
		sql = sql & "order by z.id_caso desc "
		'sql = sql & " "
		'sql = sql & "select SLA,COUNT(*) as cant_sla "
		'sql = sql & "from #temp_SlaCant "
		'sql = sql & "group by SLA "
		'sql = sql & " "
		'sql = sql & "drop table #temp_SlaCant "
		'response.write(sql)
		'response.end()
	end if

	tieneDatos = 0
	Sla_DP = 0
	Sla_FP = 0
	Sla_PI = 0

	set rs = db.execute(sql)
	%>	
	<div class="text-center"><span class="label label-info titulo1" style="font-size: 15px">SLA</span></div>
	<% 
	if not rs.EOF then
	''		'response.write(rs)
	''	do while not rs.eof 
	''		response.write(1)
	''		tipo_SLA = trim(rs("SLA"))
	''		cant_SLA = trim(rs("cant_sla"))
''
''			if tipo_SLA = "DP" then
   ''		 		Sla_DP = cant_SLA
  '' 		 	end if
  '' 		 	if tipo_SLA = "PI" then
   ''		 		Sla_PI = cant_SLA
  '' 		 	end if
   ''		 	if tipo_SLA = "FP" then
   ''		 		Sla_FP = cant_SLA
   ''		 	end if

	''		rs.MoveNext
  	''		tieneDatos = 1 
	''	loop
  	''	tieneDatos = 1 
	end if
	if tieneDatos = 1 then 
		%> 
			<div class="row-fluid text-center" title="DP" data-toggle="popover" data-trigger="hover" data-content="Dentro de Plazo">
				<button type="button" class="btn btn-success" id="btnIndicadorReclamosCajerosDP" style="height:100px;width:70px;margin-bottom: 5px;">
					<div style="font-size: 35px"><i class="icon-smile"></i></div>
					<div><%=Sla_DP%></div>
				</button>
			</div>	
			<div class="row-fluid text-center" title="10% time SLA" data-toggle="popover" data-trigger="hover" data-content="faltan un 10% del tiempo de SLA para pasar a Fuera de Plazo">							
				<button type="button" class="btn btn-warning" id="btnIndicadorReclamosCajerosPI" style="height:100px;width:70px;margin-bottom: 5px;">
					<div style="font-size: 35px"><i class="icon-meh"></i></div>
					<div><%=Sla_PI%></div>
				</button>						
			</div>	

			<div class="row-fluid text-center" title="FP" data-toggle="popover" data-trigger="hover" data-content="Fuera de Plazo Casos Criticos">
				<button type="button" class="btn btn-danger" id="btnIndicadorReclamosCajerosFP" style="height:100px;width:70px;margin-bottom: 5px;">
					<div style="font-size: 35px"><i class="icon-frown"></i></div>
					<div><%=Sla_FP%></div>
				</button>							
			</div>

	<% else %>
		<div class="row-fluid text-center" title="DP" data-toggle="popover" data-trigger="hover" data-content="Dentro de Plazo">	
			<button type="button" class="btn btn-success" style="height:100px;width:70px;margin-bottom: 5px;">
				<div style="font-size: 35px"><i class="icon-smile"></i></div>
				<div>0</div>
			</button>
		</div>	
		<div class="row-fluid text-center" title="10% time SLA" data-toggle="popover" data-trigger="hover" data-content="faltan un 10% del tiempo de SLA para pasar a Fuera de Plazo">							
			<button type="button" class="btn btn-warning" style="height:100px;width:70px;margin-bottom: 5px;">
				<div style="font-size: 35px"><i class="icon-meh"></i></div>
				<div>0</div>
			</button>						
		</div>	
		<div class="row-fluid text-center" title="FP" data-toggle="popover" data-trigger="hover" data-content="Fuera de Plazo Casos Criticos">
			<button type="button" class="btn btn-danger" style="height:100px;width:70px;margin-bottom: 5px;">
				<div style="font-size: 35px"><i class="icon-frown"></i></div>
				<div>0</div>
			</button>							
		</div>
	<%end if%>
