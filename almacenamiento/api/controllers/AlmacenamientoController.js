const middleware = require('../middleware/Middleware');

var axios = require('axios')

/**This part is for use with the database, don't delete or touch nothing**/
const mysql = require('mysql');
const connection = mysql.createConnection({
	host: 'db_almacenamiento',
	user: 'root',
	password: 'Chachas!123',
	database: 'sa_db',
	port: 3306
});

connection.connect((err) => {
	if (err) {
		console.log(err);
		throw err;
	}
	console.log('Connected!');
});

/**This part is for use with the database, from here you can edit whatever you want! XD**/


exports.initAlmacenamiento = function (req, res) {
	res.send('Almacenamiento');
}



/**
 * Post para almacenar complementos
 */

exports.post_complemento = function (req, res) {


	var token = req.body.token;
	var nombre = req.body.nombre;
	var correo = req.body.correo;
	var complemento = req.body.complemento;


	var decodedToken = null;
	if (!middleware.verifyToken(req.body.token))
		return res.json({ estado: 403, mensaje: "Permisos insufientes" });


	//trabajando con el token
	//decodedToken = middleware.decode(req.body.token);
	//console.log("Intentando decodificar..");
	//console.log(decodedToken);


	console.log(decodedToken);






	return res.json({ estado: 403, mensaje: "Permisos insufientes" });

}


/**Get complements list **/

exports.get_complementos = function (req, res) {
	const scope = "traducidos.listaComplementos";
	var token = req.query.token;
	var decodedToken = null;

	if (!middleware.verifyToken(get_token(req))) {
		res.statusCode = 401;
		return res.send({
			estado: 401,
			mensaje: "Se produjo un error al consultar el complemento con el identificador. Autorización requerida"
		});
	}
	decodedToken = middleware.decode(token);
	console.log(decodedToken);

	if (!check_scope(scope, decodedToken.payload.scopes)) {

		res.statusCode = 403;
		return res.send({
			estado: 403,
			mensaje: "Se produjo un error al consultar el complemento con el identificador. Autorización requerida"

		});
	}
	let query = "call sp_almacenamientoObtenerComplemento(null, null)";
	connection.query(query, true, (error, results, fields) => {
		if (error) {
			console.log(error);
			return res.send(error);
		}
		else {
			let rest = [];
			for (var i = results[0].length - 1; i >= 0; i--) {
				rest[i] = {
					nombre: results[0][i].nombre,
					idComplemento: results[0][i].idComplemento,
					LocalizacionOriginal: results[0][i].LocalizacionOriginal,
					nombreusr: results[0][i].nombreusr,
					correousr: results[0][i].correousr,
					localizaciones: results[0][i].localizaciones.split(",")
				};


			}


			//console.log(rest);
			return res.send({
				estado: 200,
				mensaje: "OK",
				data: {
					complementos: rest
				}
			});
		}
	});
	//return res.send(decodedToken);
}

exports.get_complemento = function (req, res) {
	const scope = "traducidos.listaComplementos";
	var token = req.query.token;
	var decodedToken = null;
	if (!middleware.verifyToken(get_token(req))) {

		res.statusCode = 401;
		return res.send({
			estado: 401,
			mensaje: "Se produjo un error al consultar el complemento con el identificador. Autorización requerida"
		});
	}

	decodedToken = middleware.decode(token);
	console.log(decodedToken);
	if (!check_scope(scope, decodedToken.payload.scopes)) {

		res.statusCode = 403;
		return res.send({
			estado: 403,
			mensaje: "Se produjo un error al consultar el complemento con el identificador. Autorización requerida"

		});
	}
	let query1 = "call sp_almacenamientoObtenerComplemento(" + req.param('idComplemento') + ", null)";
	let query2 = "call sp_almacenamientoObtenerCatalogo(" + req.param('idComplemento') + ", null)";
	console.log(query1);

	connection.query(query2, true, (error, results, fields) => {
		if (error) {
			console.log(error);
			return res.send(error);
		}
		else {
			var cadenas = [];
			for (var i = results[0].length - 1; i >= 0; i--) {
				console.log(results[0][i].msgstr);
				cadenas[i] = results[0][i].msgstr;
			}
			console.log(cadenas);
			connection.query(query1, true, (error, results, fields) => {
				if (error) {
					console.log(error);
					return res.send(error);
				}
				else {
					let rest = [];
					for (var i = results[0].length - 1; i >= 0; i--) {
						rest[i] = {
							nombre: results[0][i].nombre,
							idComplemento: results[0][i].idComplemento,
							LocalizacionOriginal: results[0][i].LocalizacionOriginal,
							nombreusr: results[0][i].nombreusr,
							correousr: results[0][i].correousr,
							localizaciones: [results[0][i].localizaciones],
							cadenas: cadenas
						};
					}
					console.log("test" + cadenas);
					return res.send({
						estado: 200,
						mensaje: "OK",
						data: rest
					});
				}
			});
		}
	});
	//res.send(query); 
}

exports.get_catalogo = function (req, res) {

	try {
		const scope = "traducidos.listaComplementos";
		var token = req.query.token;
		var decodedToken = null;
		if (!middleware.verifyToken(get_token(req))) {

			res.statusCode = 401;
			return res.send({
				estado: 401,
				mensaje: "Se produjo un error al consultar el complemento con el identificador. Autorización requerida"
			});
		}
		decodedToken = middleware.decode(token);
		console.log(decodedToken);
		if (!check_scope(scope, decodedToken.payload.scopes)) {
			return res.send({
				estado: 403,
				mensaje: "Se produjo un error al consultar el complemento con el identificador. Autorización requerida"

			});
		}

		let query2 = "call sp_almacenamientoObtenerCatalogo2(" + req.param('idComplemento') + ", null)";

		console.log("--- get catalogo ---");
		console.log(query2);
		connection.query(query2, true, (error, results, fields) => {
			if (error) {
				console.log(error);
				return res.send(error);
			}
			else {

				console.log("===== QUERY =====");
				console.log(results);
				var cadenas = [];
				var data = {};
				data.idComplemento = results[0][0].idComplemento;
				data.nombre = results[0][0].Complemento;
				var loc_original = results[0][0].LocalizacionOriginal;
				var loc_traduccion = results[0][0].LocalizacionTraduccion;

				for (var i = results[0].length - 1; i >= 0; i--) {
					//console.log(results[0][i].msgstr);
					var contenido = {
						msgid: results[0][i].msgid,
						msgstr: results[0][i].msgstr,
						numeroAprobaciones: results[0][i].numeroAprobaciones
					}
					cadenas[i] = contenido;
				}
				data.catalogo = [];
				data.catalogo[0] = {
					localizacionOriginal: loc_original,
					localizacionTraduccion: loc_traduccion,
					contenido: cadenas
				};
				console.log(cadenas);
				console.log(data);
				res.send({
					estado: 200,
					mensaje: "OK",
					data: data
				});
			}
		});


	}
	catch (error) {
		console.log(error);
		res.statusCode = 401;
		return res.send({
			estado: 401,
			mensaje: error
		});
	}
}

exports.agregar_traduccion_cadena = function (req, res) {
	const scope = "traducidos.listaComplementos";
	var token = req.body.token;
	var nombreComplemento = req.body.nombreComplemento;
	var idComplemento = req.body.idComplemento;
	var nombreLocalizacionOriginal = req.body.nombreLocalizacionOriginal;
	var nombreLocalizacionTraducida = req.body.nombreLocalizacionTraducida;
	var cadenaOriginal = req.body.cadenaOriginal;
	var cadenaTraducida = req.body.cadenaTraducida;
	var nombre = req.body.nombre;
	var correo = req.body.correo;
	var decodedToken = null;
	if (!middleware.verifyToken(get_token(req))) {

		res.statusCode = 401;
		return res.send({
			estado: 401,
			mensaje: "Se produjo un error al consultar el complemento con el identificador. Autorización requerida"
		});
	}
	decodedToken = middleware.decode(token);
	console.log(decodedToken);
	if (!check_scope(scope, decodedToken.payload.scopes)) {

		res.statusCode = 403;
		return res.send({
			estado: 403,
			mensaje: "Se produjo un error al consultar el complemento con el identificador. Autorización requerida"

		});
	}
	nombreComplemento = add_c(nombreComplemento);
	nombreLocalizacionTraducida = add_c(nombreLocalizacionTraducida);
	nombreLocalizacionOriginal = add_c(nombreLocalizacionOriginal);
	cadenaOriginal = add_c(cadenaOriginal);
	cadenaTraducida = add_c(cadenaTraducida);
	nombre = add_c(nombre);
	correo = add_c(correo);
	var params = nombreComplemento + ","
		+ idComplemento + ","
		+ nombreLocalizacionOriginal + ","
		+ nombreLocalizacionTraducida + ","
		+ cadenaOriginal + ","
		+ cadenaTraducida + ","
		+ nombre + ","
		+ correo + ","
		+ 1;

	let query2 = "call sp_almacenamientoInsertaTraduccion(" + params + ")";
	console.log(query2);
	connection.query(query2, true, (error, results, fields) => {
		if (error) {
			console.log(error);

			res.statusCode = 401;
			return res.send(error);
		}
		else {
			res.send({
				estado: 200,
				mensaje: "OK"
			});
		}
	});
	console.log(query2);
}

exports.aprobar_traduccion_cadena = function (req, res) {



	const scope = "traducidos.listaComplementos";
	var token = req.body.token;
	var nombreComplemento = req.body.nombreComplemento;
	var idComplemento = req.body.idComplemento;
	var nombreLocalizacionOriginal = req.body.nombreLocalizacionOriginal;
	var nombreLocalizacionTraducida = req.body.nombreLocalizacionTraducida;
	var cadenaOriginal = req.body.cadenaOriginal;
	var cadenaTraducida = req.body.cadenaTraducida;
	var nombre = req.body.nombre;
	var correo = req.body.correo;
	var decodedToken = null;
	if (!middleware.verifyToken(get_token(req))) {

		res.statusCode = 401;
		return res.send({
			estado: 401,
			mensaje: "Se produjo un error al consultar el complemento con el identificador. Autorización requerida"
		});
	}
	decodedToken = middleware.decode(token);
	console.log(decodedToken);
	if (!check_scope(scope, decodedToken.payload.scopes)) {

		res.statusCode = 403;
		return res.send({
			estado: 403,
			mensaje: "Se produjo un error al consultar el complemento con el identificador. Autorización requerida"

		});
	}
	nombreComplemento = add_c(nombreComplemento);
	nombreLocalizacionTraducida = add_c(nombreLocalizacionTraducida);
	nombreLocalizacionOriginal = add_c(nombreLocalizacionOriginal);
	cadenaOriginal = add_c(cadenaOriginal);
	cadenaTraducida = add_c(cadenaTraducida);
	nombre = add_c(nombre);
	correo = add_c(correo);
	var params = nombreComplemento + ","
		+ idComplemento + ","
		+ nombreLocalizacionOriginal + ","
		+ nombreLocalizacionTraducida + ","
		+ cadenaOriginal + ","
		+ cadenaTraducida + ","
		+ nombre + ","
		+ correo + ","
		+ 0;

	let query2 = "call sp_almacenamientoInsertaTraduccion(" + params + ")";
	console.log(query2);
	connection.query(query2, true, (error, results, fields) => {
		if (error) {
			console.log(error);
			return res.send(error);
		}
		else {
			console.log("----- Results -----");
			console.log(results);

			console.log(results[0][0].estado);
			//validar si ya todas las cadenas se aprobaron más de dos veces

			if (results[0][0].estado == 201) {
				console.log("Cadena limpia");
 
				var ip = "http://archivos_traducidos:80";
				var ip_auth = "http://jwt:80";

				var jwt = ip_auth + '/post/autorizacion'
				axios.post(jwt, {
					clientid: "ALMACENAMIENTO"
				})
					.then(result => {
						console.log(" === TOken ======");
						var anonymous_token = result.data.token
						//console.log(anonymous_token)
						var url2 = ip + 'post/complementoTraducido'

						axios.post(url2, {
							token: anonymous_token,
							url: almacenamiento,
							tipo: 'POST',
							funcionSolicitada: 'almacenamiento.suscripcion',
							parametros: {}
						}).then(result2 => {
							console.log("Consumiendo traducidos ==================");
							console.log(result2.data)
						})
							.catch(e => {
								console.log('MODO PÁNICO')
							});
					});


				/*
				let query3 = "call sp_traducidoscomplementoTraducido()";
				connection.query(query3, true, (error, results, fields) => {
					if (error) {
						console.log(error);
						return res.send(error);
					}
					else {
						console.log("===== QUERY 3 =====");
						console.log(results);
						var contenido = [];
						var data = {};
						data.nombre = results[0][0].nombre;
						data.correo = results[0][0].correo;
						data.token = "adfa34234234";
						var complemento = {
							nombre: results[0][0].nombre,
							localizacionOriginal: results[0][0].localizacionoriginal,
							localizacionTraducida: results[0][0].localizaciontraduccion

						};
						data.complemento = complemento;
 

						for (var i = results[0].length - 1; i >= 0; i--) { 
							var cadena = {
								msgid: results[0][i].msgid,
								msgstr: results[0][i].msgstr,
								numeroAprobaciones: results[0][i].numeroAprobaciones
							}
							contenido[i] = cadena;
						}

						data.complemento.contenido = contenido;
						console.log(data);

						return res.send({
							estado: 200,
							mensaje: data
						});

					}
				}); 

				*/

			}


			res.send({
				estado: 200,
				mensaje: results
			});
		}
	});
	console.log(query2);
}


function add_c(cad) {
	return "'" + cad + "'";
}

function get_cadenas(cid) {
	let query = "call sp_almacenamientoObtenerCatalogo(" + cid + ", null)";
	connection.query(query, true, (error, results, fields) => {
		if (error) {
			console.log(error);
		}
		else {
			let cadenas = [];
			for (var i = results[0].length - 1; i >= 0; i--) {
				console.log(results[0][i].msgstr);
				cadenas[i] = results[0][i].msgstr;
			}
			return cadenas;
		}
	});
}

function check_scope(scope, scopes) {
	let v1 = scope.toLowerCase(scope);
	console.log(scopes);
	for (var i = scopes.length - 1; i >= 0; i--) {
		let v2 = scopes[i].toLowerCase();
		console.log(v1 + ": " + v2);
		if (v2 == v1) {
			return true;
		}
	}
	return false;
}

function get_token(req) {
	return req.body.token || req.query.token;
}
