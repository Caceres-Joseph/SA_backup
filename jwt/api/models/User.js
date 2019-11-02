
/*
0.traduccion
1. almacenamiento
2. traducidos
**/

const services = [
	{
		clientid  : "TRADUCCION",
		password : "TRADUCCION",
		scopes   : [
			"traducciones.registro",
			"traducciones.iniciar",
			"traducciones.nuevoComplemento",
			"traducciones.agregarTraduccion",
			"traducciones.complementos",
			"traducciones.revisar",
			"traducciones.localizaciones",
			"traducciones.subirArchivo"
		]

	},
	{
		clientid  : "ALMACENAMIENTO",
		password : "ALMACENAMIENTO",
		scopes   : [
			"almacenamiento.guardarComplemento",
			"almacenamiento.obtenerComplemento",
			"almacenamiento.eliminarComplemento",
			"almacenamiento.guardarCatalogo",
			"almacenamiento.obtenerCatalogo",
			"almacenamiento.eliminarCatalogo",
			"almacenamiento.guardarCaracteres",
			"almacenamiento.obtenerCaracteres",
			"almacenamiento.aprobarTraduccionCadena",
			"almacenamiento.agregarTraduccionCadena",
			"almacenamiento.suscribirse"
		]
	},
	{
		clientid  : "ARCHIVOS_TRADUCIDOS",
		password : "ARCHIVOS_TRADUCIDOS",
		scopes   : [
			"traducidos.listaComplementos",
			"traducidos.listadoDeLocalizaciones",
			"traducidos.DescargaMo",
			"traducidos.DescargaPo",
			"traducidos.guardarTraduccionCompleta"
		]
	}

];

exports.values = services;