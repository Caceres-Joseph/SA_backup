var conexion = require('./db.js');
var middle = require('../middleware/Middleware.js')
const axios = require('axios');

const ESB = process.env.NODE_ESB+"/post/comunicacion/";
const JWT = process.env.NODE_JWT+"/post/autorizacion";
const ALMACENAMIENTO = process.env.NODE_ALMACENAMIENTO;
exports.initTraducciones = function(req, res){
	res.send('Traducciones');
}

exports.registro = function(request,response){
	var nombre = request.body.nombre;
	var correo = request.body.correo;
	var password = request.body.password;
	var token = request.body.token;
	var miQuery = "INSERT INTO Usuario (Nombre, Password_, Correo) VALUES(" +
    "\'"+nombre+"\'"+",\'"+password+"\'" +",\'"+correo+"\');"
    conexion.query(miQuery, function(err, result){
        if(err){
			console.log(err);
            response.send(JSON.stringify(
				{
					estado:"500",
					mensaje:"Error del Servidor de Base de Datos"
				}
			))
        }else{
            console.log(result);
            response.send(JSON.stringify(
				{ 
					estado: "200",
					mensaje: "Usuario Creado Correctamente",
					data:{
						nombre: nombre,
						correo: correo
					}
			    }
				));
        }
    });
}
exports.getLocalizaciones = function(request, response){
	var miQuery = "SELECT Nombre from Localizacion;"
	conexion.query(miQuery, function(err, result){
        if(err){
			console.log(err);
            response.send(JSON.stringify(
				{
					estado:"500",
					mensaje:"Error del Servidor de Base de Datos"
				}
			))
        }else{
            console.log(result);
            response.send(JSON.stringify(
				{ 
					estado: "200",
					mensaje: "Obteniendo Localizaciones Correctamente",
					valores: result
			    }
				));
        }
    });
}

exports.getCatalogo = function(request, response){
	var idComplemento = request.body.idComplemento;
	try{
		/*
		axios.post(JWT,{
			clientid:"ARCHIVOS_TRADUCIDOS"
			}).then(function(result){
				var token = result.data.token;
				//console.log(result.data.token);
				//console.log(middle.decode(result.data.token));
					/*
					comentario real
					addComplemento(nombre,correo,token,texto,localizacion, nombreComplemento).then(data2 =>{
						return response.send(data2);
					})*/
					/*
					var data_Almacenamiento = {
						
					};
					var ruta = ALMACENAMIENTO+"/get/catalogo/"+idComplemento+"?token="+token;
					console.log(ruta);
					axios.post(ESB,{
						token:token,
						url:ruta,
						tipo:"GET",
						funcionSolicitada:"almacenamiento.obtenerCatalogoID",
						parametros: {}
					}).then((res)=>{
						console.log(res);
						return response.send(res.data);
					}).catch((error) => {
						console.log(error);
						return response.send(error.data);
					});

				
				})
		*/
		axios.post(JWT,{
			clientid:"ARCHIVOS_TRADUCIDOS"
			}).then(function(result){
				var token = result.data.token;
				//console.log(result.data.token);
				//console.log(middle.decode(result.data.token));
					/*
					comentario real
					addComplemento(nombre,correo,token,texto,localizacion, nombreComplemento).then(data2 =>{
						return response.send(data2);
					})*/
					
					var data_Almacenamiento = {
						
					};
					var ruta = ALMACENAMIENTO+"/get/catalogo/"+idComplemento+"?token="+token;
					console.log(ruta);
					axios.post(ESB,{
						token:token,
						url:ruta,
						tipo:"GET",
						funcionSolicitada:"almacenamiento.obtenerCatalogoID",
						parametros: {}
					}).then((res)=>{
						console.log(res);
						return response.send(res.data);
					}).catch((error) => {
						console.log(error);
						return response.send(error.data);
					});

				
				})		
	}catch(error){
            return error;
    }

}
exports.inicio = function(request,response){
	var nombre = request.body.nombre;
	var password = request.body.password;
	var token = request.body.token;
	var miQuery = "SELECT EXISTS("+
    "select 1 "+
    "from Usuario "+
    "where Nombre = " + "\'"+nombre + "\'"+ " and Password_ = " + "\'" + password+"\') as inicio;"
	console.log(miQuery);
	conexion.query(miQuery, function(err, result){
        if(err){
            response.send(JSON.stringify(
				{
					estado:"500",
					mensaje:"Error de Servidor"
				}
			))
        }else{
			console.log(result);
			valido = (result[0].inicio);
			
			if(valido==1){
				response.send(JSON.stringify(
					{ 
						estado: "200",
						mensaje: "El usuario ingresado y contraseña son correctos."
					}
					));
			}else{
				response.send(JSON.stringify(
					{ 
						estado: "400",
						mensaje: "Credenciales Incorrectas"
					}
					));
			}
            
        }
    });
}


exports.nuevoComplemento = function(request,response){
	var texto = request.body.texto;
	var localizacion = request.body.localizacion;
	var idUsuario = request.body.idUsuario;
	texto = texto.replace('\r','')
	var arreglo = texto.split('\n');
	var nombreComplemento = request.body.nombreComplemento;
	try{
		axios.post(JWT,{
			clientid:"ALMACENAMIENTO"
			}).then(function(result){
				var token = result.data.token;
				//console.log(result.data.token);
				//console.log(middle.decode(result.data.token));
				var miQuery = "SELECT Nombre, Correo from Usuario where Nombre = "+idUsuario+";";
				console.log(miQuery);
				conexion.query(miQuery, function(err, result){
        		if(err){
            		response.send(JSON.stringify(
					{
						estado:"500",
						mensaje:"Error de Servidor de Base de Datos de Traduccion"
					}
					))
        		}else{
					nombre = result[0].Nombre;
					correo = result[0].Correo;
					/*
					addComplemento(nombre,correo,token,texto,localizacion, nombreComplemento).then(data2 =>{
						return response.send(data2);
					})*/
					var data_Almacenamiento = {
						token:token,
						nombre: nombre,
						correo: correo,
						complemento:{
							nombre: nombreComplemento,
							localizacion: localizacion,
							cadenas: arreglo
						}
					};
					console.log("nuevo complementito");
					console.log(data_Almacenamiento);
					axios.post(ESB,{
						token:token,
						url:ESB+"/post/complemento",
						tipo:"POST",
						funcionSolicitada:"almacenamiento.guardarComplemento",
						parametros: data_Almacenamiento
					}).then((res)=>{
						console.log(res);
						return response.send(res.data);
					}).catch((error) => {
						console.log(error);
						return response.send(error.data);
					});

				}
				})
		}).catch((error) =>{
			console.log("alosss")

			console.log(error);
			return response.send(error.data);
		})
	
	}catch(error){
            return error;
    }
	
}


exports.agregarTraduccion = function(request,response){
	var idComplemento = request.body.idComplemento;
	var nombreComplemento = request.body.nombreComplemento;
	var nombreLocalizacionOriginal = request.body.nombreLocalizacionOriginal;
	var nombreLocalizacionTraducida = request.body.nombreLocalizacionTraducida;
	var cadenaOriginal = request.body.cadenaOriginal;
	var cadenaTraducida = request.body.cadenaTraducida;
	var token = request.body.token;
	var idUsuario = request.body.idUsuario;
	/*response.send("Parametros Recibidos en /post/agregarTraduccion/\n"
	+"complemento: "+complemento+"\n"
	+"localizacion: "+localizacion+"\n"
	+"cadenaOriginal: "+cadenaOriginal+"\n"
	+"cadenaTraduccion: "+cadenaTraduccion+"\n"
	+"token: "+token+"\n");*/
	try{
		axios.post(JWT,{
			clientid:"ARCHIVOS_TRADUCIDOS"
			}).then(function(result){
				token = result.data.token;
				//console.log(result.data.token);
				//console.log(middle.decode(result.data.token));
				var miQuery = "SELECT Nombre, Correo from Usuario where Nombre = "+idUsuario+";";
				//console.log(miQuery);
				conexion.query(miQuery, function(err, result){
        		if(err){
            		response.send(JSON.stringify(
					{
						estado:"500",
						mensaje:"Error de Servidor"
					}
					))
        		}else{
					nombre = result[0].Nombre;
					correo = result[0].Correo;
					try{
						var data_Almacenamiento = {
						   token:token,
						   nombreComplemento: nombreComplemento,
						   idComplemento:idComplemento,
						   nombreLocalizacionOriginal: nombreLocalizacionOriginal,
						   nombreLocalizacionTraducida: nombreLocalizacionTraducida,
						   cadenaOriginal: cadenaOriginal,
						   cadenaTraducida: cadenaTraducida,
						   nombre: nombre,
						   correo: correo,
					   };
					   console.log("valiendomadre");
					   console.log(data_Almacenamiento);
						   return axios.post(ESB,{
							   token:token,
							   url: ALMACENAMIENTO+"/post/agregarTraduccionCadena",
							   tipo:"POST",
							   funcionSolicitada:"almacenamiento.agregarTraduccionCadena",
							   parametros: data_Almacenamiento
						   })
						   .then((res)=>{
							   console.log(res)
							   return response.send(res.data);
						   })
					   }catch(error){
						   console.log(error);
						   return response.send(error.data);
					   }
				}
				})
		})

	//  SELECT Nombre, Correo from Usuario where idUsuario = 1;
	
	}catch(error){
            return error;
    }
}

exports.getComplementos = function(request, response){
	var token = request.query.token;
	/*response.send("Parametros Recibidos en /get/complementos/?token=<token> \n"
	+"token: "+token+"\n");*/
	try{
		axios.post(JWT,{
			clientid:"ARCHIVOS_TRADUCIDOS"
			}).then(function(result){
				token = result.data.token;
				//console.log(result.data.token);
				//console.log(middle.decode(result.data.token));
				try{
					return axios.post(ESB,{
						token:token,
						url:ALMACENAMIENTO+"/get/complementos?token="+token,
						tipo:"GET",
						funcionSolicitada:"almacenamiento.obtenerComplemento",
						parametros:{
							
						}
					})
					.then((res)=>{
						console.log(res);
						return response.send(res.data);
					}).catch((error) =>{
						console.log(error);
						return response.send(error.data);
					})
				}catch(error){
					return error;
				}
		})
	//  SELECT Nombre, Correo from Usuario where idUsuario = 1;
	
	}catch(error){
            return error;
    }
}


exports.revisar = function(request, response){
	console.log("revisaando");
	var nombreComplemento = request.body.nombreComplemento;
	var idComplemento = request.body.idComplemento;
	var nombreLocalizacionOriginal = request.body.nombreLocalizacionOriginal;
	var nombreLocalizacionTraducida = request.body.nombreLocalizacionTraducida;
	var cadenaOriginal = request.body.cadenaOriginal;
	var cadenaTraduccion = request.body.cadenaTraduccion;
	var idUsuario = request.body.idUsuario;
	var esCorrecto = request.body.esCorrecto;
	try{
		axios.post(JWT,{
			clientid:"ARCHIVOS_TRADUCIDOS"
			}).then(function(result){
				token = result.data.token;
				//console.log(result.data.token);
				//console.log(middle.decode(result.data.token));
				var miQuery = "SELECT Nombre, Correo from Usuario where Nombre = "+idUsuario+";";
				//console.log(miQuery);
				conexion.query(miQuery, function(err, result){
        		if(err){
            		response.send(JSON.stringify(
					{
						estado:"500",
						mensaje:"Error de Servidor"
					}
					))
        		}else{
					nombre = result[0].Nombre;
					correo = result[0].Correo;
					try{
						var data_Almacenamiento= {
							token: token,
							nombreComplemento: nombreComplemento,
							idComplemento: idComplemento,
							nombreLocalizacionOriginal: nombreLocalizacionOriginal,
							nombreLocalizacionTraducida: nombreLocalizacionTraducida,
							cadenaOriginal: cadenaOriginal,
							nombre: nombre,
							correo: correo
						};
						return axios.post(ESB,{
							token:token,
							url:ALMACENAMIENTO+"/post/aprobarTraduccionCadena",
							tipo:"POST",
							funcionSolicitada:"almacenamiento.aprobarTraduccionCadena",
							parametros: data_Almacenamiento
						})
						.then((res)=>{
							console.log(res);
							return response.send(res.data);
						}).catch((error) =>{
							console.log(error);
							return response.send(error.data);
						})
					}catch(error){
						return error;
					}
				}
				})
		}).catch((error) =>{
			console.log(error);
		})

	//  SELECT Nombre, Correo from Usuario where idUsuario = 1;
	
	}catch(error){
            return error;
    }
	/*cadenaOriginal: "+cadenaOriginal+"\n"
	+"cadenaTraduccion: "+cadenaTraduccion+"\n"
	+"idRevisor: "+idRevisor+"\n"
	+"esCorrecto: "+esCorrecto+"\n"	
	+"token: "+token+"\n"); */

}
exports.getLocalizacion = function(request, response){
	var id = request.params.idUsuario;
	var miQuery = "SELECT Localizacion.Nombre as Localizacion FROM Localizacion, Detalle_Usuario_Localizacion "+
	"WHERE Localizacion.idLocalizacion = Detalle_Usuario_Localizacion.Localizacion_idLocalizacion and Detalle_Usuario_Localizacion.Usuario_idUsuario= "+ id
	+"";

	//console.log(miQuery);
	conexion.query(miQuery, function(err, result){
        if(err){
            response.send(JSON.stringify(
				{
					estado:"500",
					mensaje:"Error de Servidor"
				}
			))
        }else{
			//console.log(result);			
			if(true){
				response.send(JSON.stringify(
					{ 
						estado: "200",
						mensaje: "OK",
						data: result
					}
					));
			}
            
        }
    });
}

exports.subirArchivo = function(request, response){
	var complemento = request.body.idComplemento;
	var textoTraduccion = request.body.textoTraduccion;
	var localizacion = request.body.idLocalizacion;
	var token = request.body.token;
	response.json(request.body);
}

exports.loginprueba = function(req, res, next) {
	res.render('login', { title: 'Hola Alba' });
  }