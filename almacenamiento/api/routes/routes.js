module.exports  = function(app){
	var main = require('../controllers/AlmacenamientoController');	
	var main2 = require('../controllers/AlmacenamientoController2');	
	app.route('/').get(main.initAlmacenamiento); 

	app.route('/get/complementos').get(main.get_complementos);
	app.route('/get/complemento/:idComplemento').get(main.get_complemento);
	app.route('/get/catalogo/:idComplemento').get(main.get_catalogo);
	app.route('/post/agregarTraduccionCadena').post(main.agregar_traduccion_cadena);
	app.route('/post/aprobarTraduccionCadena').post(main.aprobar_traduccion_cadena);

	app.route('/post/complemento').post(main2.post_complemento);
	app.route('/post/suscripcion').post(main2.post_suscribirse);
}