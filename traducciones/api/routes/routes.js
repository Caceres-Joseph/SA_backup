module.exports  = function(app){
	var main = require('../controllers/TraduccionesController');	
	var fron = require('../controllers/FrontendController');	
	app.route('/').get(main.initTraducciones);
	app.route('/post/registro/').post(main.registro);
	app.route('/post/iniciar').post(main.inicio);
	app.route('/post/nuevoComplemento').post(main.nuevoComplemento);
	app.route('/post/agregarTraduccion').post(main.agregarTraduccion);
	app.route('/get/complementos/').get(main.getComplementos);
	app.route('/post/revisar').post(main.revisar);
	app.route('/get/localizacion/:idUsuario&/').get(main.getLocalizacion);
	app.route('/get/localizaciones').get(main.getLocalizaciones);
	app.route('/post/subirArchivo').post(main.subirArchivo);
	app.route('/post/catalogo').post(main.getCatalogo);
	// ----------------------------- Funciones frontend --------------------------------
	app.route('/login').get(fron.loginInicial);
	app.route('/registro').get(fron.registroInicial);
	app.route('/ListarUsuarios').get(fron.ListarUsuarios);
	app.route('/AgregarTraduccion').get(fron.AgregarTraduccion);
	app.route('/IngresarComplemento').get(fron.IngresarComplemento);
	app.route('/ListarComplementos').get(fron.ObtenerComplementos);
	app.route('/VerCadenas/:id/:nombre').get(fron.ObtenerCadenas);
	app.route('/TraducirAprobarCadena/:nombreComplemento/:idComplemento/:localizacionOriginal/:localizacionTraduccion/:msgid').post(fron.AccionTraduccionAprobacion);
	
	app.route('/login').post(fron.ingresoLogin);
	app.route('/registro').post(fron.ingresoRegistro);
	app.route('/IngresarComplemento').post(fron.ingresoComplemento);
}	