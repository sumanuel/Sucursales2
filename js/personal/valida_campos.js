var Vemail ;
function soloNumeros(e){
    var keynum = window.event ? window.event.keyCode : e.which;
    	if ((keynum == 8) || (keynum == 46)){
  		return true;
	}
	return /\d/.test(String.fromCharCode(keynum));
}
function validarEmail(valor) {
   	var resultado;
   	expr = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	if (!expr.test(valor)){
		resultado = false;
		return resultado;			
	}else {
		resultado = true;
		return resultado;
	}
}

function soloLetras(e) {
    key = e.keyCode || e.which;
    tecla = String.fromCharCode(key).toString();
    letras = " áéíóúabcdefghijklmnñopqrstuvwxyzÁÉÍÓÚABCDEFGHIJKLMNÑOPQRSTUVWXYZ9876543210";//Se define todo el abecedario que se quiere que se muestre.
	if(letras.indexOf(tecla) == -1){		
	    return false;
	}
}

function soloDV(e) {
    key = e.keyCode || e.which;
    tecla = String.fromCharCode(key).toString();
    letras = "0123456789kK";//Se define todo el abecedario que se quiere que se muestre.

	if(letras.indexOf(tecla) == -1){		
	    return false;
	}
}

function soloEmail(e) {
    key = e.keyCode || e.which;
    tecla = String.fromCharCode(key).toString();
    letras = "@.-_abcdefghijklmnñopqrstuvwxyz1234567890ABCDEFGHIJKLMNÑOPQRSTUVWXYZ";//Se define todo el abecedario que se quiere que se muestre.

	if(letras.indexOf(tecla) == -1){		
	    return false;
	}
}

function soloLetrasyNumeros(e) {
	    key = e.keyCode || e.which;
	    tecla = String.fromCharCode(key).toString();
	    letras = " 1234567890.áéíóúabcdefghijklmnñop,qrstuvwxyzÁÉÍÓÚABCDEFGHIJKLMNÑOPQRSTUVWXYZ+-*/?¡¿!°|¬@:;´~`^{}[]¨_=)(&%$#";//Se define todo el abecedario que se quiere que se muestre.

		if(letras.indexOf(tecla) == -1){		
		    return false;
		}
	}
