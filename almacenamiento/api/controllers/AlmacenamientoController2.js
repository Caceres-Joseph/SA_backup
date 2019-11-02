const middleware = require('../middleware/Middleware');
var sql = require('./../model/db');

 

/**
 * Post para almacenar complementos
 */

exports.post_complemento = function (req, res) {
    try {

        const scope = "almacenamiento.guardarCatalogo";

        var token = req.body.token;
        var nombre = req.body.nombre;
        var correo = req.body.correo;
        var complemento = req.body.complemento;
        var nombreComplemento = complemento.nombre;
        var localizacion = complemento.localizacion;
        var decodedToken = null;


        if (!middleware.verifyToken(token)) {
            res.statusCode = 401;
            return res.send({
                estado: 401,
                mensaje: "Se produjo un error al consultar el complemento con el identificador. Autorización requerida"
            });
        }
        decodedToken = middleware.decode(token);
        console.log(decodedToken);

        /*
        if (!check_scope(scope, decodedToken.payload.scopes)) {
            res.statusCode = 403;
            return res.send({
                estado: 403,
                mensaje: "Se produjo un error al consultar el complemento con el identificador. Autorización requerida"
    
            });
        }  
        */


        let query = "call sp_almacenamientoInsertaComplemento (\"" + nombre + "\",\"" + correo + "\",\"" + nombreComplemento + "\",\"" + localizacion + "\",\"" + complemento.cadenas.join() + "\")"

        console.log(query);

        sql.query(query, true, (error, results, fields) => {
            if (error) {
                console.log(error);
                return res.send(error);
            } else {

                var data = {
                    "nombre": nombreComplemento,
                    "path": "/"
                }

                console.log(data);
                res.statusCode = 200;
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




/**
 * Post para almacenar complementos
 */

exports.post_suscribirse = function (req, res) {
    try {

        const scope = "almacenamiento.suscribirse";

        var token = req.body.token;
        var ip = req.body.ip;
        

        var decodedToken = null;


        if (!middleware.verifyToken(token)) {
            res.statusCode = 401;
            return res.send({
                estado: 401,
                mensaje: "Se produjo un error al consultar el complemento con el identificador. Autorización requerida"
            });
        }
        decodedToken = middleware.decode(token);
        console.log(decodedToken);

        /*
        if (!check_scope(scope, decodedToken.payload.scopes)) {
            res.statusCode = 403;
            return res.send({
                estado: 403,
                mensaje: "Se produjo un error al consultar el complemento con el identificador. Autorización requerida"
    
            });
        }  
        */


        let query = "call sp_almacenamientosuscripcion (\"" + ip+ "\")"

        console.log(query);

        sql.query(query, true, (error, results, fields) => {
            if (error) {
                console.log(error);
                return res.send(error);
            } else {
 
 
                res.statusCode = 200;
                res.send({
                    estado: 200,
                    mensaje: "Suscrito correctamente"
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
/**
 * -----------------------------------------
 *  FUNCIONES
 * ---------------------------------------- 
 */


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
