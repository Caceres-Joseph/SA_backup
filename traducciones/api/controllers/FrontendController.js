var conexion = require('./db.js');
var middle = require('../middleware/Middleware.js')
const axios = require('axios');
var JSAlert = require('js-alert');
const ESB = process.env.NODE_ESB+"/post/comunicacion/";
const JWT = process.env.NODE_JWT+"/post/autorizacion";
const ALMACENAMIENTO = process.env.NODE_ALMACENAMIENTO;
const BACKEND = 'http://35.225.252.91:8005'

exports.loginInicial = function(req, res, next) {
	res.render('login', { aviso: false });
}

exports.registroInicial = function(req, res, next) {
	res.render('registro', { title: 'Hola Alba' });
}

exports.ListarUsuarios = function(req, res, next) {
	var users = [
        {"id" : 1245, "name" : 'Julito', "email" : 'julio@algo.com'},
        {"id" : 6789, "name" : 'Maxito', "email" : 'maxito@algo.com'},
        {"id" : 2468, "name" : 'Fidito', "email" : 'fidito@algo.com'},
        {"id" : 1357, "name" : 'Rosita', "email" : 'rosita@algo.com'}
    ];
    res.render('ListarUsuarios', {'users' : users});
}

exports.AgregarTraduccion = function(req, res, next) {
	var localizaciones = ['ENG-EU', 'ESP-ESP', 'ESP-LAT', 'ENG-ING'];
    res.render('AgregarTraduccion', {'localizaciones' : localizaciones});
}
// obtene las localizaciones, getLocalizaciones
exports.IngresarComplemento = function(req, res, next) {
    var localizaciones = [];

                        try{
                            axios.get(BACKEND+"/get/localizaciones/").then((res1)=>{
                                //alert(res1.data.mensaje);
                               // res.send(res1.data)
                               if(res1.data.estado==200){
                                   //console.log(res1.data.valores)
                                   for(let i=0; i < res1.data.valores.length; i++){
                                       var nombreLocalizacion = res1.data.valores[i].Nombre.replace('(','');
                                       nombreLocalizacion = nombreLocalizacion.replace(')','');
                                       console.log(nombreLocalizacion);
                                       localizaciones.push({'id':i,'descripcion':nombreLocalizacion})
                                   }
                                
    res.render('IngresarComplemento', {'localizaciones' : localizaciones});
                               }else{
                    
                                res.render('login', { aviso: true });
                               }
                               // res.redirect('/IngresarComplemento')
                            }).catch((error) =>{
                                                console.log(error);
                                                return res.send(error.data);
                                            })
                        }catch(error){
                        }    
}
// obtene l
exports.ingresoLogin = function(req, res, next) {
    var nombre = req.body.nombre;
    var pass = req.body.password;
    res.cookie('usuario',nombre, { maxAge: 9000000, httpOnly: true });

    try{
        axios.post(BACKEND+"/post/iniciar/",{
            "nombre":nombre,
            "password":pass
        }).then((res1)=>{
            //alert(res1.data.mensaje);
           // res.send(res1.data)
           if(res1.data.estado==200){
                res.redirect('/IngresarComplemento')
           }else{

            res.render('login', { aviso: true });
           }
           // res.redirect('/IngresarComplemento')
        }).catch((error) =>{
							console.log(error);
							return res.send(error.data);
						})
    }catch(error){
    }
    /*
    if(nombre == 'Julio' && pass == 'Arango'){
        res.redirect('/ListarUsuarios');
    }else{
        res.render('login', { aviso: true });
    }*/
}

exports.ingresoRegistro = function(req, res, next) {
    var nombre = req.body.nombre;
    var pass = req.body.password;
    var correo = req.body.correo;
    try{
        axios.post(BACKEND+"/post/registro/",{
            "nombre":nombre,
            "correo":correo,
            "password":pass,
            "token": "sadfasf"
        }).then((res1)=>{
            JSAlert.alert(res1.data);
            res.redirect('/login')
           //return res.send(res1.data);
        }).catch((error) =>{
							console.log(error);
							return res.send(error.data);
						})
    }catch(error){
    }
    //res.send('Nombre: ' + nombre + '\nContra: ' + pass + '\nCorreo: ' + correo);
}
// guardas complementos
exports.ingresoComplemento = function(req, res, next) {
    var nombre = req.body.nombre;
    var localizacion = req.body.localizacion;
    var complementos = req.body.complementos;
    var idUsuario = req.cookies.usuario;
    try{ 
        var dataComplemento = {
            "texto":complementos,
            "localizacion":localizacion,
            "idUsuario":idUsuario,
            "nombreComplemento": nombre
        };
        var headers = {
            'Content-Type': 'application/json; charset=utf-8',
            'Content-Length': Buffer.byteLength(JSON.stringify(dataComplemento))
         };
        axios.post(BACKEND+"/post/nuevoComplemento/",dataComplemento,headers)
        .then((res1)=>{
            console.log(res1);
            return res.send(res1.data);
        }).catch((error) =>{
            console.log(error);
            return res.send(error.data);
        })
    }catch(error){
    }
    //res.send('Los datos de agregacion son: \nnombre: ' + nombre + '\nLocalizacion: ' + localizacion + '\nComplementos: ' + complementos);
}

exports.ObtenerComplementos = function(req, res, next) {
    var peticion;
    try{
        axios.get(BACKEND+"/get/complementos/").then((res1)=>{
            //alert(res1.data.mensaje);
           // res.send(res1.data)
           peticion = res1.data;
           var complementos = peticion.data.complementos;
           res.render('ListarComplementos', {'complementos' : complementos, 'complementos_general' : complementos});
         
           // res.redirect('/IngresarComplemento')
        }).catch((error) =>{
                            console.log(error);
                            return res.send(error.data);
                        })
    }catch(error){
    }    
    };

  exports.ObtenerCadenas = function(req, res, next) {
      var idComplemento = req.params.id;
    var peticion;
    try{
        axios.post(BACKEND+"/post/catalogo/",{idComplemento:idComplemento}).then((res1)=>{
            //alert(res1.data.mensaje);
           // res.send(res1.data)
           peticion = res1.data;
           var prueba = peticion.data.catalogo;
           res.render('VerCadena', {'catalogos' : prueba, 'idComplemento' : req.params.id, 'nombreComplemento' : req.params.nombre}); 
           // res.redirect('/IngresarComplemento')
        }).catch((error) =>{
                            console.log(error);
                            return res.send(error.data);
                        })
    }catch(error){
    }    
    
      }

  exports.AccionTraduccionAprobacion = function(req, res, next) {
    var usuario = req.cookies.usuario;
    var nombreComplemento = req.params.nombreComplemento;
    var idComplemento = req.params.idComplemento;
    var localizacionOriginal = req.params.localizacionOriginal;
    var localizacionTraduccion = req.params.localizacionTraduccion;
    var msgid = req.params.msgid;
    var msgstr = req.body.msgstr;
    var verificar = req.body.bttnAccion;
    var valores = [usuario, nombreComplemento, idComplemento, localizacionOriginal, localizacionTraduccion, msgid, msgstr, verificar];
    if(verificar=='Aprobar'){
        try{
            axios.post(JWT,{
                clientid:"ARCHIVOS_TRADUCIDOS"
                }).then(function(result){
                    token = result.data.token;
                    //console.log(result.data.token);
                    //console.log(middle.decode(result.data.token));
                    var miQuery = "SELECT Nombre, Correo from Usuario where Nombre = "+usuario+";";
                    //console.log(miQuery);
                    conexion.query(miQuery, function(err, result){
                    if(err){
                        return res.send(JSON.stringify(
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
                               nombreLocalizacionOriginal: localizacionOriginal,
                               nombreLocalizacionTraducida: localizacionTraduccion,
                               cadenaOriginal: msgid,
                               cadenaTraducida: msgstr,
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
                               .then((res1)=>{
                                   console.log(res1)
                                   return res.send(res1.data);
                               })
                           }catch(error){
                               console.log(error);
                               return res.send(error.data);
                           }
                    }
                    })
            })
    
        //  SELECT Nombre, Correo from Usuario where idUsuario = 1;
        
        }catch(error){
                return error;
        }    
    }else{
        try{
            axios.post(JWT,{
                clientid:"ARCHIVOS_TRADUCIDOS"
                }).then(function(result){
                    token = result.data.token;
                    //console.log(result.data.token);
                    //console.log(middle.decode(result.data.token));
                    var miQuery = "SELECT Nombre, Correo from Usuario where Nombre = "+nombre+";";
                    //console.log(miQuery);
                    conexion.query(miQuery, function(err, result){
                    if(err){
                        return res.send(JSON.stringify(
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
                            .then((res1)=>{
                                console.log(res1);
                                return res.send(res1.data);
                            }).catch((error) =>{
                                console.log(error);
                                return res.send(error.data);
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
    }
    //res.send(valores);
}