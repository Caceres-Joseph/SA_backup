var DBHandler = require('../config/DataBaseHandler')
var dbh = new DBHandler()
var connection = dbh.createConnection()
var middleware = require('../middleware/Middleware')
var axios = require('axios')

var anonymous_token = null

exports.initArchivosTraducidos = (req, res) =>{
	//inicializar los datos, con lo que se recupera de almacenamiento
	var jwt = process.env.NODE_JWT+'/post/autorizacion'
	axios.post(jwt,{
		clientid : "ALMACENAMIENTO"
	})
	.then(result=>{
		anonymous_token=result.data.token
		//console.log(anonymous_token)
		var esb = process.env.NODE_ESB+'/post/comunicacion'
		var almacenamiento = process.env.NODE_ALM+'/post/suscripcion'
		console.log(esb)
		console.log(almacenamiento)
		axios.post(esb,{
			token : anonymous_token,
			url : almacenamiento,
			tipo : 'POST',
			funcionSolicitada :'almacenamiento.suscripcion',
			parametros:{}
		}).then( result =>{
			console.log(result.data)
		})
		.catch(e =>{
			console.log('MODO PÁNICO')
		})
	})
	//enviando informacion
	res.send({
		estado:"200", 
		mensaje:"Ok", 
		data:{
			nombre:'Archivos traducidos'
			}
		}
	);
}

exports.initFEArchivosTraducidos = (req, res) =>{
	//inicializar los datos, con lo que se recupera de almacenamiento
	res.render('init')
}

exports.listaComplementos = function(req, res){
	var token = req.query.token
/*
	if(!middleware.verifyToken(token)){//esto está bien?
		res.send({
			estado:"403",
			mensaje:"Permisos insuficientes"
		})
	}*/
	
	connection.query('SELECT * FROM archivo_traducido',(err,archivos) =>{
		if(err){
			res.send({
				estado:"500",
				mensaje:"Error de operacion"
			})
		}
		/* TODO armar json de respuesta
		var objs = [];
		for (var i = 0;i < archivos.length; i++) {
			objs.push({ "id": archivos[i].id, "nombre":archivos[i].archivo_traducido });
		}
		var data = JSON.stringify(objs,['id','nombre'])
		console.log(archivos)*/
		res.send({
			estado:"200",
			mensaje:"Se realizo la consulta de complementos",
			archivos
		})
	})
}

exports.listaFEComplementos = function(req, res){
	connection.query('SELECT * FROM archivo_traducido',(err,archivos) =>{
		if(err){
			res.send({
				estado:"500",
				mensaje:"Error de operacion"
			})
		}
		res.render('archivostraducidos',{
			data: archivos
		})
	})
}

exports.listaDeLocalizaciones = function(req, res){
	var strComplement = req.params.strComplement
	var token = req.query.token
	res.send("Parametros recibidos en /get/listaDeLocalizaciones/:strComplement?token<token> \n"
	+"strComplement: "+strComplement+"\n"
	+"token: "+token+"\n")
}

exports.listaFEDeLocalizaciones = function(req, res){
	var loc = req.params.loc
	if(loc=='all'){
		console.log('Mostrar todos')
	}else{
		console.log('Consultar por localizacion '+loc)
	}
	res.send("Parametros recibidos en /listaDeLocalizaciones/:loc\n"
	+"loc: "+loc)
}

exports.descargaMo = function(req,res){
	var strComplement = req.params.strComplement
	var strPath = req.params.strPath
	var token = req.query.token

	if(!middleware.verifyToken(token)){//esto está bien?
		res.send({
			estado:"403",
			mensaje:"Permisos insuficientes"
		})
	}
	res.send(
		{
			estado:"200",
			mensaje:"Ok",
			data:{
				tipo:"GET",
				nombre:strComplement,
				localizacion:strPath
			}
		}
	)
}

exports.descargaPo = function(req,res){
	var strComplement = req.params.strComplement
	var strPath = req.params.strPath
	var token = req.query.token

	//if(!middleware.verifyToken(token)){//esto está bien?
	//	res.send({
	//		estado:"403",
	//		mensaje:"Permisos insuficientes"
	//	})
	//}

	connection.query('SELECT * FROM Traducido.ArchivoCadena;',(err,archivos) =>{
		if(err){
			res.send({
				estado:"500",
				mensaje:"Error de operacion"
			})
		}


		const fs=require('fs')

		var aux = "";
		var aux2 = "";
		var flag = false;
		for (var i=0; i <archivos.length; i++){
			
			if(aux == archivos[i].Complemento)
			{
				//sigue siendo el mismo archivo
				
				var encode = require( 'hashcode' ).hashCode;
     			var hash = encode().value( archivos[i].Cadena+" "+archivos[i].Traduccion ); 

				aux2 = aux2 + "\n# $tense = __( '"+archivos[i].Cadena+"', '"+archivos[i].Traduccion+"' );\n"+
							"#\n"+
							"# wpml-name: "+hash*-1+""+
							"\nmsgid '\""+archivos[i].Cadena+"\" \nmsgstr \""+archivos[i].Traduccion+"\"\n"
				flag = true;

			}else
			{
				//nuevo archivo
				if(flag)
				{
					fs.writeFile('./'+aux+'.po', aux2, error => {
						if (error)
						console.log(error);
						else
						console.log('El archivo fue creado');
					})
					flag = false;
				}

				aux = archivos[i].Complemento;
				aux2 = "# Este archivo es geenrado por el Grupo No 2\n"+
						"# Es un archivo para traducciones en WordPress.\n\n"+
						//"# https://wpml.org"+
						"# Trasducido:\n"+
						//"# Alejandro Martín Muñoz <info@alejandromartinfotografia.com>, 2014"+
						//"# Intel <malo1@luisrivera.com>, 2014"+
						//"# luismi <luismi@ahigal.net>, 2014"+
						//"# Pablo Palacios <pablo.palacios@moplin.com>, 2014"+
						//"# Tim Ingarfield <tim@sctsystemic.com>, 2014"+
						"\nmsgid \"\""+
						"\nmsgstr \"\"\n\n"+
						"\"Project-Id-Version: 1.0\\n\"\n"+
						"\"POT-Creation-Date: \\n\"\n"+
						"\"PO-Revision-Date: 2019-11-02 \\n\"\n"+
						"\"Language-Team: "+archivos[i].Idioma+" \\n\"\n"+
						"\"User: "+archivos[i].nombreusr+" \\n\"\n"+
						"\"Language-Team: "+archivos[i].Idioma+" \\n\"\n"+
						//"\"MIME-Version: 1.0\n\""+
						"\"Content-Type: text/plain; charset=UTF-8\\n\"\n"+
						"\"Content-Transfer-Encoding: 8bit\\n\"\n"+
						"\"Language: "+archivos[i].Idioma+" \\n\"\n"+
						//"\"Plural-Forms: nplurals=2; plural=(n != 1);\n\""+
						//"\"X-Generator: Poedit 1.7.4\n\""
						"\"Complemento: "+archivos[i].Complemento+"\\n\"\n\n"+
						"\n# $tense = __( '"+archivos[i].Cadena+"', '"+archivos[i].Traduccion+"' );\n"+
						"#\n"+
						"# wpml-name: "+hash*-1+""+
						"\nmsgid '\""+archivos[i].Cadena+"\" \nmsgstr \""+archivos[i].Traduccion+"\"\n";

				flag = true;

			}			
		}	
			
		fs.writeFile('./'+aux+'.po', aux2, error => {
			if (error)
			console.log(error);
			else
			console.log('El archivo fue creado');
		})

		res.render('archivostraducidos',{

			data: archivos
		})
	})

	//res.send(
	//	{
	//		estado:"200",
	//		mensaje:"Ok",
	//		data:{
	//			tipo:"GET",
	//			nombre:strComplement,
	//			localizacion:strPath
	//		}
	//	}
	//)
}

exports.ComplementoTraducido = function(req,res){
	console.log("Entro");
	console.log(req.body);
	res.send(
		{
			estado:"200",
			mensaje:"TODO: devolver todo ok",
			data:{}
		}
	)
}
