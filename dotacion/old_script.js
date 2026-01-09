// JavaScript Document
function validarSoloNumeros(event){
	if (event.keyCode < 48 || event.keyCode > 57)
		return false;
}

function validarSoloLetras(event){
	if (event.keyCode<65 || event.keyCode>90 && event.keyCode<97 || event.keyCode>122)
		return false;
}

//Función para validar el ingreso del Digito Verificador de un RUT
function validarCaracteres(event){
	if (event.keyCode<65 || event.keyCode>90 && event.keyCode<97 || event.keyCode>122 && event.keyCode < 48 || event.keyCode > 57) {
		if (event.keyCode == 39 || event.keyCode == 219 || event.keyCode == 50 || event.keyCode == 34 )
			return false;
	}
}

//Función para validar el ingreso del Digito Verificador de un RUT
function validarDvRut(event){
	if (event.keyCode < 48 || event.keyCode > 57 ) {
		if (event.keyCode != 75 && event.keyCode != 107 )
			return false;
	}
}

//Función para validar el cierre de la una tarea.
function validarEliminar(){
	if(confirm("¿Realmente desea eliminar esta dotación?.")){
		return true;
		}
	else
		return false;
	}


//Función para validar Rut Chileno
function validarut(ruti,dvi){
	var rut = ruti+"-"+dvi;
	if (rut.length<9)
		return(false)
	dv=dvi.toUpperCase();
	nu=ruti;

	cnt=0;
	suma=0;
	for (i=nu.length-1; i>=0; i--){
		dig=nu.substr(i,1);
		fc=cnt+2;
		suma += parseInt(dig)*fc;
		cnt=(cnt+1) % 6;
	}
	dvok=11-(suma%11);
	if (dvok==11) 
		dvokstr="0";
	if (dvok==10) 
		dvokstr="K";
	if ((dvok!=11) && (dvok!=10)) 
		dvokstr=""+dvok;
	
	if (dvokstr==dv)
		return(true);
	else
		return(false);
}

/***************************************************************/

contenido_textarea = ""

function cuenta(){ 
   document.dota.caracteres.value=document.dota.txtDetalle.value.length 
}

function validaDetalle(num_caracteres_permitidos){ 
   num_caracteres = document.dota.txtDetalle.value.length 

   if (num_caracteres > num_caracteres_permitidos){ 
      document.dota.txtDetalle.value = contenido_textarea 
   }else{ 
      contenido_textarea = document.dota.txtDetalle.value 
   } 

   if (num_caracteres >= num_caracteres_permitidos){ 
      document.dota.txtDetalle.style.color="#ff0000"; 
   }else{ 
      document.dota.txtDetalle.style.color="#000000"; 
   } 

   cuenta() 
} 

/************************************************************/
//Función para validar el ingreso de nuevas alertas
function validarIngreso(){
	alerta=false;
	mensaje="";	
	
	// Tipo 1: Cupo Utilizado
	if (document.dota.slcTipo.selectedIndex == 1){
		if (document.dota.txtRut.value && document.dota.txtDv.value){
			if (!validarut(document.dota.txtRut.value,document.dota.txtDv.value)){
				mensaje=mensaje + "R.U.N no válido.\n";
				alerta=true;	
			}	
		}
		if (!document.dota.txtRut.value){
			mensaje=mensaje + "Ingrese un R.U.N.\n";
			alerta=true;
		}
		if (!document.dota.txtDv.value){
			mensaje=mensaje + "Ingrese un digito verificador.\n";
			alerta=true;
		}
		if (!document.dota.txtNombres.value){
			mensaje=mensaje + "Ingrese un nombre.\n";
			alerta=true;
		}	
		if (!document.dota.txtApep.value){
			mensaje=mensaje + "Ingrese un apellido paterno.\n";
			alerta=true;
		}
		if (!document.dota.txtApem.value){
			mensaje=mensaje + "Ingrese un apellido materno.\n";
			alerta=true;
		}
		if (document.dota.slcCargo.selectedIndex == 0){
			mensaje=mensaje + "Seleccione un cargo.\n";
			alerta=true;
		}
		if (!document.dota.txtAnexo.value){
			mensaje=mensaje + "Ingrese un anexo.\n";
			alerta=true;
		}
		if (document.dota.slcZona.selectedIndex == 0){
			mensaje=mensaje + "Seleccione una zona.\n";
			alerta=true;
		}
		if (document.dota.slcZonal.selectedIndex == 0){
			mensaje=mensaje + "Seleccione un zonal.\n";
			alerta=true;
		}
	}
	
	// Tipo 2: Cupo Faltante
	if (document.dota.slcTipo.selectedIndex == 2){
		if (document.dota.txtRut.value && document.dota.txtDv.value){
			if (!validarut(document.dota.txtRut.value,document.dota.txtDv.value)){
				mensaje=mensaje + "R.U.N no válido.\n";
				alerta=true;	
			}	
		}
		if (!document.dota.txtRut.value){
			mensaje=mensaje + "Ingrese un R.U.N.\n";
			alerta=true;
		}
		if (!document.dota.txtDv.value){
			mensaje=mensaje + "Ingrese un digito verificador.\n";
			alerta=true;
		}
		if (!document.dota.txtNombres.value){
			mensaje=mensaje + "Ingrese un nombre.\n";
			alerta=true;
		}	
		if (!document.dota.txtApep.value){
			mensaje=mensaje + "Ingrese un apellido paterno.\n";
			alerta=true;
		}
		if (!document.dota.txtApem.value){
			mensaje=mensaje + "Ingrese un apellido materno.\n";
			alerta=true;
		}
		if (document.dota.slcCargo.selectedIndex == 0){
			mensaje=mensaje + "Seleccione un cargo.\n";
			alerta=true;
		}
		if (!document.dota.txtAnexo.value){
			mensaje=mensaje + "Ingrese un anexo.\n";
			alerta=true;
		}
		if (document.dota.slcZona.selectedIndex == 0){
			mensaje=mensaje + "Seleccione una zona.\n";
			alerta=true;
		}
		if (document.dota.slcZonal.selectedIndex == 0){
			mensaje=mensaje + "Seleccione un zonal.\n";
			alerta=true;
		}
		if (document.dota.slcSucursal.selectedIndex == 0){
			mensaje=mensaje + "Seleccione una sucursal.\n";
			alerta=true;
		}
		if (!document.dota.txtDetalle.value){
			mensaje=mensaje + "Ingrese un comentario.\n";
			alerta=true;
		}
	}
	
	// Tipo 3: Cupo sin lenar
	if (document.dota.slcTipo.selectedIndex == 3){
		if (document.dota.slcCargo.selectedIndex == 0){
			mensaje=mensaje + "Seleccione un cargo.\n";
			alerta=true;
		}
		if (!document.dota.txtDetalle.value){
			mensaje=mensaje + "Ingrese un comentario.\n";
			alerta=true;
		}
	}
	
	// Tipo 1: Cupo Utilizado
	if (document.dota.slcTipo.selectedIndex == 4){
		if (document.dota.txtRut.value && document.dota.txtDv.value){
			if (!validarut(document.dota.txtRut.value,document.dota.txtDv.value)){
				mensaje=mensaje + "R.U.N no válido.\n";
				alerta=true;	
			}	
		}
		if (!document.dota.txtRut.value){
			mensaje=mensaje + "Ingrese un R.U.N.\n";
			alerta=true;
		}
		if (!document.dota.txtDv.value){
			mensaje=mensaje + "Ingrese un digito verificador.\n";
			alerta=true;
		}
		if (!document.dota.txtNombres.value){
			mensaje=mensaje + "Ingrese un nombre.\n";
			alerta=true;
		}	
		if (!document.dota.txtApep.value){
			mensaje=mensaje + "Ingrese un apellido paterno.\n";
			alerta=true;
		}
		if (!document.dota.txtApem.value){
			mensaje=mensaje + "Ingrese un apellido materno.\n";
			alerta=true;
		}
		if (document.dota.slcCargo.selectedIndex == 0){
			mensaje=mensaje + "Seleccione un cargo.\n";
			alerta=true;
		}
		if (!document.dota.txtAnexo.value){
			mensaje=mensaje + "Ingrese un anexo.\n";
			alerta=true;
		}
		if (document.dota.slcZona.selectedIndex == 0){
			mensaje=mensaje + "Seleccione una zona.\n";
			alerta=true;
		}
		if (document.dota.slcZonal.selectedIndex == 0){
			mensaje=mensaje + "Seleccione un zonal.\n";
			alerta=true;
		}
	}
		
	if (alerta){
		alert("Favor de completar lo solicitado:\n" + mensaje);		
		return false;
		}
	else
		return true;
}




/*************************************************************************/	

function fechaLarga(){
	//ojo: el mes viene entre 1 y 12 pero debe estar entre 0 y 11, asi que le resto 1
	var fechaOk = new Date()
	
	var diaSem   = fechaOk.getDay()
	var mesCorto = fechaOk.getMonth()
	var anyo     = fechaOk.getFullYear()
	var dia      = fechaOk.getDate()
	
	if (mesCorto == 0)       mes = "Enero"
	else if (mesCorto == 1)  mes = "Febrero"
	else if (mesCorto == 2)  mes = "Marzo"
	else if (mesCorto == 3)  mes = "Abril"
	else if (mesCorto == 4)  mes = "Mayo"
	else if (mesCorto == 5)  mes = "Junio"
	else if (mesCorto == 6)  mes = "Julio"
	else if (mesCorto == 7)  mes = "Agosto"
	else if (mesCorto == 8)  mes = "Septiembre"
	else if (mesCorto == 9)  mes = "Octubre"
	else if (mesCorto == 10) mes = "Noviembre"
	else if (mesCorto == 11) mes = "Diciembre"
	
	if (diaSem == 1) diaSemana = "Lunes"
	if (diaSem == 2) diaSemana = "Martes"
	if (diaSem == 3) diaSemana = "Mi&eacute;rcoles"
	if (diaSem == 4) diaSemana = "Jueves"
	if (diaSem == 5) diaSemana = "Viernes"
	if (diaSem == 6) diaSemana = "S&aacute;bado"
	if (diaSem == 0) diaSemana = "Domingo"
	
	return( diaSemana+" " + dia + ", " + mes + " de " + anyo );
	}
	
