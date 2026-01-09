<%
' Última actualización: 2025-12-03 17:30:00
'=================================================================================
' Funciones para validar días hábiles y plazos de carga
'=================================================================================

' Función para convertir fecha desde formato del CSV
' IMPORTANTE: Determinar el formato correcto según tu CSV
Function convertirFechaCSV(fechaStr)
    Dim partes, dia, mes, anio, fechaResultado
    
    On Error Resume Next
    
    ' Si viene con guiones (01-12-2025), convertir a barras
    fechaStr = Replace(fechaStr, "-", "/")
    
    ' Dividir por /
    partes = Split(fechaStr, "/")
    
    If UBound(partes) = 2 Then
        ' CAMBIO IMPORTANTE: Formato DD/MM/YYYY (Europeo)
        ' Si tu CSV usa formato americano MM/DD/YYYY, cambia el orden
        dia = CInt(partes(0))      ' Primer número = DÍA
        mes = CInt(partes(1))      ' Segundo número = MES  
        anio = CInt(partes(2))     ' Tercer número = AÑO
        
        ' Crear fecha en formato correcto
        fechaResultado = DateSerial(anio, mes, dia)
        
        If Err.Number <> 0 Then
            convertirFechaCSV = Null
            Err.Clear
        Else
            convertirFechaCSV = fechaResultado
        End If
    Else
        ' Intentar conversión directa
        convertirFechaCSV = CDate(fechaStr)
        If Err.Number <> 0 Then
            convertirFechaCSV = Null
            Err.Clear
        End If
    End If
    
    On Error GoTo 0
End Function

' Función para obtener una configuración desde la base de datos
Function obtenerConfiguracion(grupo, clave, valorPorDefecto)
    Dim sql, rs, valor
    
    On Error Resume Next
    
    ' Agregar timestamp para evitar caché
    sql = "SELECT TOP 1 conf_valor FROM SUC_configuraciones WITH (NOLOCK) " & _
          "WHERE conf_grupo = '" & grupo & "' AND conf_clave = '" & clave & "' AND activo = 1"
    
    Set rs = db.execute(sql)
    
    If Err.Number <> 0 Then
        ' Si hay error, retornar valor por defecto
        valor = valorPorDefecto
        Err.Clear
    ElseIf rs.EOF Then
        ' Si no existe registro, retornar valor por defecto
        valor = valorPorDefecto
    Else
        ' Obtener valor y asegurarse de que sea válido
        valor = Trim(CStr(rs("conf_valor")))
        If valor = "" Or Not IsNumeric(valor) Then
            valor = valorPorDefecto
        End If
    End If
    
    If Not rs Is Nothing Then
        If Not rs.EOF Then rs.Close
        Set rs = Nothing
    End If
    On Error GoTo 0
    
    obtenerConfiguracion = valor
End Function

' Función para verificar si una fecha es día hábil (de lunes a viernes, sin feriados)
Function esDiaHabil(fecha)
    Dim diaSemana
    diaSemana = Weekday(fecha)
    
    ' Si es sábado (7) o domingo (1), no es día hábil
    If diaSemana = 1 Or diaSemana = 7 Then
        esDiaHabil = False
        Exit Function
    End If
    
    ' Aquí podrías agregar validación contra una tabla de feriados si la tienes
    ' Por ahora, solo validamos lunes a viernes
    esDiaHabil = True
End Function

' Función para obtener el siguiente día hábil
Function obtenerSiguienteDiaHabil(fecha)
    Dim fechaTmp
    fechaTmp = DateAdd("d", 1, fecha)
    
    Do While Not esDiaHabil(fechaTmp)
        fechaTmp = DateAdd("d", 1, fechaTmp)
    Loop
    
    obtenerSiguienteDiaHabil = fechaTmp
End Function

' Función para validar si la carga puede realizarse (antes de las 18:00 del día hábil anterior)
' NUEVA VERSION: Usa Stored Procedure para evitar problemas de caché
Function validarPlazoCarga(fechaInicio)
    Dim resultado, rs, sql, fechaSQL
    
    On Error Resume Next
    
    ' Convertir fechaInicio a Date si viene como string
    If Not IsDate(fechaInicio) Then
        Set resultado = Server.CreateObject("Scripting.Dictionary")
        resultado.Add "valido", False
        resultado.Add "mensaje", "Formato de fecha inválido"
        Set validarPlazoCarga = resultado
        Exit Function
    End If
    
    ' Formatear fecha para SQL (YYYY-MM-DD)
    fechaSQL = Year(fechaInicio) & "-" & Right("0" & Month(fechaInicio), 2) & "-" & Right("0" & Day(fechaInicio), 2)
    
    ' Ejecutar stored procedure
    sql = "EXEC SP_ValidarPlazoCargaReemplazo @fecha_inicio = '" & fechaSQL & "'"
    Set rs = db.execute(sql)
    
    ' Crear objeto resultado
    Set resultado = Server.CreateObject("Scripting.Dictionary")
    
    If Err.Number <> 0 Or rs.EOF Then
        ' Si hay error, permitir la carga (fail-safe)
        resultado.Add "valido", True
        resultado.Add "mensaje", "Error al validar: " & Err.Description
        resultado.Add "fechaLimite", ""
        resultado.Add "fechaLimiteConHora", ""
        resultado.Add "horaLimite", 18
        Err.Clear
    Else
        ' Leer resultado del SP
        Dim resultadoSP, mensajeSP
        resultadoSP = Trim(rs("resultado"))
        mensajeSP = Trim(rs("mensaje"))
        
        If resultadoSP = "OK" Then
            resultado.Add "valido", True
            resultado.Add "mensaje", ""
        Else
            resultado.Add "valido", False
            resultado.Add "mensaje", mensajeSP
        End If
        
        ' Agregar datos adicionales
        resultado.Add "fechaLimite", rs("fecha_limite")
        resultado.Add "fechaLimiteConHora", rs("fecha_limite")
        resultado.Add "horaLimite", rs("hora_limite")
    End If
    
    If Not rs Is Nothing Then
        If Not rs.EOF Then rs.Close
        Set rs = Nothing
    End If
    
    On Error GoTo 0
    
    Set validarPlazoCarga = resultado
End Function

' Función para validar si hoy es día hábil y la hora es válida
Function validarHorarioCargaActual()
    Dim ahora, horaActual, horaLimiteConfig, sqlConfig, rsConfig
    Dim resultado
    
    ' Obtener hora límite DIRECTAMENTE desde la base de datos (sin caché)
    On Error Resume Next
    horaLimiteConfig = 18 ' Valor por defecto
    
    sqlConfig = "SELECT TOP 1 conf_valor FROM SUC_configuraciones WITH (NOLOCK) " & _
                "WHERE conf_grupo = 'PERSONAL' AND conf_clave = 'HORA_LIMITE_CARGA_REEMPLAZOS' AND activo = 1"
    
    Set rsConfig = db.execute(sqlConfig)
    
    If Err.Number = 0 And Not rsConfig.EOF Then
        Dim valorTemp
        valorTemp = Trim(CStr(rsConfig("conf_valor")))
        If IsNumeric(valorTemp) Then
            horaLimiteConfig = CInt(valorTemp)
        End If
    End If
    
    If Not rsConfig Is Nothing Then
        If Not rsConfig.EOF Then rsConfig.Close
        Set rsConfig = Nothing
    End If
    Err.Clear
    On Error GoTo 0
    
    ahora = Now()
    horaActual = Hour(ahora)
    
    Set resultado = Server.CreateObject("Scripting.Dictionary")
    resultado.Add "valido", True
    resultado.Add "mensaje", ""
    resultado.Add "horaLimite", horaLimiteConfig
    
    ' Verificar que sea día hábil
    If Not esDiaHabil(ahora) Then
        resultado("valido") = False
        resultado("mensaje") = "La carga de reemplazos solo puede realizarse en días hábiles (lunes a viernes)."
        Set validarHorarioCargaActual = resultado
        Exit Function
    End If
    
    ' Verificar que sea antes de la hora límite configurada
    If horaActual >= horaLimiteConfig Then
        resultado("valido") = False
        resultado("mensaje") = "La carga de reemplazos solo puede realizarse hasta las " & horaLimiteConfig & ":00 hrs. Hora actual: " & FormatDateTime(ahora, 4)
    End If
    
    Set validarHorarioCargaActual = resultado
End Function
%>
