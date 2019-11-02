//var request = require('request');
var request      = require("request-factory");
//var callAPI   = require('call-api-factory');
var rp           = require('request-promise');
const axios      = require('axios');
const middleware = require('../middleware/Middleware'); 

exports.initEsb = function(req, res){
	//res.send('Hola mundo ESB');
	/*request.get("http://almacenamiento", function(error, response, body){
		if(error){
			res.json(error);
		}
		else{
			var a = '{' + '"body":"' + body + '"}';
			res.send(JSON.parse(a));
		}
	});*/
	res.send({name:"mike"})
}



exports.testAlmacenamiento = function(req, res){
	//res.send('Hola mundo ESB');
	console.log("From storage");
	request.get("http://almacenamiento", function(error, response, body){
		if(error){
			res.json(error);
		}
		else{
			var a = '{' + '"body":"' + body + '"}';
			res.send(JSON.parse(a));
		}
	});
}



exports.testArchivosTraducidos = function(req, res){
	//res.send('Hola mundo ESB');
	request.get("http://archivos_traducidos", function(error, response, body){
		if(error){
			res.json(error);
		}
		else{
			var a = '{' + '"body":"' + body + '"}';
			res.send(JSON.parse(a));
		}
	});
}



exports.testTraducciones = function(req, res){
	//res.send('Hola mundo ESB');
	request.get("http://traducciones", function(error, response, body){
		if(error){
			res.json(error);
		}
		else{
			var a = '{' + '"body":"' + body + '"}';
			res.send(JSON.parse(a));
		}
	});
}


exports.comunicacion = function(req, res) {
	/**check the jwt token here*/
	var route = req.body.tipo;
	var path  = req.body.url;
	var data  = req.body.parametros;
	var other = req.body.funcionSolicitada;
	var decodedToken = null;
	if(!check_params(req.body)) return res.json({estado:404, mensaje: "todos los parametros son necesarios.", contenido: req.body});
	if(!middleware.verifyToken(req.body.token)) {
		return res.json({estado:403, mensaje:"Permisos insufientes"});
	}
	else{
		decodedToken = middleware.decode(req.body.token);
	}
	console.log(decodedToken);


	//console.log(req);
	switch(route){
		case "GET":
		case "get":
			//res.send(route + " "  + path);
			var options = {
				uri: path,
				qs: data,
			    json: true 		
			} 
			rp(options)
			.then(function(response){
				res.send(response);
			})
			.catch(function(response){
				res.send(response);
			});
		break;
		case "POST":
		case "post":
			//res.send(route + " "  + path);
			//console.log(path);
			console.log("holi esb")
			axios.post(path, data)
			.then((response) => {
			  console.log(`statusCode: ${res.statusCode}`)
			  //console.log(response);
			  return res.send(response.data);
			})
			.catch((error) => {
				console.log(error);
			  return res.json(error);  
			})
			break;
		case "PUT":
		case "put":
			res.send(route + " "  + path);
		break;
		case "DELETE":
		case "delete":
			axios.delete(path, data)
			.then((response) => {
			  console.log(`statusCode: ${res.statusCode}`)
			  //console.log(response);
			  return res.send(response.data);
			})
			.catch((error) => {
			  return res.send(error);  
			});

		break;
	}
}

function check_params(body) {
	return body.tipo && body.url && body.parametros && body.funcionSolicitada;
}

/**
{
	"token": "t",
	"tipo": "get",
	"ruta": "http://almacenamiento",
	"parametros": {
		"data": 1,
		"data1": 1,
		"data2": 1
	}
	
}
**/


/*
{
	"token": "t",
	"tipo": "post",
	"ruta": "http://almacenamiento/post/subirArchivo",
	"parametros": {
		"idComplemento": 1,
		"textoTraduccion": 1,
		"localizacion": 1,
		"token": 1
	}
	
}
**/