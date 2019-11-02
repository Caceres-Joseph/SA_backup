module.exports  = function(app){
	var main = require('../controllers/MainController');	
	app.route('/').get(main.initEsb);


	/*pruebas sobre las rutas basicas en los otros tres servicios.*/
	app.route('/alamacenamiento').get(main.testAlmacenamiento);
	app.route('/archivos_traducidos').get(main.testArchivosTraducidos);
	app.route('/traducciones').get(main.testTraducciones);
	app.route('/post/comunicacion').post(main.comunicacion);
}